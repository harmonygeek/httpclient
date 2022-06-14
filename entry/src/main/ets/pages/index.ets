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

import router from '@system.router';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Flex({ direction: FlexDirection.Column }) {
        Button('Core').width('80%').height('100%').fontSize(25).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {
          router.push({
            uri:'pages/core'
          })
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Sample').width('80%').height('100%').fontSize(25).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {
          router.push({
          uri:'pages/sample'
          })
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('UploadAndDownload').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {
          router.push({
            uri:'pages/uploadAndDownload'
          })
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Compression').width('80%').height('100%').fontSize(25).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {
          router.push({
            uri:'pages/compression'
          })
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Okio_Sample').width('80%').height('100%').fontSize(25).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {
          router.push({
            uri:'pages/okio_sample'
          })
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Auxiliary').width('80%').height('100%').fontSize(25).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {
          router.push({
            uri:'pages/auxiliary'
          })
        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

    }.width('100%').margin({ top: 5 }).height('100%')
  }
}