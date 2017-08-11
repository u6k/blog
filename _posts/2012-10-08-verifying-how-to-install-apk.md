---
layout: single
title: apkインストール方法の実験 - "adb install -r"
tags:
  - "Android"
date: 2012-10-08 21:12:00+09:00
redirect_from:
  - /2012/10/android-adb-install.html
---

Androidアプリは、SharedPreferenceという領域に設定情報などを保存できます。アプリをバージョンアップする時、Google Playからアップデートした場合は当然設定情報は引き継がれますが、adbコマンドでapkを上書きした時にどうなるか確認してみました。

<!--more-->

# 実験

入力した文字列をSharedPreferenceに保存し、またSharedPreferenceから読み込んで表示する、簡単なアプリを作成しました。アップデートして確認するため、v1.0とv1.1を作成しました。内容は全く同じです。

![](/assets/img/2012-10-08-verifying-how-to-install-apk/001.png)

まず、文字列を入力して保存。次にそれを読み込んでみます。当然、保存した文字列が読み込まれて表示されます。

![](/assets/img/2012-10-08-verifying-how-to-install-apk/002.png)

次に、adbコマンドでv1.1のapkをインストールしました。

```
D:¥doc¥sample-apk-install¥apk>adb install -r sample-apk-install-1.1.apk
1824 KB/s (171890 bytes in 0.092s)
    pkg: /data/local/tmp/sample-apk-install-1.1.apk
Success
```

v1.1を起動して、保存した文字列を表示してみました。v1.0で保存した「テスト」という文字列が表示されました。

![](/assets/img/2012-10-08-verifying-how-to-install-apk/003.png)

# 結論

adbコマンドでバージョンアップしても、SharedPreferenceは引き継がれました。…まぁ、なんというか、当たり前の事実を再確認しただけでした。

作成したソースコード、アプリは以下で公開しています。

* [sample-apk-install](https://bitbucket.org/u6k/sample-apk-install/)
