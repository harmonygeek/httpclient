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

import gZipUtil from './utils/gZipUtil';
import Request from './Request'
import HttpCall from './HttpCall'
import {Interceptor} from './utils/Interceptor'
import {gInterceptors} from './utils/Interceptor';
import {TimeUnit, TimeoutType} from './utils/Utils'
import Log from './utils/log'
import HttpTaskDispatcher from './dispatcher/HttpTaskDispatcher'

var _dispatcher = Symbol();
var _interceptors = Symbol();
var _authenticator = Symbol();
var _cache = Symbol();
var _protocols = Symbol();
var _callTimeout = Symbol();
var _connectTimeout = Symbol();
var _readTimeout = Symbol();
var _writeTimeout = Symbol();
var _pingInterval = Symbol();
var _taskRunner = Symbol();

class HttpClient {
  constructor(build) {
    if (!arguments.length) {
      build = new HttpClient.Builder();
    }
    this[_dispatcher] = build[_dispatcher];
    this[_interceptors] = build[_interceptors];
    this[_authenticator] = build[_authenticator];
    this[_cache] = build[_cache];
    this[_protocols] = build[_protocols];
    this[_callTimeout] = build[_callTimeout];
    this[_connectTimeout] = build[_connectTimeout];
    this[_readTimeout] = build[_readTimeout];
    this[_writeTimeout] = build[_writeTimeout];
    this[_pingInterval] = build[_pingInterval];
    this[_taskRunner] = build[_taskRunner];

    this.processInterceptor();
  }

  processInterceptor() {
    /*if (gInterceptors.request.getSize() == 0) {
      gInterceptors.request.use(req => {
        var header = req.headers;
        var requestJSON = JSON.parse(JSON.stringify(header));
        var encodingFormat = requestJSON["Accept-Encoding"];
        encodingFormat = (encodingFormat == undefined)?requestJSON["Accept-Encoding".toLowerCase()]:encodingFormat;
        encodingFormat = (encodingFormat == undefined)?requestJSON["Accept-Encoding".toUpperCase()]:encodingFormat;
        if (encodingFormat == undefined || encodingFormat == null || encodingFormat == '') {
          return req;
        }
        if (encodingFormat.toString().toLowerCase() == 'gzip') {
          try {
            if (req.body != null) {
              var compressed = gZipUtil.gZipString(req.body.content);
              let myArray = gZipUtil.stringToUint8Array(compressed)
              let buffer = gZipUtil.uint8ArrayToBuffer(myArray)
              req.body.content = buffer;
            }
          } catch (error) {
            Log.showError("gInterceptors: Request error : " + error.message);
          }
        }
        return req;
      });
    }
    if (gInterceptors.response.getSize() == 0) {
      gInterceptors.response.use(resp => {
        var header = resp.header;
        var responseJSON = JSON.parse(JSON.stringify(header));
        var decodingFormat = responseJSON["Content-Encoding"];
        decodingFormat = (decodingFormat == undefined)?responseJSON["Content-Encoding".toLowerCase()]:decodingFormat;
        decodingFormat = (decodingFormat == undefined)?responseJSON["Content-Encoding".toUpperCase()]:decodingFormat;
        if (decodingFormat == undefined || decodingFormat == null || decodingFormat == '') {
          return resp;
        }
        if (decodingFormat.toString().toLowerCase() == 'gzip') {
          try {
            if (resp.result != null) {
              var restored = gZipUtil.ungZipString(JSON.parse(resp.result));
              return restored;
            }
          } catch (error) {
            Log.showError("gInterceptors: Response error : " + error.message);
          }
        }
        return resp;
      });
    }
    */
  }

  newCall(request) {
    if (request == undefined || request == null || request == '') {
      throw new Error('Incorrect request parameters');
    }
    var newCall = new HttpCall(this, request);
    request.client = this;
    return newCall;
  }

  newWebSocket(request, webSocketListener) {}

  get dispatcher() {
    return this[_dispatcher];
  }

  get interceptors() {
    return this[_interceptors];
  }

  get authenticator() {
    return this[_authenticator];
  }

  get cache() {
    return this[_cache];
  }

  get protocols() {
    return this[_protocols];
  }

  get callTimeout() {
    return this[_callTimeout];
  }

  get connectionTimeout() {
    return this[_connectTimeout];
  }

  get readTimeout() {
    return this[_readTimeout];
  }

  get writeTimeout() {
    return this[_writeTimeout];
  }

  get pingInterval() {
    return this[_pingInterval];
  }

  get taskRunner() {
    return this[_taskRunner];
  }

  cancelRequestByTag(tagKey) {
    Log.showInfo('HttpClient: cancelRequestByTag tagKey : ' + tagKey);
    let queuedCalls = this.dispatcher.getQueuedCalls();
    queuedCalls.forEach(call => {
      if (call.getRequest().tag == tagKey) {
        Log.showInfo('HttpClient: cancelRequestByTag - call with tagkey found in queuedCalls : ' + tagKey);
        call.cancel();
      }
    });

    let runningCalls = this.dispatcher.getRunningCalls();
    runningCalls.forEach(call => {
      if (call.getRequest().tag == tagKey) {
        Log.showInfo('HttpClient: cancelRequestByTag - call with tagkey found in runningCalls : ' + tagKey);
        call.cancel();
      }
    });
  }

  static get Builder() {
    class Builder {
      constructor() {
        this[_dispatcher] = new HttpTaskDispatcher();
        this[_interceptors] = {
          request: new Interceptor(),
          response: new Interceptor()
        };
        this[_authenticator] = null;
        this[_protocols] = {};
        this[_cache] = null;
        this[_callTimeout] = null;
        this[_connectTimeout] = 10000;
        this[_readTimeout] = 10000;
        this[_writeTimeout] = 10000;
        this[_pingInterval] = 0;
        this[_taskRunner] = null;
      }

      addInterceptor(aInterceptor) {
        this[_interceptors].push(aInterceptor);
        return this;
      }

      authenticator(aAuthenticator) {
        this[_authenticator] = aAuthenticator;
        return this;
      }

      cache(aCache) {
        this[_cache] = aCache;
        return this;
      }

      protocols(aProtocols) {
        this[_protocols] = aProtocols;
        return this;
      }

      setCallTimeout(timeout, unit) {
        return this;
      }

      setConnectTimeout(timeout, unit) {
        var timeUnit = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
        this._setTimeOut(timeout == undefined || timeout == null || timeout == ''
                         || timeout < 0 ? this[_connectTimeout] : timeout, timeUnit, TimeoutType.CONNECT);
        return this;
      }

      setReadTimeout(timeout, unit) {
        var timeUnit = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
        this._setTimeOut(timeout == undefined || timeout == null || timeout == ''
                         || timeout < 0 ? this[_readTimeout] : timeout, timeUnit, TimeoutType.READ);
        return this;
      }

      setWriteTimeout(timeout, unit) {
        var timeUnit = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
        this._setTimeOut(timeout == undefined || timeout == null || timeout == ''
                         || timeout < 0 ? this[_writeTimeout] : timeout, timeUnit, TimeoutType.WRITE);
        return this;
      }

      _setTimeOut(timeout, timeUnit, timeoutType) {
        var lTimeout = timeout;
        if (timeUnit != null) {
          switch (timeUnit) {
            case TimeUnit.SECONDS:
              lTimeout = timeout * 1000;
              break;
            case TimeUnit.MINUTES:
              lTimeout = timeout * 60000;
              break;
            default:
              break;
          }
        }
        switch (timeoutType) {
          case TimeoutType.CONNECT:
            this[_connectTimeout] = lTimeout;
            break;
          case TimeoutType.READ:
            this[_readTimeout] = lTimeout;
            break;
          case TimeoutType.WRITE:
            this[_writeTimeout] = lTimeout;
            break;
          default:
            break;
        }
      }

      setPingInterval(timeout, unit) {}

      build() {
        Log.showInfo('HttpClient: Builder.build() invoked');
        return new HttpClient(this);
      }
    }

    return Builder;
  }
}

export default HttpClient;