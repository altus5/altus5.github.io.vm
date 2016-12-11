# kickster
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
# 
# docker run の初回に、my_awesome_site から、/srv/jekyll にコピーすれば、
# dockerの初回起動時間が短くなる。
#
FROM jekyll/jekyll:pages

RUN \
  apk --update add curl bash \
    build-base ruby-dev libxml2-dev libxslt-dev readline-dev libffi-dev \
    yaml-dev zlib-dev libxml2 zlib

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
  curl -fsSL https://github.com/nielsenramon/kickster/archive/1.4.0.zip > kickster-1.4.0.zip && \
  unzip -q kickster-1.4.0.zip && \
  mv /usr/src/kickster-1.4.0 /usr/src/kickster

RUN \
  mkdir -p /srv && \
  cd /srv && \
  chown -R jekyll:jekyll /srv

USER jekyll
RUN \
  cd /srv && \
  kickster new my_awesome_site && \
  cd my_awesome_site && \
  bin/setup && \
  # CircleCI用の設定とツールを持ってくる
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
USER root

WORKDIR /srv/jekyll
VOLUME  /srv
EXPOSE 35729 4000
