#!/bin/bash
#
# VagrantでのOS起動時の自動実行スクリプト
# =====================================

basedir=$(cd $(dirname $0) && pwd)
if [ -e $basedir/setenv.sh ]; then
  source $basedir/setenv.sh
fi

cd /vagrant

# dockerコンテナ起動
docker-compose up -d

