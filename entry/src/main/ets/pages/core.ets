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
import Log from '../model/log'

@Entry
@Component
struct Core {
  @State message: string = 'Hello World'
  @State status: string = '000';
  @State content: string = 'init';
  info : any;
  echoServer: string = "http://www.yourserverfortest.com";
  redirectServer: string = "http://www.yourserverforredirect.com";
  client = new httpclient.HttpClient.Builder().setConnectTimeout(10000).build();

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column }) {
        Navigator({ target: 'pages/index', type: NavigationType.Push }) {
          Text('BACK')
            .fontSize(12).border({width: 1}).padding(10).fontColor(0x000000).borderColor(0x317aff)
        }
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('GET').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            let request = new httpclient.Request.Builder()
              .get("https://postman-echo.com/get?foo1=bar1&foo2=bar2")
              .addHeader("Content-Type", "application/json")
              .params("testKey1", "testValue1")
              .params("testKey2", "testValue2")
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

      Flex({ direction: FlexDirection.Column }) {
        Button('POST-1').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            var request = new httpclient.Request.Builder()
              .url(this.echoServer)
              .post(httpclient.RequestBody.create("test123"))
              .addHeader("Content-Type", "application/json")
              .build();
            this.client.newCall(request).execute().then((result) => {
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
            }).catch((error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('POST-2').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            var request = new httpclient.Request.Builder()
              .url("https://postman-echo.com/post")
              .post(httpclient.RequestBody.create({
                a: 'a1', b: 'b1'
              }, new httpclient.Mime.Builder().contentType('application/json', 'charset', 'utf8').build().getMime()))
              .build();
            this.client.newCall(request).execute().then((result) => {
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
            }).catch((error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('POST-3').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            let formEncoder = new httpclient.FormEncoder.Builder()
              .add('key1', 'value1')
              .add('key2', 'value2')
              .build();
            let feBody = formEncoder.createRequestBody();
            var request = new httpclient.Request.Builder()
              .url("https://postman-echo.com/post")
              .post(feBody)
              .build();
            this.client.newCall(request).execute().then((result) => {
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
            }).catch((error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('REDIRECT').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            var request = new httpclient.Request.Builder()
              .get(this.redirectServer)
              .addHeader("Content-Type", "application/json")
              .followRedirects(true)
              .retryOnConnectionFailure(true)
              .redirectMaxLimit(20)
              .retryMaxLimit(20)
              .build();

            this.client.newCall(request).execute().then((result) => {
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
            }).catch((error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('PUT').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            var request = new httpclient.Request.Builder()
              .url("https://postman-echo.com/put")
              .put(httpclient.RequestBody.create({
                a: 'a1', b: 'b1'
              }, new httpclient.Mime.Builder().contentType('application/json', 'charset', 'utf8').build()))
              .build();
            this.client.newCall(request).execute().then((result) => {
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
            }).catch((error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('DELETE').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            var request = new httpclient.Request.Builder()
              .url("https://reqres.in/api/users/2")
              .delete()
              .build();
            this.client.newCall(request).execute().then((result) => {
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
            }).catch((error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('MULTI DATA REQUEST').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            let requestBody1 = httpclient.RequestBody.create({Title: 'Multipart', Color: 'Brown'})
            let requestBody2 = httpclient.RequestBody.create("Okhttp")
            let requestBody3 = httpclient.RequestBody.create("MultiRequest")
            let boundary = "AaB03x";

            let multiPartObj = new httpclient.MultiPart.Builder()
              .boundary(boundary)
              .type(httpclient.MultiPart.FORMDATA)
              .addPart(requestBody1)
              .addPart(requestBody2)
              .addPart(requestBody3)
              .build();
            let body = multiPartObj.createRequestBody();
            var request =  new httpclient.Request.Builder()
              .url(this.echoServer)
              .post(body)
              .addHeader("Content-Type", "multipart/form-data")
              .params("LibName", "Okhttp-ohos")
              .params("Request", "MultiData")
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
            }, (error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('MULTIPLE REQUESTS').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            let request1 = new httpclient.Request.Builder()
              .get(this.echoServer)
              .addHeader("Content-Type", "application/json")
              .params("testKey1", "testValue1")
              .params("testKey2", "testValue2")
              .build();
            this.client.newCall(request1).enqueue((result) => {
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
            }, (error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });

            //POST
            let request2 = new httpclient.Request.Builder()
              .url(this.echoServer)
              .post(httpclient.RequestBody.create("test123"))
              .addHeader("Content-Type", "application/json")
              .build();
            this.client.newCall(request2).enqueue((result) => {
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
            }, (error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });

            //POST with 2 values
            let request3 = new httpclient.Request.Builder()
              .url(this.echoServer)
              .post(httpclient.RequestBody.create({
                a: 'a1', b: 'b1'
              }, new httpclient.Mime.Builder().contentType('application/json', 'charset', 'utf8').build().getMime()))
              .build();
            this.client.newCall(request3).enqueue((result) => {
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
            }, (error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
            //POST with 3 values
            let formEncoder = new httpclient.FormEncoder.Builder()
              .add('key1', 'value1')
              .add('key2', 'value2')
              .add('key3', 'value3')
              .build();
            let feBody = formEncoder.createRequestBody();

            var request4 = new httpclient.Request.Builder()
              .url(this.echoServer)
              .post(feBody)
              .build();
            this.client.newCall(request4).enqueue((result) => {
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
            }, (error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });

            //PUT request
            var request5 = new httpclient.Request.Builder()
              .url(this.echoServer)
              .put(httpclient.RequestBody.create({
                a: 'a1', b: 'b1'
              }, new httpclient.Mime.Builder().contentType('application/json', 'charset', 'utf8').build().getMime()))
              .build();
            this.client.newCall(request5).enqueue((result) => {
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
            }, (error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });

            //DELETE request
            var request6 = new httpclient.Request.Builder()
              .url(this.echoServer)
              .delete()
              .build();
            this.client.newCall(request6).enqueue((result) => {
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
            }, (error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('DNS Interceptor').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC)
          .align(Alignment.Center).margin(10)
          .onClick((event:ClickEvent) => {
            var url = "www.baidu.com";
            this.info = httpclient.DnsUtil.resolveDNSQuery(url);
            //execute useDNSInterceptor after 3000 milliseconds (3 seconds)
            setTimeout(() => {
              var url = "www.baidu.com";
              var request = new httpclient.Request.Builder()
                .get(url)
                .addInterceptor((req) => {
                  var route = new httpclient.Route(this.info);
                  //Now we have got the interceptor, now we can connect to IPAddress one after the other if previous one fails
                  Log.showInfo("onDNSRequest and route" + route);
                  return req;
                }, (res) => {
                  return res;
                })
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
              }, (error) => {
                this.status = "";
                this.content = error.data;
                Log.showInfo("onError -> Error : " + this.content);
              });
            }, 3000);
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
    }
    .width('100%').margin({ top: 5, bottom: 100 }).height('80%')

  }
}
