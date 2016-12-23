#!/bin/sh
#
# jekyll の準備
# =============
# jekyll の準備ができていない場合に、my_awesome_site のテンプレートを
# jekyll ディレクトリにコピーして、準備を整える。  

basedir=$(cd $(dirname $0) && pwd)

# ホストOSに共有する必要のないディレクトリは、
# my_awesome_site のディレクトリを内部マウントする
mount /srv/my_awesome_site/node_modules /srv/jekyll/node_modules
mount /srv/my_awesome_site/.asset-cache /srv/jekyll/.asset-cache
chown -R jekyll:jekyll node_modules .asset-cache

# jekyll ディレクトリのセットアップ
if [ ! -e /srv/jekyll/bin/automated ]; then
  echo 'Setup jekyll...'
  cp -apr /srv/my_awesome_site/. /srv/jekyll/
fi

