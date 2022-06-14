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

import httpclient from '@ohos/httpclient';
import router from '@system.router';
import defaultConfigJSON from './defaultConfig.json';
import Log from '../model/log'

@Entry
@Component
struct Auxiliary {
  @State message: string = 'Hello World'
  @State status: string = "";
  @State content: string = "";
  echoServer: string = "https://postman-echo.com/get";
  client: any = new httpclient.HttpClient
  .Builder()
    .setConnectTimeout(10, httpclient.TimeUnit.SECONDS)
    .setReadTimeout(10, httpclient.TimeUnit.SECONDS)
    .build();
  onError(error) {
    this.content = JSON.stringify(error);
  }
  build() {
    Column() {
      Flex({
        direction: FlexDirection.Column
      }) {
        Navigator({
          target: 'pages/index',
          type: NavigationType.Push
        }) {
          Text('BACK')
            .fontSize(12).border({
            width: 1
          }).padding(10).fontColor(0x000000).borderColor(0x317aff)
        }
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({
        direction: FlexDirection.Column
      }) {
        Button('setDefaultContentType').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var request = new httpclient.Request.Builder()
            .url("https://postman-echo.com/post")
            .post()
            .body(httpclient.RequestBody.create("test123"))
            .addHeader("Content-Type", "application/json")
            .setDefaultContentType(null)
            .build();
          this.client.newCall(request).execute().then((result) => {
            if (result.response) {
              this.status = result.response.responseCode+ "";
            }
            if (result.response.result)
            this.content = result.response.result ;
            else
            this.content = JSON.stringify(result.response);
          }).catch((error) => {
            this.content = JSON.stringify(error);
          });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({
        direction: FlexDirection.Column
      }) {
        Button('setDefaultUserAgent').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var request = new httpclient.Request.Builder()
            .url("https://postman-echo.com/post")
            .post()
            .body(httpclient.RequestBody.create("test123"))
            .addHeader("Content-Type", "application/json")
            .setDefaultUserAgent(null)
            .build();
          this.client.newCall(request).execute().then((result) => {
            if (result.response) {
              this.status = result.response.responseCode+ "";
            }
            if (result.response.result)
            this.content = result.response.result ;
            else
            this.content = JSON.stringify(result.response);
          }).catch((error) => {
            this.content = JSON.stringify(error);
          });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({
        direction: FlexDirection.Column
      }) {
        Button('setContentType').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var request = new httpclient.Request.Builder()
            .url("https://postman-echo.com/post")
            .post()
            .body(httpclient.RequestBody.create("test123"))
            .setDefaultContentType("application/text")
            .build();
          this.client.newCall(request).execute().then((result) => {
            if (result.response) {
              this.status = result.response.responseCode+ "";
            }
            if (result.response.result)
            this.content = result.response.result ;
            else
            this.content = JSON.stringify(result.response);
          }).catch((error) => {
            this.content = JSON.stringify(error);
          });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({
        direction: FlexDirection.Column
      }) {
        Button('setUserAgent').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var request = new httpclient.Request.Builder()
            .url("https://postman-echo.com/post")
            .post()
            .body(httpclient.RequestBody.create("test123"))
            .addHeader("Content-Type", "application/json")
            .setDefaultUserAgent("My Application 1.0")
            .build();
          this.client.newCall(request).execute().then((result) => {
            if (result.response) {
              this.status = result.response.responseCode+ "";
            }
            if (result.response.result)
            this.content = result.response.result ;
            else
            this.content = JSON.stringify(result.response);

          }).catch((error) => {
            this.content = JSON.stringify(error);
          });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({
        direction: FlexDirection.Column
      }) {
        Button('defaultConfigJSON').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var request = new httpclient.Request.Builder()
            .url("https://postman-echo.com/post")
            .post()
            .body(httpclient.RequestBody.create("test123"))
            .setDefaultConfig(defaultConfigJSON)
            .build();
          this.client.newCall(request).execute().then((result) => {
            if (result.response) {
              this.status = result.response.responseCode+ "";
            }
            if (result.response.result)
            this.content = result.response.result ;
            else
            this.content = JSON.stringify(result.response);
          }).catch((error) => {
            this.content = JSON.stringify(error);
          });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)
    }.width('100%').margin({
      top: 5,
      bottom: 100
    }).height('80%')
  }
}