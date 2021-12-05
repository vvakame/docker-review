FROM debian:bullseye-slim
LABEL maintainer="vvakame@gmail.com"

ENV REVIEW_VERSION 5.3.0
ENV REVIEW_PEG_VERSION 0.2.2
ENV NODEJS_VERSION 16

ENV PANDOC_VERSION 2.15
ENV PANDOC_DEB_VERSION 2.15-1

ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# setup
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      locales git-core curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen en_US.UTF-8 && update-locale en_US.UTF-8

# for Debian Bug#955619
RUN mkdir -p /usr/share/man/man1

# install Re:VIEW environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      texlive-lang-japanese texlive-fonts-recommended texlive-latex-extra lmodern fonts-lmodern cm-super tex-gyre fonts-texgyre texlive-pictures texlive-plain-generic \
      texlive-luatex \
      ghostscript gsfonts \
      zip ruby-zip \
      ruby-nokogiri mecab ruby-mecab mecab-ipadic-utf8 poppler-data \
      graphviz gnuplot python3-blockdiag plantuml \
      ruby-dev build-essential \
      mecab-jumandic- mecab-jumandic-utf8- \
      texlive-extra-utils poppler-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
## if you want to use ipa font instead of haranoaji font, use this settings
# RUN kanji-config-updmap ipaex

# setup Re:VIEW
RUN gem install bundler rake -N && \
    gem install review -v "$REVIEW_VERSION" -N && \
    gem install pandoc2review -N && \
    gem install rubyzip -N
#   gem install review-peg -v "$REVIEW_PEG_VERSION" -N

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
# RUN apt-get update && apt-get -y install fonts-noto-cjk-extra && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

## if you want to use noto font instead of haranoaji font, use this settings
# RUN kanji-config-updmap-sys noto-otc

RUN kanji-config-updmap-sys haranoaji

## install pandoc
RUN curl -sL -o /tmp/pandoc.deb https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_DEB_VERSION}-$(dpkg --print-architecture).deb && \
    dpkg -i /tmp/pandoc.deb && \
    rm /tmp/pandoc.deb

## set cache folder to work folder (disabled by default)
# RUN mkdir -p /etc/texmf/texmf.d && echo "TEXMFVAR=/work/.texmf-var" > /etc/texmf/texmf.d/99local.cnf
