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

import pako from 'pako';
import fileIO from '@ohos.fileio';
import featureAbility from '@ohos.ability.featureAbility';
import Log from './log';

function gZipUtil() {
}


/**
 * convert a String value to its gzip value and returns its value as string
 *
 * @param strvalue string value object
 *
 * @returns {String} a converted string
 */
gZipUtil.gZipString = function gZipString(strvalue) {

  const compressed = pako.deflate(JSON.stringify(strvalue));
  return compressed;
}


/**
 * convert a gzip String value to its original value and returns its value as string
 *
 * @param strvalue string value object
 *
 * @returns {String} a converted string
 */
gZipUtil.ungZipString = function ungZipString(strvalue) {

  const restored = JSON.parse(pako.inflate(strvalue, { to: 'string' }));
  return JSON.stringify(restored);
}


/**
 * convert a String value to its gzip value and returns its value as string
 *
 * @param strvalue string value object
 *
 * @returns {String} a converted string
 */
gZipUtil.gZipFile = function gZipFile(srcFile, targetFile) {

  let stat = fileIO.statSync(srcFile);
  const buf = new ArrayBuffer(stat.size);
  const reader = fileIO.openSync(srcFile, 0o2);
  fileIO.readSync(reader, buf);

  const writer = fileIO.openSync(targetFile, 0o102, 0o666);
  const options = { gzip: true, level: 9 };
  fileIO.writeSync(writer, pako.gzip(new Uint8Array(buf), options).buffer);
  fileIO.closeSync(reader);
  fileIO.closeSync(writer);

  Log.showInfo('gZipFile done');
}


/**
 * convert a String value to its gzip value and returns its value as string
 *
 * @param strvalue string value object
 *
 * @returns {String} a converted string
 */
gZipUtil.ungZipFile = async function ungZipFile(srcFile, targetFile) {
  const reader = fileIO.openSync(srcFile, 0o2);
  const stat = fileIO.statSync(srcFile);
  const buf = new ArrayBuffer(stat.size);
  const res = await fileIO.read(reader, buf);

  const options = {
    gzip: true, level: 9
  };
  const data = pako.inflate(new Uint8Array(res.buffer), options);

  const writer = fileIO.openSync(targetFile, 0o102, 0o666);
  fileIO.writeSync(writer, data.buffer);
  fileIO.closeSync(writer);
  fileIO.closeSync(reader);

  Log.showInfo('ungZipFile done');
}

/**
 * string  Uint8Array
 * @param str String
 */
gZipUtil.stringToUint8Array = function stringToUint8Array(str) {
        var arr = [];
        if (str instanceof String) {
            for (var i = 0, j = str.length; i < j; ++i) {
                arr.push(str.charCodeAt(i));
            }
            var tmpUint8Array = new Uint8Array(arr);
            return tmpUint8Array
        } else if (str instanceof Uint8Array) {
            return str
        } else if (str instanceof Int8Array) {
            return str
        } else if (str instanceof Array) {
            return str
        } else {
            return new Uint8Array(arr)
        }
    }

gZipUtil.uint8ArrayToBuffer = function uint8ArrayToBuffer(array) {
        return array.buffer.slice(array.byteOffset, array.byteLength + array.byteOffset)
    }

export default gZipUtil;