#!/bin/sh
#
# jekyll serve の起動
# ===================
# まだ、kicksterのsetupがされていなかったら、
# my_awesome_site のテンプレートを jekyll ディレクトリにコピーする。
# serve は、--watch 付きで。

basedir=$(cd $(dirname $0) && pwd)

if [ ! -e /srv/jekyll/bin/automated ]; then
  cp -apr /srv/my_awesome_site/. /srv/jekyll/
fi

cd /srv/jekyll

# データコンテナのマウントポイントは、毎回権限を再設定する
chown -R jekyll:jekyll .asset-cache node_modules

bundle exec jekyll serve --watch --incremental --force_polling
