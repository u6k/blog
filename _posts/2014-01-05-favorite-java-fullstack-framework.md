---
layout: single
title: "個人的に気になっているJavaフルスタック(と言われている)フレームワーク"
tags:
  - "Grails"
  - "Java"
  - "JavaEE"
  - "Play Framework"
  - "Spring Framework"
date: 2014-01-05 18:35:00+09:00
redirect_from:
  - /2014/01/java.html
---

個人的に軽く何か作りたいなぁ、今はどんなフレームワークがあるのかな？と思って調べてみました。調べただけでまだ使ってはいません。

## 今注目されているフレームワークは？

EJB 2.xに嫌気が差して各レイヤー毎のフレームワークが生まれて、それらの特徴を取り込んでEJB 3.1などが出てきたみたいですが、現在のデファクトスタンダードなJavaフレームワーク、またはフレームワークの組み合わせというものが無いように思います。その中でも、自分の心にヒットしたプロダクトを以下に並べてみます。

* JavaEE 6 (JBoss Seam)
    * [Java EE 6 環境の構築 （1/4）：CodeZine](http://codezine.jp/article/detail/5698)
    * [Webの上のポジョをステートフルにつなぐJBoss Seam (1/3) - @IT](http://www.atmarkit.co.jp/fjava/special/jbossseam/jbossseam_1.html)
* Spring Framework
    * [第1回 はじめてのSpring framework ｜ Developers.IO](http://dev.classmethod.jp/server-side/java/spring-firstcontact/)
* Grails
    * [Grailsの基本を知ろう （1/6）：CodeZine](http://codezine.jp/article/detail/3809)
* Play Framework
    * [「Javaの常識を変えるPlay framework入門」最新記事一覧 - ITmedia Keywords](http://www.atmarkit.co.jp/ait/kw/play_java.html)

## JavaEE 6 (JBoss Seam)

J2EE、特にEJB 2.xは様々な設定ファイルやインターフェイス・ファイルで苦しい思いをしましたが、進化してかなり軽量化された模様です。とは言えなんだか微妙に痒いところに手が届かない模様。そういう隙間を埋めるためにJBoss Seamがある模様です。

なお、JavaEE 7がリリースされている模様。

## Spring Framework

Spring自体はDIコンテナーですが、コンポーネントを組み合わせることでフルスタックフレームワークといえる状態に構築できるみたいです。

## Grails

JavaそのものではなくGroovyをベースとした、Ruby on Railsライクなフレームワークのようです。warファイルに出力できるので、Servletコンテナーで動作できる模様。

## Play Framework

JavaまたはScalaで書くフレームワーク。Ruby on Railsライクではないですが影響を強く受けている模様です。

## 結局…

とりあえずここまで絞りました。あくまで「個人的に」なので、ここからは好き嫌いで使ってみたいと思います。とりあえずPlayかGrailsかなぁ…
