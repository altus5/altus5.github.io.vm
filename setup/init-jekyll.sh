#!/bin/sh
#
# jekyll の準備
# =============
# jekyll の準備ができていない場合に、my_awesome_site のテンプレートを
# jekyll ディレクトリにコピーして、準備を整える。  
# jekyll build は、コンテナ起動時に実行して、ターミナルにビルド時のログが
# 出力されるようにする。

basedir=$(cd $(dirname $0) && pwd)

if [ ! -e /srv/jekyll/bin/automated ]; then
  echo 'Setup jekyll...'
  cp -apr /srv/my_awesome_site/. /srv/jekyll/
fi

cd /srv/jekyll

# データコンテナのマウントポイントは、毎回権限を再設定する
chown -R jekyll:jekyll .asset-cache node_modules
echo 'Build jekyll...'
jekyll build
