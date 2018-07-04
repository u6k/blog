---
layout: single
title: "Web小説→epub変換手順"
tags:
  - "epub"
  - "Novel"
  - "青空文庫テキスト形式"
date: 2015-12-11 22:00:00+09:00
redirect_from:
  - /2015/12/web-novel-to-epub.html
---

テキストメインのWeb小説を電子書籍(epub)として読むための、自分向けの手順です。

## Webページを取得

小説のWebページ(html)をダウンロードする。

## 青空文庫テキスト形式に整形

htmlを青空文庫テキスト形式に整形する。複数htmlの場合は、単一txtに統合する。青空文庫テキスト形式は以下を参照すること。

* [注記一覧](http://www.aozora.gr.jp/annotation/)

以下の書式を追加すること。

* 表題…1行目に表題を記載
* 著者名…2行目に著者名を記載
* 中見出し、改ページ…見出しに`［＃改ページ］`と`［＃大見出し］○○［＃大見出し終わり］`を記載

## AozoraEpubでepubに変換

AozoraEpub3をダウンロードして、jarを使用可能にする。

* [hmdev/AozoraEpub3](https://github.com/hmdev/AozoraEpub3)

以下のコマンドでtxtからepubを生成する。

```
java -cp AozoraEpub3.jar AozoraEpub3 -enc UTF-8 -of file.txt
```

### AozoraEpubでWebページを直接epubに変換

[小説家になろう](http://syosetu.com/)や[Arcadia](http://www.mai-net.net/)などのサイトは、AozoraEpub3で直接epubに変換ができます。詳細は[hmdev/AozoraEpub3](https://github.com/hmdev/AozoraEpub3)を参照。

## 生成したepubが妥当か検証

epubcheckをダウンロードして、jarを使用可能にする。

* [IDPF/epubcheck](https://github.com/idpf/epubcheck)

以下のコマンドでepubを検証する。

```
java -jar epubcheck.jar file.epub
```
