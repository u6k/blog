---
layout: single
title: "Redmine@OpenShiftのMySQLデータをバックアップ&リカバリー"
tags:
  - "Redmine"
date: 2015-01-14 20:00:00+09:00
redirect_from:
  - /2015/01/redmineopenshiftmysql.html
---

自分用のRedmineをOpenShiftで稼働させていますが、何らかの理由でデータが消えてもらっては困るので、定期的にバックアップを取っています。この記事では、そのバックアップ手順と、バックアップデータをOpenShift上にリカバリーする手順を説明します。

<!-- more -->

# 前提

* MySQLデータ、Redmineソースコードをバックアップします。添付ファイルは考慮しません(私が添付ファイルを使用していないだけ)。
* phpMyAdminではなく、`mysqldump`でダンプします。phpMyAdminでダンプしたら、なぜかダンプファイルが途中までしか出力されませんでした。
* バックアップしたMySQLデータ、Redmineソースコードを使用して、OpenShift上にリカバリーします。

# バックアップ手順

`ssh`でOpenShiftにログインして、そこから`mysqldump`を使用します。しかし、いちいちログインするのは面倒なので、以下のように`ssh`を使用して、ローカルにダンプします。

```
$ ssh -i ~/.ssh/id_rsa $1@$2 mysqldump -h $3 -u $4 --password=$5 redmine | gzip >redmine.sql.gz
```

* 秘密鍵にパスフレーズを設定している場合、Pagentなり`ssh-agent`なりを使うとパスワード入力を省略できます。これは、上記コマンドをcronで定期実行するなどの場合に便利です。
* 変数は以下のように指定します。
    * **$1, $2**…OpenShiftに`ssh`アクセスするときのユーザー名、ホスト名です。OpenShiftの該当アプリケーションのページのRemote Accessで確認できます。
    * **$3**…MySQLホスト名(IPアドレス)です。phpMyAdminで確認できます。
    * **$4, $5**…MySQLユーザー名、パスワードです。OpenShiftの該当アプリケーションのページで確認できます。
* 出力先ファイル名に日時を含めると時間ごとのバックアップになります。
```
redmine_`date +%Y%m%d-%H%M%S`.sql.gz
```

# リカバリー手順

* バックアップしたMySQLデータ、Redmineソースコードを使用して、OpenShift上にリカバリーします。
* `rhc`で新規のOpenShiftアプリを作成します。
* Redmineソースコードをpushします。
* MySQLダンプファイルを`scp`でアップロードして、`mysql`でインポートします。
* 該当アプリケーションのページで、アプリケーションを再起動します。

# 備考

* Redmineをバージョンアップしたいときはどうすれば良い？
* OpenShift以外の環境(例えばローカル)に復旧する方法を考えておいたほうが良い。万が一、OpenShiftが使えなくなってしまうことを考慮して。

# Qiita

* [Redmine@OpenShiftのMySQLデータをバックアップ&リカバリー - Qiita](http://qiita.com/u6k/items/9d9cd6ec06b7523168bf)
