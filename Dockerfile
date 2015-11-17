FROM debian:jessie
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
RUN apt-get install -y texlive-lang-cjk texlive-fonts-recommended
RUN apt-get install -y --no-install-recommends zip
RUN gem install review review-peg bundler rake --no-rdoc --no-ri

# install node.js environment
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs
RUN ln -s /usr/bin/nodejs /usr/bin/node

