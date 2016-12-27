---
layout: post
title: "Dropwizard入門"
tags:
  - "Dropwizard"
date: 2015-02-19 20:00:00+09:00
---

Dropwizardの練習として、"Hello, {name}!"を出力するだけのDropwizardアプリを作成します。

# Dropwizardとは

ココらへんを参照。

- [Getting Started | Dropwizard](http://dropwizard.io/getting-started.html)
- [いますぐ採用すべきJavaフレームワークDropWizard(その１) - Qiita](http://qiita.com/ko2ic/items/cfe5b2f4593b705f9463)
- [[Java] 今年流行るかもしれないDropwizardフレームワークを使ってみる ｜ Developers.IO](http://dev.classmethod.jp/server-side/java/dropwizard/)

Dropwizardの根底にあるThe Twelve-Factor Appについては以下を参照。

- [The Twelve-Factor App（日本語訳）](http://twelve-factor-ja.herokuapp.com/)

<!-- more -->

# 前提

- Java SDK 8
	- Java SDK 7系でも問題無いはず。

```
$ java -version
java version "1.8.0_25"
Java(TM) SE Runtime Environment (build 1.8.0_25-b17)
Java HotSpot(TM) 64-Bit Server VM (build 25.25-b02, mixed mode)
```

```
$ javac -version
javac 1.8.0_25
```

- Maven 3
	- Maven 2系でも問題無いはず。

```
$ mvn --version
Apache Maven 3.1.1 (0728685237757ffbf44136acec0402957f723d9a; 2013-09-18 00:22:22+0900)
Maven home: /usr/local/Cellar/maven31/3.1.1/libexec
Java version: 1.8.0_25, vendor: Oracle Corporation
Java home: /Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home/jre
Default locale: ja_JP, platform encoding: UTF-8
OS name: "mac os x", version: "10.10.2", arch: "x86_64", family: "mac"
```

- コマンドラインとテキストエディタで作業できるように説明しますが、Eclipseでももちろん作業可能です。
- [Getting Started | Dropwizard](http://dropwizard.io/getting-started.html)に概ね沿って作業しますが、勉強のためところどころ自分用に変えています。
- 作成したソースコードは、[u6k/sample-dropwizard at 0.1.0](https://github.com/u6k/sample-dropwizard/tree/0.1.0)で参照できます。

# Mavenプロジェクトを作成

シンプルなMavenプロジェクトを作成します。

```
$ mvn -B archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DgroupId=jp.gr.java_conf.u6k.sample_dropwizard -DartifactId=sample_dropwizard
```

`-DgroupId`と`-DartifactId`を、自分のプロジェクト用に読み替えてください。

Eclipseを使用している場合、シンプルプロジェクトを作れば良いです。

- 参考
	- [Maven – Maven Getting Started Guide](http://maven.apache.org/guides/getting-started/)

プロジェクトが作成できたことを確認するため、作成したプロジェクトフォルダに移動して以下のコマンドを実行します。

```
$ mvn compile
```

"BUILD SUCCESS"と出力されて"target"フォルダに成果物が生成されたら、成功です。

Gitを使用している場合、プロジェクトフォルダに".gitignore"ファイルを作成して、"target"フォルダを無視すると良いです。Eclipseプロジェクトを作成する場合、それも無視するようにすると良いです。

```txt:.gitignore
/target/
.project
.classpath
.settings
```

## Eclipseプロジェクトを作成

`mvn`コマンドで作成したけどEclipseで作業を行いたい場合、以下のコマンドを実行することでEclipseプロジェクトファイルを生成します。

```
$ mvn eclipse:eclipse
```

# "pom.xml"を編集

Dropwizardのバージョンを定義します。

使用可能なバージョンは、[Maven Repository: io.dropwizard » dropwizard-core](http://mvnrepository.com/artifact/io.dropwizard/dropwizard-core)で確認できます。2015/2/18時点では"0.8.0-rc2"が最新でしたが、安定バージョンを使用したいので"0.7.1"を記述しました。

```xml:pom.xml
<properties>
    <dropwizard.version>0.7.1</dropwizard.version>
</properties>
```

"dropwizard-core"を依存ライブラリに追加します。

```xml:pom.xml
<dependencies>
    <dependency>
        <groupId>io.dropwizard</groupId>
        <artifactId>dropwizard-core</artifactId>
        <version>${dropwizard.version}</version>
    </dependency>
</dependencies>
```

全体的にはこんな感じ。

```xml:pom.xml
<?xml version="1.0" encoding="UTF-8"?>
<project
    xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>jp.gr.java_conf.u6k.sample_dropwizard</groupId>
    <artifactId>sample_dropwizard</artifactId>
    <packaging>jar</packaging>
    <version>0.0.1-SNAPSHOT</version>
    <name>sample_dropwizard</name>
    <properties>
        <dropwizard.version>0.7.1</dropwizard.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>io.dropwizard</groupId>
            <artifactId>dropwizard-core</artifactId>
            <version>${dropwizard.version}</version>
        </dependency>
    </dependencies>
</project>
```

## NOTE: "AppTest.java"がコンパイルエラー

`<dependencies>`にもともと定義されていたjunit 3.x系の記述を削除すると、"src/test/java/**/AppTest.java"のコンパイルがエラーになります。

さっくり"AppTest.java"を削除するか、junit 4.x系を追加してコードを修正すると良いです。

# Configurationクラス

YAMLを読み込むConfigurationクラスを作成します。

YAMLには文字列テンプレートを設定することとします。なので、Configurationクラスではその設定を読み込みます。

```java:HelloConfiguration.java
import io.dropwizard.Configuration;
import org.hibernate.validator.constraints.NotEmpty;
import com.fasterxml.jackson.annotation.JsonProperty;

public class HelloConfiguration extends Configuration {

    @NotEmpty
    private String _template;

    @JsonProperty
    public String getTemplate() {
        return _template;
    }

    @JsonProperty
    public void setTemplate(String template) {
        _template = template;
    }

}
```

YAMLファイルを作成します。

```yml:hello.yml
template: "Hello, %s!"

# use the simple server factory if you only want to run on a single port

server:
  applicationConnectors:
    - type: http
      port: 18080
  adminConnectors:
    - type: http
      port: 18081

# logging settings.
logging:

  # the default level of all loggers. Can be OFF, ERROR, WARN, INFO, DEBUG, TRACE, or ALL.
  level: DEBUG

  appenders:
    - type: console
      timeZone: JST
```

- 参考
	- [YAML - Wikipedia](http://ja.wikipedia.org/wiki/YAML)

# Resourceクラス

URIにマッピングされるResourceクラスを作成します。

"/hello"というパスに対するGETリクエストを処理します。"name"クエリパラメータを受け取り、文字列テンプレートを使用して変換し、JSONを返します。

```java:HelloResource.java
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import com.codahale.metrics.annotation.Timed;

@Path("/hello")
@Produces(MediaType.APPLICATION_JSON)
public class HelloResource {

    private String _template;

    public HelloResource(String template) {
        _template = template;
    }

    @GET
    @Timed
    public Hello say(@QueryParam("name") String name) {
        String message = String.format(_template, name);
        Hello hello = new Hello(message);

        return hello;
    }

}
```

# Representationクラス

Resourceクラスが返す処理結果であるRepresentationクラスを作成します。

先ほど作成した"HelloResource#say()"が返すクラスです。文字列テンプレートの変換結果を保持します。

```java:Hello.java
import com.fasterxml.jackson.annotation.JsonProperty;

public class Hello {

    private String _message;

    public Hello() {
    }

    public Hello(String message) {
        _message = message;
    }

    @JsonProperty
    public String getMessage() {
        return _message;
    }

}
```

# HealthCheckクラス

ヘルスチェックを行うHealthCheckクラスを作成します。ヘルスチェックは無くても問題ありませんので、スキップしても良いです(起動時に警告は出力されますが)。

メソッドが呼ばれたら、単純に正常終了を返します。

```java:AliveHealthCheck.java
import com.codahale.metrics.health.HealthCheck;

public class AliveHealthCheck extends HealthCheck {

    @Override
    protected Result check() throws Exception {
        return Result.healthy();
    }

}
```

# Applicationクラス

アプリのエントリーポイントであるApplicationクラスを作成します。

HelloResourceクラス、AliveHealthCheckクラスを処理できるように登録します。AliveHealthCheckクラスを作成していない場合、該当コードを削除してください。

```java:HelloApplication.java
import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;

public class HelloApplication extends Application<HelloConfiguration> {

    public static void main(String[] args) throws Exception {
        new HelloApplication().run(args);
    }

    @Override
    public String getName() {
        return "sample-dropwizard";
    }

    @Override
    public void initialize(Bootstrap<HelloConfiguration> bootstrap) {
    }

    @Override
    public void run(HelloConfiguration config, Environment env) throws Exception {
        env.jersey().register(new HelloResource(config.getTemplate()));
        env.healthChecks().register("alive", new AliveHealthCheck());
    }

}
```

# 再び"pom.xml"を編集

Fatjarを作成するため、"maven-shade-plugin"を追加します。

```xml:pom.xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-shade-plugin</artifactId>
            <version>2.3</version>
            <configuration>
                <createDependencyReducedPom>true</createDependencyReducedPom>
                <filters>
                    <filter>
                        <artifact>*:*</artifact>
                        <excludes>
                            <exclude>META-INF/*.SF</exclude>
                            <exclude>META-INF/*.DSA</exclude>
                            <exclude>META-INF/*.RSA</exclude>
                        </excludes>
                    </filter>
                </filters>
            </configuration>
            <executions>
                <execution>
                    <phase>package</phase>
                    <goals>
                        <goal>shade</goal>
                    </goals>
                    <configuration>
                        <transformers>
                            <transformer implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer" />
                            <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                <mainClass>jp.gr.java_conf.u6k.sample_dropwizard.HelloApplication</mainClass>
                            </transformer>
                        </transformers>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

- 参考
	- [Apache Maven Shade Plugin - Usage](http://maven.apache.org/plugins/maven-shade-plugin/usage.html)

`<main-class>`を、先ほど作成したApplicationクラスの名前にします。

また、jarファイルにバージョン情報を記述するため、"maven-jar-plugin"を追加します。

```xml:pom.xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>2.5</version>
    <configuration>
        <archive>
            <manifest>
                <addDefaultImplementationEntries>true</addDefaultImplementationEntries>
            </manifest>
        </archive>
    </configuration>
</plugin>
```

- 参考
	- [Apache Maven JAR Plugin - Plugin Documentation](http://maven.apache.org/plugins/maven-jar-plugin/plugin-info.html)

## NOTE: Javaバージョン、ソースコードの文字エンコーディングを指定

省略しても(たぶん)問題ありませんが、明記したほうが環境差異を無くすことができます。

`<properties>`に以下を追加します。

```xml:pom.xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <java.version>1.8</java.version>
</properties>
```

`<plugins>`に"maven-compiler-plugin"を追加します。

```xml:pom.xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.2</version>
    <configuration>
        <source>${java.version}</source>
        <target>${java.version}</target>
    </configuration>
</plugin>
```

`mvn package`で「指定したJavaバージョンは認識できない」的なエラーが表示された場合、MavenがJavaSDKを正しく認識できていない可能性があります。その場合、`JAVA_HOME`環境変数や`PATH`環境変数を疑うと良いです。

- 参考
	- [Maven Compiler plugin - Plugin Documentation](http://maven.apache.org/plugins/maven-compiler-plugin/plugin-info.html)
	- [Maven – Frequently Asked Technical Questions](http://maven.apache.org/general.html#encoding-warning)

## "pom.xml"全体

最終的に、"pom.xml"全体では以下のようになります。

```xml:pom.xml
<?xml version="1.0" encoding="UTF-8"?>
<project
    xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>jp.gr.java_conf.u6k.sample_dropwizard</groupId>
    <artifactId>sample_dropwizard</artifactId>
    <packaging>jar</packaging>
    <version>0.0.1-SNAPSHOT</version>
    <name>sample_dropwizard</name>
    <properties>
        <dropwizard.version>0.7.1</dropwizard.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <java.version>1.8</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>io.dropwizard</groupId>
            <artifactId>dropwizard-core</artifactId>
            <version>${dropwizard.version}</version>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>2.3</version>
                <configuration>
                    <createDependencyReducedPom>true</createDependencyReducedPom>
                    <filters>
                        <filter>
                            <artifact>*:*</artifact>
                            <excludes>
                                <exclude>META-INF/*.SF</exclude>
                                <exclude>META-INF/*.DSA</exclude>
                                <exclude>META-INF/*.RSA</exclude>
                            </excludes>
                        </filter>
                    </filters>
                </configuration>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <transformers>
                                <transformer implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer" />
                                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                    <mainClass>jp.gr.java_conf.u6k.sample_dropwizard.HelloApplication</mainClass>
                                </transformer>
                            </transformers>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <version>2.5</version>
                <configuration>
                    <archive>
                        <manifest>
                            <addDefaultImplementationEntries>true</addDefaultImplementationEntries>
                        </manifest>
                    </archive>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.2</version>
                <configuration>
                    <source>${java.version}</source>
                    <target>${java.version}</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

# ビルド

以下のコマンドでビルドします。

```
$ mvn clean package
```

"target"フォルダにjarファイルが作成されます。正しく作成されたか確認するため、以下のコマンドを実行します。

```
$ java -jar target/sample_dropwizard-0.0.1-SNAPSHOT.jar
usage: java -jar sample_dropwizard-0.0.1-SNAPSHOT.jar
       [-h] [-v] {server,check} ...

positional arguments:
  {server,check}         available commands

optional arguments:
  -h, --help             show this help message and exit
  -v, --version          show the application version and exit```
```

usageが表示されたら、成功です。

# 実行

パラメータとYAMLファイルを指定して実行します。

```
$ java -jar target/sample_dropwizard-0.0.1-SNAPSHOT.jar server hello.yml
```

起動ログが表示され、待機状態になります。

動作を確認するため、Webブラウザなどで`http://localhost:18080/hello?name=hoge`にアクセスします。正常に動作していれば、以下のように返ってきます。

```
{"message":"Hello, hoge!"}
```

ヘルスチェックは、`http://localhost:18081/healthcheck`にアクセスします(ポート番号が管理者用であることに注意)。正常に動作していれば、以下のように返ってきます。

```
{"alive":{"healthy":true},"deadlocks":{"healthy":true}}
```

# 停止

停止するには、`Ctrl + C`を押します。

# バージョン表示

usageにも表示されていますが、`-v`オプションを指定するとバージョンを表示することができます。

```
$ java -jar target/sample_dropwizard-0.0.1-SNAPSHOT.jar -v
0.0.1-SNAPSHOT
```

"pom.xml"に"maven-jar-plugin"を設定していないと、以下のように出力されます。

```
$ java -jar target/sample_dropwizard-0.0.1-SNAPSHOT.jar -v
No application version detected. Add a Implementation-Version entry to your JAR's manifest to enable this.
```

# おわりに

個人でツールを作成するときのフレームワークとして良いと思っています。今後、少しずつ機能を調べていきます。似たようなコンセプトを持つ[Spring Boot](http://projects.spring.io/spring-boot/)というフレームワークもあるので、いずれこちらも調べてみようかと。
