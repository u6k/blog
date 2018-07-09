---
layout: single
title: "自宅サーバー設計(ハードウェア編)"
tags:
  - "サーバー"
  - "設計"
date: 2018-06-04
---

自分用のRedmineやminioを運用するためにDockerホストを運用していますが、[前回](https://blog.u6k.me/2017/04/28/my-server-specification-for-hardware.html)から約1年が経過して、少し構成が変わったので整理します。

この記事では、自分用のサービス群を運用するために利用しているサービスやハードウェアの構成を説明します。

## 前提

- 昔使っていたMacBookがあるので、これをDockerホストにしたい。
- HDDが数台あるけど、1個のボリュームにして扱いやすくしたい。
- ドメイン名でアクセスできるようにしたい。
- バックアップは、自宅とは別サイトにしたい。
- ダウンタイムをなくしたいサービスは外部サービスで動作させる。

## 構成図

現在は以下のような構成になっています。

{% plantuml %}
interface "VNC"
interface "SSH"
interface "HTTP(S)"

node "MacBook" {
  [Debian]
  [Docker]
}

node "HDD1,2,3,4" {
    [LVM RAID logical volume (4TB)] as LVM
}

[ムームードメイン] <<外部サービス>>
[MyDNS] <<外部サービス>>
[クラウドストレージ] <<外部サービス>>
[DigitalOcean Spaces] <<外部サービス>>
[GitHub Pages] <<外部サービス>>

[Debian] -u- [VNC]
[Debian] --> [LVM]
[Debian] -u- [SSH]
[Debian] -u- [HTTP(S)]
[Debian] -l- [Docker]
[Debian] -r- [GitHub Pages]
[ムームードメイン] -- [MyDNS]
[MyDNS] -- [Debian]
[LVM] -- [クラウドストレージ] : バックアップ
[LVM] -- [DigitalOcean Spaces]
{% endplantuml %}

## 構成の説明

前回からの変更点とあわせて、構成を説明します。

### Docker on Debian

サービスはほぼDockerコンテナとして動作させています。当初はDocker for macで動作させていましたが、qcow2ファイルが肥大化する、ネットワークが不安定、などの問題があるため、Bootcampで確保したパーティションにDebianをセットアップして運用しています。

前回はCoreOS on VirtualHost on MacBookで、一時的にDebian on DeigitalOceanに移行して、やっぱりDebian on MacBookに戻りました。サーバー上でいろいろ作業したい場合、CoreOSはやはり不便ですね。そういうOSなのでしかたありませんが。

> __TODO:__ 実は、この記事を執筆している現時点ではまだDebian on VirtualBox on MacBookで、LVM RAID logical volumeの実験が完了したら、上記のように移行する予定です。

運用しているDockerサービス群は、別記事で説明します。

### 運用作業のためにアクセスする場合は、sshまたはVNC

普段の運用作業はsshで接続します。macOSの調子がおかしい、macOSをアップデートする、などGUIで作業を行う場合はVNCでアクセスします。

この方式は、前回から変わりありません。

### "u6k.me"でアクセスできるように、ムームードメインで契約

ムームードメインで年間契約して、MyDNSでドメイン名とIPアドレスを管理しています。IPアドレスが変わっても良いように、Rundeckコンテナで定期的にIPアドレスを通知しています。

前回までは、ジョブをJenkinsで実行していましたが(いわゆる闇のJenkinsおじさん)、現在はRundeckでジョブを実行しています。ただ、Rundeckへの移行は、正直、あまり意味がなかったかなと思っています。

### ブログはGitHub Pagesで独自ドメイン + HTTPS

ブログはダウンタイムをゼロにしたく、DockerではなくGitHub Pagesに移行しました。これにより、Dockerホストが不安定になったときやmacOSをアップデートしたいときに、ブログも巻き込まれてダウンしていましたが、現在ではそれはなくなりました。

> __TODO:__ ブログのGitHub Pagesへの移行は、この記事執筆時点では検証中です。

### HDDはLVMで統合

HDDは、LVM RAID logical volumeで統合しています。この構成の場合、LVMの機能でミラーリングするので、HDDが1個故障する程度なら復旧が可能のはずです。

前回はLVMで統合していただけであり、対障害性の観点からは脆弱でした。そうは言ってもDigitalOcean Spacesにバックアップしているので、絶対に失いたくないデータについてはあまり問題はありませんが。

> __TODO:__ この記事を執筆している現在は、まだLVM on macOSからデータを移行している途中です。ある程度の検証ができたら、別記事でセットアップ、復旧手順などを整理したいと思います。

### バックアップはDigitalOcean Spacesとクラウドストレージ

Redmineのように絶対に失いたくないデータや、失うと再収集に時間がかかりすぎるクローリング・データなどは、minioサービスの他にDigitalOcean Spacesに保存しています。他のデータはクラウドストレージに保存しようとしていますが、まだ全ては保存できておらず、少しずつ進めています。

### MacBookPro

排熱の観点から、風通しの良い場所において、まな板立てに立て掛けています。温度を監視していますが、変な高温になることは今のところありません。

この運用方法は、前回から変わりありません。

## おわりに

前回も書きましたが、できればAWSなりDigitalOceanなりに全て移行してしまいたいのですが、どーにもストレージの料金や性能を考えると、自宅ハードウエアがあるならそれで運用したい、という結論になっています。データのサイズがなぁ…

ちなみに、旅行などで長期間自宅を離れる場合に、一時的にDigitalOceanに切り替える運用は、前回から変わらずです。
