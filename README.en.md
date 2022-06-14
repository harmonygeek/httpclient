- # httpclient

  ## Introduction

  HTTP is the primary way modern applications exchange data and media over the network. httpclient is an efficient HTTP client in OpenHarmony, using it allows your content to load faster and save bandwidth. Based on the well-known httpclient, httpclient integrates the functional characteristics of android-async-http, AutobannAndroid, OkGo and the other libraries, and is committed to creating an efficient, easy-to-use and comprehensive network request library in OpenHarmony. The currently provided httpclient relies on the network request capabilities and upload and download capabilities provided by the system. On this basis, it has been expanded and developed, and some functions of the above network libraries have been realized. These completed functions include: 

  1. Globally configure debugging switches, timeouts, common request header and request parameters, etc., and support chain calls

  2.  Cooperate with okio library to optimize IO, and use annotation to define interface with retrofit

  3.  The custom task scheduler maintains the task queue to process synchronous and asynchronous requests, and support tag cancellation requests

  4.  Support setting custom interceptor

  5.  Support redirection

  6.  Support client-side gzip decompression

  7.  Support file upload and download

  8.  Support cookie management etc

     

  ##  Download and install

  ```javascript
  npm install @ohos/httpclient --save
  ```

  For more information on OpenHarmony npm environment configuration, please refer [to How to Install OpenHarmony npm](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_npm_usage.md)

  

  ## Instructions for use::

  ```javascript
  import httpclient from '@ohos/httpclient';
  ```

  1. GET request method , connection timeout example:

    ```javascript
  this.client =new httpclient.HttpClient.Builder().setConnectTimeout(10000).build();
      
  let request = new httpclient.Request.Builder()
              .get("https://postman-echo.com/get?foo1=bar1&foo2=bar2")
              .addHeader("Content-Type", "application/json")
              .params("testKey1", "testValue1")
              .params("testKey2", "testValue2")
              .build();
  
  this.client.newCall(request).enqueue(this.onComplete, this.onError);  
    ```
  
  2. Post request method example:
  
    ```javascript
  this.client =new httpclient.HttpClient.Builder().setConnectTimeout(10000).build();
var request = new httpclient.Request.Builder()
              .url(this.echoServer)
            .post(httpclient.RequestBody.create("test123"))
              .addHeader("Content-Type", "application/json")
              .build();
          this.client.newCall(request).execute().then(this.onComplete).catch(this.onError);
    
    ```
  
  3. Post request method with two parameters example:
  
    ```javascript
  this.client =new httpclient.HttpClient.Builder().setConnectTimeout(10000).build();

  var request = new httpclient.Request.Builder()
                .url("https://postman-echo.com/post")
                  .post(httpclient.RequestBody.create({
                      a: 'a1', b: 'b1'
                  }, new httpclient.Mime.Builder().contentType('application/json', 'charset', 'utf8').build().getMime()))
                  .build();
          this.client.newCall(request).execute().then(this.onComplete).catch(this.onError);
    ```
  
  4. Example of POST request method with three parameters:
  
  ```javascript
  this.client =new httpclient.HttpClient.Builder().setConnectTimeout(10000).build();

  let formEncoder = new httpclient.FormEncoder.Builder()
                  .add('key1', 'value1')
                  .add('key2', 'value2')
                  .build();
          let feBody = formEncoder.createRequestBody();
          var request = new httpclient.Request.Builder()
                  .url("https://postman-echo.com/post")
                .post(feBody)
                  .build();
        this.client.newCall(request).execute().then(this.onComplete).catch(this.onError);
    ```
  
  5. Asynchronous upload:
  
    ```javascript
  this.client= new httpclient.HttpClient.Builder()
              .setConnectTimeout(10000)
              .setReadTimeout(10000)
              .setWriteTimeout(10000)
              .build();
  
  let appInternalDir;
          // @ts-ignore
          var fAbility = featureAbility.getContext().getCacheDir();
          await fAbility.then(function (result) {
              appInternalDir = result;
          });
          let fpath = appInternalDir + this.fileName;
          let fd = fileIO.openSync(fpath, 0o102, 0o666);
          // @ts-ignore
          fileIO.writeSync(fd, "text.txt file is uploaded", function (err, bytesWritten) {
          });
        fileIO.closeSync(fd);
          fpath = fpath.replace(appInternalDir, "internal://cache");
        var fileUploadBuilder = new httpclient.FileUpload.Builder()
              .addFile(fpath)
              .addData("name2", "value2")
              .build();
          var fileObject = fileUploadBuilder.getFile();
          var dataObject = fileUploadBuilder.getData();
        let request = new httpclient.Request.Builder()
              .url(this.fileServer)
            .addFileParams(fileObject, dataObject)
              .build();
          this.client.newCall(request)
              .execute()
              .then(this.onComplete)
              .catch(this.onError);
  
    ```

  6. Example of PUT request:
  
    ```javascript
  this.client =new httpclient.HttpClient.Builder().setConnectTimeout(10000).build();
  
  var request = new httpclient.Request.Builder()
                  .url("https://postman-echo.com/put")
                  .put(httpclient.RequestBody.create({
                      a: 'a1', b: 'b1'
                  }, new httpclient.Mime.Builder().contentType('application/json', 'charset', 'utf8').build()))
                .build();
          this.client.newCall(request).execute().then(this.onComplete).catch(this.onError);
  ```
  
7. DELETE request example:
  
  ```javascript
  this.client =new httpclient.HttpClient.Builder().setConnectTimeout(10000).build();
  
  var request = new httpclient.Request.Builder()
                .url("https://reqres.in/api/users/2")
                  .delete()
                .build();
          this.client.newCall(request).execute().then(this.onComplete).catch(this.onError);
    ```
  
  8. Example of file download request:
  
    ```javascript
  this.client= new httpclient.HttpClient.Builder()
              .setConnectTimeout(10000)
              .setReadTimeout(10000)
              .setWriteTimeout(10000)
              .build();
  
  var request = new httpclient.Request.Builder()                  .download("https://archiveprogram.github.com/assets/img/direction/box2-home.png")
                .build();
              this.client.newCall(request).execute().then(this.onDownloadTaskStart).catch(this.onError);
        
    ```
  
  

  ## Interface Description

  ### 1.RequestBody ---request body
  
  | Interface name | parameter                                      | return value | illustrate                  |
  | -------------- | ---------------------------------------------- | ------------ | --------------------------- |
| create()       | content : String/JSON Object of Key:Value pair | RequestBody  | Create a RequestBody object |
  
### 2.RequestBuilder ---request constructor
  
  | Interface name    | parameter                  | return value   | illustrate                                         |
  | ----------------- | -------------------------- | -------------- | -------------------------------------------------- |
  | buildAndExecute() | None                       | void           | Builds a request object and executes the request   |
  | newCall()         | None                       | void           | Execute the request                                |
  | header()          | name:String,value:String): | RequestBuilder | Use key and value as input to build request header |
| connectTimeout()  | timeout:Long               | RequestBuilder | Time period to establish connection with host.     |
  | url()             | value:String               | RequestBuilder | Set the request url                                |
| GET()             | None                       | RequestBuilder | Builds a GET request                               |
  | PUT()             | body:RequestBody           | RequestBuilder | Builds a PUT request                               |
| DELETE()          | None                       | RequestBuilder | Builds a DELETE request                            |
  | POST()            | None                       | RequestBuilder | Builds a POST request                              |
  | UPLOAD()          | files:Array, data:Array)   | RequestBuilder | Builds an UPLOAD request                           |
  | CONNECT()         | None                       | RequestBuilder | Builds a CONNECT request                           |
  
  ### 3.MimeBuilder---media type constructor
  
  | Interface name | parameter    | return value | illustrate       |
  | -------------- | ------------ | ------------ | ---------------- |
| ContentType    | value:String | void         | Set content type |
  
### 4.FormEncodingBuilder---form encoding constructor
  
| Interface name | parameter                 | return value | illustrate                        |
  | -------------- | ------------------------- | ------------ | --------------------------------- |
  | add()          | name:String, value:String | void         | Add parameters as key-value pairs |
  | build()        | none                      | void         | returns Request Body object       |
  
  ### 4.FileUploadBuilder---File upload constructor
  
  | Interface name | parameter                 | return value | illustrate                                    |
  | -------------- | ------------------------- | ------------ | --------------------------------------------- |
  | addFile()      | furi:String               | void         | Add file URI to request parameters for upload |
  | addData()      | name:String, value:String | void         | Add parameters as key-value pairs             |
  | buildFile()    | None                      | void         | Build file object to upload                   |
  | buildData()    | None                      | void         | Build data to upload                          |
  
  ## Compatibility
  
  Support OpenHarmony API version 8 and above
  
  ## Directory Structure
  ````javascript
  |---- httpclient  
  |     |---- entry  # sample code folder
  |     |---- httpclient  # httpclient library folder
  |           |---- index.ets  # httpclient external interface
  |     |---- README.MD  # Installation and usage
  ````
  
  ## Contribute code
  
  If you find any problems during use, you can submit an [Issue](https://gitee.com/openharmony-tpc/httpclient/issues) to us. Of course, we also welcome you to submit [PR](https://gitee.com/openharmony-tpc/httpclient/pulls) to us .
  
  ## Open Source Protocol
  This project is based on  [Apache License 2.0](https://gitee.com/openharmony-tpc/httpclient/blob/master/LICENSE.txt)，please enjoy and participate in open source freely.