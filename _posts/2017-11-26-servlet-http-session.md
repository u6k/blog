---
layout: single
title: "Servlet APIにおけるHttpSessionの挙動検証"
tags:
  - "Java"
  - "Servlet"
date: 2017-11-26 16:00:00+09:00
---

Javaでよくあるセッション管理の仕組みについて他人に説明している時に、どうも自分の認識があいまいになっていることに気付いたので、挙動を検証してみます。よくあるセッション管理ということで、Servlet APIにおけるHttpSessionの挙動を検証します。

## 検証するWebアプリケーション

アクセスすると`count=1`というボディを返し、更にアクセスすると`count=2`、`count=3`とカウントアップするだけのWebアプリケーションです。もちろん、異なるWebブラウザからアクセスした場合は`count=1`からやり直しです。Webブラウザごとにセッション管理を行い、カウントを保持します。

{% plantuml %}
Webブラウザ -> Webアプリ : request
Webアプリ -> Webブラウザ : response\nbody: count=1
Webブラウザ -> Webアプリ : request
Webアプリ -> Webブラウザ : response\nbody: count=2
{% endplantuml %}

検証のために作成したWebアプリケーションは、次のリポジトリにあります。検証では詳細に説明はしないので、READMEやソースコードをご覧ください。

- [u6k/sample-http-session \| GitHub](https://github.com/u6k/sample-http-session)

## 検証

### セッション・タイムアウトを何も設定しない場合

セッション・タイムアウトは`src/main/webapp/WEB-INF/web.xml`の`<session-timeout>`で設定しますが、まずは`web.xml`を削除してデフォルトの挙動を確認してみます。

Webブラウザを開いて[http://localhost:8080/](http://localhost:8080/)にアクセスすると、`count=1`が表示されます。この時、レスポンスに`Set-Cookie`に`JSESSIONID`が設定されます。`Expires`や`Max-Age`が未設定なので、この`JSESSIONID`はWebブラウザを閉じたときにWebブラウザから削除されます。

![default timeout 01](/assets/img/2017-11-26-servlet-http-session/default-timeout-01.png)

次にアクセスすると、`count=2`が表示されます。この時、リクエストに先ほどの`JSESSIONID`が設定されています。この`JSESSIONID`により先ほどと同一セッションと判定されて、サーバー側でカウントアップ処理が行われます。

![default timeout 02](/assets/img/2017-11-26-servlet-http-session/default-timeout-02.png)

Webブラウザを閉じてアクセスすると、`count=1`が表示されます。この時、リクエストには`JSESSIONID`が設定されておらず、レスポンスに`Set-Cookie`で新しい`JSESSIONID`が設定されます。上で説明した通り、Webブラウザを閉じたために`JSESSIONID`がWebブラウザから削除され、このような挙動になります。

![default timeout 03](/assets/img/2017-11-26-servlet-http-session/default-timeout-03.png)

なお、Webアプリケーション側はセッションを無期限で保持します。

### セッション・タイムアウトを設定した場合

セッション・タイムアウトを1分に設定した時の挙動を確認してみます。

まず、`web.xml`を次のように修正します。

```
<session-config>
    <session-timeout>1</session-timeout>
</session-config>
```

`<session-timeout>`は、タイムアウト時間を分単位で設定します。

Webブラウザを開いて[http://localhost:8080/](http://localhost:8080/)にアクセスすると、先ほどと同様に`count=1`が表示されます。レスポンスも先ほどと同様に`Set-Cookie`で`JSESSIONID`が設定されており、`Expires`や`Max-Age`が未設定なのでWebブラウザを閉じたときに削除されます。

![session timeout 01](/assets/img/2017-11-26-servlet-http-session/session-timeout-01.png)

次に1分以内にアクセスすると、`count=2`が表示されます。同様にアクセスし続けると、カウントアップされ続けます。Webアプリケーション側のセッション・タイムアウト時刻は、アクセスするたびにリセットされます。

![session timeout 02](/assets/img/2017-11-26-servlet-http-session/session-timeout-02.png)

次に1分以上後にアクセスすると、`count=1`が表示されます。リクエストを見ると`JSESSIONID`が設定されていますが、レスポンスを見ると`Set-Cookie`でリクエストとは異なる`JSESSIONID`が設定されています。つまり、Webアプリケーション側でセッションが破棄され、新しいセッションが開始されたということです。

![session timeout 03](/assets/img/2017-11-26-servlet-http-session/session-timeout-03.png)

なお、1分以内にWebブラウザを閉じて再びアクセスしても`count=1`が表示されます。これは、Webブラウザを閉じたために`JSESSIONID`が削除されたためです。

### Cookie寿命を設定した場合

セッション・タイムアウトを1分、Cookie寿命を2分に設定した時の挙動を確認してみます。

まず、`web.xml`を次のように修正します。

```
<session-config>
    <session-timeout>1</session-timeout>
    <cookie-config>
        <max-age>120</max-age>
    </cookie-config>
</session-config>
```

`<cookie-config>/<max-age>`は、Cookie寿命を秒単位で設定します。これを設定することで、`Set-Cookie`に`Expires`と`Max-Age`が設定されるようになります。

セッション・タイムアウトは、Webアプリケーションにアクセスするごとにタイムアウト時刻が更新されます。これに対してCookie寿命は、最初に`Set-Cookie`されたときに設定されそのあとは更新されないために、寿命の時刻が来るとWebブラウザから削除されます。`Set-Cookie`に`Expires`と`Max-Age`が設定されるためにWebブラウザを閉じても削除されないため、Webブラウザのライフサイクルをまたいでセッションを保持することができます。

実際の挙動を確認してみます。Webブラウザを開いて[http://localhost:8080/](http://localhost:8080/)にアクセスすると、これまでと同様に`count=1`が表示されます。レスポンスに`Set-Cookie`で`JSESSIONID`が設定されますが、先ほどと異なり`Expires`と`Max-Age`が設定されます。

![cookie max age 01](/assets/img/2017-11-26-servlet-http-session/cookie-max-age-01.png)

1分以内に同様にアクセスすると、カウントアップされ続けます。

![cookie max age 02](/assets/img/2017-11-26-servlet-http-session/cookie-max-age-02.png)

Webブラウザを更新し続けていると、最初のアクセスから2分経過後に`count=1`に戻ります。リクエストを見るとそれまで設定されていた`JSESSIONID`が設定されておらず、リクエストに`JSESSIONID`がないのでレスポンスの`Set-Cookie`で新しい`JSESSIONID`が設定されます。

![cookie max age 03](/assets/img/2017-11-26-servlet-http-session/cookie-max-age-03.png)

なお、1分以内にWebブラウザを閉じて再びアクセスした場合、閉じる前のセッションが保持されているためにカウントアップが継続されます。

## おわりに

どのようにタイムアウトするのか、通信がどのように行われるのか認識があいまいでしたが、整理できました。次はSpring SessionやSpring Securityにおけるセッション管理を検証してみたいと思います。
