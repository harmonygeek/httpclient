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
import http from '@ohos.net.http';
import fileIO from '@ohos.fileio';
import featureAbility from '@ohos.ability.featureAbility'
import Author from '../model/author'
import Log from '../model/log'

@Entry
@Component
struct Sample {
  @State status: string = "";
  @State content: string = "";
  echoServer: string = "https://postman-echo.com/get";
  fileName: string = "/test.txt";
  message: string = 'Hello World';
  client: any = new httpclient.HttpClient
  .Builder()
    .setConnectTimeout(10, httpclient.TimeUnit.SECONDS)
    .setReadTimeout(10, httpclient.TimeUnit.SECONDS)
    .build();
  cookieJar = httpclient.CookieJar();
  cookieManager = new httpclient.CookieManager();
  store = httpclient.CookieStore();
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
            .fontSize(10).border({
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
        Button('timeoutRequest').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          this.content = "waiting for response";
          let request1 = new httpclient.Request.Builder()
            .get()
            .url(this.echoServer)
            .tag("tag_timeout")
            .addHeader("Content-Type", "application/json")
            .build();
          this.client.newCall(request1).enqueue((result) => {
            if (result.response) {
              this.status = result.response.responseCode + " ";
            }
            if (result.response.result)
            this.content = result.response.result;
            else
            this.content = JSON.stringify(result.response);
          }, (error) => {
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
        Button('uploadTimeoutRequest').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          let appInternalDir;
          // @ts-ignore
          var fAbility = featureAbility.getContext().getCacheDir();
          //await fAbility.then(function (result) {
          fAbility.then(function(result) {
            appInternalDir = result;
          });
          let fpath = appInternalDir + this.fileName;
          let fd = fileIO.openSync(fpath, 0o102, 0o666);
          // @ts-ignore
          fileIO.writeSync(fd, "text.txt file is uploaded", function(err, bytesWritten) {});
          fileIO.closeSync(fd);
          fpath = fpath.replace(appInternalDir, "internal://cache");
          var fileUploadBuilder = new httpclient.FileUpload.Builder()
            .addFile(fpath)
            .addData("name2", "value2")
            .build();
          var fileObject = fileUploadBuilder.getFile();
          var dataObject = fileUploadBuilder.getData();
          let request = new httpclient.Request.Builder()
            .url(this.echoServer)
            .addFileParams(fileObject, dataObject)
            .build();
          this.client.newCall(request)
            .execute()
            .then((result) => {
              if (result.response) {
                this.status = result.response.responseCode + " ";
              }
              if (result.response.result)
              this.content = result.response.result;
              else
              this.content = JSON.stringify(result.response);
            })
            .catch((error) => {
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
        Button('Custom Request').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var authorId = "abc7689"
          var userName = "TestUser";
          var emailId = "testmail@gmail.com";
          var password = "password123";
          var author = new Author(authorId, userName, emailId, password);

          let requestBody = httpclient.RequestBody.create(JSON.stringify(author))

          var request = new httpclient.Request.Builder()
            .url("https://postman-echo.com/post")
            .post()
            .body(requestBody)
            .addHeader("Content-Type", "application/json")
            .build();

          this.client.newCall(request)
            .execute()
            .then(result => {
              this.status = result.response.responseCode;
              if (result.response.result)
              this.content = result.response.result;
              else
              this.content = result.response;
              var newauthor = JSON.parse(result.response.result);
            })
            .catch(err => {
              this.content = err.data;
            });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({
        direction: FlexDirection.Column
      }) {
        Button('Cancel Running Call').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var request = new httpclient.Request.Builder()
            .get()
            .url(this.echoServer)
            .tag("tag123")
            .addHeader("Content-Type", "application/json")
            .build();
          this.client.newCall(request).enqueue((result) => {
            if (result.response) {
              this.status = result.response.responseCode + " ";
            }
            if (result.response.result)
            this.content = result.response.result;
            else
            this.content = JSON.stringify(result.response);
          }, (error) => {
            this.content = JSON.stringify(error);
          });
          this.client.cancelRequestByTag("tag123");
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({
        direction: FlexDirection.Column
      }) {
        Button('Cancel Queued Call').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          let request1 = new httpclient.Request.Builder()
            .url(this.echoServer)
            .post()
            .body(httpclient.RequestBody.create("This is just a test message"))
            .tag("tag1")
            .addHeader("Content-Type", "application/json")
            .build();
          this.client.newCall(request1).enqueue((result) => {
            if (result.response) {
              this.status = result.response.responseCode + "";
            }
            if (result.response.result)
            this.content = result.response.result;
            else
            this.content = JSON.stringify(result.response);
          }, (error) => {
            this.content = JSON.stringify(error);
          });

          let request2 = new httpclient.Request.Builder()
            .get()
            .url(this.echoServer)
            .post()
            .body(httpclient.RequestBody.create("This is just a hello world message"))
            .tag("tag2")
            .addHeader("Content-Type", "application/json")
            .build();
          this.client.newCall(request2).enqueue((result) => {
            if (result.response) {
              this.status = result.response.responseCode + "";
            }
            if (result.response.result)
            this.content = result.response.result;
            else
            this.content = JSON.stringify(result.response);
          }, (error) => {
            this.content = JSON.stringify(error);
          });

          let request3 = new httpclient.Request.Builder()
            .get()
            .url(this.echoServer)
            .tag("tag3")
            .addHeader("Content-Type", "application/json")
            .build();
          this.client.newCall(request3).enqueue((result) => {
            if (result.response) {
              this.status = result.response.responseCode + '';
            }
            if (result.response.result)
            this.content = result.response.result;
            else
            this.content = JSON.stringify(result.response);
          }, (error) => {
            this.content = JSON.stringify(error);
          });

          let request4 = new httpclient.Request.Builder()
            .url(this.echoServer)
            .post()
            .body(httpclient.RequestBody.create("This is just a repeated hello world message"))
            .tag("tag4")
            .addHeader("Content-Type", "application/json")
            .build();
          this.client.newCall(request4).enqueue((result) => {
            if (result.response) {
              this.status = result.response.responseCode + '';
            }
            if (result.response.result)
            this.content = result.response.result;
            else
            this.content = JSON.stringify(result.response);
          }, (error) => {
            this.content = JSON.stringify(error);
          });
          this.client.cancelRequestByTag("tag3");

        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({
        direction: FlexDirection.Column
      }) {
        Button('cookieRequest').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var self = this;
          this.cookieManager.setCookiePolicy(httpclient.CookiePolicy.ACCEPT_ALL);
          this.cookieJar.setCookieStore(this.store);
          //first request to get the cookie
          let request1 = new httpclient.Request.Builder()
            .get()
            .url(this.echoServer)
            .tag("tag_cookie1")
            .cookieJar(this.cookieJar)
            .cookieManager(this.cookieManager)
            .addHeader("Content-Type", "application/json")
            .build();
          self.client.newCall(request1).enqueue((result) => {
            if (result.response) {
              this.status = result.response.responseCode + " ";
            }
            if (result.response.result)
            this.content = result.response.result;
            else
            this.content = JSON.stringify(result.response);
          }, (error) => {
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
        Button('cookieExpiryRequest').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var self = this;
          this.cookieManager.setCookiePolicy(httpclient.CookiePolicy.ACCEPT_ALL);
          this.cookieJar.setCookieStore(this.store);
          let request1 = new httpclient.Request.Builder()
            .get()
            .url(this.echoServer)
            .tag("tag_cookie1")
            .cookieJar(this.cookieJar)
            .cookieManager(this.cookieManager)
            .addHeader("Content-Type", "application/json")
            .build();
          self.client.newCall(request1).enqueue((result) => {
            if (result.response) {
              this.status = result.response.responseCode + " ";
            }
            if (result.response.result)
            this.content = result.response.result;
            else
            this.content = JSON.stringify(result.response);
          }, (error) => {
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
        Button('cookieDomainRequest').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var self = this;
          this.cookieManager.setCookiePolicy(httpclient.CookiePolicy.ACCEPT_ORIGINAL_SERVER);
          this.cookieJar.setCookieStore(this.store);
          let request1 = new httpclient.Request.Builder()
            .get()
            .url(this.echoServer)
            .tag("tag_cookie2")
            .cookieJar(this.cookieJar)
            .cookieManager(this.cookieManager)
            .addHeader("Content-Type", "application/json")
            .build();
          self.client.newCall(request1).enqueue((result) => {
            if (result.response) {
              this.status = result.response.responseCode + " ";
            }
            if (result.response.result)
            this.content = result.response.result;
            else
            this.content = JSON.stringify(result.response);
          }, (error) => {
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
        Button('JSONcallback').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var Callback = new httpclient.JsonCallback();
          this.content = "waiting for response";
          let request1 = new httpclient.Request.Builder()
            .get()
            .url(this.echoServer)
            .tag("tag_callbackJSON")
            .addHeader("Content-Type", "application/json")
            .convertor(Callback)
            .build();
          this.client.newCall(request1).execute().then((result) => {
            if (result.body) {
              this.content = "onCallbackComplete -> result : " + JSON.stringify(result.body) + " ,type is : " +
              typeof result.body + " , code:" + result.code + " , header:" + result.header;
            } else
            this.content = "onCallbackComplete -> result : " + JSON.stringify(result.response);
          })
            .catch((error) => {
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
        Button('Stringcallback').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var Callback = new httpclient.StringCallback();
          this.content = "waiting for response";
          let request1 = new httpclient.Request.Builder()
            .get()
            .url(this.echoServer)
            .tag("tag_callbackString")
            .addHeader("Content-Type", "application/json")
            .convertor(Callback)
            .build();
          this.client.newCall(request1).execute().then((result) => {
            if (result.body) {
              this.content = "onCallbackComplete -> result : " + JSON.stringify(result.body) + " ,type is : " +
              typeof result.body + " , code:" + result.code + " , header:" + result.header;
            } else
            this.content = "onCallbackComplete -> result : " + JSON.stringify(result.response);
          })
            .catch((error) => {
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
        Button('ByteStringcallback').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event: ClickEvent) => {
          var Callback = new httpclient.ByteStringCallback();
          this.content = "waiting for response";
          let request1 = new httpclient.Request.Builder()
            .get()
            .url(this.echoServer)
            .tag("tag_callbackByte")
            .addHeader("Content-Type", "application/json")
            .convertor(Callback)
            .build();
          this.client.newCall(request1).execute().then((result) => {
            if (result.body) {
              this.content = "onCallbackComplete -> result : " + JSON.stringify(result.body) + " ,type is : " +
              typeof result.body + " , code:" + result.code + " , header:" + result.header;
            } else
            this.content = "onCallbackComplete -> result : " + JSON.stringify(result.response);
          })
            .catch((error) => {
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
        Text("Response:\n Status:" + this.status)
          .fontSize(20)
          .fontWeight(FontWeight.Bold);
        Text("Content:" + this.content)
          .fontSize(20)
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