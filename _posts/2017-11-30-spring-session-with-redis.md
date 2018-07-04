---
layout: single
title: "HttpSession with Spring Sessionの挙動検証"
tags:
  - "Java"
  - "Servlet"
  - "Spring"
  - "Redis"
date: 2017-11-30 23:00:00+09:00
---

[先日は](https://blog.u6k.me/2017/11/26/servlet-http-session.html)Servlet APIにおけるセッション管理の挙動を検証しました。今回は、Servlet APIにSpring Sessionを組み込んだ時の挙動を検証します。

## 検証するWebアプリケーション

今回のWebアプリケーションも先日と同様、アクセスすると`count=1`、`count=2`、`count=3`とカウントアップするだけのWebアプリケーションです。

{% plantuml %}
Webブラウザ -> Webアプリ : request
Webアプリ -> Webブラウザ : response\nbody: count=1
Webブラウザ -> Webアプリ : request
Webアプリ -> Webブラウザ : response\nbody: count=2
{% endplantuml %}

検証のために作成したWebアプリケーションは、次のリポジトリにあります。検証では詳細に説明はしないので、READMEやソースコードをご覧ください。

- [u6k/sample-spring-session-with-servlet \| GitHub](https://github.com/u6k/sample-spring-session-with-servlet)

## 検証

### Spring Sessionを組み込んだだけで、何も設定しない場合

[Spring Session - HttpSession (Quick Start)](https://docs.spring.io/spring-session/docs/current/reference/html5/guides/httpsession.html)を参考に実装を進めます。この検証では説明をいろいろ省略するので、詳細は[Spring Session - HttpSession (Quick Start)](https://docs.spring.io/spring-session/docs/current/reference/html5/guides/httpsession.html)をご覧ください。

#### 依存関係を追加

`pom.xml`の依存関係に、次の設定を追加します。

```
<dependency>
    <groupId>org.springframework.session</groupId>
    <artifactId>spring-session-data-redis</artifactId>
    <version>1.3.1.RELEASE</version>
    <type>pom</type>
</dependency>
<dependency>
    <groupId>biz.paluch.redis</groupId>
    <artifactId>lettuce</artifactId>
    <version>3.5.0.Final</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-web</artifactId>
    <version>4.3.4.RELEASE</version>
</dependency>
```

#### Spring Java Configurationを作成

Spring設定を行う`Config`クラスを作成します。`src/main/java/me/u6k/sample/sample_spring_session_with_servlet/Config.java`ファイルを次のように作成します。

```
package me.u6k.sample.sample_spring_session_with_servlet;

import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession;

@EnableRedisHttpSession
public class Config {
    @Bean
    public LettuceConnectionFactory connectionFactory() {
        return new LettuceConnectionFactory();
    }
}
```

`@EnableRedisHttpSession`によって、`HttpSession`をSpring Sessionで置き換えます。

`LettuceConnectionFactory`によって、`localhost:6379`で待ち受けるRedisに接続するように設定されます。

#### Servletコンテナを初期化

先ほどのSpring設定を適用するため、Servletコンテナの初期化を行う`Initializer`クラスを作成します。`src/main/java/me/u6k/sample/sample_spring_session_with_servlet/Initializer.java`ファイルを次のように作成します。

```
package me.u6k.sample.sample_spring_session_with_servlet;

import org.springframework.session.web.context.AbstractHttpSessionApplicationInitializer;

public class Initializer extends AbstractHttpSessionApplicationInitializer {
    public Initializer() {
        super(Config.class);
    }
}
```

コンストラクタの`super()`に先ほどの`Config`クラスを渡すことで、Spring設定を適用します。

#### セッションを使用する

`HttpSession`が内部的に置き換えられているため、使い方は普段と同じです。

```
package me.u6k.sample.sample_spring_session_with_servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
@WebServlet("/")
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("count") == null) {
            session.setAttribute("count", 0);
        }

        int count = (Integer) session.getAttribute("count") + 1;
        session.setAttribute("count", count);

        resp.setContentType("text/plain");
        resp.getWriter().write("count=" + count);
    }
}
```

`req.getSession()`で`HttpSession`を取得して、`getAttribute()`や`setAttribute()`でセッションに値を入出力します。内部的にはSpring Sessionが使用され、Redisに値が保存されます。

#### 実行する

まず、Redisを起動します。

```
$ docker run --name redis -d -p 6379:6379 redis
```

この時点のRedisは空ですが、空であることを確認します。Redisの内容を確認するには、redis-cliを使用します。

```
$ docker run -it --link redis:redis --rm redis redis-cli -h redis -p 6379
```

全てのキーを確認してみます。

```
redis:6379> keys *
(empty list or set)
```

空であることが確認できます。

次に、Webアプリケーションを起動します。

```
$ ./mvnw jetty:run
```

[http://localhost:8080/](http://localhost:8080/) にアクセスすると、`count=1`が表示されます。再びアクセスすると`count=2`が表示されるはずです。つまり、セッションに値が保存されます。

![redis session 01](/assets/img/2017-11-30-spring-session-with-redis/redis-session-01.png)

![redis session 02](/assets/img/2017-11-30-spring-session-with-redis/redis-session-02.png)

この時のRedisの内容を確認します。再び、全てのキーを確認してみます。

```
redis:6379> keys *
1) "spring:session:sessions:expires:b3d335ac-e57e-4a18-a87f-92282aded73e"
2) "spring:session:sessions:b3d335ac-e57e-4a18-a87f-92282aded73e"
3) "spring:session:expirations:1512043860000"
```

セッションに対応するキーが作成されていることが分かります。

`Set-Cookie`に`Expires`が設定されていないため、このセッションはWebブラウザを閉じるとWebブラウザから削除されます。Webブラウザを開いて再び [http://localhost:8080/](http://localhost:8080/) にアクセスすると、また`count=1`が表示されます。つまり、新しいセッションが作成されます。この時のRedisの内容を確認すると、次のようにキーが増えていることが分かります。

![redis session 03](/assets/img/2017-11-30-spring-session-with-redis/redis-session-03.png)

```
redis:6379> keys *
1) "spring:session:sessions:expires:5e50fc3c-7f05-431c-840f-93f1a0d0b8e0"
2) "spring:session:sessions:expires:b3d335ac-e57e-4a18-a87f-92282aded73e"
3) "spring:session:sessions:b3d335ac-e57e-4a18-a87f-92282aded73e"
4) "spring:session:sessions:5e50fc3c-7f05-431c-840f-93f1a0d0b8e0"
5) "spring:session:expirations:1512043980000"
6) "spring:session:expirations:1512044040000"
```

### セッション・タイムアウトを設定した場合

`HttpSession`をそのまま使う場合のセッション・タイムアウトは、`web.xml`の`<session-timeout>`に設定しますが、Spring Session with Redisを使用する場合は、`@EnableRedisHttpSession`の`maxInactiveIntervalInSeconds`に設定します。パラメータ名の通り、秒単位です。例えば、セッション・タイムアウトを3分に設定する場合は、以下のように設定します。

```
@EnableRedisHttpSession(maxInactiveIntervalInSeconds = 150)
public class Config {
(中略)
}
```

修正したら、先程と同様にRedisを起動して、Webアプリケーションを起動します。起動して [http://localhost:8080/](http://localhost:8080/) にアクセスすると、`count=1`が表示されます。`Set-Cookie`には`Expires`は設定されません。

![session timeout 01](/assets/img/2017-11-30-spring-session-with-redis/session-timeout-01.png)

この時のRedisの内容を確認します。

```
redis:6379> keys *
1) "spring:session:sessions:expires:b7f0fc5f-ccc3-4959-9698-803760bc48a8"
2) "spring:session:expirations:1512043320000"
3) "spring:session:sessions:b7f0fc5f-ccc3-4959-9698-803760bc48a8"
```

分かりづらいですが、`spring:session:expirations:xxx`の値は、最終アクセス時刻から3分後を示しています。

試しにこの状態で3分以上放置してから、再びRedisの状態を確認してみます。

```
redis:6379> keys *
1) "spring:session:sessions:b7f0fc5f-ccc3-4959-9698-803760bc48a8"
```

キーが減りました。つまり、セッションがサーバー側で破棄されました。Webブラウザで [http://localhost:8080/](http://localhost:8080/) にアクセスすると、再び`count=1`が表示されます。

![session timeout 02](/assets/img/2017-11-30-spring-session-with-redis/session-timeout-02.png)

Redisの状態を確認すると、新しいセッションのキーが増えていることが分かります。

```
redis:6379> keys *
1) "spring:session:sessions:expires:e82d2bde-75f7-491f-b1a6-87c2c6eacf85"
2) "spring:session:sessions:e82d2bde-75f7-491f-b1a6-87c2c6eacf85"
3) "spring:session:expirations:1512043560000"
4) "spring:session:sessions:b7f0fc5f-ccc3-4959-9698-803760bc48a8"
```

### Cookie寿命を設定した場合

セッション・タイムアウトを1分、Cookie寿命を2分に設定した時の挙動を確認します。

`HttpSession`をそのまま使う場合のCookie寿命は、`web.xml`の`<cookie-config>/<max-age>`に設定しますが、Spring Session with Redisの場合は、`CookieSerializer`インスタンスを構築することで設定します。

具体的には、以下のように設定します。

```
@EnableRedisHttpSession(maxInactiveIntervalInSeconds = 60)
public class Config {
(中略)

    @Bean
    public CookieSerializer cookieSerializer() {
        DefaultCookieSerializer serializer = new DefaultCookieSerializer();
        serializer.setCookieMaxAge(120);
        return serializer;
    }
}
```

詳細は [Spring Session - Custom Cookie](https://docs.spring.io/spring-session/docs/current/reference/html5/guides/custom-cookie.html) をご覧ください。

修正したら、先程と同様にRedisを起動して、Webアプリケーションを起動します。起動して [http://localhost:8080/](http://localhost:8080/) にアクセスすると、`count=1`が表示されます。この時の`Set-Cookie`では`Expires`と`Max-Age`が設定されます。

![cookie maxage 01](/assets/img/2017-11-30-spring-session-with-redis/cookie-maxage-01.png)

1分以内に同様にアクセスすると、カウントアップされ続けます。

![cookie maxage 02](/assets/img/2017-11-30-spring-session-with-redis/cookie-maxage-02.png)

Webブラウザを更新し続けていると、最初のアクセスから2分経過後に`count=1`に戻ります。

![cookie maxage 03](/assets/img/2017-11-30-spring-session-with-redis/cookie-maxage-03.png)

この時のRedisを確認すると、最初のセッション・キーと2回目のセッション・キーの両方が存在します。最初のセッション・キーはこの時点で消滅していないためです。1分ほど放置すると、最初のセッション・キーは消滅します。

```
redis:6379> keys *
1) "spring:session:sessions:expires:e9e0bb2a-c003-468a-b99d-ab5fcfae97d7"
2) "spring:session:sessions:expires:cd116f8e-ed1f-478a-8774-42c5cb4fbbe5"
3) "spring:session:expirations:1512044820000"
4) "spring:session:sessions:cd116f8e-ed1f-478a-8774-42c5cb4fbbe5"
5) "spring:session:sessions:e9e0bb2a-c003-468a-b99d-ab5fcfae97d7"
```

## おわりに

Redisと連携した時のセッション管理がどのように行われるのかが整理できました。次はSpring Securityを食い込んだ時のセッション管理か、Spring Securityによるサインアップかな。

## Link

- Author
    - [u6k.Blog()](https://blog.u6k.me/)
    - [u6k - GitHub](https://github.com/u6k)
    - [u6k_yu1 \| Twitter](https://twitter.com/u6k_yu1)
- Source
    - [2017-11-30-spring-session-with-redis.md](https://github.com/u6k/blog/blob/master/_posts/2017-11-30-spring-session-with-redis.md)
