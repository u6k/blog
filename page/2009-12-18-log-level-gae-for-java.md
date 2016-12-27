---
title: "GAE/jのログレベル"
tags: ["Google App Engine", "ログ"]
date: 2009-12-18 00:00:00+09:00
published: false
parmalink: "gaej"
postID: 7310584366937244111
---

`java.util.logging`のログレベルと、GAE/jのログレベルの対応が分からなかったので、調べました。

|java.util.logging|GAE/j|
|---|---|
|CONFIG|Debug|
|FINE|(出力されない)|
|FINER|(出力されない)|
|FINEST|(出力されない)|
|INFO|info|
|SEVERE|Error|
|WARNING|Warning|
