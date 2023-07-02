FROM debian:bookworm-slim
LABEL maintainer="vvakame@gmail.com"

# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETARCH

ENV REVIEW_VERSION 5.7.0
ENV NODEJS_VERSION 20

# ENV PANDOC_VERSION 2.17.1.1
# ENV PANDOC_DEB_VERSION 2.17.1.1-1

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
      plantuml \
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

RUN kanji-config-updmap-sys haranoaji

## install pandoc
# RUN curl -sL -o /tmp/pandoc.deb "https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_DEB_VERSION}-${TARGETARCH}.deb" && \
#     dpkg -i /tmp/pandoc.deb && \
#     rm /tmp/pandoc.deb
## pandoc2review doesn't support pandoc 3. So just use Debian's version
RUN apt-get update && apt-get -y install pandoc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Playwright support with fonts. This consumes ~350MB
RUN apt-get update && apt-get -y install --no-install-recommends fonts-noto-cjk-extra fonts-noto-color-emoji libatk1.0-0 libatk-bridge2.0-0 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libpango-1.0-0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN npm install -g playwright && rm -rf /root/.cache/ms-playwright/firefox* /root/.cache/ms-playwright/webkit* && gem install playwright-runner -N

## set cache folder to work folder (disabled by default)
# RUN mkdir -p /etc/texmf/texmf.d && echo "TEXMFVAR=/work/.texmf-var" > /etc/texmf/texmf.d/99local.cnf
