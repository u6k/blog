---
layout: single
title: "Windows 10のデータ通信を抑制する"
tags:
  - "Windows"
date: 2018-06-25 00:00:00+09:00
---

自分はMicrosoft Surface Pro 4を使っていますが、何も考えずにテザリングすると、あっという間にデータ通信量がGBを越えてしまいます。

ここでは、データ通信を抑制するためにやったことを整理します。

# TL;DR

- Wi-Fiを従量課金接続に設定する
- Windows Updateの自動更新を無効化する
- Dropboxなどのファイル共有サービスを停止する
- アプリケーションの自動バージョンチェックを無効化する

# Wi-Fiを従量課金接続に設定する

Wi-Fiを従量課金接続として設定することで、次の効果が得られるようです。

- Windows Update で、優先度の高い更新プログラムだけが更新される
- Windows ストアからのアプリのダウンロードが一時停止される
- スタート画面のタイルで表示されていた情報の更新が停止する
- OneDriveで、オフラインファイルが自動で同期されない

従量課金接続として設定することで、Windowsはデータ通信がある程度抑制されますが、他のアプリケーションまで抑制されるとは限りませんし、Windows Updateについても優先度が高いプログラムは自動更新されてしまうので、この設定だけでは不十分です。とはいえ、効果はあるので設定しておきます。

設定は、次の手順で行います。

- スタート → 設定 → ネットワークとインターネット → Wi-Fi → 接続済みのWi-Fiをクリックします。
- 「従量課金接続として設定する」をオンにします。

設定からは、どのアプリケーションがどの程度の通信を行ったのかを参照する機能もあります。

- ネットワークとインターネット → データ使用状況

- 参考リンク
    - [Windows 10 での従量制課金接続](https://support.microsoft.com/ja-jp/help/4028458/windows-metered-connections-in-windows-10)
    - [Windows10でデータ通信量を確認する方法、データ節約設定方法、大容量格安sim比較！ - あんりふ！](https://ahiru8usagi.hatenablog.com/entry/Windows10_DataTraffic)

# Link

- Author
  - [u6k.Blog](https://blog.u6k.me/)
  - [u6k - GitHub](https://github.com/u6k)
  - [u6k_yu1 \| Twitter](https://twitter.com/u6k_yu1)
- Source
  - [2018-06-25-suppress-network-access-of-windows-10.md](https://github.com/u6k/blog/blob/master/_posts/2018-06-25-suppress-network-access-of-windows-10.md)
