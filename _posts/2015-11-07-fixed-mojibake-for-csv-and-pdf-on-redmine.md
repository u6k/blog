---
layout: single
title: "RedmineのCSVおよびPDFの文字化けを解消"
tags:
  - "Redmine"
date: 2015-11-07 00:00:00+09:00
redirect_from:
  - /2015/11/eliminate-redmine-csv-pdf-mojibake.html
---

自分のタスク管理用に稼働させているRedmineでCSVやPDFを出力すると文字化けが発生します。これを解消したので、手順を説明します。

<!-- more -->

# 前提

* Redmineは[openshift/openshift-redmine-quickstart · GitHub](https://github.com/openshift/openshift-redmine-quickstart)で構築。
* OpenShift上で稼働。

# 手順

[PDFおよびCSVの文字化けを回避する — Redmine.JP](http://redmine.jp/faq/general/pdfcsv/)によれば、`config/locales/ja.yml`を開き、`general_csv_encoding: CP932`にすれば良いとのこと。

`rhc git-clone myredmine`で稼働中のソースコードを取得して、`config/locales/ja.yml`を開いたところ、既に`general_csv_encoding: CP932`になっていました。

試しに`general_csv_encoding: SJIS`に設定して`git push`したところ、文字化けが解消しました。
