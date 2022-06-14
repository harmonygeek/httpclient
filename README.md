## httpclient

## 简介

HTTP是现代应用程序通过网络交换数据和媒体的的主要方式。httpclient是OpenHarmony 里一个高效执行的HTTP客户端，使用它可使您的内容加载更快，并节省您的流量。httpclient以人们耳熟能详的OKHTTP为基础，整合android-async-http，AutobahnAndroid，OkGo等库的功能特性，致力于在OpenHarmony 打造一款高效易用，功能全面的网络请求库。当前版本的httpclient依托系统提供的网络请求能力和上传下载能力，在此基础上进行拓展开发，已经实现的功能特性如下所示：

1.支持全局配置调试开关，超时时间，公共请求头和请求参数等，支持链式调用。

2.可以搭配[okio](https://gitee.com/openharmony-tpc/okio)库优化数据传输，搭配[retrofit](https://gitee.com/openharmony-tpc/retrofit)使用注解定义接口，让您的代码看起来更简洁美观。

3.自定义任务调度器维护任务队列处理同步/异步请求，支持tag取消请求。

4.支持设置自定义拦截器。

5.支持客户端解压缩。

6.支持文件上传下载。

7.支持cookie管理。





## 下载安装

```javascript
npm install @ohos/httpclient --save
```

OpenHarmony npm环境配置等更多内容，请参考[如何安装OpenHarmony npm](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_npm_usage.md)



## 使用说明
```
import httpclient from '@ohos/httpclient';
```

1.  GET请求方法配合拦截器I连接超时示例：

  ```javascript
   const myInterceptor = okhttp.interceptors.request.use(req => {
           req.url = req.url + "&foo3=bar3";
           return req;
       });
       var reqBuilder = new okhttp.RequestBuilder();
       reqBuilder.interceptors.request.use(req => {
           req.url = req.url + "&foo4=bar4";
           return req;
       });
       reqBuilder.interceptors.response.use(resp => {
           resp.responseCode = 404;
           return resp;
       });
       reqBuilder.GET("https://postman-echo.com/get?foo1=bar1&foo2=bar2").header("Content-Type", .connectTimeout(10000).buildAndExecute().then(this.onComplete).catch(this.onError);
       okhttp.interceptors.request.eject(myInterceptor);
  ```

2.POST请求方法示例 ：

```javascript
new okhttp.RequestBuilder().url("https://postman-echo.com/post").POST(okhttp.RequestBody.create("test123")).header("Content-Type", "application/json").connectTimeout(10000).buildAndExecute().then(this.onComplete).catch(this.onError);
```

3. POST请求方法带两个参数示例：

  ```javascript
  new okhttp.RequestBuilder().url("https://postman-echo.com/post")
           .POST(okhttp.RequestBody.create({
               a: 'a1', b: 'b1'
           }, new okhttp.MimeBuilder().contentType('application/json', 'charset', 'utf8').build()))
           .buildAndExecute().then(this.onComplete).catch(this.onError);
  ```

4. POST请求方法带三个参数示例:

  ```javascript
  let fe_body = new okhttp.FormEncodingBuilder().add('key1', 'value1').add('key2', 'value2').build();
       new okhttp.RequestBuilder().url("https://postman-echo.com/post").POST(fe_body).buildAndExecute()
           .then(this.onComplete).catch(this.onError);
  ```

5. 异步上传示例：

  ```javascript
  let appInternalDir;
       // @ts-ignore
       await featureAbility.getContext().getCacheDir().then(function (result) {
           appInternalDir = result;
       });
       let fpath = appInternalDir + this.fileName;
       let fd = fileIO.openSync(fpath, 0o102, 0o666);
       // @ts-ignore
       fileIO.writeSync(fd, "text.txt file is uploaded", function (err, bytesWritten) {
           if (!err) {
               console.log("meta " + bytesWritten);
           }
       });
       fileIO.closeSync(fd);
       fpath = fpath.replace(appInternalDir, "internal://cache");
       var fileUploadBuilder = new okhttp.FileUploadBuilder().addFile(fpath).addData("name2", "value2");
       var fileObject = fileUploadBuilder.buildFile();
       var dataObject = fileUploadBuilder.buildData();
       await new okhttp.RequestBuilder().url(this.fileServer)
           .UPLOAD(fileObject, dataObject).buildAndExecute().then(this.onComplete).catch(this.onError);
  ```

6. PUT请求示例：

  ```javascript
  new okhttp.RequestBuilder().url("https://postman-echo.com/put")
           .PUT(okhttp.RequestBody.create({
               a: 'a1', b: 'b1'
           }, new okhttp.MimeBuilder().contentType('application/json', 'charset', 'utf8').build()))
           .buildAndExecute().then(this.onComplete).catch(this.onError);
  ```

7.  DELETE请求示例：

  ```javascript
  new okhttp.RequestBuilder().url("https://reqres.in/api/users/2")
           .DELETE()
           .buildAndExecute().then(this.onComplete).catch(this.onError);
  ```

8. 文件下载请求示例：

  ```
  new okhttp.RequestBuilder().DOWNLOAD("https://archiveprogram.github.com/assets/img/direction/box2-home.png")
           .buildAndExecute().then(this.onDownloadTaskStart).catch(this.onError);
  onDownloadTaskStart: function (downloadTask) {
   downloadTask.on('complete', () => {
       this.content = "Download Task Completed";
   })
  }
  ```

## 接口说明

#### RequestBody

| 接口名 | 参数                                           | 返回值      | 说明                |
| ------ | ---------------------------------------------- | ----------- | ------------------- |
| create | content : String/JSON Object of Key:Value pair | RequestBody | 创建RequestBody对象 |

#### RequestBuilder

| 接口名          | 参数                     | 返回值         | 说明                     |
| --------------- | ------------------------ | -------------- | ------------------------ |
| buildAndExecute | 无                       | void           | 构建并执行RequestBuilder |
| newCall         | 无                       | void           | 执行请求                 |
| header          | name:String,value:String | RequestBuilder | 传入key、value构建请求头 |
| connectTimeout  | timeout:Long             | RequestBuilder | 设置连接超时时间         |
| url             | value:String             | RequestBuilder | 设置请求url              |
| GET             | 无                       | RequestBuilder | 构建GET请求方法          |
| PUT             | body:RequestBody         | RequestBuilder | 构建PUT请求方法          |
| DELETE          | 无                       | RequestBuilder | 构建DELETE请求方法       |
| POST            | 无                       | RequestBuilder | 构建POST请求方法         |
| UPLOAD          | files:Array, data:Array  | RequestBuilder | 构建UPLOAD请求方法       |
| CONNECT         | 无                       | RequestBuilder | 构建CONNECT请求方法      |

#### MimeBuilder

| 接口名      | 参数         | 返回值 | 说明                          |
| ----------- | ------------ | ------ | ----------------------------- |
| contentType | value:String | void   | 添加MimeBuilder contentType。 |

#### FormEncodingBuilder

| 接口名 | 参数                     | 返回值 | 说明                 |
| ------ | ------------------------ | ------ | -------------------- |
| add    | name:String,value:String | void   | 以键值对形式添加参数 |
| build  | 无                       | void   | 获取RequestBody对象  |

#### FileUploadBuilder

| 接口名    | 参数                     | 返回值 | 说明                        |
| --------- | ------------------------ | ------ | --------------------------- |
| addFile   | furi : String            | void   | 添加文件URI到参数里用于上传 |
| addData   | name:String,value:String | void   | 以键值对形式添加请求数据    |
| buildFile | 无                       | void   | 生成用于上传的文件对象      |
| buildData | 无                       | void   | 构建用于上传的数据          |

## 兼容性

支持OpenHarmony API version 8 及以上版本

## 目录结构

```javascript
|---- httpclient  
|     |---- entry  # 示例代码文件夹
|     |---- httpclient  # httpclient 库文件夹
|           |---- index.ets  # httpclient对外接口
|     |---- README.MD  # 安装使用方法                   
```

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/httpclient/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/httpclient/pulls)。

## 开源协议

本项目基于 [Apache License 2.0](https://gitee.com/openharmony-tpc/httpclient/blob/master/LICENSE.txt)，请自由地享受和参与开源。