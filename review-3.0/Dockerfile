FROM debian:stretch-slim
LABEL maintainer="vvakame@gmail.com"

ENV REVIEW_VERSION 3.0.0
ENV REVIEW_PEG_VERSION 0.2.2
ENV NODEJS_VERSION 10

ENV LANG en_US.UTF-8

# setup
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      locales git-core curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen en_US.UTF-8 && update-locale en_US.UTF-8

# install Re:VIEW environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      texlive-lang-japanese texlive-fonts-recommended texlive-latex-extra lmodern fonts-lmodern tex-gyre fonts-texgyre texlive-pictures \
      ghostscript gsfonts zip ruby-zip ruby-nokogiri mecab ruby-mecab mecab-ipadic-utf8 poppler-data cm-super \
      graphviz gnuplot python-blockdiag python-aafigure && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
## if you want to use ipa font instead of noto font, use this settings
# RUN kanji-config-updmap ipaex

# setup Re:VIEW
RUN gem install bundler rake --no-rdoc --no-ri && \
    gem install review -v "$REVIEW_VERSION" --no-rdoc --no-ri && \
    gem install review-peg -v "$REVIEW_PEG_VERSION" --no-rdoc --no-ri

# install node.js environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash - 
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g yarn

# install noto font from backports
RUN echo "deb http://ftp.jp.debian.org/debian/ stretch-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get -y install fonts-noto-cjk/stretch-backports fonts-noto-cjk-extra/stretch-backports

## install font map of noto for dvipdfmx
COPY noto/ /usr/share/texlive/texmf-dist/fonts/map/dvipdfmx/ptex-fontmaps/noto/

## use noto for uplatex
RUN texhash && kanji-config-updmap-sys noto

## set cache folder to work folder (disabled by default)
# RUN mkdir -p /etc/texmf/texmf.d && echo "TEXMFVAR=/work/.texmf-var" > /etc/texmf/texmf.d/99local.cnf
