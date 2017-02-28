#!/bin/bash
#
# VagrantでのOS起動時の自動実行スクリプト
# =======================================

basedir=$(cd $(dirname $0) && pwd)
if [ -e $basedir/setenv.sh ]; then
  . $basedir/setenv.sh
fi

set -e
trap 'echo "ERROR $0" 1>&2' ERR

# centos7の場合、eth1に固定IPが割り振られないことがあり、
# その場合は、network restart が必要で、dockerも、再起動が必要
service network restart
service docker restart

cd /vagrant/
# 最初に build を実行して、エラーがあるかどうかをターミナルにログ出力させる
docker-compose run jekyll_boot /srv/bin/init-jekyll.sh
# dockerコンテナ起動
docker-compose up -d

echo "SUCCESS - $0"
