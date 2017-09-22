---
layout: single
title: "CircleCI 2.0 + Javaのチュートリアル"
tags:
  - "CircleCI"
  - "Gradle"
  - "Java"
date: 2017-09-23 07:00:00+09:00
---

単純なJavaアプリケーション(Hello, worldレベル)を、ローカルPCでCircleCI 2.0 CLIを使ってビルドするチュートリアルです。

# 前提

- Docker
    - Docker for Windowsで実施しました。他環境では、手順を適宜読み替えてください。

```
$ docker version
 Version:      17.03.1-ce
 API version:  1.27
 Go version:   go1.7.5
 Git commit:   c6d412e
 Built:        Tue Mar 28 00:40:02 2017
 OS/Arch:      windows/amd64

Server:
 Version:      17.06.2-ce
 API version:  1.30 (minimum version 1.12)
 Go version:   go1.8.3
 Git commit:   cec0b72
 Built:        Tue Sep  5 19:59:19 2017
 OS/Arch:      linux/amd64
 Experimental: false
```

- Gradle
    - 未インストールでも、Gradleイメージを使用するので問題ありません。

```
$ gradle --version

------------------------------------------------------------
Gradle 4.1
------------------------------------------------------------

Build time:   2017-08-07 14:38:48 UTC
Revision:     941559e020f6c357ebb08d5c67acdb858a3defc2

Groovy:       2.4.11
Ant:          Apache Ant(TM) version 1.9.6 compiled on June 29 2015
JVM:          1.8.0_141 (Oracle Corporation 25.141-b15)
OS:           Linux 4.4.86-boot2docker amd64
```

# 手順

## CircleCI CLIをインストール

[Using the CircleCI Command Line Interface (CLI) - CircleCI](https://circleci.com/docs/2.0/local-jobs/#circleci-command-line-interface-cli-overview)に、インストール手順が書いてあります。

```
$ curl -o /usr/local/bin/circleci https://circle-downloads.s3.amazonaws.com/releases/build_agent_wrapper/circleci && chmod +x /usr/local/bin/circleci
```

`/usr/local/bin/`に出力する説明ですが、Docker for Windowsではこのフォルダは存在しません。`$PATH`を見ると`$HOME/bin`が通っていることが分かりますので、`$HOME/bin`を作成した上で、以下のように実行します。

```
$ curl -o $HOME/bin/circleci https://circle-downloads.s3.amazonaws.com/releases/build_agent_wrapper/circleci && chmod +x $HOME/bin/circleci
```

動作確認のため、ヘルプを表示してみます。初回のみ、DockerイメージのPullが実行されます。

```
$ circleci help
Unable to find image 'circleci/picard@sha256:678fed6cf44e2341ae1cc57966871b03031c2636c87198dbd067cce7afa8dcbb' locally
sha256:678fed6cf44e2341ae1cc57966871b03031c2636c87198dbd067cce7afa8dcbb: Pulling from circleci/picard
90f4dba627d6: Pull complete
91846fb0d5cc: Pull complete
06d74f32ea0e: Pull complete
52c8a4ef6260: Pull complete
96859c268820: Pull complete
f3fce07f01bd: Pull complete
Digest: sha256:678fed6cf44e2341ae1cc57966871b03031c2636c87198dbd067cce7afa8dcbb
Status: Downloaded newer image for circleci/picard@sha256:678fed6cf44e2341ae1cc57966871b03031c2636c87198dbd067cce7afa8dcbb
The CLI tool to be used in CircleCI.

Usage:
  circleci [flags]
  circleci [command]

Available Commands:
  build       run a full build locally
  config      validate and update configuration files
  help        Help about any command
  step        execute steps
  tests       collect and split files with tests
  version     output version info

Flags:
  -c, --config string   config file (default is .circleci/config.yml)
  -h, --help            help for circleci
      --taskId string   TaskID
      --verbose         emit verbose logging output

Use "circleci [command] --help" for more information about a command.
```

## Javaアプリケーションを作成

ビルドを試すため、GradleプロジェクトのJavaアプリケーションを作成します。

まず、Gradleラッパーを作成します。

```
$ docker run --rm -it -v $(pwd):/var/my-app gradle gradle -p /var/my-app wrapper
```

Gradleプロジェクトを作成します。

```
$ ./gradlew init
```

`settings.gradle`を変更します。

```
$ cat settings.gradle
rootProject.name = 'hello'
```

`build.gradle`を変更します。

```
$ cat build.gradle
apply plugin: 'java'
apply plugin: 'application'

repositories {
    jcenter()
}

mainClassName = 'Hello'

dependencies {
    compile 'org.slf4j:slf4j-api:1.7.25'
    testCompile 'junit:junit:4.12'
}
```

`Hello.java`を作成します。

```
$ cat src/main/java/Hello.java
public class Hello {
    public static void main(String[] args) {
        System.out.println("hello");
    }
}
```

動作確認をします。`hello`という文字列が表示されます。

```
$ ./gradlew run

> Task :run
hello


BUILD SUCCESSFUL in 1s
2 actionable tasks: 2 executed
```

## CircleCI設定ファイルを作成

CircleCI 2.0の設定ファイルを作成します。とりあえず動作確認を行うだけの最小設定です。

```
$ cat .circleci/config.yml
version: 2
jobs:
    build:
        docker:
            - image: circleci/openjdk:8-jdk
        working_directory: ~/repo
        steps:
            - checkout
            - run: ./gradlew run
```

## ローカルPCでビルド

ローカルPCでビルドを実行します。初回のみ、DockerイメージのPullが実行されます(長い)。

```
$ circleci build

====>> Spin up Environment
Build-agent version 0.0.4233-c9a1216 (2017-09-21T04:41:54+0000)
Starting container circleci/openjdk:8-jdk
  using image circleci/openjdk@sha256:4e3319daf38eb0464066e1e6413980b74e11a5253cd5038a6e2f415b07fee3fa

Using build environment variables:
  BASH_ENV=/tmp/.bash_env-localbuild-1506050141
  CI=true
  CIRCLECI=true
  CIRCLE_BRANCH=
  CIRCLE_BUILD_NUM=
  CIRCLE_ENV=/tmp/.bash_env-localbuild-1506050141
  CIRCLE_JOB=build
  CIRCLE_NODE_INDEX=0
  CIRCLE_NODE_TOTAL=1
  CIRCLE_REPOSITORY_URL=
  CIRCLE_SHA1=
  CIRCLE_WORKING_DIRECTORY=~/repo

====>> Checkout code
  #!/bin/sh
mkdir -p /home/circleci/repo && cp -r /tmp/_circleci_local_build_repo/. /home/circleci/repo
====>> ./gradlew run
  #!/bin/bash -eo pipefail
./gradlew run
Downloading https://services.gradle.org/distributions/gradle-4.1-bin.zip
................................................................
Unzipping /home/circleci/.gradle/wrapper/dists/gradle-4.1-bin/c3kp51zwwt108wc78u68yt7vs/gradle-4.1-bin.zip to /home/circleci/.gradle/wrapper/dists/gradle-4.1-bin/c3kp51zwwt108wc78u68yt7vs
Set executable permissions for: /home/circleci/.gradle/wrapper/dists/gradle-4.1-bin/c3kp51zwwt108wc78u68yt7vs/gradle-4.1/bin/gradle
Starting a Gradle Daemon (subsequent builds will be faster)
:compileJava
Download https://jcenter.bintray.com/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.pom
Download https://jcenter.bintray.com/org/slf4j/slf4j-parent/1.7.25/slf4j-parent-1.7.25.pom
Download https://jcenter.bintray.com/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar
:processResources NO-SOURCE
:classes
:run
hello

BUILD SUCCESSFUL in 46s
2 actionable tasks: 2 executed
Success!
```

無事、ビルドが成功しました。

# おわりに

ローカルPCにCircleCI CLIをインストールしてからビルドするまでの手順を簡単に説明しました。自分はSpring Bootアプリケーションをよく作るので、今度はその説明をしたいと思います。
