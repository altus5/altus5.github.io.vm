#!/bin/bash
#
# VagrantでのOS起動時の自動実行スクリプト
# =====================================

basedir=$(cd $(dirname $0) && pwd)
if [ -e $basedir/setenv.sh ]; then
  source $basedir/setenv.sh
fi

# CoreOSの自動アップデートによるrebootを抑止する
systemctl stop update-engine

cd /vagrant

# 最初に build を実行して、エラーがあるかどうかをターミナルにログ出力させる
docker-compose run jekyll_boot /srv/setup/init-jekyll.sh
# dockerコンテナ起動
docker-compose up -d

