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

import Request from './src/main/js/Request'
import HttpClient from './src/main/js/HttpClient'
import RequestBody from './src/main/js/RequestBody';
import {TimeUnit} from './src/main/js/utils/Utils';
import FileUpload from './src/main/js/builders/FileUpload';
import FormEncoder from './src/main/js/builders/FormEncoder';
import Mime from './src/main/js/builders/Mime';
import MultiPart from './src/main/js/builders/MultiPart';
import Cookie from './src/main/js/cookies/Cookie';
import CookieJar from './src/main/js/cookies/CookieJar';
import CookieStore from './src/main/js/cookies/CookieStore';
import {CookiePolicy} from './src/main/js/cookies/httpcookieutils';
import CookieManager from './src/main/js/cookies/CookieManager';
import Route from './src/main/js/core/Route';
import DnsUtil from './src/main/js/utils/DnsUtil';
import gZipUtil from './src/main/js/utils/gZipUtil';
import WebSocket from './src/main/js/WebSocket';
import JsonCallback from './src/main/js/callback/JsonCallback';
import StringCallback from './src/main/js/callback/StringCallback';
import ByteStringCallback from './src/main/js/callback/ByteStringCallback';

var httpclient = {
  'Request': Request,
  'HttpClient': HttpClient,
  'RequestBody': RequestBody,
  'Mime': Mime,
  'MultiPart': MultiPart,
  'FileUpload': FileUpload,
  'FormEncoder': FormEncoder,
  'TimeUnit': TimeUnit,
  'Cookie': Cookie,
  'CookieJar': CookieJar,
  'CookieStore': CookieStore,
  'CookiePolicy': CookiePolicy,
  'CookieManager': CookieManager,
  'gZipUtil': gZipUtil,
  'WebSocket': WebSocket,
  'Route': Route,
  'DnsUtil': DnsUtil,
  'JsonCallback':JsonCallback,
  'StringCallback':StringCallback,
  'ByteStringCallback':ByteStringCallback
}

export default httpclient;