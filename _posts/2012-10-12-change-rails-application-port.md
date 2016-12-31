---
layout: single
title: "Railsアプリのポート番号を変更"
tags:
  - "Ruby"
  - "Ruby on Rails"
date: 2012-10-12 22:03:00+09:00
redirect_from:
  - /2012/10/change-rails-port.html
---

Ruby on Railsアプリは、デフォルトでは3000番ポートを使用します。既に3000番ポートを使用している場合などは起動に失敗しますが、使用ポートを変更する場合、`config/root.rb`に以下を追記します(4000番ポートに変更する場合)。

```
require 'rails/commands/server'
module Rails
  class Server
    def default_options
      super.merge({
        :Port =&gt; 4000
      })
    end
  end
end
```

# 参考ページ

* [【Rails3】デフォルトポートを変更する - ふわふわRuby on Rails](http://d.hatena.ne.jp/zucay/20111121/1321856764)
