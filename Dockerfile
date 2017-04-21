FROM debian:stretch-slim
MAINTAINER vvakame

ENV LANG en_US.UTF-8

# setup
RUN apt-get update
RUN apt-get install -y locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen en_US.UTF-8
RUN update-locale en_US.UTF-8
RUN apt-get install -y git-core curl

# install Re:VIEW environment
# install font map of noto for dvipdfmx
ADD https://kmuto.jp/debian/noto/noto-map.tgz /tmp/noto-map.tgz
RUN mkdir -p /usr/share/texlive/texmf-dist/fonts/map/dvipdfmx/ptex-fontmaps && cd /usr/share/texlive/texmf-dist/fonts/map/dvipdfmx/ptex-fontmaps && tar zxvf /tmp/noto-map.tgz && rm /tmp/noto-map.tgz

# set cache folder to work folder (disabled by default)
# RUN mkdir -p /etc/texmf/texmf.d && echo "TEXMFVAR=/work/.texmf-var" > /etc/texmf/texmf.d/99local.cnf

## NOTE noto serif is experimental. can't install via fonts-noto-cjk now.
ADD http://kmuto.jp/debian/noto/fonts-noto-cjk_1.004+repack3-1~exp1_all.deb /tmp/noto.deb
RUN dpkg -i /tmp/noto.deb && rm /tmp/noto.deb

RUN apt-get install -y --no-install-recommends texlive-lang-japanese texlive-fonts-recommended texlive-fonts-recommended texlive-latex-extra lmodern fonts-lmodern fonts-texgyre tex-gyre texlive-pictures && \
    apt-get install -y --no-install-recommends ghostscript gsfonts zip ruby-zip ruby-nokogiri ruby-mecab mecab mecab-ipadic-utf8 poppler-data && \
    kanji-config-updmap ipaex && \
    apt-get -y --no-install-recommends upgrade && \
    apt-get clean

# use noto for uplatex
RUN kanji-config-updmap-sys noto

# setup Re:VIEW
RUN gem install review review-peg bundler rake --no-rdoc --no-ri

# install node.js environment
RUN apt-get install -y gnupg
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
