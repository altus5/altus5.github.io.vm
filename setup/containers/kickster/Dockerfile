# kickster でセットアップした jekyll の実行環境
# ===========================================
#
# kicksterのtemplateを作成した状態をイメージにすることで、
# 実行要件を整える手間を省いて、jekyllおよびkicksterでのサイト作成を早める。
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
  apk --update add curl bash \
    build-base ruby-dev libxml2-dev libxslt-dev readline-dev libffi-dev \
    yaml-dev zlib-dev libxml2 zlib
# pngquantの依存モジュールを追加
RUN \
  apk --update add \
    libpng-dev file autoconf automake nasm

RUN \
  curl -fsSL https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 > /usr/local/bin/jq && \
  chmod +x /usr/local/bin/jq

RUN \
  gem install nokogiri && \
  gem install kickster && \
  npm install -g bower

# kickster の snippets などを利用するために、リポジトリをもってきておく
RUN \
  mkdir -p /usr/src && \
  cd /usr/src && \
  curl -fsSL https://github.com/nielsenramon/kickster/archive/master.zip > kickster-master.zip && \
  unzip -q kickster-master.zip && \
  mv /usr/src/kickster-master /usr/src/kickster

# my_awesome_site で node install する
RUN \
  mkdir -p /srv/my_awesome_site && \
  chown -R jekyll:jekyll /srv
COPY my_awesome_site/* /srv/my_awesome_site/
RUN \
  cd /srv/my_awesome_site && \
  npm install

# my_awesome_site を kickster でセットアップする
USER jekyll
RUN \
  cd /srv && \
  kickster new my_awesome_site --force && \
  cd my_awesome_site && \
  bin/setup && \
  # CircleCI用の設定とツールを持ってくる
  cp -f /usr/src/kickster/snippets/circle/circle.yml . && \
  cp /usr/src/kickster/snippets/circle/automated bin && \
  chmod +x bin/automated
USER root
RUN \
  cd /srv/my_awesome_site && \
  bundle clean --force
USER jekyll
RUN \
  cd /srv/my_awesome_site && \
  jekyll build
# kicksterに加えてgulpを動かすための追加修正を行う
RUN \
  cd /srv/my_awesome_site && \
  # .jekyll-metadata も .gitignore に追加
  echo '/.jekyll-metadata' >> .gitignore && \
  # gulpを使うので、node_modules も exclude に追加
  sed -i -e 's|^\s*-\s*vendor|&\n  - node_modules|' _config.yml && \
  # gulpの実行を追加
  sed -i -e 's|jekyll build|&\ngulp|' bin/automated && \
  sed -i -e 's|jekyll build|&\ngulp|' bin/deploy && \
  sed -i -e 's|jekyll build|&\n    - gulp|' circle.yml
USER root

WORKDIR /srv/jekyll
VOLUME  /srv
EXPOSE 35729 4000
