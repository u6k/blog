---
title: "Raspberry Pi(Raspbian wheezy)をOS XのQEMUで動作させる手順"
tags: ["Raspberry Pi", "Setup"]
date: 2015-11-30 23:00:00+09:00
published: false
parmalink: "raspbian-qemu-osx"
postID: 8869948407560965359
---

[Raspberry Pi emulator for WindowsでRaspbian最新版を動作させる手順](http://blog.u6k.me/2015/01/raspberry-pi-emulator-for.html)ではWindows上のQEMUでRaspbianを動作させましたが、現在使用しているのはMacBookなので、OS X上のQEMUでRaspbianを動作させる手順をまとめます。内容はほぼ同じです。

<!-- more -->

# 注意

* Raspbian Jessieを動作させようとしましたが、Kernel Panicで起動しませんでした。よって、当記事では前回と同じRaspbian wheezyを動作させます。
* OSとQEMUの組み合わせがマズイのかと思ってDebian on VirtualBoxで試しましたが、別の原因で起動しませんでした。
* CentOS、Ubuntuでは`qemu-system-arm`をインストールする方法が分かりませんでした。あまりまじめに探していませんが。

# 作業環境

* OS X Yosemite
* qemu 2.4.0.1

# 作業手順

## QEMUをインストール

Homebrewでqemuをインストールします。

```
$ brew install qemu
```

必要なCPUがサポートされているかチェックします。`arm1176`が表示されればサポートされています。`arm1176`が表示されない場合は、QEMUをビルドする必要があります。問題無いはず。

```
$ qemu-system-arm -M versatilepb -cpu '?' | grep arm1176
```

## Raspbianおよびkernelをダウンロード

[Raspberry Pi Downloads - Software for the Raspberry Pi](https://www.raspberrypi.org/downloads)から、`RASPBIAN WHEEZY`をダウンロードします。ファイルサイズが大きいので注意。ダウンロードしたら展開して、`raspbian.img`にリネームします。

次に、[dhruvvyas90/qemu-rpi-kernel](https://github.com/dhruvvyas90/qemu-rpi-kernel)から`kernel-qemu-3.10.25-wheezy`をダウンロードします。ダウンロードしたら、`kernel-qemu`にリネームします。

## Raspbian使用準備

RaspbianをQEMUで使用するためには、いくつかの調整を行う必要があります。なお、この作業の一部でキーボードが英語配列になることがあるので注意。

### Raspbianを起動(1回目)

調整のため、1回目の起動を行います。

```
$ qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" -hda raspbian.img
```

### `ld.so.preload`を修正

`/etc/ld.so.preload`を修正します。1行目先頭に`#`を追加して、コメントアウトします。

```
# sed -i -e 's/^/#/' /etc/ld.so.preload
```

### `90-qemu.rules`を作成

`/etc/udev/rules.d/90-qemu.rules`を作成します。

```
# touch /etc/udev/rules.d/90-qemu.rules
# echo 'KERNEL=="sda", SYMLINK+="mmcblk0"' >> /etc/udev/rules.d/90-qemu.rules
# echo 'KERNEL=="sda?", SYMLINK+="mmcblk0p%n"' >> /etc/udev/rules.d/90-qemu.rules
# echo 'KERNEL=="sda2", SYMLINK+="root"' >> /etc/udev/rules.d/90-qemu.rules
```

### Raspbianを終了

これで使用準備ができました。いったん、終了します。

```
# exit
```

## Raspbianを起動(2回目)

Raspbianを起動します。以降、以下のコマンドでRaspbianを起動します。1回目の起動とはコマンド内容が少し異なるので注意。

```
$ qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -hda raspbian.img -redir tcp:5022::22
```

正常に起動したら、設定完了です。この時点の`raspbian.img`をバックアップしておくと、状態を元に戻すのが楽になります。

`-redir tcp:5022::22`で、ホストOSの5022番ポートを、ゲストOSの22番ポートにリダイレクトします。5022番ポート以外を使用する場合は、このオプションを変更します。sshログインするには、以下のようにコマンドを実行します。パスワードは`raspberry`です。

```
ssh -p 5022 pi@localhost
```

# 参考

* [Raspberry Pi を QEMU でエミュレートする方法 (2015年7月更新)](https://blog.ymyzk.com/2013/12/raspberry-pi-qemu/)
* [OSX raspberry pi emulation via QEMU](https://gist.github.com/JasonGhent/e7deab904b30cbc08a7d)
