---
title: "QEMU for windowsでRaspbian Jessieを動作させる"
tags: ["Raspberry Pi"]
date: 2016-03-08 07:00:00+09:00
published: false
parmalink: "raspbian-jessie-on-qemu"
postID:
---

[以前、QEMUでRaspbian Wheezyを動作させました](http://blog.u6k.me/2015/01/raspberry-pi-emulator-for.html)が、Raspbian Jessieはできませんでした。いろいろ試行錯誤していましたが、以下のページの手順で動作させることができたので、作業手順をまとめます。

[Emulating Jessie image with 4.1.x kernel · dhruvvyas90/qemu-rpi-kernel Wiki](https://github.com/dhruvvyas90/qemu-rpi-kernel/wiki/Emulating-Jessie-image-with-4.1.x-kernel)

<!-- more -->

# 動作させる目的

自宅でRaspberry Pi Model B+が元気に動作していますが、これに変更を加える前に動作確認する環境が欲しいです。一般的なOSであれば、普通にVagrant+VirtualBoxやDockerを使用しますが、ARMプロセッサが前提のRaspbianでは簡単にはできません。当記事は、その環境を作るための作業手順です。

ちなみに、元々はRaspbian+Dockerの動作確認環境が欲しかったための作業でしたが、後述しますがDockerは動作できませんでした。

# ダウンロード

この作業で作成したパッケージは、[GitHubで公開](https://github.com/u6k/raspbian-on-qemu/releases/tag/20160307-raspbian-jessie-on-qemu)しています。

# 作業環境

* Surface Pro 4 + Windows 10
    * `qemu-system-arm`が動作すれば、この環境でなくても問題無いはずです。
* Vagrant 1.8.1 + VirtualBox
    * Raspbianイメージをマウントするために必要ですが、`.img`内を編集できるのであれば不要です。
* QEMU 2.4.1 on Windows
* Raspbian Jessie 2016/2/26版

# 作業手順

## Qemu、Raspbian、カーネルイメージをダウンロード

QEMUは、Windows用にビルドされたアプリをダウンロードします。記事執筆時点では`Qemu-2.4.1-windows.7z`が最新です。

[Qemu On Windows](http://lassauge.free.fr/qemu/)

Raspbianをダウンロードします。記事執筆時点では`2016-02-26-raspbian-jessie.zip`が最新です。

[Download Raspbian for Raspberry Pi](https://www.raspberrypi.org/downloads/raspbian/)

> *NOTE:* 旧バージョンのRaspbianがページに表示されていませんが、 https://downloads.raspberrypi.org/ から旧バージョンをダウンロードできるっぽいです。

RaspbianをQEMUで動作させるために必要なカーネルイメージをダウンロードします。Jessie用をダウンロードしてください。記事執筆時点では`kernel-qemu-4.1.13-jessie`が最新です。

[dhruvvyas90/qemu-rpi-kernel: Qemu kernel for emulating Rpi on QEMU](https://github.com/dhruvvyas90/qemu-rpi-kernel)

ダウンロードしたファイルは、全て`C:\raspbian-jessie-on-qemu\`に置きます。

## ダウンロードしたファイルを展開

ダウンロードしたファイルを展開します。フォルダ・パスを決め打ちにしていますが、別フォルダでも問題ありません。

`Qemu-2.4.1-windows.7z`を`C:\raspbian-jessie-on-qemu\qemu\`に展開します。`C:\raspbian-jessie-on-qemu\qemu\`以下にQemuのファイル群が展開されている状態になります。

`2016-02-26-raspbian-jessie.zip`を`C:\raspbian-jessie-on-qemu\raspbian\`に展開します。

`kernel-qemu-4.1.13-jessie`は`C:\raspbian-jessie-on-qemu\raspbian\`に移動します。

これで、以下のようなファイル構成になります。

```
C:\
+---raspbian-jessie-on-qemu\
    +---qemu\
    |   +---qemu-system-arm.exe などQemuのファイル群
    +---raspbian\
        +---2016-02-26-raspbian-jessie.img
        +---kernel-qemu-4.1.13-jessie
```

## Raspbianイメージを変更

Raspbianはこのままでは起動できません。起動できるように内部を編集します。この作業でVagrant+VirtualBoxを使用します。Raspbianイメージをマウントできて内部を編集できるのであれば、別の手段で問題ありません。

コマンドプロンプトを開き、`C:\raspbian-jessie-on-qemu\raspbian\`まで移動して、Vagrantを起動します。

```
cd C:\raspbian-jessie-on-qemu\raspbian\
vagrant init ubuntu/trusty64
vagrant up
vagrant ssh
```

Vagrantは、デフォルトで`Vagrantfile`があるフォルダを`/vagrant/`にマウントします。つまり、`/vagrant/2016-02-26-raspbian-jessie.img`にRaspbianイメージがあります。このRaspbianイメージをマウントします。

```
$ sudo mount -v -o offset=67108864 -t ext4 /vagrant/2016-02-26-raspbian-jessie.img /mnt/
```

`/mnt/etc/ld.so.preload`を開きます。

```
$ sudo vi /mnt/etc/ld.so.preload
```

1行目をコメントアウトします。

```
/usr/lib/arm-linux-gnueabihf/libarmmem.so
↓
#/usr/lib/arm-linux-gnueabihf/libarmmem.so
```

`/mnt/etc/fstab`を開きます。

```
sudo vi /mnt/etc/fstab
```

`/dev/mmcblk`を含む行をコメントアウトします。

```
/dev/mmcblk0p1  /boot           vfat    defaults          0       2
/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
↓
#/dev/mmcblk0p1  /boot           vfat    defaults          0       2
#/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
```

`exit`して、Vagrantを破棄します。

```
vagrant destroy -f
rm Vagrantfile
rmdir /S /Q .vagrant
```

これで、Raspbianイメージの変更は完了です。

## Raspbianを起動

QEMUでRaspbianを起動します。コマンドが長いので、起動バッチ・ファイルを作成します。`C:\raspbian-jessie-on-qemu\run.bat`を以下のように作成します。

```
qemu\qemu-system-arm.exe -kernel raspbian\kernel-qemu-4.1.13-jessie -cpu arm1176 -m 256 -M versatilepb -serial stdio -append "root=/dev/sda2 rootfstype=ext4 rw" -hda raspbian\2016-02-26-raspbian-jessie.img -redir tcp:50022::22
```

作成した`run.bat`を実行します。問題が無ければ、以下のようにRaspbianが起動します。

![raspbian-startup](https://github.com/u6k/raspbian-on-qemu/raw/master/doc/img/raspbian-startup.png)

初期ユーザーは`pi`、パスワードは`raspberry`です。

上記のバッチ・ファイルに`-redir tcp:50022::22`というオプションが指定されているため、50022番ポートでssh接続ができます。

## Raspbian Liteの場合

以上の作業をRaspbian Liteで行うと、以下のように起動します。

![raspbian-lite-startup](https://github.com/u6k/raspbian-on-qemu/raw/master/doc/img/raspbian-lite-startup.png)

# おまけ：Raspbian Jessie on qemuでDockerを動作させようとして失敗したメモ

```
$ apt-cache show docker.io
Package: docker.io
Version: 1.3.3~dfsg1-2
Architecture: armhf
Maintainer: Paul Tagliamonte <paultag@debian.org>
Installed-Size: 14970
Depends: adduser, iptables, init-system-helpers (>= 1.18~), perl, libapparmor1 (>= 2.6~devel), libc6 (>= 2.14), libdevmapper1.02.1 (>= 2:1.02.90), libsqlite3-0 (>= 3.5.9)
Recommends: aufs-tools, ca-certificates, cgroupfs-mount | cgroup-lite, git, xz-utils
Suggests: btrfs-tools, debootstrap, lxc, rinse
Breaks: docker (<< 1.5~)
Replaces: docker (<< 1.5~)
Built-Using: golang-context (= 0.0~git20140604.1.14f550f-1), golang-dbus (= 1-1), golang-go-patricia (= 1.0.1-1), golang-go-systemd (= 2-1), golang-go.net-dev (= 0.0~hg20131201-1), golang-gocapability-dev (= 0.0~git20140516-1), golang-gosqlite-dev (= 0.0~hg20130601-1), golang-mux (= 0.0~git20140505.1.136d54f-2), golang-pty (= 0.0~git20140315.1.67e2db2-1)
Homepage: https://github.com/docker/docker
Priority: optional
Section: admin
Filename: pool/main/d/docker.io/docker.io_1.3.3~dfsg1-2_armhf.deb
Size: 3081622
SHA256: c5808c63bb28259d8bc4d13dad0b3c04675ec4abcf1b7bc18b07979d525fc62b
SHA1: 186f392e650ef2d71b9ba7f01078dc35ae3cca95
MD5sum: e6e16890ff92228a4607eb1a040e78c7
Description: Linux container runtime
 Docker complements kernel namespacing with a high-level API which operates at
 the process level. It runs unix processes with strong guarantees of isolation
 and repeatability across servers.
 .
 Docker is a great building block for automating distributed systems:
 large-scale web deployments, database clusters, continuous deployment systems,
 private PaaS, service-oriented architectures, etc.
 .
 This package contains the daemon and client. Using docker.io on non-amd64 hosts
 is not supported at this time. Please be careful when using it on anything
 besides amd64.
 .
 Also, note that kernel version 3.8 or above is required for proper operation of
 the daemon process, and that any lower versions may have subtle and/or glaring
 issues.
Description-md5: 05dc9eba68f3bf418e6a0cf29d555878
```

`docker.io`がインストールできるので、早速、インストールして簡単なコマンドを実行したところ、エラーになってしまいました…

```
$ sudo docker run ubuntu /bin/echo 'Hello world'
2016/03/07 05:36:01 Post http:///var/run/docker.sock/v1.15/containers/create: read unix /var/run/docker.sock: connection reset by peer
```

そもそもインストールされたバージョンが古いですし、別の手段を探すこととします。

# ライセンス

[RaspbianはDFSGで提供](https://www.debian.org/legal/licenses/)されています。

[QEMUはGPL v2で提供](http://wiki.qemu.org/License)されています。

この文章の作業手順で作成してGitHubで公開しているパッケージは、RaspbianとQEMUのライセンスに準拠します。

[![クリエイティブ・コモンズ・ライセンス](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/)この文章は[クリエイティブ・コモンズ 表示 - 継承 4.0 国際 ライセンスの下に提供されています。](http://creativecommons.org/licenses/by-sa/4.0/)この文章に書いてある内容は無保証であり、自己責任でご利用ください。
