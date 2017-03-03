# kickster でセットアップした jekyll の実行環境
# ===========================================
#
# kicksterのtemplateを作成した状態をイメージにすることで、
# 実行要件を整える手間を省いて、jekyllでのサイト構築を早期に着手する。
#
# jekyll は、 /srv/jekyll のディレクトリで起動される。
# このディレクトリは、docker run のときに、ホスト側のディレクトリがマウントされる
# ことを前提とする。
# 
# kicksterは、jekyll用の最小限のテンプレートを生成するわけだが、
# ただし、kickster の初期設定が、5分くらいかかってしまって面倒なので、
# このイメージでは、あらかじめ、/srv/my_awesome_site に kicksterのsetupを
# 実行した状態で保持しておく。
# あわせて、 node install も、あらかじめ実行して、イメージの中に保持する。
# 
# docker run の初回に、my_awesome_site から、/srv/jekyll にコピーすれば、
# dockerの初回起動時間が短くなるので、kicksterの通常の使い方ではなくて、
# setup済の my_awesome_site ディレクトリをコピーして環境準備することを想定している。
#
FROM jekyll/jekyll:pages

RUN \
  df -h
RUN \
  apk --update add wget bash rsync \
    build-base ruby-dev libxml2-dev libxslt-dev readline-dev libffi-dev \
    yaml-dev zlib-dev libxml2 zlib
# pngquant のビルドに必要なモジュールを追加
RUN \
  apk --update add \
    libpng-dev file autoconf automake nasm

RUN \
  wget -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
  chmod +x /usr/local/bin/jq

RUN \
  gem install nokogiri && \
  gem install kickster && \
  gem install ffi && \
  npm install -g bower

# my_awesome_site で node install する
COPY my_awesome_site /srv/my_awesome_site/
RUN \
  chown -R jekyll:jekyll /srv && \
  cd /srv/my_awesome_site && \
  chmod +x bin/automated && \
  npm install

# my_awesome_site を kickster でセットアップする
USER jekyll
RUN \
  cd /srv && \
  kickster new my_awesome_site --force && \
  cd my_awesome_site && \
  bin/setup && \
  # CircleCI用の設定を準備したもので置き換え
  mv circle0.yml circle.yml
USER root
RUN \
  cd /srv/my_awesome_site && \
  bundle clean --force
USER jekyll
RUN \
  cd /srv/my_awesome_site && \
  jekyll build --incremental
# kicksterに加えてgulpを動かすための追加修正を行う
RUN \
  cd /srv/my_awesome_site && \
  # .jekyll-metadata も .gitignore に追加
  echo '/.jekyll-metadata' >> .gitignore && \
  # gulpを使うので、node_modules も exclude に追加
  sed -i -e 's|^\s*-\s*vendor|&\n  - node_modules|' _config.yml && \
  sed -i -e 's|^\s*-\s*vendor|&\n  - package.json|' _config.yml && \
  sed -i -e 's|^\s*-\s*vendor|&\n  - gulpfile.js|' _config.yml && \
  # gulpの実行を追加
  sed -i -e 's|jekyll build --incremental|&\ngulp imagemin|' bin/deploy
USER root

WORKDIR /srv/jekyll
VOLUME  /srv
EXPOSE 35729 4000

CMD ["/srv/my_awesome_site/bin/start-jekyll-dev.sh"]
