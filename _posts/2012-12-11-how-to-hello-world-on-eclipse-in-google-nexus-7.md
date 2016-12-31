---
layout: single
title: "Google Nexus 7 (4.2)で、EclipseからHello, world!できるようになるまでの手順"
tags:
  - "Android"
  - "Setup"
date: 2012-12-11 18:00:00+09:00
redirect_from:
  - /2012/12/google-nexus-7-42eclipsehello-world.html
---

Google Nexus 7 (4.2)を触る機会があったので、せっかくなのでHello, world!してみようとしたところ少し手間取ったので、ここにその手順を残します。

<!-- more -->

なお、4.1の場合は多少手順が異なる模様です。

# 参考ページ

以下のページを参考にしました。

* [ADB対応USBドライバー for NEXUS 7 - 気まぐれなももぽえむ](http://blogs.yahoo.co.jp/momo_poem/67257950.html)
* [alaif Laboratory: Nexus7がEclipseのデバイスリストに表示されない現象への対応方法](http://blog.alaif.net/2012/09/nexsus7eclipse.html)

# 手順

## 1. USBドライバーをダウンロードする

ASUSからADBドライバーをダウンロードします。

* [ASUS - タブレット- ASUS Nexus 7](http://www.asus.co.jp/Tablet/Nexus/Nexus_7/)

以下の手順でダウンロードできます。

* [OS]で[Android]を選択します。
* [USB]から[Nexus 7 USB driver for Windows]を選択します。
* [ダウンロードする地域]から[グローバル]をクリックします。

USB driverと表記されていますが、ADBドライバーが含まれています。

## 2. デベロッパーになる

Nexus 7の設定でデベロッパーになります。

どうも、4.2からは開発者オプションが標準で非表示となっている模様です。以下の操作でデベロッパーになることで表示できます。

* [設定]→[タブレット情報]をタップします。
* [ビルド番号]を7回タップします。トーストで「デベロッパーになりました。」と表示されます。

## 3. PCに接続してドライバーをインストール

ここからはいつも通りの手順です。

* 開発者向けオプションで、[USBデバッグ]を有効にします。
* Nexus 7をPCにUSB接続します。
* ADBドライバーのセットアップに失敗するので、WindowsのデバイスマネージャからダウンロードしたUSBドライバーをインストールします。

これで、EclipseのDDMSにデバイスが表示されますので、アプリ開発を行うことができます。

いやしかし、いいですねNexus 7。文字の表示がきれいで、タッチにも滑らかに反応します。ようやくiPhone・iPad並みに満足する端末が出ましたね。
