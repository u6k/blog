---
layout: post
title: "CentOS 6.3セットアップのメモ"
tags:
  - "CentOS"
  - "Setup"
date: 2012-10-15 21:13:00+09:00
---

テスト環境の作成で、よくOracle VirtualBox上にCentOSをセットアップする機会があります。ここでは、その手順を説明します。

<!-- more -->

# 前提

* CentOS 6.3
* Oracle VirtualBox v4.1.8
    * VirtualBoxじゃなくてVMwareなど他の仮想化ツールや物理PCでも、同じような手順になるはずです。物理PCの場合はスナップショットが作成できませんが。

# 作業手順

作業は、大きく以下のようになります。

* VirtualBoxをインストール
* CentOSをダウンロード
* CentOSをインストール
* ネットワーク設定
* ユーザー作成
* rootによるsshログイン禁止
* IPv6無効化
* SELinux無効化
* インストール済みパッケージのアップデート
* 開発系パッケージのインストール
* Java SDKをインストール

## VirtualBoxをインストール

[Oracle VM VirtualBox](https://www.virtualbox.org/)からインストール・パッケージをダウンロードして、インストールします。インストールは特に難しいことはなくスムーズに終わるはずです。

## CentOSをダウンロード

[www.centos.org](https://www.centos.org/)からCentOSのインストール・メディアをダウンロードします。少し分かりづらいので画像で説明します。

![](http://2.bp.blogspot.com/-5SfTRtiTZTo/UHvj1uS-jBI/AAAAAAAAAJA/atvEG5rU05s/s1600/001_1.png)

ページ上部メニュの`Downloads`をクリックします。

![](http://4.bp.blogspot.com/-tghdiBAHIi4/UHvj1nDbPWI/AAAAAAAAAJI/UZmkLKuFLI4/s1600/002_1.png)

ミラーサイトを選択するため、`Mirror List`をクリックします。

![](http://4.bp.blogspot.com/-0Crol0fRM9c/UHvj1i1YfBI/AAAAAAAAAJE/EEY7hvqppLc/s1600/003_1.png)

ミラーサイトの一覧が表示されますが、これはNorth Americanのサイトであり、ダウンロードに時間がかかります。日本国内のサーバーからダウンロードしたいので、`South American, Asian, Oceania, Middle Eastern, African and Other Regional`をクリックします。

![](http://4.bp.blogspot.com/-TNd0peOoFR0/UHvj2U9lVlI/AAAAAAAAAJM/1iyL-UCmxgU/s1600/004_1.png)

一覧にJapanのサイトが表示されるので、いずれかのサイトの`HTTP`または`FTP`をクリックします(どのサイトも、ほぼ同じフォルダ構成になっています)。

![](http://3.bp.blogspot.com/-kAd-Ho4B0os/UHvj27YDsuI/AAAAAAAAAJY/e0DUSd_b_gU/s1600/006_1.png)

CentOSのバージョンごとのフォルダが一覧表示されるので、今回使用する`6.3`をクリックします。

この後はフォルダを下がって行って、以下のいずれかのフォルダまで移動します。

* `/pub/Linux/CentOS/6.3/isos/i386`
* `/pub/Linux/CentOS/6.3/isos/x86_64`

`i386`または`x86_64`は、インストール先の環境に合わせて選択します。

![](http://4.bp.blogspot.com/-LIu6Gb75vo8/UHvnEDw8M_I/AAAAAAAAAKw/ZX3jjXkFERE/s1600/007_1.png)

CentOSのインストール・メディアの一覧が表示されます。ここではminimalによるインストールを説明しますので、`CentOS-6.3-i386-minimal.iso`をダウンロードします。

> **note** ダウンロードしたファイルのハッシュ値を確認したほうが良いです。

## CentOSをインストール

CentOSのインストール・メディアをダウンロードしたので、VirtualBox上に仮想マシンを作成し、CentOSをインストールします。

![](http://2.bp.blogspot.com/-x5clG6Abyi4/UHvWBe9ErnI/AAAAAAAAADU/mepFX3-joFU/s1600/001.png)

VirtualBoxを開くと、このような画面が表示されます。ツールバーの`新規`をクリックします。

![](http://3.bp.blogspot.com/-lnTfxh2boho/UHvWBYA7vmI/AAAAAAAAADQ/KrKgc_jiluc/s1600/002.png)

以下のように入力して、`次へ`をクリックします。

* 名前: 適当(ここでは`centos-6.3`)
* タイプ: Linux
* バージョン: Red Hat

![](http://1.bp.blogspot.com/-8BFnbhwpozI/UHvWBmj7WYI/AAAAAAAAADg/LNERDe49y2A/s1600/003.png)

お使いの環境に合わせて変更します。

![](http://2.bp.blogspot.com/-mCdmxXSV3ME/UHvWB3anVyI/AAAAAAAAADc/aVD4KG57qdI/s1600/004.png)

新規に作成するので、`仮想ハードドライブを作成する`を選択します。

![](http://2.bp.blogspot.com/-x3MnFcTdjdI/UHvWC2bCs2I/AAAAAAAAADs/UjXd1xM3ipY/s1600/007.png)

不足したら新規にHDDを追加することにして、初期値の`8GB`のままにします。

![](http://2.bp.blogspot.com/-ZlukFC0CQLQ/UHvWC6uJJfI/AAAAAAAAAD0/MpLmaAZJehg/s1600/006.png)

初期値の`可変サイズ`のままにします。

![](http://4.bp.blogspot.com/-JLbF63aW8ZI/UHvWCZIkj8I/AAAAAAAAADk/fILCV0dCkaE/s1600/005.png)

初期値の`VDI (VirtualBox Disk Image)`のままにします。

![](http://4.bp.blogspot.com/-lQFLf05rCE8/UHvWDCUFsWI/AAAAAAAAADw/7YyxaZWeN7U/s1600/008.png)

以上で仮想マシンが作成されました。

次に、ツールバーの`設定`をクリックして設定画面を開きます。

![](http://2.bp.blogspot.com/--KJeGlbKfzs/UHvWDzw__II/AAAAAAAAAD8/FS8-K0yt7yE/s1600/009.png)

左ペインから`ストレージ`を選択して、CD/DVDドライブに先ほどダウンロードしたCentOSのインストール・メディアを指定します。

![](http://1.bp.blogspot.com/-FNGbgHedP48/UHvWEYUKZxI/AAAAAAAAAEI/fNo1cxIK9CY/s1600/010.png)

左ペインから`ネットワーク`を選択して、割り当てを`ブリッジアダプタ―`に変更します。

また、`高度`をクリックして表示を広げ、`MACアドレス`の値を控えておきます。これは後で、ネットワーク設定を行う時に必要になります。

以上で、仮想マシンの設定を終わります。

いよいよCentOSをインストールします。ツールバーの`起動`をクリックします。

> **tips** VirtualBoxに限らず仮想マシンツールはキーボードやマウスの制御を仮想マシンに移譲します。仮想マシンから抜け出したいときは、VirtualBoxの場合、右Ctrlを押します。

> **tips** CentOSインストール画面は、マウスは使用できずキーボードで操作することになります。主な操作方法は以下の通りです。
> * Tab / Alt+Tab: 項目を移動。
> * Space: チェックボックスなどで項目を選択。
> * 矢印キー: 項目を選択。
> * Enterキー: 決定。

![](http://3.bp.blogspot.com/-UNRsZ6iTjIU/UHvWEQZVpdI/AAAAAAAAAEM/dgSsJlmNfKA/s1600/011.png)

放っておけば約1分後にインストールが開始されますが、`Install or upgrade an existing system`を選択してEnterを押します。

![](http://1.bp.blogspot.com/-BFXfE7g-joc/UHvWFZ9srPI/AAAAAAAAAEU/3-mkcZlpPkU/s1600/012.png)

インストール・メディアの検証を行うか聞かれますが、心配でなければ`Skip`を選択してEnterを押します。

![](http://3.bp.blogspot.com/-LSqkp88uRIk/UHvWFejPVsI/AAAAAAAAAEc/xhso0gMtTFY/s1600/013.png)

Enterを押します。

![](http://1.bp.blogspot.com/-ms1-Mq4bkSI/UHvWFvM0BKI/AAAAAAAAAEY/b6UYcXcdBRg/s1600/014.png)

インストール作業で表示する言語を選択します。日本語も選択できますがVirtualBoxでは表示できないようなので、`English`を選択して、`OK`でEnterを押します。

![](http://3.bp.blogspot.com/-JppQKxPBEZo/UHvWGVRgxCI/AAAAAAAAAEg/Tx2o4AOg3Ik/s1600/015.png)

キーボードの種類を選択します。お使いのキーボードの種類を選択しますが、普通は`jp106`を選択して、`OK`でEnterを押します。

![](http://1.bp.blogspot.com/-V2LACH1xrKo/UHvWGoBZQ9I/AAAAAAAAAEk/cqOb_GAh4CA/s1600/016.png)

Warningが表示されますが、これは仮想HDDが未初期化であることを表す警告です。`Re-initialize all`を選択してEnterを押します。

![](http://4.bp.blogspot.com/-igs2dsWFDws/UHvWHQz-qAI/AAAAAAAAAEw/8gSQZJuM3sY/s1600/017.png)

タイムゾーンを選択します。日本であれば`Asia/Tokyo`を選択して、`OK`でEnterを押します。

![](http://1.bp.blogspot.com/--BMEJxdydlU/UHvWHcw-1fI/AAAAAAAAAEs/HyU9KRE8G9s/s1600/018.png)

rootのパスワードを設定します。パスワードを入力して、"OK"でEnterを押します。

![](http://1.bp.blogspot.com/-s1OqGBUYtYU/UHvWHjuz_tI/AAAAAAAAAE0/moFW8MIwKLs/s1600/019.png)

仮想HDDのパーティションの種類を選択します。このまま`OK`でEnterを押します。

![](http://1.bp.blogspot.com/-4Ffdvko6O78/UHvWIIyVhbI/AAAAAAAAAE4/CyZr7wuHH6A/s1600/020.png)

仮想HDDにパーティションを書き込んでもよいか聞かれます。勿論良いので、`Write changes to disk`を選択してEnterを押します。

![](http://2.bp.blogspot.com/-PzI3BYStPro/UHvWIdsEXyI/AAAAAAAAAE8/QXT18BBIxpQ/s1600/021.png)

パーティションを書き込むと、パッケージのインストールが始まります。時間がかかりますので、緑茶でも飲みながら待ちます。

![](http://2.bp.blogspot.com/-YCP4HJaFqyE/UHvWI9qUTQI/AAAAAAAAAFY/6kWNbYXLnCE/s1600/022.png)

しばらくすると、インストールが完了します。`Reboot`でEnterを押すと、仮想マシンの再起動が開始されます。

以上で、CentOSのインストールは完了です。

> **note** パッケージのインストールや作業などで汚れてきたときにいつでもインストール直後の状態に戻すために、OSインストール直後にスナップショットを作成すると便利です。

![](http://3.bp.blogspot.com/-nwb02T8eqrc/UHvWJbf7tRI/AAAAAAAAAFM/qD8VR4IY5Ik/s1600/023.png)

## ネットワーク設定

ネットワーク設定を確認します。ifconfigを実行してみます。

![](http://1.bp.blogspot.com/-thFqgL2KJmA/UHvWL7A8WmI/AAAAAAAAAG0/_IcHL4tV7s8/s1600/100.png)

`eth`が表示されず`lo`しか表示されていない場合、ネットワークに接続できていません。この場合、ネットワーク設定を変更する必要があります。

今度は`-a`付きでifconfigを実行してみます。

![](http://1.bp.blogspot.com/-6gE9flIX5Kg/UHvWM7J1YHI/AAAAAAAAAG4/7XWAPFuWZKU/s1600/101.png)

`eth0`が存在することが分かります。念のため、`HWaddr`を控えておきます。

ネットワーク設定ファイルは、`/etc/sysconfig/network-scripts/`にありますので、移動します。

![](http://2.bp.blogspot.com/-qossLTX1V6Q/UHvWOlnUTzI/AAAAAAAAAG8/PLPreTJv6K4/s1600/102.png)

`eth0`の設定は`ifcfg-eth0`に書かれていますので、これをviで開きます。ファイル中の以下の値を確認します。

* `HWADDR`: MACアドレスを設定します。`ifconfig -a`で確認した値を記述します。
* `ONBOOT`: `yes`に設定します。ネットワーク起動時に接続します。

> **note** ネットワーク設定の詳細は、お使いのネットワーク環境に合わせて変更してください。

> **note** `eth0`ではなく`eth1`の場合、`ifcfg-eth0`を`mv`で`ifcfg-eth1`にリネームします。また、DEVICEの値を`eth1`に設定します。

設定したら、`service network restart`でネットワークを再起動します。

![](http://1.bp.blogspot.com/-PcdZGk5aouU/UHvWPtyNu5I/AAAAAAAAAHA/g-fufp3qHLU/s1600/103.png)

正常に再起動できたら、ifconfigでネットワークを確認します。

![](http://1.bp.blogspot.com/-PbmlKOtuGIc/UHvWQz-ktAI/AAAAAAAAAHE/3p2IAGsuQOo/s1600/104.png)

`eth0`が表示され、`inet addr`が割り当てられていることが分かります。

これで、ネットワークに接続し、外部からssh接続できるようになりましたので、`exit`してTeraTermなどのツールで接続します。この時点ではroot接続を禁止していないため、rootでsshログインできます。

## ユーザー作成

作業用ユーザーを作成します。

```
# useradd test
# passwd test
```

## rootによるsshログイン禁止

rootで外部からsshログインできる状態は危険なので、rootによるsshログインを禁止します。viで`/etc/ssh/sshd_config`を開きます。

```
# vi /etc/ssh/sshd_config
```

以下の箇所を変更します。

```
#PermitRootLogin yes
↓
PermitRootLogin no

#PermitEmptyPasswords no
↓
PermitEmptyPasswords no
```

sshdを再起動します。

```
# service sshd restart
```

一度ログアウトしてからrootでログインしてみます。ログインできなければ設定成功です。先ほど作成した作業用ユーザーでログインします。

> **note** 以降、プロンプトの文字で、rootによる作業か、作業用ユーザーによる作業かを区別します。
> * #…rootによる作業
> * $…作業用ユーザーによる作業

## IPv6無効化

IPv6は使用しないので、無効化します(IPv6環境の方は次に進んでください)。

ifconfigを実行すると、`inet addr`の他に`inet6 addr`が表示されます。これはIPv6が有効のためです。

```
# ifconfig
eth0      Link encap:Ethernet  HWaddr 08:00:27:26:9F:7C
          inet addr:192.168.0.2  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fe26:9f7c/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:311 errors:0 dropped:0 overruns:0 frame:0
          TX packets:220 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:40068 (39.1 KiB)  TX bytes:27623 (26.9 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
```

IPv6を無効化するには、`/etc/sysctl.conf`を開きます。

```
# vi /etc/sysctl.conf
```

`sysctl.conf`の最後に以下を追記します。

```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
```

ネットワークを再起動します。

```
# service network restart
```

ifconfigを実行して、再度、ネットワーク設定を確認します。

```
# ifconfig
eth0      Link encap:Ethernet  HWaddr 08:00:27:26:9F:7C
          inet addr:192.168.0.2  Bcast:192.168.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:412 errors:0 dropped:0 overruns:0 frame:0
          TX packets:331 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:42154 (41.1 KiB)  TX bytes:45551 (44.4 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
```

表示から`inet6 addr`が消えていたら、設定成功です。

> **note** 参考ページ: [CentOS 6でIPv6を無効化する方法](http://gmt-24.net/archives/1015)

IPv6を無効化したことでip6tablesも不必要となったので、停止します。

```
# service ip6tables stop
# chkconfig ip6tables off
```

ip6tablesが停止設定になったことを確認します。

```
# chkconfig --list | grep ip6tables
ip6tables       0:off   1:off   2:off   3:off   4:off   5:off   6:off
```

全てoffになっているため、ip6tablesが停止設定になっていることが分かります。

## SELinux無効化

セキュリティのために非常に重要なSELinuxですが、同時に煩わしくもあります。所詮はテスト環境と割り切って、SELinuxを無効化します。

SELinuxを無効化するには、`/etc/sysconfig/selinux`を開きます。

```
# vi /etc/sysconfig/selinux
```

以下のように変更します。

```
SELINUX=enforcing
↓
SELINUX=disabled
```

変更したら、OSを再起動します。

```
# reboot
```

再起動したら、`getenforce`を実行します。

```
$ getenforce
Disabled
```

`Disabled`と表示されているため、SELinuxが無効化されたことが分かります。

### インストール済みパッケージのアップデート

インストール済みパッケージを最新化します。

以下のコマンドを実行し、しばらく待ちます。

```
# yum update -y
```

## 開発系パッケージのインストール

開発系パッケージをインストールします。これをインストールしないと、使えるコマンドがかなり少ないです。

```
# yum groupinstall -y "Development Tools"
```

## wgetをインストール

wgetはよく使用するので、これをインストールします。

```
# yum install -y wget
```

## Java SDKをインストール

Javaアプリを動作させたいため、Java SDKをインストールします。他言語処理系を使用する場合は、それぞれのインストール方法でインストールしてください。

まず、インストール可能なJava SDKを確認します。

```
# yum search jdk
Loaded plugins: fastestmirror, presto
Loading mirror speeds from cached hostfile
 * base: mirrors.sin3.sg.voxel.net
 * extras: mirrors.sin3.sg.voxel.net
 * updates: mirrors.sin3.sg.voxel.net
==================================== N/S Matched: jdk ====================================
java-1.6.0-openjdk.i686 : OpenJDK Runtime Environment
java-1.6.0-openjdk-demo.i686 : OpenJDK Demos
java-1.6.0-openjdk-devel.i686 : OpenJDK Development Environment
java-1.6.0-openjdk-javadoc.i686 : OpenJDK API Documentation
java-1.6.0-openjdk-src.i686 : OpenJDK Source Bundle
java-1.7.0-openjdk.i686 : OpenJDK Runtime Environment
java-1.7.0-openjdk-demo.i686 : OpenJDK Demos
java-1.7.0-openjdk-devel.i686 : OpenJDK Development Environment
java-1.7.0-openjdk-javadoc.noarch : OpenJDK API Documentation
java-1.7.0-openjdk-src.i686 : OpenJDK Source Bundle
ldapjdk-javadoc.i686 : Javadoc for ldapjdk
icedtea-web.i686 : Additional Java components for OpenJDK
ldapjdk.i686 : The Mozilla LDAP Java SDK

  Name and summary matches only, use "search all" for everything.
```

1.6.0と1.7.0がインストール可能であることが分かります。ここでは1.7.0をインストールすることにします。1.7.0にもいくつかありますが、`-devel`とついているパッケージをインストールします。

```
# yum install -y java-1.7.0-openjdk-devel
```

インストールが完了したら、バージョン情報を表示して、正しくインストールされたことを確認します。

```
$ java -version
java version "1.7.0_05-icedtea"
OpenJDK Runtime Environment (rhel-2.2.1.el6_3.3-i386)
OpenJDK Client VM (build 23.0-b21, mixed mode)

$ javac -version
javac 1.7.0_05
```

以上で、セットアップは完了です。

ここまでセットアップしたものをベースとして、テスト環境をいくつか作成する場合はクローンして使用します。
