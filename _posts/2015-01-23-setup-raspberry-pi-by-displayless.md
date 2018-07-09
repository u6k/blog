---
layout: single
title: "Raspberry Piセットアップメモ(ディスプレイレス)"
tags:
  - "Raspberry Pi"
date: 2015-01-23 13:59:00+09:00
redirect_from:
  - /2015/01/raspberry-pi.html
---

安価で遊べるサーバーが欲しかったので、Raspberry Pi Model B+を購入しました。取りあえず使えるようにするまでの初期構築手順を記述します。あくまで自分用メモなので、しっかりした手順を知りたい場合は、既にたくさん公開されている同様の記事を見たほうが良いかもしれません。

## 作業前提

* MacBookProで作業しました。Windowsでも適宜読み替えてもらえば、作業可能なはずです。
* Raspberry Pi側のセットアップは、ssh接続でセットアップしました。ディスプレイ、キーボード、マウスは使用していません。
	* 正直、何かあってssh接続できない時に状況を確認できないので、ディスプレイ、キーボードくらいは用意したほうが良いと思います。

## 使った機材

* Rasberry Pi Model B+
	* RSコンポーネンツでケースと一緒に購入しました。
	* [Raspberry PI B+](http://jp.rs-online.com/web/p/processor-microcontroller-development-kits/8111284/)
	* [Raspberry Pi B+ Case, Black](http://jp.rs-online.com/web/p/development-board-enclosures/8193655/?origin=PSF_502004|acc)
* LANケーブル、USB無線LANアダプター
	* 最終的には無線だけにしたいですが、最初は有線でのセットアップが必要です。有線のまま運用するなら、USB無線LANアダプターは不要です。
* USBケーブル+アダプター
	* 電源供給のために必要です。USBミニBが必要になります。スマホの電源と同じアレです。
* microSD、外付けHDD
	* OSを外付けHDDに格納するなら、microSDは8GB程度で十分です。microSDだけで運用するなら外付けHDDは不要ですが、それなりの容量のものを用意したほうが良いと思います。
	* 現時点で、完全にmicroSDレスにはできないもようです。
* MacBookPro
	* セットアップ作業のために必要です。ここではMacBookProを使いましたが、Windowsでも可能なはずです。

## セットアップ後の状態

* ネットワーク接続…Wi-Fi
	* iptables(というかufw)で制限。
* ssh接続
	* LAN、WANからssh接続できる。
	* ポート番号を変更。
	* 公開鍵認証を有効、パスワード認証を無効。
* ストレージ…ブート関連はmicroSD、OSは外付けHDD。
	* microSDのみで運用する場合は、外付けHDDに関する手順を読み飛ばす。
* タイムゾーン…Asia/Tokyo
* CPU…1000MHzにオーバークロック。
* メモリ…GPU割り当てを最小(16MB)。

## 作業手順

### microSDにRaspbianをインストール

MacBookProで作業します。

[Downloads | Raspberry Pi](http://www.raspberrypi.org/downloads/)からRaspbianをダウンロードします。NOOBSだと楽という話も聞きますが、ここではRaspbianを使います。NOOBSでの手順は別記事をご覧ください。

microSDをMacBookProに挿入して、ディスクユーティリティでFATフォーマットします。

フォーマットしたmicroSDにRaspbianイメージを書き込みます。

```bash
$ df -h
$ sudo diskutil unmountDisk /dev/disk2s1
$ sudo dd if=2014-09-09-wheezy-raspbian.img of=/dev/disk2 bs=4m
$ sudo e2fsck -f /dev/disk2s1
```

`df`でデバイス名を確認、`diskutil`でmicroSDをアンマウント、`dd`でmicroSDにイメージを書き込み、`e2fsck`でファイル破損チェックを行っています。

### Raspberry Piを起動

microSDをRaspberry Piに挿入し、LANケーブルを接続し、電源を接続して起動します。Raspberry Piには電源スイッチが無く、通電すると自動的に起動するので注意してください。この時点では、外付けHDD、USB無線LANアダプターは接続しません。

Raspberry Piが起動して数分経過したら、Raspberry Piに割り当てられたIPアドレスを確認します。ルーターの管理画面でDHCPで割り当てたIPアドレスを確認する、などの方法で確認します。

Raspberry PiのIPアドレスが確認できたら、MacBookProから`ssh`でRaspberry Piに接続します。初期ユーザーは"pi"、パスワードは"raspberry"です。

```bash
$ ssh pi@192.168.1.10
```

ssh接続できたことを確認したら、シャットダウンします。

```bash
$ sudo halt
```

### 外付けHDDにファイルを移行

※microSDのみで運用する場合、この手順は不要です。
**※筆者はこの手順をRaspberry Piで作業を行いましたが、Linux PCを用意して作業したほうが良いです。**

外付けHDDをRaspberry Piに接続し、電源を接続してRaspberry Piを起動します。

Raspberry Piを起動してssh接続したら、外付けHDDをext4でフォーマットします。
まず、`fdisk`で外付けHDDのデバイス名を確認します。

```bash
$ sudo fdisk -l
```

デバイス名を確認したら、`fdisk`でパーティションを編集します。

```bash
$ sudo fdisk /dev/sda
```

`fdisk`では、以下の操作でパーティションを編集します。

* `p`で現在のパーティション設定を確認できる。
* `d`でパーティションを削除する。
* `n`でパーティションを作成する。
* `w`で保存する。

パーティションを編集して`fdisk`を終了したら、`mkfs.ext4`でext4フォーマットします。外付けHDDの容量によっては数分かかります。

```bash
$ sudo mkfs.ext4 /dev/sda1
```

ext4フォーマットが終了したら、OSのパーティションをmicroSDから外付けHDDにコピーします。**この作業は非常に時間がかかります(1～2時間程度)。**

```bash
$ sudo dd if=/dev/mmcblk0p2 of=/dev/sda1
$ sudo e2fsck -f /dev/sda1
$ sudo resize2fs /dev/sda1
```

`dd`でコピー、`e2fsck`でファイル破損チェック、`resize2fs`でパーティション容量を拡張しています。`dd`でコピーしただけだと容量が小さいままなので、`resize2fs`で拡張する必要があります。

> NOTE: Raspberry Piの`dd`は、bsオプションを指定するとエラーになるようです。

OSパーティションをコピーしたら、OSパーティションから起動するように設定を変更します。
まず、外付けHDDを適当なフォルダにマウントします。

```bash
$ sudo mount /dev/sda1 /mnt
```

microSD内の自動マウント設定を修正します。自動マウント設定はmicroSD内の"/boot/cmdline.txt"にありますので、これを編集します。

```bash:cmdline.txt
前：root=/dev/mmcblk0p2
後：root=/dev/sda1
```

次に、外付けHDD内の自動マウント設定を修正します。HDD内の自動マウント設定は"/etc/fstab"にありますので、これを編集します。

```bash:/etc/fstab
前：/dev/mmcblk0p2
後：/dev/sda1
```

`reboot`でRaspberry Piを再起動します。

```bash
$ sudo reboot
```

再起動が完了したら、マウント位置が"/dev/sda1"に変更されていることを確認します。

```bash
$ df -h
```

### 初期設定作業

`raspi-config`で初期設定を行います。

```bash
$ sudo raspi-config
```

以下のように設定します。

* Expand Filesystem  →Select
* Change User Password
* Internationalisation Options / Change Timezone  →Asia / Tokyo
* Advanced Options / Memory Split  →16
* Overclock  →Turbo

rootのパスワードを変更します。

```bash
$ sudo passwd
```

ソフトウェアをアップデートします。

```bash
$ sudo apt-get update
$ sudo apt-get upgrade
```

ファームウェアをアップデートします。

```bash
$ sudo rpi-update
$ sudo reboot
```

作業ユーザーを作成します。

```bash
$ id
$ sudo useradd -m u6k -G pi,adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,netdev,input,spi,gpio
$ sudo passwd u6k
$ sudo visudo
```

作業ユーザーはpiユーザーと同じグループに所属させます。なので、まず`id`でpiユーザーの所属グループを確認し、同じグループを`useradd`で指定します。ユーザーを作成したら`passwd`でパスワードを設定します。`sudo`するときにパスワードを省略したいので、`visudo`で設定を編集します。内容は、以下を追加します。

```bash:visudo
u6k ALL=(ALL) NOPASSWD: ALL
```

作成したら、作業ユーザーでログインできること、`sudo`でパスワードを省略できることを確認します。

> NOTE: piユーザーを削除・リネームするなどして使えなくしたほうがセキュリティ的に良いかもしれません。

### 無線LANを設定

※有線で運用する場合、この手順は不要です。

USB無線LANアダプターをRaspberry Piに挿入し、認識されたことを確認します。

```bash
$ lsusb
```

USB無線LANアダプターが認識されたら、Wi-Fiアクセスポイントが検知できることを確認します。

```bash
$ sudo iwlist wlan0 scan | grep ESSID
```

Wi-Fiアクセスポイントが検知できたら、SSIDとパスフレーズを設定します。

```bash
$ wpa_passphrase HG8045-2428-bg $1 | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
```

* \$1…Wi-Fiアクセスポイントのパスフレーズ
* Wi-Fiアクセスポイントの設定によっては、"wpa_supplicant.conf"を編集する必要があります。

ネットワーク設定を修正します。

```bash:/etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto wlan0
iface wlan0 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

修正したら、ネットワークを再起動します。

```bash
$ sudo service networking restart
```

Wi-Fiに割り当てられたIPアドレスを確認し、そのIPアドレスでssh接続できることを確認します。

```bash
$ ssh u6k@192.168.10.123
```

以降、LANケーブルを外してWi-Fiで作業します。

### スピードテストを実施

※この作業は必要ではありません。気になる場合に実施します。

インターネット接続の速度計測を行います。`speedtest-cli`を使用します。

```bash
$ sudo aptitude install python-pip
$ sudo pip install speedtest-cli
$ speedtest-cli
```

### sshを鍵認証方式に設定

パスワード認証方式を無効にして、鍵認証方式のみを有効にします。

まず、MacBookPro側で秘密鍵・公開鍵を作成します。

```bash
$ ssh-keygen -t rsa
```

カレントフォルダに"id_rsa"、"id_rsa.pub"が作成されます。**秘密鍵("id_rsa")は漏洩することがないよう、厳重に管理すること。**

> NOTE: `ssh-copy-id`で簡単に配置できるようです。いつか試す。

作成した鍵のうち公開鍵をRaspberry Piに配置します。

```bash
$ cd
$ mkdir .ssh
$ chmod 700 .ssh
$ cd .ssh
$ vi authorized_keys
```

"id_rsa.pub"の内容をコピー&ペーストします。
"authorized_keys"のパーミッションを変更します。

```bash
$ chmod 600 authorized_keys
```

sshの公開鍵認証を有効にして、パスワード認証を無効にします。"/etc/ssh/sshd_config"を以下のように設定します。

```bash:/etc/ssh/sshd_config
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PermitRootLogin no
RhostsRSAAuthentication no
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
```

セキュリティのため、sshdのポート番号を変更します。実際は、適当なポート番号に変更してください。**外部からこの作業を行っている場合、ルーターのポートフォワーディング設定と合わせないと接続できなくなるので注意(外部からなんて作業しないと思うけど…)。**

```bash:/etc/ssh/sshd_config
Port 12345
```

Raspberry Piを再起動します。

```bash
$ sudo reboot
```

ssh接続を、以下のように確認します。

* 変更後のポート番号で接続できること。変更前のポート番号で接続できないこと。
* rootユーザーのログインが失敗すること。
* piユーザーのログインが、パスワード認証、公開鍵認証の両方ともに失敗すること。
* 作業ユーザーのログインが、パスワード認証に失敗し、公開鍵認証に成功すること。

### iptablesを設定

ufwを使用して、iptablesの設定を行います。

まず、ufwをインストールします。

```bash
$ sudo aptitude install ufw
```

ufwの状況を確認します。この時点では無効になっています。

```bash
$ sudo ufw status
```

ufwでiptablesを設定します。以下では、80(http)、443(https)、22(ssh)を設定しています。sshポート番号を変更している場合、読み替えてください。

```bash
$ sudo ufw default DENY
$ sudo ufw allow 80
$ sudo ufw allow 443
$ sudo ufw allow 22
```

ufwを有効化にします。「ssh接続が切断されるかもしれないが良いか？」と聞かれますが、"y"を入力します。有効化後、別sshクライアントで接続できることを確認します。

```bash
$ sudo ufw enable
```

ufwの状況を表示し、設定が反映されていることを確認します。

```bash
$ sudo ufw status
```

> NOTE: 間違えてルールを追加した場合、以下のコマンドで削除できます。
> ```$ sudo ufw delete $1 $2```
> 例: ```$ sudo ufw delete allow 22```

### 外部から接続

※LAN内でのみ運用する場合、この手順は不要です。

ルーターにポートフォワーディングの設定を行います。

"ieserver.net"で、会員登録を行い、DDNSの設定を行います。

"ieserver.net"からDDNS更新スクリプトをダウンロードして、定期実行するように設定します。

"ddns-update.txt"を"/usr/local/bin"にダウンロードします。"ddns-update.pl"にリネームし、実行権限を与えます。

```bash
$ cd /usr/local/bin
$ sudo wget http://ieserver.net/ddns-update.txt
$ sudo mv ddns-update.txt ddns-update.pl
$ sudo chmod +x ddns-update.pl
```

"ddns-update.pl"を修正します。アカウント、ドメイン名、パスワードを記述します。

"ddns-update.pl"を実行します。実行後、"ieserver.net"でIPアドレスが正しく更新されたことを確認します。

```bash
$ ./ddns-update.pl
```

cronで定期的に実行されるように設定します。設定後、しばらく後に"ieserver.net"を表示し、IPアドレスが正しく更新されたことを確認します。

```bash
$ sudo crontab -e
```

```bash:crontab
*/10 * * * * /usr/local/bin/ddns-update.pl
```

LAN、WANから、ドメイン名指定でssh接続できることを確認します。

### USBポートに1.2Aの電力供給を設定

初期状態では0.6Aまでに制限されており、1.2Aまで電力供給するように設定します。電力供給が少ないと、USBポートから電力を確保しているUSB HDDやWi-Fiアダプターなどの動作が不安定になるようです。

`/boot/config.txt`に以下を記述します。

```
safe_mode_gpio=4
max_usb_current=1
```

記述後、再起動します。

```
$ sudo reboot
```

* 参考
	* [Raspberry Pi Model B+のUSBポートに1.2Aの電力を供給する](http://akkiesoft.hatenablog.jp/entry/20140727/1406443999)

## 参考リンク

* [RaspberryPi - Raspberry Pi Model B+セットアップ - Qiita](http://qiita.com/jh3rox/items/684ba1e746a6a3763b5c)
* [speedtest-cliでターミナルから回線速度を計測する - sheeplogh :: memo](http://sheeplogh.hatenablog.com/entry/2013/12/03/124241)
* [Internet - cliでインターネットの速度計測(speedtest.net) - Qiita](http://qiita.com/tukiyo3/items/78ab5a63aec20632c162)
* [Raspbian の初期設定 その2 (無線LANの設定) - こまけぇこたぁいいんだよ！！](http://d.hatena.ne.jp/dekovoko/20140509/1399610982)
* [Wi-Fi - RaspberryPi(Raspbian)のWiFiドングル設定メモ - Qiita](http://qiita.com/R-STYLE/items/8d37fb59e4872faee2bc)
* [CentOS - USB外付けHDDをext4にフォーマットする手順 - Qiita](http://qiita.com/ikuwow/items/c5832fd823e869825c80)
* [Raspberry Pi Model B+ のUSBポートの電力アップ | Making Mugbot　マグボットの作り方](http://www.mugbot.com/2014/08/19/raspberry-pi-model-b-%E3%81%AEusb%E3%83%9D%E3%83%BC%E3%83%88%E3%81%AE%E9%9B%BB%E5%8A%9B%E3%82%A2%E3%83%83%E3%83%97/)
* [Raspberry Pi でサーバー構築](http://baticadila.dip.jp/rpi_010.html)
