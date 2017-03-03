#!/bin/sh
#
# jekyll の準備
# =============
# jekyll の準備ができていない場合に、my_awesome_site のテンプレートを
# jekyll ディレクトリにコピーして、準備を整える。  

basedir=$(cd $(dirname $0) && pwd)

# ホストOSに共有する必要のないディレクトリは、
# my_awesome_site のディレクトリを内部マウントする
mkdir -p /srv/jekyll/node_modules
mkdir -p /srv/jekyll/.asset-cache
mount /srv/my_awesome_site/node_modules /srv/jekyll/node_modules
mount /srv/my_awesome_site/.asset-cache /srv/jekyll/.asset-cache
chown -R jekyll:jekyll node_modules .asset-cache

# jekyll ディレクトリのセットアップ
if [ ! -e /srv/jekyll/bin/automated ]; then
  echo 'Setup jekyll...'
  rsync -avq /srv/my_awesome_site/ /srv/jekyll/ --exclude node_modules --exclude .asset-cache
  su - jekyll -c 'cd /srv/jekyll && npm install'
fi

su - jekyll -c 'cd /srv/jekyll && $(npm bin)/gulp'
