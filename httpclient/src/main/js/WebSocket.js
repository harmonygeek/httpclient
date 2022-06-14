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

import webSocket from '@ohos.net.webSocket';

var _request = Symbol();
var _url = Symbol();

class WebSocket {
  constructor() {
    this[_request] = webSocket.createWebSocket();
  }

  get socketObject() {
    return this[_request];
  }

  url(value) {
    this[_url] = value;
    return this;
  }

  connect(success, error) {

    let promise = this.socketObject.connect(this[_url]);
    promise.then(() => {
      success('Connected')
    }).catch((err) => {
      error(err)
    });

  }

  sendMessage(message, success, error) {
    if (this.socketObject == null || this.socketObject == undefined) {
      error('Not Connected')
    }

    let promise = this.socketObject.send(message);
    promise.then((value) => {
      success(value)
    }).catch((err) => {
      error(err)
    });

    this.socketObject.on('message', (err, value) => {
      if (value) {
        success(value)
      } else {
        error(err)
      }
    });
    return this;
  }

  webSocketDisconnect(success, error) {
    if (this.socketObject == null || this.socketObject == undefined) {
      error('Not Connected')
    }
    let promise = this.socketObject.close();
    promise.then(() => {
      this[_request] = null;
      success('close success')

    }).catch((err) => {
      error('close fail, err is ' + JSON.stringify(err))
    });

  }
}

export default WebSocket;