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
struct Compression {
  @State status: string = '000';
  @State content: string = 'init';
  gzipServer = "http://www.yourserverfortest.com";
  client = new httpclient.HttpClient.Builder().setConnectTimeout(10000).build();

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
        Button('GZIP Encode').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            const test = "hello, world!  adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdkja\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs";

            var compressed = httpclient.gZipUtil.gZipString(test);
            this.content = JSON.stringify(compressed);
            this.status = "";
            Log.showInfo("gzipencodeTest after gzip and compressed result is " + compressed);
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('GZIP Decode').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {
          const test = "hello, world!  adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdkja\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs";
          var compressed = httpclient.gZipUtil.gZipString(test);

          Log.showInfo("gzipencodeTest after gzip and compressed result is " + compressed);

          var restored = httpclient.gZipUtil.ungZipString(compressed);
          // Output to console
          Log.showInfo("gzipdecodeTest and uncompressed result is " + JSON.stringify(restored));
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('GZIP Encode File').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            var context = featureAbility.getContext();
            // @ts-ignore
            context.getCacheDir()
              .then((appInternalDir) => {
                Log.showInfo("gzipEncodeFileTest and appInternalDir is " + appInternalDir);
                let fpath = appInternalDir + "/hello.txt";
                let fd = fileIO.openSync(fpath, 0o102, 0o666);
                // @ts-ignore
                fileIO.writeSync(fd, "hello, world!  adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdkja\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
                + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs",
                  function (err, bytesWritten) {
                  });
                fileIO.closeSync(fd);

                //Till now string is written to hello.txt file. Now gzip hello.txt file to test.txt.gz
                let dest = appInternalDir + "/test.txt.gz";

                httpclient.gZipUtil.gZipFile(fpath, dest);
                Log.showInfo("gzipEncodeFile test success");
              })
              .catch((error) => {
                Log.showError('Failed to obtain the file directory. Cause: ' + error.message);
              })
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('GZIP Decode File').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            var context = featureAbility.getContext();
            // @ts-ignore
            context.getCacheDir()
              .then((appInternalDir) => {
                Log.showInfo("gzipDecodeFiletest and  appInternalDir is " + appInternalDir);

                let src = appInternalDir + "/test.txt.gz";
                let dest = appInternalDir + "/hello2.txt";

                httpclient.gZipUtil.ungZipFile(src, dest);
                Log.showInfo("gzipDecodeFiletest success");
              })
              .catch((error) => {
                Log.showError('Failed to obtain the file directory. Cause: ' + error.message);
              })
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Post GZIP Text').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            const teststr = "hello, world!  adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdkja\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
            + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs";

            var request = new httpclient.Request.Builder()
              .url(this.gzipServer)
              .post(httpclient.RequestBody.create(teststr))
              .addHeader("Content-Type", "application/json")
              .addHeader("Accept-Encoding", "gzip")
              .build();

            this.client.newCall(request).enqueue((result) => {
              if (result.response) {
                this.status = ""+result.response.responseCode;
              }
              if (result.response.result) {
                this.content = result.response.result;
              } else {
                this.content = JSON.stringify(result.response);
              }
              Log.showInfo("onComplete -> Status : " + this.status);
              Log.showInfo("onComplete -> Content : " + JSON.stringify(this.content));
            }, (error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
            this.content = 'waiting for response';
          })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Get GZIP Text').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            var request = new httpclient.Request.Builder()
              .get(this.gzipServer)
              .addHeader("Content-Type", "application/json")
              .addHeader("Accept-Encoding", "gzip")
              .build();
            this.client.newCall(request).enqueue((result) => {
              if (result.response) {
                this.status = ""+result.response.responseCode;
              }
              if (result.response.result) {
                this.content = result.response.result;
              } else {
                this.content = JSON.stringify(result.response);
              }
              Log.showInfo("onComplete -> Status : " + this.status);
              Log.showInfo("onComplete -> Content : " + JSON.stringify(this.content));
            }, (error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Text(this.status)
        .fontSize(20)
        .fontWeight(FontWeight.Bold);
      Text(this.content)
        .fontSize(20)

    }.width('100%').margin({ bottom: 100 }).height('80%')
  }
}