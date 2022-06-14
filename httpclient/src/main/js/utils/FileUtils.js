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

import fileIO from '@ohos.fileio';
import Log from './log';

function FileUtils () {}

FileUtils.isFilePathValid = function isFilePathValid(filePath) {
    const lastSlash = filePath.lastIndexOf("/");
    const directoryName = filePath.substring(0, lastSlash);
    const fileName = filePath.substring(lastSlash + 1);
    const downloadPathDirectory = "data/misc";
    Log.showInfo("isFilePathValid lastSlash INDEX : "+lastSlash+" directoryName : "
    +directoryName+" fileName : "+fileName);
    //Framework requires filepath to include fileName
    if (!fileName.includes(".")) {
        Log.showInfo("isFilePathValid filename does not include .");
        throw new Error("Invalid filepath. Need to include filename");
    }

    //As per current OS limitation, download is restricted to data/misc folder.
    if (!directoryName.startsWith(downloadPathDirectory)) {
        Log.showInfo("isFilePathValid invalid directory does not contain data/misc");
        throw new Error("Invalid filepath. Download directory must be present in data/misc");
    }
    Log.showInfo("isFilePathValid fileName is ok and directory name starts with data/misc");
    let isDir = false;
    let errorMsg ="";
    try {
        isDir = fileIO.statSync(directoryName).isDirectory();
    } catch (err) {
        Log.showInfo("isFilePathValid fileIO.statSync(directoryName).isDirectory() : " + err);
        isDir = false;
        errorMsg = err;
    }
    if (!isDir) {
        Log.showInfo("isFilePathValid isDir is  " + isDir+ " errorMessage : "+errorMsg);
        throw new Error("Invalid filePath : "+errorMsg);
    }
    Log.showInfo("isFilePathValid filePath is valid");
    return true;

}

export default FileUtils;