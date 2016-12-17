#!/bin/sh
#
# jekyll serve の起動
# ===================

basedir=$(cd $(dirname $0) && pwd)

/srv/setup/init-jekyll.sh

cd /srv/jekyll
echo 'jekyll serve'
jekyll serve --watch --incremental --force_polling
