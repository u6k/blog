---
title: apkインストール方法の実験 - "adb install -r"
tags: "Android"
date: 2012-10-08 21:12:00+09:00
published: false
parmalink: "android-adb-install"
postID: 2772423783502060096
---

Androidアプリは、SharedPreferenceという領域に設定情報などを保存できます。アプリをバージョンアップする時、Google Playからアップデートした場合は当然設定情報は引き継がれますが、adbコマンドでapkを上書きした時にどうなるか確認してみました。

<!--more-->

# 実験

入力した文字列をSharedPreferenceに保存し、またSharedPreferenceから読み込んで表示する、簡単なアプリを作成しました。アップデートして確認するため、v1.0とv1.1を作成しました。内容は全く同じです。

![](http://2.bp.blogspot.com/-MmojYhweY8I/UHLAZ4xmx_I/AAAAAAAAACI/gwTyIdzSIRw/s1600/device-2012-10-08-205606.png)

まず、文字列を入力して保存。次にそれを読み込んでみます。当然、保存した文字列が読み込まれて表示されます。

![](http://1.bp.blogspot.com/-DzHBs65J_4A/UHLAZ-E6vzI/AAAAAAAAACQ/bP9TfCRPQEI/s1600/device-2012-10-08-205634.png)

次に、adbコマンドでv1.1のapkをインストールしました。

```
D:¥doc¥sample-apk-install¥apk>adb install -r sample-apk-install-1.1.apk
1824 KB/s (171890 bytes in 0.092s)
    pkg: /data/local/tmp/sample-apk-install-1.1.apk
Success
```

v1.1を起動して、保存した文字列を表示してみました。v1.0で保存した「テスト」という文字列が表示されました。

![](http://3.bp.blogspot.com/-OEdDv4Cvi2A/UHLAZwlNZYI/AAAAAAAAACM/xz5hTDISxgs/s1600/device-2012-10-08-205746.png)


# 結論

adbコマンドでバージョンアップしても、SharedPreferenceは引き継がれました。…まぁ、なんというか、当たり前の事実を再確認しただけでした。

作成したソースコード、アプリは以下で公開しています。

* [sample-apk-install](https://bitbucket.org/u6k/sample-apk-install/)
