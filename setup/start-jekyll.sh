#!/bin/sh
#
# jekyll serve の起動
# ===================
# まだ、kicksterのsetupがされていなかったら、
# my_awesome_site のテンプレートを jekyll ディレクトリにコピーする。
# serve は、--watch 付きで。

basedir=$(cd $(dirname $0) && pwd)

if [ ! -e /srv/jekyll/bin/automated ]; then
  cp -pr /srv/my_awesome_site/* /srv/jekyll/
fi

cd /srv/jekyll
bundle exec jekyll serve --watch --incremental --force_polling
