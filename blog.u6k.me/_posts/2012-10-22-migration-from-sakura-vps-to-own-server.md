---
layout: post
title: "Redmineを自宅PCからさくらVPSに移行しました"
tags:
  - "Redmine"
  - "migration"
  - "さくらVPS"
date: 2012-10-22 18:00:00+09:00
---

今まで、Redmine-warなどのチケットを管理していたRedmineは、実は自宅PCで動作していました。しかしこのPC、数年前のPCで、メモリが389MBしか積んでいないという超低スペックマシン。すっごく遅かったのでイラッとしながら使っていたわけです。

それで、以前から気になっていたさくらVPSを借りて、そこにRedmineを移行しました！　さくらのVPS 1Gと一番安価なプランを使用していますが、それでもかなり快適になりました。

<!-- more -->

# VPSのセットアップ

以下の記事を参考にしてセットアップを行いました。感謝！

* [さくらVPSでスタートダッシュ決めるには結局どーすりゃいいの？](http://plusblog.jp/6062/)
* [さくらVPSでスタートダッシュ決めた後はこーすりゃいいの？](http://plusblog.jp/6093/)

# Redmineの移行

自宅RedmineはMySQLで動作していましたが、ドッグフーディングという意味で、SQLite3に移行してRedmine-warに配置しました。自分がRubyについて無知なだけですが、結構苦労しました…

* [Redmineで使うデータベースを変更する](http://blog.redmine.jp/articles/change-database/)
* [アップグレード - Redmine.JP](http://redmine.jp/guide/RedmineUpgrade/)
* [本番環境のPostgreSQLに格納されたデータを開発環境のSQLite3に持ってくる](http://d.hatena.ne.jp/next49/20110513/p1)
