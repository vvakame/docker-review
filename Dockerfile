FROM debian:stretch-slim
MAINTAINER vvakame

ENV LANG en_US.UTF-8

# setup
RUN apt-get update && apt-get install -y locales git-core curl
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen en_US.UTF-8 && update-locale en_US.UTF-8

# install Re:VIEW environment
RUN apt-get install -y --no-install-recommends \
      texlive-lang-japanese texlive-fonts-recommended texlive-latex-extra lmodern fonts-lmodern tex-gyre fonts-texgyre texlive-pictures \
      ghostscript gsfonts zip ruby-zip ruby-nokogiri mecab ruby-mecab mecab-ipadic-utf8 poppler-data && \
    apt-get clean
## if you want to use ipa font instead of noto font, use this settings
# RUN kanji-config-updmap ipaex

# setup Re:VIEW
RUN gem install review review-peg bundler rake --no-rdoc --no-ri

# install node.js environment
RUN apt-get install -y gnupg
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs && npm install -g yarn

## NOTE noto serif is experimental. can't install via fonts-noto-cjk now.
#RUN echo "deb http://ftp.jp.debian.org/debian/ stretch-backports main" >> /etc/apt/sources.list
#RUN apt-get update && apt-get -y install fonts-noto-cjk/stretch-backports
ADD https://kmuto.jp/debian/noto/fonts-noto-cjk_1.004+repack3-1~exp1_all.deb /tmp/noto.deb
RUN dpkg -i /tmp/noto.deb && rm /tmp/noto.deb

## install font map of noto for dvipdfmx
ADD https://kmuto.jp/debian/noto/noto-map.tgz /tmp/noto-map.tgz
RUN tar Cxvf /usr/share/texlive/texmf-dist/fonts/map/dvipdfmx/ptex-fontmaps \
    /tmp/noto-map.tgz && rm /tmp/noto-map.tgz

## use noto for uplatex
RUN texhash && kanji-config-updmap-sys noto

## set cache folder to work folder (disabled by default)
# RUN mkdir -p /etc/texmf/texmf.d && echo "TEXMFVAR=/work/.texmf-var" > /etc/texmf/texmf.d/99local.cnf
