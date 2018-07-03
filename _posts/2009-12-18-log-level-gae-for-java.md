---
layout: single
title: "GAE/jのログレベル"
tags:
  - "Google App Engine"
  - "ログ"
date: 2009-12-18 00:00:00+09:00
redirect_from:
  - /2009/12/gaej.html
---

`java.util.logging`のログレベルと、GAE/jのログレベルの対応が分からなかったので、調べました。

## ログレベル

|java.util.logging|GAE/j|
|---|---|
|CONFIG|Debug|
|FINE|(出力されない)|
|FINER|(出力されない)|
|FINEST|(出力されない)|
|INFO|info|
|SEVERE|Error|
|WARNING|Warning|
