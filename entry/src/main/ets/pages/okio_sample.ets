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

@Entry
@Component
struct Okio_sample {
  @State message: string = 'Hello World'

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
        Button('Write/ReadUtf8').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {

        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('EncodeBase64').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {

        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('okhttp EncodeBase64').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {

        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('okhttp DecodeBase64').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {

        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('okhttp EncodeHex').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {

        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('encode MD5Hex').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {

        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('okhttp DecodeHex').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {

        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('FileWrite & Read').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {

        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

      Flex({ direction: FlexDirection.Column }) {
        Button('Append & Read').width('80%').height('100%').fontSize(18).fontColor(0xCCCCCC).align(Alignment.Center).margin(10).onClick((event:ClickEvent) => {

        })
      }
      .height('10%')
      .width('100%')
      .padding(10)

    }.width('100%').margin({ top: 5, bottom: 100 }).height('80%')
  }
}