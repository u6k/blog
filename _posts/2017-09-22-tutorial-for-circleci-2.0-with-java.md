---
layout: single
title: "CircleCI 2.0 + Javaのチュートリアル"
tags:
  - "CircleCI"
  - "Gradle"
  - "Java"
date: 2017-09-23 07:00:00+09:00
---

TODO: 整理する。

Using the CircleCI Command Line Interface (CLI) - CircleCI https://circleci.com/docs/2.0/local-jobs/#circleci-command-line-interface-cli-overview

```
curl -o /usr/local/bin/circleci https://circle-downloads.s3.amazonaws.com/releases/build_agent_wrapper/circleci && chmod +x /usr/local/bin/circleci
```

`/usr/local/bin/` に出力する説明だけど、Docker for Windowsではこのフォルダは存在しない。 `$PATH` を見ると `$HOME/bin` が通っていることが分かる。

```
$ mkdir $HOME/bin
```

```
curl -o $HOME/bin/circleci https://circle-downloads.s3.amazonaws.com/releases/build_agent_wrapper/circleci && chmod +x $HOME/bin/circleci
```

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

ビルドを試すため、Gradleプロジェクトを作成する。

まず、Gradleラッパーを作成する。

```
$ docker run --rm -it -v $(pwd):/var/my-app gradle gradle -p /var/my-app wrapper
```

Gradleプロジェクトを作成する。

```
$ ./gradlew init
```

`settings.gradle`を変更する。

```
$ cat settings.gradle
rootProject.name = 'hello'
```

`build.gradle`を変更する。

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

`Hello.java`を作成する。

```
$ cat src/main/java/Hello.java
public class Hello {
    public static void main(String[] args) {
        System.out.println("hello");
    }
}
```

動作確認をします。

```
$ ./gradlew run

> Task :run
hello


BUILD SUCCESSFUL in 1s
2 actionable tasks: 2 executed
```

CircleCI 2.0の設定ファイルを作成します。

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

ローカルPCでビルドを実行します。

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
