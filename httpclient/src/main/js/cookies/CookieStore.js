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
import dataStorage from '@ohos.data.storage'
import featureAbility from '@ohos.ability.featureAbility'
import {CookiePolicy} from './httpcookieutils';
import Log from '../utils/log';

function CookieStore() {
  var cookieJSON, path = null;
  var context = featureAbility.getContext();
  try {
    context.getFilesDir().then(data=>{
      this.path = data
    }).catch((err) => {
      Log.showError("CookieStore getFilesDir not resolved : "+err);
    });
  } catch (error) {
    Log.showError("CookieStore getFilesDir failed : "+error);
  }
  return this;
}
CookieStore.prototype.readCookie = function readCookie(hostname) {
  Log.showInfo('okhttp- CookieStore readCookie: ' + hostname);
  let storage = dataStorage.getStorageSync(this.path + '/cookiestore');
  let cookieJSON = storage.getSync(hostname, '')
  storage.flushSync();
  return cookieJSON;
}
CookieStore.prototype.writeCookie = function writeCookie(hostname, cookieJSON) {
  Log.showInfo('okhttp- CookieStore writeCookie: ' + hostname + ',cookieJSON:' + cookieJSON + ',path:' + this.path);
  let storage = dataStorage.getStorageSync(this.path + '/cookiestore');
  storage.putSync(hostname, cookieJSON)
  storage.flushSync();
}

export default CookieStore;