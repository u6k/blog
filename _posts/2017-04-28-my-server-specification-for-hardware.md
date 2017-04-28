---
layout: single
title: "自宅サーバー設計(ハードウェア編)"
tags:
  - "サーバー"
  - "設計"
date: 2017-04-28
---

自分用のRedmineやownCloudを運用するために、さくらVPSやDigitalOceanやOpenShiftなどをうろうろしていましたが、落ち着いてきたので現状を整理したいと思います。まずは、ハードウェア構成を整理します。

# 前提

- 昔使っていたMacBookがあるので、これをDockerホストにしたい。
- HDDが数台あるけど、1個のボリュームにして扱いやすくしたい。
- ドメイン名でアクセスできるようにしたい。
- バックアップは、自宅とは別サイトにしたい。

# 構成図

紆余曲折あり、現在は以下のような構成になっています。

![component](http://www.plantuml.com/plantuml/png/oymhIIrAIqnELL0AytDMuif4y8E3FL3u7Y4X0Hh1cafSN7dvAK2-RsAoKtv-Ta1Hlf92DPS244Jd9YRx1yU2sSdvkGNvUQbv9K23CujAIXDpdF8hO0h1YftpYr9XgckvQc76UhYu6EeOwHZ33VK9yrL8hIWnKT0m2t7IZ0MfZ7xSlE1nynuOsVcuUU7ZfYMFcpV7AjZOF5qoxMNpYiTDMy5oanytxRIpuuhshNJn2yOjxPYRM9MVvvoJNvhYKfHPbefJ9HVKamgwfGMw2j70G8lbWdb5GLVN3jEz25cm3c2mOeX1WpOMdyTqWUeWde1x1YG43N9qMy5oc9woKdZSFE5nS_FZflMFcnQ16CtJ0G00)
<!-- http://www.plantuml.com/plantuml/uml/oymhIIrAIqnELL0AytDMuif4y8E3FL3u7Y4X0Hh1cafSN7dvAK2-RsAoKtv-Ta1Hlf92DPS244Jd9YRx1yU2sSdvkGNvUQbv9K23CujAIXDpdF8hO0h1YftpYr9XgckvQc76UhYu6EeOwHZ33VK9yrL8hIWnKT0m2t7IZ0MfZ7xSlE1nynuOsVcuUU7ZfYMFcpV7AjZOF5qoxMNpYiTDMy5oanytxRIpuuhshNJn2yOjxPYRM9MVvvoJNvhYKfHPbefJ9HVKamgwfGMw2j70G8lbWdb5GLVN3jEz25cm3c2mOeX1WpOMdyTqWUeWde1x1YG43N9qMy5oc9woKdZSFE5nS_FZflMFcnQ16CtJ0G00 -->

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
