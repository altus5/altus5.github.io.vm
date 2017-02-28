#!/bin/bash
#
# Vagrantのプロビジョンスクリプト
# ===============================

basedir=$(cd $(dirname $0) && pwd)
. $basedir/inc/provision_utils.sh

project_dir=$basedir/..

set -e
trap 'echo "ERROR $0" 1>&2' ERR

# centos7の場合、eth1に固定IPが割り振られないことがあり、
# その場合は、network restart が必要で、dockerも、再起動が必要
service network restart

echo 'docker.sh ...'
$basedir/omni/docker.sh
echo 'docker_compose.sh ...'
$basedir/omni/docker_compose.sh

echo 'load_docker_cache.sh ...'
$basedir/omni/load_docker_cache.sh

## buildする
#cd /vagrant
#docker-compose build

## vagrant ssh したときのディレクトリを /vagrant に
cat >> /home/vagrant/.bashrc <<-EOT
cd /vagrant
EOT

echo "SUCCESS - $0"
