---
layout: single
title: "Raspberry Pi emulator for WindowsでRaspbian最新版を動作させる手順"
tags:
  - "Linux"
  - "Raspberry Pi"
date: 2015-01-09 18:00:00+09:00
redirect_from:
  - /2015/01/raspberry-pi-emulator-for.html
---

自宅実験用にRaspberry Piの購入を検討した時、そもそもRaspberry Piとはどんなものかを確認するためにエミュレータを使用しました。少し古いRaspbianでも良いのであれば、「Raspberry Pi emulation for Windows」でダウンロードしたqemuをただ実行すれば良いのですが、最新版のRaspbianを動作させるには作業が必要でした。ここに、その作業ログを記述します。

<!-- more -->

# 作業環境

* OS…Windows 7 (32bit)

# 作業手順

* Raspberry Pi emulation for Windows(以降、qemu)、および最新版のRaspbianをダウンロードします。
    * [Raspberry Pi emulation for Windows | SourceForge.net](http://sourceforge.net/projects/rpiqemuwindows/)
    * [Downloads | Raspberry Pi](http://www.raspberrypi.org/downloads/)
* qemuを`C:\`に展開します。
    * `C:\qemu\`に展開されます。
* Raspbianを`C:\qemu\qemu\`に展開します。
    * `C:\qemu\qemu\*.img`に展開されます。
* `C:\qemu\qemu\run.bat`を以下のように修正します。
    * Raspbianファイル名(例: `2012-07-15-wheezy-raspbian.img`)が書いてあるので、展開したファイル名に修正します。
    * `-append`を`root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash`に変更します。
* `C:\qemu\qemu\run.bat`を実行します。
    * `root@(none):/#`というプロンプトが起動します。
    * キーボード配列が英語配列になっているので、日本語キーボードの刻印と違う文字が入力されることがあります。特に記号。
* `/etc/ld.so.preload`を修正します。
    * 1行目をコメントアウトします。
* `/etc/udev/rules.d/90-qemu.rules`を作成します。
```
KERNEL=="sda", SYMLINK+="mmcblk0"
KERNEL=="sda?", SYMLINK+="mmcblk0p%n"
KERNEL=="sda2", SYMLINK+="root"
```
* ウィンドウの[x]をクリックして、qemuを終了します。
* `C:\qemu\qemu\run.bat`を修正します。
    * `-append`から`init=/bin/bash`を除去します。
    * 開放したいポートについて、`-redir`を追加します。開放したいポートが無ければ、この作業は不要です。
        * `-redir tcp:10022::22`
        * `-redir tcp:10080::80`
* 完了です。`C:\qemu\qemu\run.bat`を実行して、Raspbianが起動すること、(22番ポートを開放している場合)ssh接続できることを確認します。

# 備考

* 当手順はWindowsでの作業手順ですが、qemuとカーネルイメージの入手手順を読み替えれば、MacやLinuxでも同様にできるはずです。

# Qiita

* [RaspberryPi - Raspberry Pi emulator for WindowsでRaspbian最新版を動作させる手順 - Qiita](http://qiita.com/u6k/items/1301cc75d19066150701)
