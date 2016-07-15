---
title: "Scala学習のため、DockerでScala動作確認環境を構築しました"
tags: ["Scala", "Docker"]
date: 2016-07-15 07:00:00+09:00
published: false
parmalink: "hello-scala-docker"
postID:
---

長い間、主にJavaを使ってきましたが、もっと軽く簡単にコードを書けないかなと思い、重い腰を上げて新しい言語を学ぼうと考えました。以前に少し調べたPlayFrameworkがScalaを扱えることを思い出し、他言語も合わせて考えてみましたが、Scalaを学習対象にしました。学習するために動作確認環境が必要となるため、動作確認環境を構築しました。

<!-- more -->

# 前提

Scalaとは
簡単に環境の再現ができるDocker上に構築する
普通はsbtを使うと思うが、最終的にはPlayFrameworkでWebアプリケーションを作成したいので、Typesafe Activatorを使用する。
CoreOS環境で作業をしたが、Dockerが動作すればホストOSは問わないはず。

# できあがる環境

JavaSDK 8
Typesafe Activator v1.3.10
Scala 2.11.7
vim

# 環境構築手順

# ScalaでHello, world!

# リンク
