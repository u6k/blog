---
layout: post
title: "Redmineバージョンアップの作業メモ"
tags:
  - "Redmine"
date: 2015-05-15 23:00:00+09:00
---

OpenShift上でRedmineを構築・運用していますが、スケーリングができる設定ではありませんでした。また、バージョンも古かったです。そこで、Redmineのバージョンアップを行いました。
この記事では、バージョンアップ手順を説明します。

<!-- more -->

# 構築手順

前回は[openshift/openshift-redmine-quickstart](https://github.com/openshift/openshift-redmine-quickstart)でRedmineを構築しました。改めて良い構築手順はないかと探したら、[Redmine 2.4](https://hub.openshift.com/quickstarts/5-redmine-2-4)を見つけました。

この手順だと、ボタン1押しで構築できる上に、スケーリングできる設定となっています。

構築作業を実施する手順を考えました。

* 旧Redmineのデータ(MySQL、ファイル)をダンプする。
* 上記手順で、新Redmineをデプロイしてみる。
	* デプロイ後、プロジェクト作成、チケット作成などで動作確認する。
* 新Redmineにデータをインポートする。
* しばらく使った後、問題無いと判断したら、旧Redmineを削除する。

# 旧Redmineのデータをダンプ

MySQLデータをダンプし、添付ファイルを取得します。MySQLへの接続、ssh接続の方法はOpenShiftコンソールに表示されているので、接続・ダンプします。

# 新Redmineを構築

[Redmine 2.4](https://hub.openshift.com/quickstarts/5-redmine-2-4)の手順で構築しました。必要情報を入力してボタンをクリックするだけなので、特に迷うことはありません。

デプロイ後、念の為にデプロイ状況を確認した。`rhc show-app`コマンドでアプリ情報を確認したところ、以下のように表示されました。

```
>rhc show-app myredmine
DL is deprecated, please use Fiddle
myredmine @ http://myredmine-u6kapps.rhcloud.com/ (uuid: 5507c99dfcf933bc9c000162)
----------------------------------------------------------------------------------
  Domain:          u6kapps
  Created:         3:28 PM
  Gears:           2 (defaults to small)
  Git URL:         ssh://5507c99dfcf933bc9c000162@myredmine-u6kapps.rhcloud.com/~/git/myredmine.git/
  Initial Git URL: https://github.com/openshift/openshift-redmine-quickstart.git
  SSH:             5507c99dfcf933bc9c000162@myredmine-u6kapps.rhcloud.com
  Deployment:      auto (on git push)

  mysql-5.5 (MySQL 5.5)
  ---------------------
    Gears:          1 small
    Connection URL: mysql://$OPENSHIFT_MYSQL_DB_HOST:$OPENSHIFT_MYSQL_DB_PORT/
    Database Name:  myredmine
    Password:       ***
    Username:       ***

  haproxy-1.4 (Web Load Balancer)
  -------------------------------
    Gears: Located with ruby-1.9

  ruby-1.9 (Ruby 1.9)
  -------------------
    Scaling: x1 (minimum: 1, maximum: available) on small gears
```

MySQL接続情報が表示されます。MySQLホストとポート番号が環境変数ですが、これはこれで問題ありません。

sshログインして、MySQL接続を確認します。

```
> mysql -h $OPENSHIFT_MYSQL_DB_HOST -P $OPENSHIFT_MYSQL_DB_PORT -u *** --password=***
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.5.41 MySQL Community Server (GPL)

Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

接続できました。ついでにデータベースも確認してみます。

```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| myredmine          |
| mysql              |
| performance_schema |
+--------------------+
4 rows in set (0.00 sec)
```

とりあえず、デプロイした新Redmineで動作確認を行います。

# 新Redmineにデータをインポート

`myredmine`データベースを事前ダンプしたデータと入れ替えます。

まず、`myredmine`データベースを削除して、作成し直します。

```
mysql> drop database myredmine;
Query OK, 0 rows affected (0.02 sec)

mysql> create database myredmine character set utf8;
Query OK, 1 row affected (0.00 sec)
```

既存RedmineのMySQLダンプデータをOpenShiftホストにアップロードして、以下のコマンドを実行してMySQLにデータをインポートします。

```
> mysql -h $OPENSHIFT_MYSQL_DB_HOST -P $OPENSHIFT_MYSQL_DB_PORT -u *** --password=*** myredmine < redmine_20150317-164347.sql
```

インポートされたことを確認してみます。

```
> mysql -h $OPENSHIFT_MYSQL_DB_HOST -P $OPENSHIFT_MYSQL_DB_PORT -u *** --password=*** myredmine

mysql> show tables;
+-------------------------------------+
| Tables_in_myredmine                 |
+-------------------------------------+
| attachments                         |
| auth_sources                        |
| boards                              |
| changes                             |
| changeset_parents                   |
| changesets                          |
| changesets_issues                   |
| comments                            |
| custom_fields                       |
| custom_fields_projects              |
| custom_fields_roles                 |
| custom_fields_trackers              |
| custom_values                       |
| documents                           |
| enabled_modules                     |
| enumerations                        |
| groups_users                        |
| issue_categories                    |
| issue_relations                     |
| issue_statuses                      |
| issues                              |
| journal_details                     |
| journals                            |
| member_roles                        |
| members                             |
| messages                            |
| news                                |
| open_id_authentication_associations |
| open_id_authentication_nonces       |
| projects                            |
| projects_trackers                   |
| queries                             |
| queries_roles                       |
| repositories                        |
| roles                               |
| schema_migrations                   |
| settings                            |
| time_entries                        |
| tokens                              |
| trackers                            |
| user_preferences                    |
| users                               |
| versions                            |
| watchers                            |
| wiki_content_versions               |
| wiki_contents                       |
| wiki_pages                          |
| wiki_redirects                      |
| wikis                               |
| workflows                           |
+-------------------------------------+
50 rows in set (0.01 sec)

mysql> select count(1) from issues;
+----------+
| count(1) |
+----------+
|     3261 |
+----------+
1 row in set (0.01 sec)
```

インポートはできているようです。

次にDBマイグレーションしたいと思いますが、OpenShiftホスト上で`rake`を直接実行する方法が分かりません。`git push`するとマイグレーションなど一連の処理が自動的に実行されることは知っているので、それで実行してみます。

`git clone`して適当にファイルを操作して`git push`してみます。

```
> vi README.md
> git add README.md
> git commit -m commit
> git push
warning: push.default is unset; its implicit value is changing in
Git 2.0 from 'matching' to 'simple'. To squelch this message
and maintain the current behavior after the default changes, use:

  git config --global push.default matching

To squelch this message and adopt the new behavior now, use:

  git config --global push.default simple

See 'git help config' and search for 'push.default' for further information.
(the 'simple' mode was introduced in Git 1.7.11. Use the similar mode
'current' instead of 'simple' if you sometimes use older versions of Git)

Counting objects: 5, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 318 bytes, done.
Total 3 (delta 2), reused 0 (delta 0)
remote: Stopping Ruby cartridge
remote: Waiting for stop to finish
remote: Waiting for stop to finish
remote: Waiting for stop to finish
remote: Waiting for stop to finish
remote: Waiting for stop to finish
remote: Waiting for stop to finish
remote: Waiting for stop to finish
remote: Waiting for stop to finish
remote: Syncing git content to other proxy gears
remote: Saving away previously bundled RubyGems
remote: Building git ref 'master', commit 5d7b3f0
remote: Building Ruby cartridge
remote: Restoring previously bundled RubyGems
remote: NOTE: You can commit .openshift/markers/force_clean_build to force a clean bundle
remote: NOTE: Skipping 'bundle install' because Gemfile is not modified.
remote: Preparing build for deployment
remote: Deployment id is 3fd2bb5a
remote: Activating deployment
remote: HAProxy already running
remote: HAProxy instance is started
remote: Compilation of assets is disabled or assets not detected.
remote: Starting Ruby cartridge
remote: ------------------------
remote: Selected DBMS: mysql
remote: ------------------------
remote: Migrating database
remote: Generating secret token
remote: -------------------------
remote: Git Post-Receive Result: success
remote: Activation status: success
remote: Deployment completed with status: success
To /var/lib/openshift/5507c99dfcf933bc9c000162//git/myredmine.git/
   3def682..5d7b3f0  master -> master
```

DBマイグレーション、シークレットトークンの生成が実行されました。

# 設定の移行

既存Redmineの新Redmineに移行します。

既存Redmineを`git clone`して`config/configuration.yml`を確認したところ、メール送信設定を書いていました。

```
default:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: smtp.gmail.com
      port: 587
      domain: smtp.gmail.com
      authentication: :login
      user_name: "u6k.apps@gmail.com"
      password: "***"
      enable_starttls_auto: true
```

同様の設定を、新Redmineにも書きます。

まず、新Redmineを`git clone`します。GitリポジトリURLは`rhc show-app`で確認できます。

`config/configuration.yml`を作成したいと思いますが、`.gitignore`に`config/configuration.yml`が無視設定されているので、これを削除します。

```
> vi .gitignore
```

`config/configuration.yml.sample`を`config/configuration.yml`にコピーして、上記設定を書きます。

```
> cp config/configuration.yml.sample config/configuration.yml
> vi config/configuration.yml
```

編集をコミットして、`git push`します。

```
> git add .gitignore
> git add config/configuration.yml
> git commit -m "update config"
> git push
```

# テーマの移行

以前はgitmikeを使っていました。面倒なので後で適用しよう。

# おわりに

以上で、新Redmineの構築とデータ・マイグレーションは完了です。1ヶ月程度使いましたが特に問題はないようなので、旧Redmineは削除しました。

# (おまけ)Jenkinsジョブ設定 - 定期バックアップ

JenkinsでRedmineのMySQLデータダンプを定期的に取得しているので、そのジョブを作成しました。

```
ssh -i /etc/jenkins/id_rsa_openshift ***@myredmine-u6kapps.rhcloud.com -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "mysqldump -h ***-u6kapps.rhcloud.com -P 59861 -u *** --password=*** --lock-all-tables myredmine" | gzip | sudo tee /var/owncloud/u6k/files/backup/Redmine_on_OpenShift/myredmine_`date +%Y%m%d-%H%M%S`.sql.gz
```

`rhc show-app`ではMySQLホスト名、ポート番号が環境変数で表示されましたが、上記コマンドに環境変数を指定しても空になるだけなので、仕方ないのでOpenShiftホストにsshログインして、環境変数の具体的な値を調べました。

```
> echo $OPENSHIFT_MYSQL_DB_HOST
***-u6kapps.rhcloud.com
> echo $OPENSHIFT_MYSQL_DB_PORT
59861
```

Jenkinsジョブを手動実行して、想定通りにDBダンプデータが取得できていることを確認します。
