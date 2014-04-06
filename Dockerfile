FROM debian:jessie
MAINTAINER vvakame

# setup
RUN apt-get update
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
RUN update-locale en_US.UTF-8
RUN apt-get install -y git-core

# install Re:VIEW environment
RUN apt-get install -y texlive-lang-cjk texlive-fonts-recommended
RUN gem install review rake --no-rdoc --no-ri

# install node.js environment
RUN apt-get install -y nodejs npm
RUN ln -s /usr/bin/nodejs /usr/bin/node
