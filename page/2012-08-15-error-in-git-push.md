---
title: "git pushで「error: RPC failed; result=55, HTTP code = 0」"
tags: "git"
date: 2012-08-15 00:00:00+09:00
published: false
parmalink: "git-pusherror-rpc-failed-result55-http"
postID: 521356891833526103
---

`git push`したら、件名のエラーが発生してpushできませんでした。ググったところ、以下のページに記載されている対応で治りました。

[git push is failed due to RPC failure (result=56)](http://flyingtomoon.com/2011/04/12/git-push-is-failed-due-to-rpc-failure-result56/)

対応方法は、以下のコマンドを実行します。

```
# git config http.postBuffer 524288000
```
