---
layout: single
title: "CentOSのローカルyumリポジトリの作り方"
tags:
  - "Linux"
  - "手順"
date: 2013-06-20 19:34:00+09:00
redirect_from:
  - /2013/06/centosyum.html
---

セキュリティに厳しい組織でCentOSサーバーを管理していると、インターネットから切り離されたCentOSサーバーを管理することがあります。この場合、インターネットにアクセスできないため、yumは使えません。

そこで、ローカルにyumリポジトリを作ることで、非インターネット環境でもyumを使えるようにします。

## 概要

例えば、組織内にインターネット環境と、セキュリティレベルの高い非インターネット環境があるとします。この、非インターネット環境では、オンラインのyumリポジトリにアクセスすることはできません。

![](/assets/img/2013-06-20-build-local-yum-repository-for-centos/001.png)

これを解消するために、ローカルにyumリポジトリを作ることで、yumを使えるようにすることが出来ます。

![](/assets/img/2013-06-20-build-local-yum-repository-for-centos/002.png)

また、多数のCentOSサーバーを抱えている場合、ローカルyumリポジトリを参照することで、回線負荷と処理時間を低減することが出来ます。

![](/assets/img/2013-06-20-build-local-yum-repository-for-centos/003.png)

この記事では、インターネットから切り離されたCentOSサーバーでyumを使えるようにする方法を説明します。手順は、以下の通りです。

* サーバーAの作業
    * 1.必要なソフトウェア(yum-utils、createrepo)をインストールする。
    * 2.reposyncとcreaterepoで、ローカルyumリポジトリを作る。
    * 3.cronで定期更新するように設定する。
* サーバーBの作業
    * 4.ローカルyumリポジトリを置くディレクトリを作成する。
    * 5.CentOS-Base.repoを修正する。
    * 6.サーバーAに作ったローカルyumリポジトリを、外付けHDDなどでサーバーBにコピーする。

## 1. 必要なソフトウェア(yum-utils、createrepo)をインストールする。

以下のコマンドを実行します。

```
# yum -y install yum-utils createrepo
```

yum-utilsに含まれるreposyncでyumリポジトリのファイルをコピーして、createrepoでyumリポジトリのリポジトリデータを作成します。

## 2. reposyncとcreaterepoで、ローカルyumリポジトリを作る。

`/var/www/html/yum-repo/`にローカルyumリポジトリを作る場合、`/usr/local/bin/yum-repo-sync.sh`を以下のように作成します。

```
#!/bin/sh

yum -y update

cd /var/www/html/yum-repo/

reposync -r base -n -t /var/cache/yum
createrepo base/
reposync -r updates -n -t /var/cache/yum
createrepo updates/
reposync -r extras -n -t /var/cache/yum
createrepo extras/
reposync -r centosplus -n -t /var/cache/yum
createrepo centosplus/
reposync -r contrib -n -t /var/cache/yum
createrepo contrib/
```

作成したら実行して、正常に完了するか確認します。なお、初回はすごく時間がかかります。(数時間単位)

このスクリプトの内容を説明します。

`/etc/yum.repos.d/CentOS-Base.repo`を見ると、yumリポジトリが以下のように分かれていることが分かります。

* base
* updates
* extras
* centosplus
* contrib

各リポジトリは、rpmファイルとリポジトリデータで構成されます。例えば、baseだと以下のようになります。

* base/
    * Packages/
        * RPMファイル群
    * repodata/
        * リポジトリデータファイル

reposyncで、指定したリポジトリ名のファイルをPackagesディレクトリにコピーします。これだけだと単にファイルをコピーしただけなので、createrepoで指定ディレクトリ以下のファイルを読み込んで、リポジトリデータファイルを作成します。これを各リポジトリの分だけ繰り返します。

なお、baseリポジトリは更新されることが無いので、初回のコピーが完了したらコメントアウトしたほうが良いです。また、CentOSのDVDを持っている場合は、DVD中のosディレクトリがbaseに相当するので、直接コピーしたほうが早いです。

## 3. cronで定期更新するように設定する。

`yum-repo-sync.sh`を、例えば1日ごとに実行するように、cronで設定します。

```
# crontab -e
```

```
0 0 * * * /usr/local/bin/yum-repo-sync.sh
```

これを行うことで、ローカルyumリポジトリを最新に保つことが出来ます。

以上で、サーバーA側の作業は終わりです。この作業は、1度だけ行えば、後は放っておいて良いです(正常に動作していれば)。

## 4. ローカルyumリポジトリを置くディレクトリを作成する。

次に、サーバーB側の作業を行います。

まず、ローカルyumリポジトリを置くディレクトリを作成します。ここでは、サーバーAと同じ`/var/www/html/yum-repo/`とします。

```
# mkdir /var/www/html/yum-repo
```

## 5. CentOS-Base.repoを修正する。

yumが参照するリポジトリの場所は、`/etc/yum.repos.d/CentOS-Base.repo`に設定されています。通常はインターネットのミラーサイトが設定されていますが、ローカルyumリポジトリを参照するように修正します(mirrorlistをコメントアウトして、baseurlをローカルyumリポジトリに設定しています)。

```
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
baseurl=file:///var/www/html/yum-repo/base/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#released updates
[updates]
name=CentOS-$releasever - Updates
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
baseurl=file:///var/www/html/yum-repo/updates/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
baseurl=file:///var/www/html/yum-repo/extras/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
baseurl=file:///var/www/html/yum-repo/centosplus/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#contrib - packages by Centos Users
[contrib]
name=CentOS-$releasever - Contrib
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=contrib
baseurl=file:///var/www/html/yum-repo/contrib/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
```

## 6. サーバーAに作ったローカルyumリポジトリを、外付けHDDなどでサーバーBにコピーする。

媒体は何を使っても良いですが、サーバーAの`/var/www/html/yum-repo/`以下の全てのファイルを、サーバーBの`/var/www/html/yum-repo/`にコピーします。外付けHDDをmountして、

```
rsync -av --delete /var/www/html/yum-repo/ /mnt/hdd/yum-repo/
```

などのようにコピーします。

サーバーBへのコピーが完了したら、試しに`yum update`してみます。ローカルyumリポジトリを参照してアップデートできたら、成功です。

## 備考

* 作成したローカルyumリポジトリをhttpdなどで公開して、LAN内の多数のCentOSサーバーのCentOS-Base.repoをそこを参照するように修正すれば、回線負荷と処理時間を低減することが出来ます。
* EPELなど外部リポジトリを参照している場合でも、reposyncとcreaterepoを同様に行うことで、ローカルepelリポジトリを作ることが出来ます。
