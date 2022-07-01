# Re:VIEW image for Docker

[![CircleCI](https://circleci.com/gh/vvakame/docker-review.svg?style=svg)](https://circleci.com/gh/vvakame/docker-review)
[![Docker Build Statu](https://img.shields.io/docker/build/vvakame/review.svg)](https://hub.docker.com/r/vvakame/review/)
[![Docker Automated buil](https://img.shields.io/docker/automated/vvakame/review.svg)](https://hub.docker.com/r/vvakame/review/)
[![Docker Stars](https://img.shields.io/docker/stars/vvakame/review.svg)](https://hub.docker.com/r/vvakame/review/)
[![Docker Pulls](https://img.shields.io/docker/pulls/vvakame/review.svg)](https://hub.docker.com/r/vvakame/review/)

このリポジトリは[Docker](https://www.docker.com/)上で[Re:VIEW](https://github.com/kmuto/review/)を動かすためのものです。

[Docker Hub](https://hub.docker.com/r/vvakame/review/)にTrusted Buildとして置いてあるのでご活用ください。
試験的に[GitHub Container Registry](https://github.com/users/vvakame/packages/container/package/review)にも置いてあります。

Windows用の手引は[こちら](https://github.com/vvakame/docker-review/blob/master/doc/windows-review.md)を参考にしてください。
docker-composeを使った時の手引としても使えます。

## 仕様

### サポートしているタグ

Re:VIEWのバージョン毎にイメージを作成しています。
現在存在しているタグは `latest`, `3.2`, `4.2`, `5.0`, `5.1`, `5.2`, `5.3`, `5.4`, `5.5` です。
`2.3`, `2.4` , `2.5` もDocker Hub上に存在していますが、サポートは終了しています。

```
$ docker pull vvakame/review:5.5
$ docker pull vvakame/review:5.4
$ docker pull vvakame/review:5.3
$ docker pull vvakame/review:5.2
$ docker pull vvakame/review:5.1
$ docker pull vvakame/review:5.0
$ docker pull vvakame/review:4.2
$ docker pull vvakame/review:3.2
```

```
$ docker pull ghcr.io/vvakame/review:5.5
$ docker pull ghcr.io/vvakame/review:5.4
$ docker pull ghcr.io/vvakame/review:5.3
$ docker pull ghcr.io/vvakame/review:5.2
$ docker pull ghcr.io/vvakame/review:5.1
$ docker pull ghcr.io/vvakame/review:5.0
$ docker pull ghcr.io/vvakame/review:4.2
$ docker pull ghcr.io/vvakame/review:3.2
```

### インストールされているコマンド

* git
* curl
* TeXLive & 日本語環境
* MeCab （Re:VIEW 索引作成時に利用される）
* Ruby （Re:VIEW 実行環境）
* Node.js & npm （[ReVIEW-Template](https://github.com/TechBooster/ReVIEW-Template)用環境）
* Re:VIEW & rake & bundler
* pandoc
* pandoc2review

他。詳細は[Dockerfile](https://github.com/vvakame/docker-review/blob/master/Dockerfile)を参照してください。

## TeX周りの初期設定

PDF作成時、[原の味フォント](https://github.com/trueroad/HaranoAjiFonts)をデフォルトで利用し、フォントの埋め込みも行うようになっています。

* [IPAフォント](http://ipafont.ipa.go.jp/)を使いたいとき
  * `kanji-config-updmap ipaex` を実行する
* [Notoフォント](https://www.google.com/get/noto/)を使いたいとき
  * `apt-get install fonts-not-cjk-extra` および `kanji-config-updmap noto-otc` を実行する

## 使い方

次のようなディレクトリ構成を例にします。

```
├── README.md
└── src
    ├── catalog.yml
    ├── config.yml
    ├── ch01.re
    ├── ch02.re
    ├── ch03.re
    ├── index.re
    └── layouts
```

- `config.yml`が存在するディレクトリをコンテナ上にマウントする

`src`ディレクトリに`config.yml`がある場合

```
-v `pwd`/src:/work
```

`work`ディレクトリは任意の名前でよいです。後述のコマンドで`cd`をする先になります。

- `vvakame/review` イメージを使用する

- マウントしたディレクトリ内で任意のビルドコマンドを実行する

pdf出力する場合

```
/bin/sh -c "cd /work && rake pdf"
```

この例では実行するコマンドは次のようになります。

```
$ docker run --rm -v `pwd`/src:/work vvakame/review /bin/sh -c "cd /work && rake pdf"
```

ビルドが終了すると、`src`ディレクトリ内にpdfファイルが出力されます。
