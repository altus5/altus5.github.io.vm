#!/bin/sh
#
# jekyll の準備
# =============
# jekyll の準備ができていない場合に、my_awesome_site のテンプレートを
# jekyll ディレクトリにコピーして、準備を整える。  

basedir=$(cd $(dirname $0) && pwd)

if [ ! -e /srv/jekyll/bin/automated ]; then
  echo 'Setup jekyll...'
  cp -apr /srv/my_awesome_site/. /srv/jekyll/
fi

