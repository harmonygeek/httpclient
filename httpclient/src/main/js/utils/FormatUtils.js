/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Log from './log';

function FormatUtils()  {};


var TAG = 'FormatUtils:: ';

/**
 * convert a key/value object into a query string
 *
 * @param keyValueObject a key/value object
 *
 * @returns {String} a query string
 */
FormatUtils.objectToQueryString = function objectToQueryString(keyValueObject) {
    var value = null;
    var res = '';
    var keyValue = void 0;

    if (keyValueObject === null) return '';

    for (var key in keyValueObject) {
        if (Object.prototype.hasOwnProperty.call(keyValueObject, key)) {
            value = keyValueObject[key].toString();
            keyValue = key + '=' + value;
            res += res === '' ? '?' + keyValue : '&' + keyValue;
        }
    }

    return res;
}

/**
 * convert a mime string array into key/value Object.
 * <pre>
 *     mimeStringArrayToObject(['Content-Type:image/jpg', 'Content-ID: myid'])
 *     ==>
 *     {
 *          'Content-Type': 'image/jpg',
 *          'Content-ID': 'myid',
 *     }
 * </pre>
 *
 * @param {Array} mimes array of strings that each represent a mime header.
 *
 * @return {Object} a key/value Object
 */
FormatUtils.mimeStringArrayToObject = function mimeStringArrayToObject(mimes) {
    if (!Array.isArray(mimes)) return mimes;

    var keyValue = {};

    var msg = TAG + 'mimeStringArrayToObject(..) --> mimes array is not formatted correctly';

    var _iteratorNormalCompletion = true;
    var _didIteratorError = false;
    var _iteratorError = undefined;

    try {
        for (var _iterator = mimes[Symbol.iterator](),
            _step;!(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
            var item = _step.value;
            if (typeof item === 'string') {
                var arr = item.split(':');
                if (arr.length < 2) {
                    keyValue[arr[0].trim()] = arr[1].trim();
                }
            }
        }
    } catch (err) {
        _didIteratorError = true;
        _iteratorError = err;
    } finally {
        try {
            if (!_iteratorNormalCompletion && _iterator.return) {
                _iterator.return();
            }
        } finally {
            if (_didIteratorError) {
                //error
            }
        }
    }

    return keyValue;
}

export default FormatUtils;