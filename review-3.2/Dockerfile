FROM debian:buster-slim
LABEL maintainer="vvakame@gmail.com"

ENV REVIEW_VERSION 3.2.0
ENV REVIEW_PEG_VERSION 0.2.2
ENV NODEJS_VERSION 14

ENV HARANOAJI_VERSION 20210130

ENV PANDOC_VERSION 2.12
ENV PANDOC_DEB_VERSION 2.12-1

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
      texlive-lang-japanese texlive-fonts-recommended texlive-latex-extra lmodern fonts-lmodern cm-super tex-gyre fonts-texgyre texlive-pictures texlive-plain-generic \
      texlive-luatex \
      ghostscript gsfonts \
      zip ruby-zip \
      ruby-nokogiri mecab ruby-mecab mecab-ipadic-utf8 poppler-data \
      graphviz gnuplot python-blockdiag python-aafigure \
      ruby-dev build-essential \
      mecab-jumandic- mecab-jumandic-utf8- \
      texlive-extra-utils poppler-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
## if you want to use ipa font instead of haranoaji font, use this settings
# RUN kanji-config-updmap ipaex

# setup Re:VIEW
RUN gem install bundler rake --no-rdoc --no-ri && \
    gem install review -v "$REVIEW_VERSION" --no-rdoc --no-ri && \
    gem install pandoc2review --no-rdoc --no-ri
#   gem install review-peg -v "$REVIEW_PEG_VERSION" --no-rdoc --no-ri

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

# install noto font
RUN apt-get update && apt-get -y install fonts-noto-cjk-extra && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## install font map of noto for dvipdfmx
COPY noto-otc/ /usr/share/texlive/texmf-dist/fonts/map/dvipdfmx/ptex-fontmaps/noto-otc/

## if you want to use noto font instead of haranoaji font, use this settings
# RUN kanji-config-updmap-sys noto-otc

# install haranoaji font
RUN mkdir -p /usr/local/share/texmf/fonts/opentype && \
    curl -L -s -o /usr/local/share/texmf/fonts/opentype/haranoaji.zip \
      https://github.com/trueroad/HaranoAjiFonts/archive/${HARANOAJI_VERSION}.zip && \
    cd /usr/local/share/texmf/fonts/opentype && \
    unzip -q haranoaji.zip && \
    rm haranoaji.zip

## install font map of haranoaji for dvipdfmx
COPY haranoaji/ /usr/share/texlive/texmf-dist/fonts/map/dvipdfmx/ptex-fontmaps/haranoaji/

## use haranoaji for uplatex
RUN texhash && kanji-config-updmap-sys haranoaji

## install pandoc
RUN curl -sL -o /tmp/pandoc.deb https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_DEB_VERSION}-amd64.deb && \
    dpkg -i /tmp/pandoc.deb && \
    rm /tmp/pandoc.deb

## set cache folder to work folder (disabled by default)
# RUN mkdir -p /etc/texmf/texmf.d && echo "TEXMFVAR=/work/.texmf-var" > /etc/texmf/texmf.d/99local.cnf
