#!/bin/sh
#
# jekyll serve の起動
# ===================
# jekyll serveの前に、jekyll build を実行して、
# コンテナ起動時にターミナルにビルド時のログが出力されるようにする。

basedir=$(cd $(dirname $0) && pwd)

/srv/setup/init-jekyll.sh

cd /srv/jekyll

# ホストOSに共有する必要のないディレクトリは、
# my_awesome_site のディレクトリを内部マウントする
mount /srv/my_awesome_site/node_modules /srv/jekyll/node_modules
mount /srv/my_awesome_site/.asset-cache /srv/jekyll/.asset-cache
chown -R jekyll:jekyll node_modules .asset-cache
echo 'Build jekyll...'
jekyll build

echo 'Start jekyll serve'
jekyll serve --watch --incremental --force_polling
