---
layout: single
title: "自宅サーバー設計(ハードウェア編)"
tags:
  - "サーバー"
  - "設計"
date: 2018-06-04
---

自分用のRedmineやownCloudを運用するために、さくらVPSやDigitalOceanやOpenShiftなどをうろうろしていましたが、落ち着いてきたので現状を整理したいと思います。まずは、ハードウェア構成を整理します。

# 前提

- 昔使っていたMacBookがあるので、これをDockerホストにしたい。
- HDDが数台あるけど、1個のボリュームにして扱いやすくしたい。
- ドメイン名でアクセスできるようにしたい。
- バックアップは、自宅とは別サイトにしたい。

# 構成図

紆余曲折あり、現在は以下のような構成になっています。

{% plantuml %}

interface "VNC"
interface "SSH"
interface "HTTP(S)"

node "MacBookPro" {
    [macOS]
    component "VirtualBox" {
        [CoreOS]
    }
}

node "HDD1,2,3" {
    [LVM ext4 (6TB)]
}

[ムームードメイン] <<外部サービス>>
[MyDNS] <<外部サービス>>
[AmazonCloudDrive] <<外部サービス>>

[macOS] -up- [VNC]
[CoreOS] --> [LVM ext4 (6TB)]
[CoreOS] -up- [SSH]
[CoreOS] -up- [HTTP(S)]
[ムームードメイン] -- [MyDNS]
[MyDNS] -- [macOS]
[LVM ext4 (6TB)] -- [AmazonCloudDrive] : バックアップ

{% endplantuml %}

# 構成の説明

## CoreOS on VirtualBox on macOS

Docker for macも使っていましたが、以下のような不安定さがあり、結局、CoreOSに戻しました。

- `qcow2`ファイルが肥大化して、ストレージを圧迫してしまう。
- ネットワーク通信が頻発すると、接続確立できなくなる？

## 外部からアクセスする場合は、sshまたはVNC

普段はCoreOSで作業を行うため、sshで接続します。CoreOSの調子がおかしい、macOSをアップデートする、などの場合はVNCでアクセスします。

## "u6k.me"でアクセスできるように、ムームードメインで契約

ムームードメインで年間契約して、MyDNSでドメイン名とIPアドレスを管理しています。IPアドレスが変わっても良いように、Jenkinsコンテナで定期的にIPアドレスを通知しています。

## HDDはLVMでボリュームを統合

ボリュームを1個に統合して、ext4ストレージとして使っています。これは今でもちょっと迷っていて、個別ボリュームで扱った方が良いかな？故障したときどこまで被害が広がるかな？と悩んでいます。

## バックアップはAmazonCloudDrive

まだ全部をバックアップはできていなくて、少しずつ進めています。

## MacBookPro

排熱の観点から、風通しの良い場所において、まな板立てに立て掛けています。温度を監視していますが、変な高温になることは今のところありません。

# おわりに

ストレージさえ解決すれば、全てAWSかDigitalOceanに持っていきたいのですけど、今のところ自宅で運用しています。また、旅行などで長期間自宅を離れる場合は、Redmineなど必須サービスのみをDigitalOceanで一時的運用するようにしています。

CoreOSの中でどのようなDockerコンテナが動作しているかは、ソフトウェア編で説明します。


# Link

- Author
    - [u6k.Blog()](https://blog.u6k.me/)
    - [u6k - GitHub](https://github.com/u6k)
    - [u6k_yu1 \| Twitter](https://twitter.com/u6k_yu1)
- Source
    - [2018-06-04-my-service-specification-hardware-part.md](https://github.com/u6k/blog/blob/master/_posts/2018-06-04-my-service-specification-hardware-part.md)
