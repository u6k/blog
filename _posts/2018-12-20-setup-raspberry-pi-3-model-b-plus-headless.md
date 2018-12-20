# Raspberry Pi 3 Model B+セットアップ手順(Raspbian Stretch、ヘッドレス)

Raspberry Pi Model B+にヘッドレスでRaspbian Stretchをインストールして、sshクライアントから接続するまでの手順を説明する。

{{toc}}

## 背景

簡単なWebアプリケーションやちょっとしたジョブを稼働させたくて、Raspberry Pi 3 Model B+(以降、RaspberryPiと呼ぶ)を購入した。以前にRaspberry Pi Model B+をセットアップしたが、OSがバージョンアップしたため当時の手順は使えない。

この記事では、RaspberryPiをディスプレイやキーボードを接続せずに、つまりヘッドレスでRaspbian Stretchをインストールして、PCなどのsshクライアントからRaspberryPiに接続するまでの手順を説明する。

この記事の手順では、とりあえずRaspberryPiを起動してssh接続するまでなので、このままではインターネットに公開などできないし、いくつかの設定作業が残っている。これらは少しの手作業とAnsibleを使った一括設定を行う予定だが、別の記事で説明する。

## 前提

次の機材が必要となる。

- Raspberry Pi 3 Model B+ RS版
- microUSB電源 5V/3.0A
    - RaspberryPiの仕様は2.5A
    - 2.0Aでは起動しなかった
- microSD 16GB
    - microSD->SD変換アダプターも必要
    - 容量は、8GB以上が望ましい
- MacBookPro
    - 筆者はMacBookProを使用したが、microSDカードへの書き込みができるのであれば、Windows PCでも問題ない

ただ、トラブルに遭遇した時の原因調査に困るので、できれば次の機材も用意したほうが良い。

- USB有線キーボード
- HDMIケーブル、ディスプレイ
    - テレビにHDMI接続できる場合が多い

使用機材にMacBookProをあげた通り、PC側の作業手順はMacBookProを想定して説明する。Windows PCでも同様の作業はできるので、適宜読み替えてほしい。

## 手順

次に、手順を説明する。

### Raspbianをダウンロードする

[Download Raspbian for Raspberry Pi](https://www.raspberrypi.org/downloads/raspbian/)からRaspbian Stretch Liteをダウンロードする。

同ページにハッシュ値が記載されているので、ダウンロードが終了したらダッシュ値が一致することを確認する。

```
$ openssl sha256 2018-11-13-raspbian-stretch-lite.zip 
SHA256(2018-11-13-raspbian-stretch-lite.zip)= 47ef1b2501d0e5002675a50b6868074e693f78829822eef64f3878487953234d
```

### microSDにRaspbianをインストールする

zipファイルを展開する。

```
$ unzip 2018-11-13-raspbian-stretch-lite.zip
Archive:  2018-11-13-raspbian-stretch-lite.zip
  inflating: 2018-11-13-raspbian-stretch-lite.img
```

microSDのマウント・ポイントを確認する。

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

容量を見ると、`/dev/disk2`がmicroSDのマウント・ポイントだとわかる。

microSDをFAT32でフォーマットする。

> __NOTE:__ 当然だが、microSDの内容は消去される。また、デバイスの指定を間違えるとどえらいことになるので、要注意。

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

microSDをアンマウントする。

```
$ diskutil unmountDisk /dev/disk2
Unmount of all volumes on disk2 was successful
```

microSDにRaspbianイメージを書き込む。数分かかる。

```
$ sudo dd if=2018-11-13-raspbian-stretch-lite.img of=/dev/disk2 bs=1m conv=sync
1780+0 records in
1780+0 records out
1866465280 bytes transferred in 702.735738 secs (2655999 bytes/sec)
```

### 事前設定(SSH有効化、Wi-Fi設定)を行う

> __NOTE:__ これらの作業は、ディスプレイと優先キーボードを使用するのであれば、RaspberryPiの起動後に`raspi-setup`コマンドで行うことができる。この記事では、ヘッドレス作業のため、RaspberryPi起動前に行う。

microSDカードのルート・フォルダに移動する。

```
$ cd /Volumes/boot/
```

SSH機能を有効化するため、`ssh`ファイルを作成する。これは空ファイルで良い。

```
$ touch ssh
```

Wi-Fiを設定するため、`wpa_supplicant.conf`ファイルを作成する。

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

暗号キーは、[Wireshark · WPA PSK Generator](https://www.wireshark.org/tools/wpa-psk.html)などでSSIDとパスフレーズから生成できる。ルーターによっては、PSK設定項目があることがあるので、その場合はそこに設定されている値を使用する。

### RaspberryPiを起動する

microSDを取り出す準備をする。

```
$ cd
$ diskutil eject /dev/disk2
Disk /dev/disk2 ejected
```

microSDをPCから実際に取り出す。

RaspberryPiにmicroSDを挿入して、電源に接続する。RaspberryPiに電源スイッチはなく、電源に接続すると自動的に起動する。

> __NOTE:__ HDMIケーブルやUSBキーボードなど他の機器を接続する場合、まず電源ケーブル以外の機器を接続して、最後に電源ケーブルを接続する。

### PCからRaspberryPiにssh接続する

電源に接続して数分で起動が終了する。設定に問題がなければ、RaspberryPiが無線LANに接続されているはず。ルーターのDHCP機能などで割当IPアドレスリストを見ると、IPアドレスが増えていることが分かる。

PCからRaspberryPiにssh接続する。初期ユーザーは`pi`、パスワードは`raspberry`となっている。

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

macOSや、WindowsでもBonjourがインストールされていれば、`raspberrypi.local`でRaspberryPiを発見することができる。これで接続できない場合は、ルーターのDHCP機能などでIPアドレスを調べる。

## ハマりポイント

### microSDのフォーマットはFAT32でなければならない

例えばディスク・ユーティリティなどでexFATでフォーマットしてしまうと、RaspberryPiは起動しないもよう[^sd-format]。その場合、FAT32でフォーマットし直す。

### 電源が不足していると起動しない

Raspberry Pi 3 Model B+の仕様[^rpi-spec]によると、5V/2.5Aの電源が必要となる。試しに手元にあった5V/2.0A(スマホ充電用)の電源をRaspberryPiに接続してみたが、起動しなかった。同様の問題が報告されている。[^power]

### microSDの相性が悪い

microSDの相性が悪い[^sd-compati]と起動しないもよう。なお、筆者はこの問題に遭遇したことはない。

## 参考リンク

- [【ヘッドレス】Raspberry Pi 3 セットアップ for macOS - Qiita](https://qiita.com/y_k/items/2e37583d4a5dcf81dc19)
- [RaspberryPi Raspbian ヘッドレスインストール - Qiita](https://qiita.com/nori-dev-akg/items/a8361e728a66a8c3bdba)

[^sd-format]: [Formatting an SDXC card for use with NOOBS - Raspberry Pi Documentation](https://www.raspberrypi.org/documentation/installation/sdxc_formatting.md)
[^rpi-spec]: [Raspberry Pi 3 Model B+ - Raspberry Pi](https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/)
[^power]: [Raspberry pi 3 が起動しない場合の対処法 | 日々の知見ストック](http://chiken-stock.com/2018/05/16/raspiproblem/)
[^sd-compati]: [Raspberry Pi B+ で起動しない問題について - Qiita](https://qiita.com/sff1019/items/83fcbe72387fe12ddccc)
