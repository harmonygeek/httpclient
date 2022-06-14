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

import HttpTaskDispatcher from './dispatcher/HttpTaskDispatcher'

class HttpCall {
  constructor(httpClient, originalRequest) {
    this.client = httpClient;
    this.request = originalRequest;
    this.isCancelledRequest = false;
    this.onSuccessCallback = null;
    this.onFailureCallback = null;
  }

  getRequest() {
    return this.request;
  }

  getClient() {
    return this.client;
  }

  async execute() {
    this.request.isSyncCall = true;
    var response = await this.client.dispatcher.execute(this);
    return response;
  }

  enqueue(onSuccess, onFailure) {
    this.onSuccessCallback = onSuccess;
    this.onFailureCallback = onFailure;
    this.request.isSyncCall = false;
    this.client.dispatcher.enqueue(this);
  }

  getSuccessCallback() {
    return this.onSuccessCallback;
  }

  getFailureCallback() {
    return this.onFailureCallback;
  }

  cancel() {
    this.isCancelledRequest = true;
  }

  isCancelled() {
    return this.isCancelledRequest;
  }
}

export default HttpCall;
