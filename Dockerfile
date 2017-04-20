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
## NOTE noto serif is experimental. can't install via fonts-noto-cjk now.
RUN curl -sL -o /tmp/noto.deb https://kmuto.jp/debian/noto/fonts-noto-cjk_1.004+repack3-1~exp1_all.deb && dpkg -i /tmp/noto.deb && rm /tmp/noto.deb && \
    apt-get install -y texlive-lang-japanese texlive-fonts-recommended texlive-latex-extra && \
    apt-get install -y --no-install-recommends ghostscript gsfonts zip ruby-zip ruby-nokogiri ruby-mecab mecab mecab-ipadic-utf8 poppler-data && \
    kanji-config-updmap ipaex && \
    apt-get clean
ADD ./noto-font.map /etc/texmf
RUN gem install review review-peg bundler rake --no-rdoc --no-ri

# install node.js environment
RUN apt-get install -y gnupg
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
