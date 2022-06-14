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

import FormatUtils from './utils/FormatUtils'

var _mimes = Symbol();
var _content = Symbol();

var LF = '\r\n';

class RequestBody {
  constructor() {
    this[_mimes] = {};
    this[_content] = null;
  }

  mimesToString() {
    var res = '';

    for (var mimeName in this.mimes) {
      if (Object.prototype.hasOwnProperty.call(this.mimes, mimeName)) res += mimeName + ': '
      + this.mimes[mimeName] + LF;
    }

    return res;
  }

  get mimes() {
    return this[_mimes];
  }

  set mimes(value) {
    this[_mimes] = value;
  }

  get content() {
    return this[_content];
  }

  set content(value) {
    this[_content] = value;
  }

  static create(content) {
    if (content == undefined || content == null || content == '') {
      throw new Error('Incorrect request body content');
    }

    var rb = new RequestBody();

    if (typeof content === 'string') {
      rb.content = content;
    } else {
      rb.content = JSON.stringify(content);
      if (rb.content && (rb.content.localeCompare('{}') == 0)) {
        rb.content = null;
      }
    }

    rb.mimes = {};

    for (var _len = arguments.length, mimes = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
      mimes[_key - 1] = arguments[_key];
    }

    if (mimes && mimes.length) {
      if (typeof mimes[0] === 'string') rb.mimes = FormatUtils.mimeStringArrayToObject(mimes);
      else rb.mimes = mimes[0];
    }

    return rb;
  }
}

export default RequestBody;