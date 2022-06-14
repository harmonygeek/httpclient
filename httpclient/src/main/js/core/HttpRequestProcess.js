/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import http from '@ohos.net.http';
import HttpClient from '../HttpClient'
import Request from '../Request'
import request from '@ohos.request';
import {gInterceptors} from '../utils/Interceptor';
import Log from '../utils/log';
import BaseWorker from './BaseWorker';
import CallbackResponse from '../callback/CallbackResponse';
import FileUtils from '../utils/FileUtils';

var TAG = 'HttpRequestProcess:: ';

var _request = Symbol();
var _nodeRequest = Symbol();
var _response = Symbol();
var _data = Symbol();
var _timeout = Symbol();

var httpCarrier;

class Response {
  constructor() {

  }
}

class HttpRequestProcess extends BaseWorker {
  constructor($request, $id = '0', $priorityKey = 0) {
    super($id, $priorityKey);
    this[_request] = $request;
    this[_nodeRequest] = null;
    this[_response] = null;
    this[_data] = null;
  }

  process(lInterceptors, onComplete, onError) {
    super.process(onComplete, onError);
    this[_data] = null;
    this[_response] = null;

    var self = this;
    var lRequest = this.request;

    if (null != lInterceptors && lInterceptors.request.interceptorList
    && lInterceptors.request.interceptorList.length != 0) {
      lRequest = this.handleInterceptor(lInterceptors.request.interceptorList, lRequest);
    }

    if (null != gInterceptors && gInterceptors.request.interceptorList
    && gInterceptors.request.interceptorList.length != 0) {
      lRequest = this.handleInterceptor(gInterceptors.request.interceptorList, lRequest);
    }

    var body = lRequest.body;
    var parsedUrl = lRequest.url;

    httpCarrier = http.createHttp();

    var headers = body ? Object.assign(lRequest.headers, body.mimes) : Object.assign({}, lRequest.headers);

    var options = {
      method: lRequest.method,
      header: headers,
    };

    if (null != lRequest.params) {
      options['params'] = lRequest.params;
      var isbegin = true;
      Object.keys(lRequest.params).forEach(function (key) {
        Log.showInfo('Params key - ' + key + ', value - '
        + lRequest.params[key].toString());
        parsedUrl = parsedUrl.toString().concat(isbegin ? '?' : '&');
        parsedUrl = parsedUrl.concat(key).concat('=').concat(lRequest.params[key].toString());
        isbegin = false;
      })
    }

    var client = lRequest.client;
    if (client) {
      if (null != client.connectionTimeout) {
        options['connectTimeout'] = client.connectionTimeout;
        Log.showInfo('HttpRequestProcess : connectionTimeout:' + client.connectionTimeout);
      }

      if (null != client.readTimeout) {
        options['readTimeout'] = client.readTimeout;
        Log.showInfo('HttpRequestProcess : readTimeout:' + client.readTimeout);
      }
    }
    if (body && null != body.content) {
      options['extraData'] = body.content;
    }

    function requestOnResponse(res) {
      // from documentation
      // This properly handles multi-byte characters that would otherwise be potentially
      // mangled if you simply pulled the Buffers directly and called buf.toString(encoding) on them.
      // If you want to read the data as strings, always use this method.

      if (null != lRequest.cookieJar) {
        Log.showInfo('HttpRequestProcess :  cookieJar - ' + lRequest.cookieJar);
        lRequest.cookieJar.saveFromResponse(res, parsedUrl, lRequest.cookieManager);
        Log.showInfo('saveFromResponse :  saveFromResponse - completed' );

      }
      if(null != lRequest.convertor) {
        Log.showInfo('HttpRequestProcess :  convertor -started ' );
        let body = lRequest.convertor.convertResponse(res.result);
        let callbackresponse = new CallbackResponse(body,res);
        self.notifyComplete(callbackresponse);
        return;
      }
      self[_response] = res;

      self[_data] = res.result;
      Log.showInfo('HttpRequestProcess :  notifyComplete -res '+JSON.stringify(res) );
      self.notifyComplete(self);
    }
    function uploadOnResponse(data) {
      self.notifyComplete(data);
    }

    function requestOnResponseDownload(res) {
      self.notifyComplete(res);
    }

    function requestOnError(err) {
      self.notifyError(err);
    }

    if ('UPLOAD' == lRequest.method) {
      Log.showInfo('HttpRequestProcess : Upload request - Parsed Url - ' + parsedUrl.toString());
      lRequest.files.forEach(async function (file) {
        Log.showInfo('HttpRequestProcess : File  = ' + JSON.stringify(file))
        let config = {
        url: parsedUrl,
        header: {},
        method: "POST",
        files: [file],
        data: [lRequest.data],
        };
        this[_nodeRequest] =  request.upload(lRequest.abilityContext,config, (err, data) => {
          if (err) {
            requestOnError(err);
            return;
          }
          uploadOnResponse(data)
        });
      })
    } else if ('DOWNLOAD' == lRequest.method) {
      var downloadRequestData = { url: parsedUrl ,filePath:''};
      if (headers) {
        downloadRequestData['header'] = headers;
      }
      if (lRequest.filePath) {
                downloadRequestData["filePath"] = lRequest.filePath;
            } else {
                const defaultFileDownloadDirectory = "/data/storage/el2/base/haps/entry/files/";
                const fileParts = parsedUrl.split('/');
                const fileName = fileParts[fileParts.length-1];
                downloadRequestData["filePath"] = defaultFileDownloadDirectory+fileName;
      }
      Log.showInfo('downloadRequestData :  = ' + JSON.stringify(downloadRequestData))
      if(FileUtils.exist(downloadRequestData["filePath"])){
        Log.showInfo('filePath exits :  = ' + downloadRequestData["filePath"])
        FileUtils.deleteFile(downloadRequestData["filePath"])
      }
      request.download(lRequest.abilityContext,downloadRequestData).then((downloadTask)=>{
        Log.showInfo('download starts :  = ' + downloadTask)
        if(downloadTask){
          requestOnResponseDownload(downloadTask);
        }
      }).catch((err)=>{
        Log.showInfo('download err :  = ' + JSON.stringify(err))
        requestOnError(err);
        return;
      })

    } else {

      Log.showInfo("------request--------------");
      Log.showInfo('Parsed Url - ' + parsedUrl.toString());
      Log.showInfo('options - ' + JSON.stringify(options));
      Log.showInfo("------request--------------");
      this[_nodeRequest] = httpCarrier.request(parsedUrl, options, (err, data) => {
        Log.showInfo('HttpProcessRequest : response received for lRequest.tag : '
        + lRequest.tag + ' lRequest.isSync: ' + lRequest.isSyncCall);
        let dispatcher = lRequest.client.dispatcher;
        let call = dispatcher.asyncCallObject;
        //Only calls from queue can be marked cancel, therefore only these calls can be cancelled
        if (!lRequest.isSyncCall
        && lRequest.tag === call.getRequest().tag
        && dispatcher.asyncCallObject.isCancelled()) {
          Log.showInfo('HttpProcessRequest : call is marked cancelled');
          let errMsg = { code: '', data: 'Request canceled by user' };
          dispatcher.onError(errMsg, call);
        } else {
          if (err == null) {
          var lData = data;
          Log.showInfo('HttpProcessRequest response received: '+JSON.stringify(lData))
           if (null != lInterceptors && lInterceptors.response.interceptorList
           && lInterceptors.response.interceptorList.length != 0) {
             lData = this.handleInterceptor(lInterceptors.response.interceptorList, lData);
           }

           if (null != gInterceptors && gInterceptors.response.interceptorList
           && gInterceptors.response.interceptorList.length != 0) {
             lData = this.handleInterceptor(gInterceptors.response.interceptorList, lData);
           }

          Log.showInfo('HttpProcessRequest after interceptors response received: '+JSON.stringify(lData))

          //Send redirect request, if required.
            if (lRequest.followRedirects) {
              Log.showInfo('HttpRequestProcess : Follow redirect is enabled');
              self[_response] = lData;
              var status = self.response.responseCode;
              Log.showInfo('HttpRequestProcess : Response Code - ' + status);
              if (status == 300 || status == 301 || status == 302
              || status == 303 || status == 307 || status == 308) {
                //300 - Multiple Choices, 301 - Moved Permanently, 302 - Moved Temporarily,
                //303 - See Other, 307 - Temporary Redirect, 308 - Permanent Redirect.
                var redirectMaxLimit = lRequest.redirectMaxLimit;
                var redirectCount = lRequest.redirectionCount;
                Log.showInfo('HttpRequestProcess : Redirect - ' + redirectCount + '/' + redirectMaxLimit);
                if (redirectCount <= redirectMaxLimit) { //Default redirect max limit is 20.
                  Log.showInfo('HttpRequestProcess : URL Moved');
                  Log.showInfo('HttpRequestProcess : Header - ' + JSON.stringify(self.response.header));
                  Log.showInfo('HttpRequestProcess : Location - ' + JSON.stringify(self.response.header.Location));
                  if (self.response.header.Location == undefined) {
                    Log.showInfo('HttpRequestProcess: Undefined location URL');
                    requestOnResponse(lData);
                    return;
                  }
                  var location = self.response.header.Location.toString();
                  Log.showInfo('HttpRequestProcess : Redirecting to ' + location);
                  var count = redirectCount + 1;
                  //Send redirect request
                  this.sendRequest(lRequest, location, count, onComplete, onError);
                } else {
                  Log.showInfo('HttpRequestProcess : URL Moved, Redirect max limit reached');
                  requestOnResponse(lData);
                }
              } else {
                requestOnResponse(lData);
              }
            } else {
              requestOnResponse(lData);
            }
          } else {
            //onError
            if (lRequest.retryOnConnectionFailure && (err.data == 'IOException')) {
              Log.showInfo('HttpRequestProcess: IOException occurred - ' + err.data);
              var retryMaxLimit = lRequest.retryMaxLimit;
              var retryCount = lRequest.retryConnectionCount;
              Log.showInfo('HttpRequestProcess : Retry - ' + retryCount + '/' + retryMaxLimit);
              if (retryCount <= retryMaxLimit) { //Default retry max limit is 20.
                var count = retryCount + 1;
                //Retry request on connection failure
                this.sendRequest(lRequest, parsedUrl, count, onComplete, onError);
              } else {
                Log.showInfo('HttpRequestProcess : Retry max limit reached');
                requestOnError(err);
              }
            }
            else {
              Log.showInfo('HttpRequestProcess: Exception occurred - ' + err.data);
              requestOnError(err);
            }
          }
        }
      });
    }
  }

  sendRequest(request, location, count, onComplete, onError) {
    Log.showInfo('HttpProcessRequest sendRequest location : ' + location + ' count : ' + count +
    ' retryConnectionCount : ' + request.retryConnectionCount + ' request.redirectionCount :'
    + request.redirectionCount);
    request.url = location;
    request.retryConnectionCount = count;
    request.redirectionCount = count;
    request.client.dispatcher.executeFrameWorkCall(request, request.client.interceptors).then(onComplete, onError);
  }

  handleInterceptor(interceptorList, data) {
    var lData = data;

    if (null != interceptorList && interceptorList.length != 0) {
      var interceptorLength = interceptorList.length;
      for (var i = 0; i < interceptorLength; i++) {
        let iData = interceptorList[i](lData);
        if (null != iData) {
          lData = iData;
        }
      }
    }
    return lData;
  }

  stop() {
    if (this[_nodeRequest]) this[_nodeRequest].abort();
  }

  dispose() {
    this.stop();
    this[_nodeRequest] = null;
    this[_request] = null;
  }

  close() {
    httpCarrier.destroy();
  }

  get request() {
    return this[_request];
  }

  get data() {
    return this[_data];
  }

  get response() {
    return this[_response];
  }
}

export default HttpRequestProcess;