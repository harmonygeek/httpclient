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

import httpclient from "@ohos/httpclient/"
import fileIO from '@ohos.fileio';
import featureAbility from '@ohos.ability.featureAbility'
import Log from '../model/log'

@Entry
@Component
struct UploadAndDownload {
  @State status: string = '000';
  @State content: string = 'init';
  echoServer : string = "http://www.yourserverfortest.com";
  fileServer : string = "http://www.yourserverforfileupload.com";
  fileName : string = "/test.txt";
  downloadDirectory : string = "data/misc";

  client = new httpclient.HttpClient.Builder()
    .setConnectTimeout(10000)
    .setReadTimeout(10000)
    .setWriteTimeout(10000)
    .build();

  uploadRequest = async function () {
    const ctx = this
    Log.showInfo(" cacheDir   " + globalThis.cacheDir)
    let filePath = globalThis.cacheDir + this.fileName;
    Log.showInfo("   filePath   " + filePath)
    let fd = fileIO.openSync(filePath, 0o102, 0o666)
    fileIO.ftruncateSync(fd)
    fileIO.writeSync(fd, "test httpclient")
    fileIO.fsyncSync(fd)
    fileIO.closeSync(fd)

    Log.showInfo(" writeSync    ");
    Log.showInfo( "create file success   ")

    filePath = filePath.replace(globalThis.cacheDir, "internal://cache");

    var fileUploadBuilder = new httpclient.FileUpload.Builder()
      .addFile(filePath)
      .addData("name2", "value2")
      .build();
    var fileObject = fileUploadBuilder.getFile();
    var dataObject = fileUploadBuilder.getData();
    Log.showInfo( "fileObject:   "+JSON.stringify(fileObject));
    Log.showInfo( "dataObject:   "+JSON.stringify(dataObject));

    Log.showInfo('about to set : abilityContext - cacheDir  = ' + globalThis.abilityContext.cacheDir);
    Log.showInfo('about to Set : abilityContext - filesDir  = ' + globalThis.abilityContext.filesDir);
    Log.showInfo("type of :"+ typeof globalThis.abilityContext)

    let request = new httpclient.Request.Builder()
      .url(this.fileServer)
      .addFileParams(fileObject, dataObject)
      .setAbilityContext(globalThis.abilityContext)
      .build();
    this.client.newCall(request).execute().then((data) => {
      data.on('progress', (uploadedSize, totalSize) => {
        Log.showInfo('progress--->uploadedSize: ' + uploadedSize + ' ,totalSize--->' + totalSize);
        if (uploadedSize == totalSize){

        }
      })
      data.on('headerReceive', (headers) => {
        Log.showInfo( 'progress--->uploadSize: ' + JSON.stringify(headers));
      })
    }).catch((error)=> {
      this.status = "";
      this.content = error.data;
      Log.showInfo("onError -> Error : " + this.content);
    });
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column }) {
        Navigator({ target: 'pages/index', type: NavigationType.Push }) {
          Text('BACK')
            .fontSize(12).border({ width: 1}).padding(10).fontColor(0x000000).borderColor(0x317aff)
        }
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Upload').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            this.uploadRequest();
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Download IMG FILE').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            try {
              Log.showInfo(' abilityContext - cacheDir  = ' + globalThis.abilityContext.cacheDir);
              Log.showInfo(' abilityContext - filesDir  = ' + globalThis.abilityContext.filesDir);
              var request = new httpclient.Request.Builder()
                .download("https://archiveprogram.github.com/assets/img/direction/box2-home.png")
                .setAbilityContext(globalThis.abilityContext)
                .build();
              this.client.newCall(request).execute().then((downloadTask) => {
                downloadTask.on('progress', (receivedSize, totalSize) => {
                  Log.showInfo('progress--->downloadedSize: ' + receivedSize + ' ,totalSize--->' + totalSize);

                })
                downloadTask.on('complete', () => {
                  Log.showInfo("download complete");
                  this.content = "Download Task Completed";
                })
              }).catch((error)=> {
                this.status = "";
                this.content = error.data;
                Log.showInfo("onError -> Error : " + this.content);
              });
            } catch (err) {
              Log.showError("downloadFile execution failed - errorMsg : "+err);
            }
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Download BIN File').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            try {
              var request = new httpclient.Request.Builder()
                .download("https://filesamples.com/samples/font/bin/fontawesome-webfont.bin")
                .setAbilityContext(globalThis.abilityContext)
                .build();
              this.client.newCall(request).execute().then((downloadTask) => {
                downloadTask.on('complete', () => {
                  Log.showInfo("download complete");
                  this.content = "Download Task Completed";
                })
              }).catch((error)=> {
                this.status = "";
                this.content = error.data;
                Log.showInfo("onError -> Error : " + this.content);
              });
            } catch (err) {
              Log.showError("downloadBinaryFile execution failed - errorMsg : "+err);
            }
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Download Enqueue').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {

            try {
              this.status = "";
              let fPath = this.downloadDirectory + "/sampleEnqueue.jpg";
              var request = new httpclient.Request.Builder()
                .download("https://imgkub.com/images/2022/03/09/pexels-francesco-ungaro-15250411.jpg", fPath)
                .setAbilityContext(globalThis.abilityContext)
                .build();
              this.client.newCall(request).enqueue((downloadTask) => {
                downloadTask.on('complete', () => {
                  Log.showInfo("onDownloadTaskStart download complete");
                  this.content = "Download Task Completed";
                });
                downloadTask.on("progress", ( receivedSize, totalSize)=>{
                  Log.showInfo("onDownloadTaskStart downloadSize : "+receivedSize+" totalSize : "+totalSize);
                  this.content = ""+(receivedSize/totalSize)*100;
                });
              }, (error)=> {
                this.status = "";
                this.content = error.data;
                Log.showError("onError -> Error : " + this.content);
              });
            } catch (err) {
              Log.showError("downloadCustomLocationEnqueue execution failed - errorMsg : "+err);
            }
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Download Execute').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {
          try {
            this.status = "";
            let fPath = this.downloadDirectory + "/sampleExecute.jpg";
            var request = new httpclient.Request.Builder()
              .download("https://imgkub.com/images/2022/03/09/pexels-francesco-ungaro-15250411.jpg", fPath)
              .setAbilityContext(globalThis.abilityContext)
              .build();
            this.client.newCall(request).execute().then((downloadTask) => {
              downloadTask.on('complete', () => {
                Log.showInfo("onDownloadTaskStart download complete");
                this.content = "Download Task Completed";
              });
              downloadTask.on("progress", ( receivedSize, totalSize)=>{
                Log.showInfo("onDownloadTaskStart downloadSize : "+receivedSize+" totalSize : "+totalSize);
                this.content = "" + (receivedSize/totalSize)*100;
              });
            }).catch((error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
          } catch (err) {
            Log.showInfo("downloadCustomLocationExecute execution failed - errorMsg : "+err);
          }
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

    }.width('100%').margin({ top: 5, bottom: 100 }).height('80%')
  }

}