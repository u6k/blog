---
layout: single
title: "Eclipse環境構築にyoxosを使っている話、および自分は開発環境に何を求めているのか？"
tags:
  - "yoxos"
  - "Eclipse"
  - "Setup"
date: 2015-11-08 00:00:00+09:00
redirect_from:
  - /2015/11/provisioning-eclipse.html
---

仕事で複数のPCを使ったり、たまにOS再セットアップを行ったり、Eclipse環境自体に残ったゴミファイルやゴミ設定をクリーンするなどで、Eclipse環境を再セットアップすることがあります。

[手作業ですが構築手順は書いてある](http://blog.u6k.me/2012/10/java.html)のでその通りに実施すれば良いのですが、かなり面倒臭いし時間がかかります。できれば、コマンド1発で構築したいです。そこで、yoxosを利用しています。

この記事では、yoxosとは何かを簡単に説明し、もう少し踏み込んで開発環境に何を求めているかを整理してみます。

<!-- more -->

# yoxosとは

[yoxos](https://yoxos.eclipsesource.com/)は、プロファイルにプラグインセットを事前設定することで、Windows・Macなどどの環境でもEclipse環境(プラグインインストール済み)を1発で構築することができるサービスです。

## yoxos利用手順

* yoxosでアカウントを作成する。
* yoxosサイト上で、プロファイルにプラグインを追加する。
* Yoxos Launcherをダウンロード、インストールする。
	* Yoxos Launcher上でプロファイルにプラグインを追加することもできる。というかこちらの方がやりやすい。
* Yoxos LauncherからEclipseを起動する。この時、Eclipse環境が一気に構築される。

別の環境でEclipse環境を構築する場合は、Yoxos Launcherをインストールしてプロファイルにログインすることで、Eclipse環境を一気に構築することができます。

# yoxosの利点

* プロファイルから同じ環境を手軽にいくつも作れる。OS、CPUが異なっていても、yoxosがよろしく調整してくれる。
* 面倒なプラグインのインストール作業を1ステップで実行することができる。
* 環境構築後の各種設定を行った後にプリファレンスをエクスポートしておけば、yoxosで構築+プリファレンスインポートで、設定まで復元できる。
* プラグインにバージョンアップがあった場合、yoxosがチェック、インストールしてくれる。

# yoxosの欠点

* yoxosの無償利用ができなくなるかも？
* **yoxosが提供するプラグインからしか選べない！** これがかなり厳しい。
	* バージョンが微妙に古かったりする。
	* そもそもサポートされていない場合がある。

# そもそも、開発環境に求める要件を考えてみる

開発環境については、いろいろなツールやプラグインを使ってきて、なんだか頭がごちゃごちゃになってしまっているので、ここらで一度、自分は開発環境に何を求めているのか？ という観点を整理してみます。

## テキストエディター機能要件

* ソースコードをシンタックスハイライトできる。
* 行数を表示できる。
* 文字エンコーディングを設定できる。
* 改行コードを設定できる。
* タブ表示を設定できる。
* 自動インデントができる。
	* ファイル種類(プログラミング言語)ごとに設定できる。
* 自動でフォーマッティングする。
* 入力補完ができる。
	* 言語キーワード。
	* クラス名、メソッド名、関数名。
	* 変数。
* 表示折り返し位置を設定できる
	* 折り返し無し。
	* 桁指定して折り返し。
	* 画面右端で折り返し。
* ファイル種類に応じた設定で編集できる。
	* java
	* html
	* js
	* css
	* txt
	* md
	* php
	* ruby
	* sh
	* sql
	* python
* 依存するライブラリのリファレンスを表示する。
* Markdownはリアルタイムでプレビュー表示して欲しい。
* リファクタリングできることが望ましい。

## ビルド機能要件

* ファイルを変更すると、バックグラウンドでビルドが実行される。
	* 可能な限り軽く。
	* コンパイルエラーを検知する。
	* コーディング規約違反を検知する。
	* バグ疑惑(FindBugsなど)の検知を行う。
	* 対象ソースコードに対するテストコードを実行し、結果を表示する。
* 依存するライブラリを定義し、ダウンロードできる。
* コンパイルエラー、コーディング規約違反、バグ疑惑などを、ソースコード単位、プロジェクト単位で一覧表示する。
	* 一覧から該当箇所を表示できる。
* プロジェクト全体の、複雑度などメトリクスを表示する。

## デバッグ機能要件

* 開発中アプリを起動できる。
	* ローカル起動。
	* 結合環境などでの起動。
* デバッグ機能があること。
	* 実行中断(ブレークポイント)
	* ステップ実行
	* 変数内容確認
	* デバッグログのリアルタイム表示

## プロビジョニング機能要件

* どのプラットフォームでも開発環境をプロビジョニングできる。
	* Windows
	* Linux
	* Mac
* プロビジョニングでは、一発で環境を最新化できる。
	* 環境設定
	* プラグイン
* ソースコード、設定ファイル、プロジェクトごとの環境設定を保存する。
* バージョン管理ツールと連携できる。
	* ただし、SourceTreeなど優秀な外部ツールがあるので、連携できなくても良い。
* コンソール環境のみで利用できることが望ましい。

# おわりに

Eclipse抜きに「開発環境とは」を考えると、いわゆるIDEがよくできていることが改めてわかります。とは言えもっと簡単にセットアップしたいとも思います。もうちょっと色々と追求してみます。

# 参考

* [Vim でJava を書く環境を整えましたが、IDE で良い気がします](http://moznion.hatenadiary.com/entry/20130103/1357234061)
* [Javaエンジニアがいまさら始めるRuby開発環境 - Qiita](http://qiita.com/ko2ic/items/9204f5dba907dab37a1b)
* [プロビジョニング - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0)
* [プロビジョニングとは｜provisioning - 意味/解説/説明/定義 ： IT用語辞典](http://e-words.jp/w/%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0.html)
* [Eclipse Oomph のドキュメント日本語訳: Contents-Scopes - Qiita](http://qiita.com/Mura-Mi/items/4a7019d164b9911ba866)
* [10回目のリリースとなる「Eclipse Mars」が登場、Docker対応へ | OSDN Magazine](http://osdn.jp/magazine/15/06/26/063000)
* [Creating custom installations with Oomph](http://www.winklerweb.net/index.php/blog/12-eclipse/20-creating-custom-installations-with-oomph)
* [Eclipse Installer - Eclipsepedia](http://wiki.eclipse.org/Eclipse_Installer)
* [Eclipse Oomph Authoring - Eclipsepedia](https://wiki.eclipse.org/Eclipse_Oomph_Authoring)
* [Top 10 Eclipse Mars Features « EclipseSource Blog](http://eclipsesource.com/blogs/2015/06/24/top-10-eclipse-mars-features/)
    * Eclipse Oomphとやらでyoxos相当のことができるらしい…？