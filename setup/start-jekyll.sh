#!/bin/sh
#
# jekyll serve の起動
# ===================
# jekyll serveの前に、jekyll build を実行して、
# コンテナ起動時にターミナルにビルド時のログが出力されるようにする。

basedir=$(cd $(dirname $0) && pwd)

/srv/setup/init-jekyll.sh

cd /srv/jekyll

echo 'Build jekyll...'
jekyll build

echo 'Start jekyll serve'
jekyll serve
