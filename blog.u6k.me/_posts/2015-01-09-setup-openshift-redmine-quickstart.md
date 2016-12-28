---
layout: post
title: "Redmine@OpenShiftインストール手順(openshift-redmine-quickstart)"
tags:
  - "Redmine"
date: 2015-01-09 21:46:00+09:00
redirect_from:
  - /2015/01/redmineopenshiftopenshift-redmine.html
---

個人的なタスク管理ツールについて、Google Tasks、Wunderlist、Toodledo、Remember the milk、付箋紙などなどいろいろ乗り換えてきましたが、ここ2年ほどはRedmineで運用しています(Redmineがタスク管理ツールかどうかは置いておいて)。当初はさくらVPS、次に(短期間だけど)Digital Oceanで稼働させていましたが、今はOpenShiftで稼働させています。

OpenShiftのメリットはいろいろありますがそれは別記事で述べるとして、ここではOpenShiftにRedmineをインストールする手順を説明します。

<!-- more -->

# 前提

* あらかじめ、OpenShiftに会員登録しておきます。
* git、Rubyを使用するので、インストールしておきます。
* `rhc`というgemをインストールしておきます。

# 作業手順

手順というほどのことはなく、[openshift/openshift-redmine-quickstart](https://github.com/openshift/openshift-redmine-quickstart)の手順に従って作業を行うだけです。特につまづくこともなく、非常に簡単にインストールできます。

# 備考

当時はこの手順が一番簡単だと思いましたが、今はもっと簡単な手順があるようです。

* [Ruby読めない僕が紹介する、Redmineを基本無料で構築する方法(初級編) - Qiita](http://qiita.com/koh-taka@github/items/efd5fd52b475a8863436)

# Qiita

* [Redmine@OpenShiftインストール手順(openshift-redmine-quickstart) - Qiita](http://qiita.com/u6k/items/60513a930a2450642852)
