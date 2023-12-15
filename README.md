# Hosei-Sakai-iOS

[![Swift Badge](https://img.shields.io/badge/Swift-5.0-F05138?logo=swift&logoColor=fff&style=flat)](https://developer.apple.com/swift/)
[![License GPLv3](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat)](https://www.gnu.org/licenses/gpl-3.0.html)

![icon](assets/icon.png)

法政大学の学習支援システム、Hoppii のアプリです。大学の許可を得る上の自主制作です。

ベータ版はここからダウンロードできます：[TestFlight](https://testflight.apple.com/join/jkk2nFWH)。

Android 版はこちら：[GitHub](https://github.com/megabitsenmzq/Hosei-Sakai-Android)

## 機能詳細

### 課題一覧

- 課題を表示することができ、Hoppii と別で課題の完成状況を管理できる。自分と関係ない課題や、別の所で提出する課題を完成として表記できる。
- 課題の本文と添付ファイルを表示とダウンロードできる。
- 課題の締め切り時間を前の日の 23:55 に揃って表示することで、遅延の可能性を減らすことができる。

### 授業一覧

- お知らせと添付ファイルを表示できる。
- 教材の表示とダウンロードができる。

### その他

- 時間割：Hoppii の時間割ページを表示する。

- 田町教室予約状況：田町の教室予約システムは、ただ空教室を確認したい人にとって使いずらい。本機能は、簡単で予約状況を表示する機能である。

## 技術仕様

アプリは SwiftUI で作成している。iOS バージョンは 15.0 以上に設定している。

ログイン部分は法政の統合認証のページを裏に表示し、入力した情報を自動的に裏のページに入力する方法で実装している。

Hoppii は [Sakai](https://www.sakailms.org) をベースして作った物なので、Sakai の API で色々な情報をアクセスできる。Hoppii のサーバーにもその API を説明するページがある：https://hoppii.hosei.ac.jp/direct/describe

残りの API で表示できないものは、HTML をパースして表示する。

### 使用したパッケージ

- [KeychainSwift](https://github.com/evgenyneu/keychain-swift)：Keychain でログイン情報を安全に保存するために使用している。
- [SwiftSoup](https://github.com/scinfu/SwiftSoup)：HTML を解読するために使用している。 
