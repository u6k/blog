---
layout: single
title: "Raspberry Pi検証作業に使える、Raspbian Stretch Lite仮想マシンを構築する"
tags:
  - "Raspberry Pi"
  - "Raspbian"
  - "仮想化"
date: 2019-01-21 00:00:00+09:00
---

Raspbianで作業をしていると、しばしばクリーンな状態に戻したくなります。しかし、クラウドとは違い面倒な作業を行う必要があります。できれば、事前検証を行うことでクリーンに戻す機会を減らしたいものです。

この記事では、Raspbianの検証作業に使える、Raspbian仮想マシンの構築手順を説明します。

この手順を実行することで、何度でも壊して復元できるRaspbian仮想マシンをDebian上に構築することができます。WindowsやmacOSの場合でも、Debian仮想マシンを構築することで同様のことができるはずです。

## この手順で得られるもの

個人用に、Raspberry Pi 3 Model B+(以降、RaspberryPi)にRaspbian Stretch Lite(以降、Raspbian)をインストールして、簡単なサーバーとして運用しています。ソフトウェアのインストール、設定変更、運用に関する細々な調整など、まぁいろいろな作業を行いますので、しばしばクリーンな状態に戻したくなります。この時、RaspberryPiからmicroSDカードを外してRaspbianイメージの書き込みを行い、各種設定作業を行い、といった感じでぶっちゃけ面倒です。Raspbianに変更作業を実際に行う前に、検証作業を行いたいものです。

そこで、Raspbian仮想マシンを構築します。仮想マシンですので、任意のタイミングでイメージ・ファイルをバックアップしておけば、いつでも簡単にバックアップ時点まで戻すことができます。

構築したRaspbian仮想マシンは、メモリが256MBしかない上に動作がすごく遅いです。簡単な検証作業にしか使えないと割りきったほうが良いでしょう。パーティション・サイズは任意に拡張可能です。

OSは、Raspbian Stretch Liteになります。

```
$ uname -a
Linux raspberrypi 4.14.50+ #1 Fri Sep 21 11:29:13 CDT 2018 armv6l GNU/Linux
```

## 前提…作業環境、注意点など

筆者はDigitalOcean上のDebianサーバーで作業を行いました。WindowsやmacOSの場合、VagrantなどでDebian仮想マシンを構築すれば、同様の作業が可能のはずです。

```
$ uname -a
Linux debian-s-1vcpu-1gb-sgp1-01 4.9.0-8-amd64 #1 SMP Debian 4.9.130-2 (2018-10-27) x86_64 GNU/Linux
```

筆者は、Raspbian仮想マシンで動作検証と作業手順作成を行ったあと、実機に反映させるという運用をしています。この作業は何度も行なっているので、Ansible playbookで定義しており、半自動的に行えるようにしています。この記事では手動作業として説明するので、Ansibleの場合は別記事で説明する予定です。

次の章から、Raspbian仮想マシンを構築・起動して、最低限の体裁を整える手順を説明します。これにより、Debian上で動作するRaspbian仮想マシンを得ることができます。

## 手順1. `qemu`をインストールする

Raspbian仮想マシンをQEMUで動作させるため、インストールします。

```
$ sudo apt -y install qemu
```

## 手順2. Raspbianイメージと必要ファイルをダウンロード、展開する

Raspbianイメージをダウンロードして、展開します。

```
$ curl -L -o raspbian_lite_latest.zip https://downloads.raspberrypi.org/raspbian_lite_latest
$ unzip raspbian_lite_latest.zip
```

QEMUの動作に必要なファイルをダウンロードします。

```
$ curl -LO https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.14.50-stretch
$ curl -LO https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/versatile-pb.dtb
```

## 手順3. Raspbian仮想マシンを起動する

次のコマンドを実行することで、Raspbian仮想マシンを起動することができます。

```
$ qemu-system-arm \
    -kernel kernel-qemu-4.14.50-stretch \
    -cpu arm1176 \
    -M versatilepb \
    -dtb versatile-pb.dtb \
    -m 256 \
    -no-reboot \
    -serial stdio \
    -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
    -hda 2018-11-13-raspbian-stretch-lite.img \
    -net nic \
    -net user,hostfwd=tcp::10022-:22 \
    -curses
```

Raspbianの初期ユーザーである`pi`の初期パスワードは`raspberry`です。

ホストOSの10022ポートを、Raspbian仮想マシン側の22ポートにフォワードしています。これによりSSH接続することが可能ですが、Raspbianは初期状態ではSSHが無効化されているので、`sudo raspi-config`でSSHを有効化する必要があります。

## おわりに

以上で、Raspbian仮想マシンを使用することができます。良いRaspberryPi生活を！

なお、この状態のRaspbian仮想マシンはいろいろと使いづらいので、筆者はさらに次の作業を行っています。

- Raspbianイメージのサイズ拡張
- スワップ領域を追加
- `raspi-config`でOS設定
- ファームウェア更新
- バックアップ

これらの説明は長くなってしまうので、Ansibleによるセットアップと同様、別記事にしたいと思います。
