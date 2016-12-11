#!/bin/bash
#
# プロビジョニングのユーティリティ
# =========================

# ダウンロードファイルのキャッシュディレクトリ
DOWNLOAD_CACHE_DIR=${DOWNLOAD_CACHE_DIR:-/vagrant/.local_cache/download}

# docker imageのキャッシュディレクトリ
DOCKER_CACHE_DIR=${DOCKER_CACHE_DIR:-/vagrant/.local_cache/docker}

##
# ファイルをダウンロードする。
# 一度、ダウンロードしたファイルは、ローカルにキャッシュして、再利用する。
# 
# $1 ダウンロードURL
# $2 キャッシュにエントリーするときのファイル名
# $3 ダウンロードしたファイルを配置するパス
#
download_cache() {
  url=$1
  cache_entry_name=$2
  dist_path=$3
  cache_path=$DOWNLOAD_CACHE_DIR/$cache_entry_name
  mkdir -p $DOWNLOAD_CACHE_DIR
  
  if [ ! -e $cache_path ]; then
    echo "download $cache_path"
    curl -Ss -L $url > $cache_path
  else
    echo "download $cache_entry_name (use cache)"
  fi
  cp $cache_path $dist_path
}

docker_cache_env() {
  _docker_image_name=$1
  _docker_cache_path=$DOCKER_CACHE_DIR/$_docker_image_name.tar
  _docker_cache_path=`echo $_docker_cache_path | sed -e "s|:|/|"`
  _docker_cache_dir=`dirname $_docker_cache_path`
}

##
# docker pull してキャッシュする。
# キャッシュは、 pull したイメージを save して、キャッシュディレクトリに保存し、
# 2回目以降の pull では、キャッシュディレクトリから、 load する。
# 
# $1 docker image name
#
docker_pull_cache() {
  docker_cache_env $*
  mkdir -p $_docker_cache_dir

  if [ ! -e $_docker_cache_path ]; then
    echo "docker pull $_docker_image_name"
    docker pull $_docker_image_name
    echo "docker save $_docker_image_name > $_docker_cache_path"
    docker save $_docker_image_name > $_docker_cache_path
  else
    echo "docker load -i $_docker_cache_path"
    docker load -i $_docker_cache_path
  fi
}

docker_compose_build_cache() {
  args="$*"
  do_build=0
  for image_name in $args
  do
    docker_cache_env $image_name
    if [ ! -e $_docker_cache_path ]; then
      do_build=1
      break
    fi
  done

  if [ "1" = "$do_build" ]; then
    docker-compose build
  fi

  for image_name in $args
  do
    if [ "1" = "$do_build" ]; then
      docker_save_cache $image_name
    else
      docker_load_cache $image_name
    fi
  done
}

docker_load_cache() {
  docker_cache_env $*

  if [ -e $_docker_cache_path ]; then
    echo "docker load -i $_docker_cache_path"
    docker load -i $_docker_cache_path
  fi
}

docker_save_cache() {
  docker_cache_env $*

  if [ ! -e $_docker_cache_path ]; then
    mkdir -p $_docker_cache_dir
    echo "docker save $_docker_image_name > $_docker_cache_path"
    docker save $_docker_image_name > $_docker_cache_path
  fi
}

##
# URL が有効になるまで(200を返すまで) wait する。
# dockerコンテナで起動されるミドルウェアがアプリを起動するのを、
# 待機するなどの用途を想定する。
# 
# $1 URL
#
wait_url_ready() {
  url=$1
  echo "waiting for $url to be ready"
  while :
  do
    result=`curl -Ss -I --retry 30 --connect-timeout 30 $url | grep "200 OK" | wc -l`
    if [ "$result" = "1" ]; then
      echo "ready!"
      break
    else
      echo "retry ..."
      sleep 3
    fi
  done
  return $result
}
