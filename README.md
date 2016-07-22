# Re:VIEW image for Docker

このリポジトリは[Docker](https://www.docker.io/)上で[Re:VIEW](https://github.com/kmuto/review/)を動かすためのものです。

利用可能になるのは、review関連コマンドとrakeコマンド、texlive関連コマンド、vvakameの趣味により、Node.jsの利用環境とgitコマンドも整備されます。

[Docker index](https://index.docker.io/u/vvakame/review/)にTrusted Buildとして置いてあるのでご活用ください。

最近台頭してきたCIサービスの[drone.io](https://drone.io/)はDockerをベースにしてるため、vvakame/reviewをベースに指定すればRe:VIEWドキュメントのビルドをCIサービス上で簡単に行うことができるでしょう。

## 使い方

次のようなディレクトリ構成を例にします

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

`work`ディレクトリは任意の名前でよいです。後述のコマンドで`cd`する先になります。
    
- `vvakame/review` イメージを使用する

- マウントしたディレクトリ内で任意のビルドコマンドを実行する

pdf出力する場合

```
/bin/sh -c "cd /work && review-pdfmaker config.yml"
```

この例では実行するコマンドは次のようになります。

```
$ docker run --rm -v `pwd`/src:/work vvakame/review /bin/sh -c "cd /work && review-pdfmaker config.yml"
```

ビルドが終了すると、`src`ディレクトリ内にpdfファイルが出力されます。