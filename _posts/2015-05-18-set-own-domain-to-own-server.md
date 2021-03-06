---
layout: single
title: "自宅サーバーに独自ドメインを設定"
tags:
  - "DNS"
date: 2015-05-18 20:00:00+09:00
redirect_from:
  - /2015/05/blog-post_18.html
---

独自ドメインを取得し、Bloggerへの設定は完了しました。次は、自宅サーバーに独自ドメインを設定します。

## 概要

自宅サーバーのIPアドレスは変化する可能性があるため、固定IPアドレスとしてドメイン名と紐付けすることができません。そこで、DDNSの仕組みを使って、動的にIPアドレスを設定することとします。以下のページを参考に設定を行いました。

* [DynamicDNS (ムームードメインとmyDNS.jp)](http://gomocool.net/gomokulog/?p=10)
* [DynamicDNS (ムームードメインとmyDNS.jp) 2](http://gomocool.net/gomokulog/?p=24)

ムームードメインで独自ドメインを購入し、MyDNS.jpを利用してドメイン名とIPアドレスを紐付けます。MyDNS.jpにはスクリプトでIPアドレスを設定する機能があるので、それを利用します。

## ムームードメイン、MyDNS.jpの基本的な設定

MyDNS.jpのアカウントを取得して、ドメイン名を設定し、ムームードメインのDNS向き先をMyDNS.jpに向ける手順は、上記ページに書いてあるので省略します。

## スクリプトでIPアドレスを更新

MyDNS.jpのHOW TO USEを見ると、スクリプトでIPアドレスを設定する方法は数種類あるようです。ここでは、HTTP-BASICという方法で行います。これは、指定されたURLにアクセスするだけでIPアドレスを更新する方法です。

`/usr/local/bin`に`update-dns.sh`を作成し、内容を以下のようにします。

```
#!/bin/sh

wget --http-user=$MYDNS_USER --http-password=$MYDNS_PASSWORD -O - http://www.mydns.jp/login.html
```

指定URLはBasic認証がかかっているので、MyDNS.jpのアカウント情報を設定してアクセスします。ここでは、環境変数から取得することとします。スクリプトを作成したら、`sudo chmod +x`で実行権限を与えます。

## スクリプトを試験実行

スクリプトでIPアドレスが更新されることを確認するため、MyDNS.jp側のIPアドレスを`0.0.0.0`に設定しておきます(IP ADDR DIRECTから設定)。

次に、スクリプトを実行してみます。コンソールにHTMLが表示されたら成功です。また、MyDNS.jpでIPアドレスを確認して、更新されていれば成功です。

## cronで定期実行

cronやJenkinsなどで定期実行するように設定します。環境変数を使用している場合は、正しく設定されるか確認したほうが良いです。

## おわりに

以上で、自宅サーバーに独自ドメインを設定できました。
