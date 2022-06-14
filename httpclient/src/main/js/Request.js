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

import HttpRequestProcess from './core/HttpRequestProcess';
import Log from './utils/log'
import {Interceptor} from './utils/Interceptor'
import FileUtils from './utils/FileUtils';

var _method = Symbol();
var _url = Symbol();
var _tag = Symbol();
var _body = Symbol();
var _files = Symbol();
var _data = Symbol();
var _headers = Symbol();
var _params = Symbol();
var _queryParams = Symbol();
var _classResponse = Symbol();
var _dataAux = Symbol();
var _flagReturnRequestAsResponse = Symbol();
var _httpRequestProcess = Symbol();
var _responseEncoding = Symbol();
var _connectTimeout = Symbol();
var _readTimeout = Symbol();
var _downloadFilePath = Symbol();
var _followRedirects = Symbol();
var _retryOnConnectionFailure = Symbol();
var _retryMaxLimit = Symbol();
var _redirectMaxLimit = Symbol();
var _redirectCount = Symbol();
var _retryCount = Symbol();
var _client = Symbol();
var _cookieJar = Symbol();
var _cookieManager = Symbol();
var _isSyncCall = Symbol();
var _interceptors = Symbol();
var _debugMode = Symbol();
var _userAgent = Symbol();
var _contentType = Symbol();
var _convertorType = Symbol();

class Request {
  constructor(build) {
    if (!arguments.length) {
      build = new Request.Builder();
    }
    this[_method] = build[_method];
    this[_url] = build[_url];
    this[_tag] = build[_tag];
    this[_body] = build[_body];
    this[_files] = build[_files];
    this[_data] = build[_data];
    this[_headers] = build[_headers];
    this[_params] = build[_params];
    this[_queryParams] = build[_queryParams];
    this[_classResponse] = build[_classResponse];
    this[_dataAux] = build[_dataAux];
    this[_flagReturnRequestAsResponse] = build[_flagReturnRequestAsResponse];
    this[_httpRequestProcess] = new HttpRequestProcess(this);
    this[_responseEncoding] = build[_responseEncoding];
    this[_connectTimeout] = build[_connectTimeout];
    this[_readTimeout] = build[_readTimeout];
    this[_downloadFilePath] = build[_downloadFilePath];
    this[_followRedirects] = build[_followRedirects];
    this[_retryOnConnectionFailure] = build[_retryOnConnectionFailure];
    this[_retryMaxLimit] = build[_retryMaxLimit];
    this[_redirectMaxLimit] = build[_redirectMaxLimit];
    this[_redirectCount] = build[_redirectCount];
    this[_retryCount] = build[_retryCount];
    this[_cookieJar] = build[_cookieJar];
    this[_cookieManager] = build[_cookieManager];
    this[_interceptors] = build[_interceptors];
    this[_convertorType] =build[_convertorType];
  }

  addHeader(key, value) {
    this[_headers][key] = value;
  }

  set body(value) {
    this[_body] = value;
  }

  get dataAux() {
    return this[_dataAux];
  }

  get httpRequestProcess() {
    return this[_httpRequestProcess];
  }

  get headers() {
    return this[_headers];
  }

  get body() {
    return this[_body];
  }

  get url() {
    return this[_url];
  }

  get tag() {
    return this[_tag];
  }

  get method() {
    return this[_method];
  }

  get queryParams() {
    return this[_queryParams];
  }

  get params() {
    return this[_params];
  }

  get responseEncoding() {
    return this[_responseEncoding];
  }

  get classResponse() {
    return this[_classResponse];
  }

  get filePath() {
    return this[_downloadFilePath];
  }

  get filesDir() {
    return this[_files];
  }

  get interceptors() {

    return this[_interceptors];
  }

  get followRedirects() {
    return this[_followRedirects];
  }

  get retryOnConnectionFailure() {
    return this[_retryOnConnectionFailure];
  }

  get retryMaxLimit() {
    return this[_retryMaxLimit];
  }

  get retryConnectionCount() {
    return this[_retryCount];
  }

  get redirectMaxLimit() {
    return this[_redirectMaxLimit];
  }

  get redirectionCount() {
    return this[_redirectCount];
  }

  get files() {
    return this[_files];
  }

  get data() {
    return this[_data];
  }

  get client() {
    return this[_client];
  }

  get isSyncCall() {
    return this[_isSyncCall];
  }

  get cookieJar() {
    return this[_cookieJar];
  }

  get cookieManager() {
    return this[_cookieManager];
  }
  get convertor() {
    return this[_convertorType];
  }

  set url(urlString) {
    this[_url] = urlString;
  }

  set client(httpClient) {
    this[_client] = httpClient;
  }

  set retryConnectionCount(count) {
    this[_retryCount] = count;
  }

  set redirectionCount(count) {
    this[_redirectCount] = count;
  }

  set isSyncCall(isSyncCallObject) {
    this[_isSyncCall] = isSyncCallObject;
  }

  set headers(value) {
    this[_headers] = value;
  }

  request(method){
    var body = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
    this[_method] = method;
    if(body){
      this[_body] = body;
    }
  }

  static get Builder() {
    class Builder {
            constructor() {
                this[_method] = 'GET';
        this[_url] = null;
        this[_tag] = new Date().getTime() + '';
        this[_body] = null;
        this[_files] = null;
        this[_data] = null;
        this[_headers] = {};
        this[_queryParams] = {};
        this[_params] = {};
        this[_classResponse] = null;
        this[_dataAux] = null;
        this[_flagReturnRequestAsResponse] = false;
        this[_responseEncoding] = 'utf8';
        this[_downloadFilePath] = null;
        this[_followRedirects] = false;
        this[_retryOnConnectionFailure] = true;
        this[_retryMaxLimit] = 20;
        this[_redirectMaxLimit] = 20;
        this[_redirectCount] = 1;
        this[_retryCount] = 1;
        this[_cookieJar] = null;
        this[_cookieManager] = null;
        this[_debugMode] = true;
        this[_userAgent] = '';
        this[_contentType] = 'application/json';
        this[_convertorType] = null;
        this[_interceptors] = {
          request: new Interceptor(),
          response: new Interceptor()
        };

      }
      convertor(convertorType){
        this[_convertorType] = convertorType;
        return this;
      }
      cookieJar(cookieJar) {
        this[_cookieJar] = cookieJar;
        return this;
      }

      cookieManager(cookieManager) {
        this[_cookieManager] = cookieManager;
        return this;
      }

      retryOnConnectionFailure(isRetryOnConnectionFailure) {
        this[_retryOnConnectionFailure] = isRetryOnConnectionFailure;
        return this;
      }

      retryMaxLimit(maxValue) {
        maxValue = (maxValue == undefined || maxValue == null || maxValue == ''
        || maxValue < 0 || maxValue > 20) ? this[_retryMaxLimit] : maxValue;
        this[_retryMaxLimit] = maxValue;
        return this;
      }

      retryConnectionCount(count) {
        this[_retryCount] = count;
        return this;
      }

      followRedirects(aFollowRedirects) {
        this[_followRedirects] = aFollowRedirects;
        return this;
      }

      redirectMaxLimit(maxValue) {
        maxValue = (maxValue == undefined || maxValue == null || maxValue == ''
        || maxValue < 0 || maxValue > 20) ? this[_redirectMaxLimit] : maxValue;
        this[_redirectMaxLimit] = maxValue;
        return this;
      }

      redirectionCount(count) {
        this[_redirectCount] = count;
        return this;
      }

      addInterceptor(req, resp) {


        if (null != req) {

          this[_interceptors].request.use(req);
        }

        if (null != resp) {

          this[_interceptors].response.use(resp);
        }

        return this;
      }

      dataAux(value) {
        this[_dataAux] = value;
        return this;
      }

      headers(value) {
        this[_headers] = value;
        return this;
      }

      addHeader(key, value) {
        this[_headers][key] = value;
        return this;
      }

      setDefaultUserAgent(value) {
        this[_headers]['user-agent'] = (value == undefined || value == null || value == ''
          ? this[_userAgent] : value);
        return this;
      }

      setDefaultContentType(value) {
        this[_headers]['content-type'] = (value == undefined || value == null || value == ''
          ? this[_contentType] : value);
        return this;
      }

      body(value) {
        this[_body] = value;
        return this;
      }

      url(value) {
        if (value == undefined || value == null || value == '') {
          throw new Error('Incorrect URL parameters');
        }
        this[_url] = value;
        return this;
      }

      tag(value) {
        this[_tag] = value;
        return this;
      }

      method(value) {
        this[_method] = value;
        return this;
      }

      queryParams(value) {
        this[_queryParams] = value;
        return this;
      }

      query(key, value) {
        this[_queryParams][key] = value;
        return this;
      }

      params(key, value) {
        this[_params][key] = value;
        return this;
      }

      addFileParams(files, data) {
        this[_method] = 'UPLOAD';
        this[_files] = files && files !== undefined ? files : null;
        this[_data] = data && data !== undefined ? data : null;
        return this;
      }

      responseEncoding(value) {
        this[_responseEncoding] = value;
        return this;
      }

      bufferResponse() {
        this[_responseEncoding] = null;
        return this;
      }

      textResponse() {
        this[_responseEncoding] = 'utf8';
        return this;
      }

      classResponse(value) {
        this[_classResponse] = value;
        return this;
      }
            filePath(path) {
                Log.showInfo("Request: filePath : "+path)
                try {
                    if (FileUtils.isFilePathValid(path)) {
                        Log.showInfo("Request: isFilePathValid : true");
                        this[_downloadFilePath] = path;
                    }
                } catch (err) {
                    Log.showInfo("Request: isFilePathValid : error : "+err);
                    throw new Error(err);
                }
                return this;
            }

      get() {
        if (arguments.length > 0 && (arguments[0] == null || arguments[0] == ''|| arguments[0] == undefined)) {
          throw new Error('Incorrect GET URL parameters');
        }
        var url = arguments.length > 0  ? arguments[0] : null;
        this[_method] = 'GET';
        if (url) {
          this[_url] = url;
        }
        return this;
      }

      put(body) {
        if (body == undefined || body == null || body == '') {
          throw new Error('Incorrect PUT body parameters');
        }
        this[_method] = 'PUT';
        this[_body] = body;
        return this;
      }

      delete() {
        this[_method] = 'DELETE';
        return this;
      }

      head() {
        this[_method] = 'HEAD';
        return this;
      }

      options() {
        this[_method] = 'OPTIONS';
        return this;
      }

      post() {
        if (arguments.length > 0 && (arguments[0] == null || arguments[0] == ''|| arguments[0] == undefined)) {
            throw new Error('Incorrect POST body parameters');
        }
        var body = arguments.length > 0  ? arguments[0] : null;

        this[_method] = 'POST';
        if(body)
          this[_body] = body;
        return this;
      }

      upload(files, data) {
        this[_method] = 'UPLOAD';
        this[_files] = files && files !== undefined ? files : null;
        this[_data] = data && data !== undefined ? data : null;
        return this;
      }

      download() {
                this[_method] = 'DOWNLOAD';
                var url = arguments.length >= 1 && arguments[0] !== undefined ? arguments[0] : null;

		
                if (url) {
                    this[_url] = url;
                }
                var filePath = arguments.length >=2 && arguments[1] !== undefined ? arguments[1] : null;
                if (filePath) {
                    Log.showInfo("Request: filePath : "+filePath)
                    try {
                        if (FileUtils.isFilePathValid(filePath)) {
                            Log.showInfo("Request: isFilePathValid : true");
                            this[_downloadFilePath] = filePath;
                        }
                    } catch (err) {
                        Log.showInfo("Request: isFilePathValid : error : "+err);
                        throw new Error(err);
                    }
                }
                return this;
            }
      trace() {
        this[_method] = 'TRACE';
        return this;
      }

      connect() {
        this[_method] = 'CONNECT';
        return this;
      }

      request(method) {
        var body = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
        this[_method] = method;
        if (body) {
          this[_body] = body;
        }
        return this;
      }

      /*setdebugmode(value) {
        if (value) {
          console.log = loggerLog;
          console.info = loggerInfo;
          console.debug = loggerDebug;
          console.warn = loggerWarn;
          console.error = loggerError;
        } else {
          console.log = console.info = console.debug = console.warn = console.error = function () {
          };
        }

        return this;
      }*/

      setDefaultConfig(defaultConfig) {
        //this.setdebugmode(defaultConfig.debug_mode)
        this.setDefaultContentType(defaultConfig.content_type)
        this.setDefaultUserAgent(defaultConfig.user_agent)
        return this;
      }

      build() {
        if(!this[_url]){
          throw new Error('Incorrect  URL parameters');
        }
        Log.showInfo('Request: Builder.build() invoked');
        if (this[_cookieJar] != null) {
          Log.showInfo('Request: Build cookie... ');
          let cookieString = this[_cookieJar].loadForRequest(this[_url]);
          if (cookieString) {
            Log.showInfo('Request: cookies loaded:' + cookieString);
            this[_headers]['cookie'] = cookieString;
          }
        }
        return new Request(this);
      }
    }

    return Builder;
  }
}

export default Request;