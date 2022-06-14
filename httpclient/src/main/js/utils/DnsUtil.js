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

import featureAbility from '@ohos.ability.featureAbility'
import connection from '@ohos.net.connection';
import Log from '../utils/log';

function DnsUtil () {}


/**
 * This function gets IPAddresses corresponding to url by resolving DNS
 *
 * @param url urls who IP to resolve
 *
 * @returns {info} an array of IPAddress information
 */
DnsUtil.resolveDNSQuery = async function resolveDNSQuery(url) {

    var info = [];
    Log.showInfo("handleDNSQuery and url is "+ url);
    try {
        var hasNet =await connection.hasDefaultNet();

        if(true == hasNet){
            info = await connection.getAddressesByName(url);

            Log.showInfo("getDefaultNet & info "+ JSON.stringify(info));
        }
    } catch (err) {
        Log.showInfo("onFetchIpAddress getDefaultNet error :"+err);
        Log.showInfo("onFetchIpAddress getDefaultNet error stringified:"+JSON.stringify(err));
    }

    return info;
}

export default DnsUtil;