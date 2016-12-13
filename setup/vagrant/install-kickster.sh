#!/bin/bash
#
# kicksterのインストール
# ======================
#

basedir=$(cd $(dirname $0) && pwd)
source $basedir/provision_utils.sh
# setenv.shがある場合は、環境変数を上書きする
if [ -e $basedir/setenv.sh ]; then
  source $basedir/setenv.sh
fi

# docker-compose のインストール
$basedir/install-docker-compose.sh

# docker image をキャッシュするために、 docker-compose の前に pull しておく
docker_pull_cache busybox:latest
docker_pull_cache jekyll/jekyll:pages

cd /vagrant
docker_compose_build_cache \
  altus5/kickster:latest \
  altus5/jekyll_data:latest
