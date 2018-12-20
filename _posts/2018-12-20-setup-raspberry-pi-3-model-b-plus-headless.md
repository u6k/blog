---
layout: single
title: "Raspberry Pi 3 Model B+を購入してからヘッドレスでsshできるようにするまでの5ステップと、ハマりポイント"
tags:
  - "Raspberry Pi"
  - "サーバー構築"
date: 2018-12-20 00:00:00+09:00
---

購入直後のRaspberry Pi Model B+にRaspbian Stretch Liteをインストールして、ヘッドレスでssh接続するまでの手順を説明します。

## 背景

簡単なWebアプリケーションやちょっとしたジョブを稼働させたくて、Raspberry Pi 3 Model B+(以降、RaspberryPiと呼びます)を購入しました。以前に[Raspberry Pi Model B+をセットアップ](https://blog.u6k.me/2015/01/23/setup-raspberry-pi-by-displayless.html)しましたが、OSがバージョンアップしたため当時の手順は使えませんでした。

この記事では、RaspberryPiをディスプレイやキーボードを接続せずに、つまりヘッドレスでRaspbian Stretch Liteをインストールして、PCなどのsshクライアントからRaspberryPiに接続するまでの手順を説明します。

この記事の手順では、とりあえずRaspberryPiを起動してssh接続するまでなので、このままではインターネットに公開などできませんし、いくつかの設定作業が残っています。これらは少しの手作業とAnsibleを使った一括設定を行う予定ですが、別の記事で説明します。

## 前提

次の機材が必要となります。

- Raspberry Pi 3 Model B+ RS版
- microUSB電源 5V/3.0A
    - RaspberryPiの仕様は2.5A
    - 2.0Aでは起動しませんでした
- microSD 16GB
    - microSD->SD変換アダプターも必要
    - 容量は、8GB以上が望ましいです
- MacBookPro
    - 筆者はMacBookProを使用しましたが、microSDカードへの書き込みができるのであれば、Windows PCでも問題ありません

筆者はRaspberryPiとmicroUSB電源を秋葉原の秋月電子で購入しましたが、Amazonなどでも購入することができます。購入サイトによって価格が異なりますので注意が必要です。

上記の機材だけでも作業は可能ですが、トラブルに遭遇した時の原因調査に困るので、できれば次の機材も用意したほうがよいです。

- USB有線キーボード
- HDMIケーブル、ディスプレイ
    - テレビにHDMI接続できる場合が多いです

使用機材にMacBookProをあげた通り、PC側の作業手順はMacBookProを想定して説明します。Windows PCでも同様の作業はできますので、適宜読み替えてください。

## 手順

それでは、実際のセットアップ手順を説明します。

### Raspbianをダウンロードする

[Download Raspbian for Raspberry Pi](https://www.raspberrypi.org/downloads/raspbian/)からRaspbian Stretch Liteをダウンロードします。

同ページにハッシュ値が記載されていますので、ダウンロードが終了したらダッシュ値が一致することを確認します。

```
$ openssl sha256 2018-11-13-raspbian-stretch-lite.zip 
SHA256(2018-11-13-raspbian-stretch-lite.zip)= 47ef1b2501d0e5002675a50b6868074e693f78829822eef64f3878487953234d
```

### microSDにRaspbianをインストールする

zipファイルを展開します。

```
$ unzip 2018-11-13-raspbian-stretch-lite.zip
Archive:  2018-11-13-raspbian-stretch-lite.zip
  inflating: 2018-11-13-raspbian-stretch-lite.img
```

microSDのマウント・ポイントを確認します。

```
$ diskutil list
/dev/disk0 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *121.3 GB   disk0
   1:                        EFI EFI                     209.7 MB   disk0s1
   2:                 Apple_APFS Container disk1         120.5 GB   disk0s2

/dev/disk1 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +120.5 GB   disk1
                                 Physical Store disk0s2
   1:                APFS Volume OSX                     114.0 GB   disk1s1
   2:                APFS Volume Preboot                 22.4 MB    disk1s2
   3:                APFS Volume Recovery                514.7 MB   disk1s3
   4:                APFS Volume VM                      2.1 GB     disk1s4

/dev/disk2 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *15.9 GB    disk2
   1:             Windows_FAT_32 boot                    46.0 MB    disk2s1
   2:                      Linux                         15.9 GB    disk2s2
```

容量を見ると、`/dev/disk2`がmicroSDのマウント・ポイントだとわかります。

microSDをFAT32でフォーマットします。

> __NOTE:__ 当然ですが、microSDの内容は消去されます。また、デバイスの指定を間違えるとどえらいことになるので、要注意です。

```
$ diskutil eraseDisk FAT32 RPI /dev/disk2
Started erase on disk2
Unmounting disk
Creating the partition map
Waiting for partitions to activate
Formatting disk2s2 as MS-DOS (FAT32) with name RPI
512 bytes per physical sector
/dev/rdisk2s2: 30673616 sectors in 1917101 FAT32 clusters (8192 bytes/cluster)
bps=512 spc=16 res=32 nft=2 mid=0xf8 spt=32 hds=255 hid=411648 drv=0x80 bsec=30703616 bspf=14978 rdcl=2 infs=1 bkbs=6
Mounting disk
Finished erase on disk2
```

microSDをアンマウントします。

```
$ diskutil unmountDisk /dev/disk2
Unmount of all volumes on disk2 was successful
```

microSDにRaspbianイメージを書き込みます。この作業は数分かかります。応答が返ってこなくてもしばらく放置しましょう。

```
$ sudo dd if=2018-11-13-raspbian-stretch-lite.img of=/dev/disk2 bs=1m conv=sync
1780+0 records in
1780+0 records out
1866465280 bytes transferred in 702.735738 secs (2655999 bytes/sec)
```

### 事前設定(SSH有効化、Wi-Fi設定)を行う

> __NOTE:__ これらの作業は、ディスプレイと有線キーボードを使用するのであれば、RaspberryPiの起動後に`raspi-setup`コマンドで行うことができます。この記事では、ヘッドレス作業のため、RaspberryPi起動前に行います。

microSDのルート・フォルダに移動します。

```
$ cd /Volumes/boot/
```

SSH機能を有効化するため、`ssh`ファイルを作成します。これは空ファイルでよいです。

```
$ touch ssh
```

Wi-Fiを設定するため、`wpa_supplicant.conf`ファイルを作成します。

```
$ cat wpa_supplicant.conf 
country=JP
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
    ssid="{SSID}"
    psk="{暗号キー}"
}
```

暗号キーは、[Wireshark · WPA PSK Generator](https://www.wireshark.org/tools/wpa-psk.html)などでSSIDとパスフレーズから生成できます。ルーターによっては、PSK設定項目があることがあるので、その場合はそこに設定されている値を使用します。

### RaspberryPiを起動する

microSDを取り出す準備をします。

```
$ cd
$ diskutil eject /dev/disk2
Disk /dev/disk2 ejected
```

コマンドが成功したら、microSDをPCから実際に取り出します。

RaspberryPiにmicroSDを挿入して、電源に接続します。RaspberryPiに電源スイッチはなく、電源に接続すると自動的に起動します。

> __NOTE:__ HDMIケーブルやUSBキーボードなど他の機器を接続する場合、まず電源ケーブル以外の機器を接続して、最後に電源ケーブルを接続します。

### PCからRaspberryPiにssh接続する

電源に接続して数分で起動が終了します。設定に問題がなければ、RaspberryPiが無線LANに接続されているはずです。ルーターのDHCP機能などで割当IPアドレスリストを見ると、IPアドレスが増えていることがわかると思います。

PCからRaspberryPiにssh接続します。初期ユーザーは`pi`、パスワードは`raspberry`となっています。

```
$ ssh pi@raspberrypi.local

Linux raspberrypi 4.14.79-v7+ #1159 SMP Sun Nov 4 17:50:20 GMT 2018 armv7l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Dec 19 05:55:53 2018 from 192.168.3.2
pi@raspberrypi:~ $
```

macOSやWindowsでもBonjourがインストールされていれば、`raspberrypi.local`でRaspberryPiを発見することができます。これで接続できない場合は、ルーターのDHCP機能などでIPアドレスを調べてください。

## ハマりポイント

### microSDのフォーマットはFAT32でなければならない

例えばディスク・ユーティリティなどで[exFATでフォーマットしてしまうと、RaspberryPiは起動しない](https://www.raspberrypi.org/documentation/installation/sdxc_formatting.md)ようです。その場合、FAT32でフォーマットしなおしてください。

### 電源が不足していると起動しない

[Raspberry Pi 3 Model B+の仕様](https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/)によると、5V/2.5Aの電源が必要となります。試しに手元にあった5V/2.0A(スマホ充電用)の電源をRaspberryPiに接続してみましたが、起動しませんでした。[同様の問題が報告](http://chiken-stock.com/2018/05/16/raspiproblem/)されています。

### microSDの相性が悪い

[microSDの相性が悪いと起動しない](https://qiita.com/sff1019/items/83fcbe72387fe12ddccc)ようです。筆者はこの問題に遭遇したことはありません。

## 所感

とりあえず、RaspberryPiを使えるように最低限のセットアップを行いました。この手順が手作業なのは仕方ありませんが、次のOSセットアップやソフトウェア・セットアップは可能な限り自動化する予定です。

## 参考リンク

- [【ヘッドレス】Raspberry Pi 3 セットアップ for macOS - Qiita](https://qiita.com/y_k/items/2e37583d4a5dcf81dc19)
- [RaspberryPi Raspbian ヘッドレスインストール - Qiita](https://qiita.com/nori-dev-akg/items/a8361e728a66a8c3bdba)
- [Raspberry Piセットアップメモ(ディスプレイレス) - u6k.Blog](https://blog.u6k.me/2015/01/23/setup-raspberry-pi-by-displayless.html)
- [Formatting an SDXC card for use with NOOBS - Raspberry Pi Documentation](https://www.raspberrypi.org/documentation/installation/sdxc_formatting.md)
- [Raspberry Pi 3 Model B+ - Raspberry Pi](https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/)
- [Raspberry pi 3 が起動しない場合の対処法 \| 日々の知見ストック](http://chiken-stock.com/2018/05/16/raspiproblem/)
- [Raspberry Pi B+ で起動しない問題について - Qiita](https://qiita.com/sff1019/items/83fcbe72387fe12ddccc)
