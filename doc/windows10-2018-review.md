# WindowsでDocker+Re:VIEWを使う

本ドキュメントでは、Windows上で「Windows Subsystem for Linux」と「Re:VIEW image for Docker」を利用し、Re:VIEWドキュメントからPDFおよびEPUBを生成する方法を紹介します。

## 必要なもの
* **Microsoft Windows**。本ドキュメントはWindows 10 Homeエディションに基づいています。
  * Windows 10 April Update 2018（10.0.17134）以降の環境と対象とします。
* **ストレージ内に最低でも3.5GB以上の空き領域**。Windows Subsystem for Linuxをインストールするのと1.10GB使用します。Re:VIEW image for Dockerをインストールすると2.03GBを使用します(Re:VIEW 2.5)。このほかにドキュメント自体などを収納するための空き領域も必要です。
* **UTF-8を扱うことのできるテキストエディタ**。「メモ帳」アプリでもUTF-8形式での保存は可能ですが、実際にドキュメントを執筆・編集するにあたってはより適切で高機能なテキストエディタが必要になるでしょう。Visual Studio Code、Atom、Emacs、秀丸など向けにRe:VIEWをサポートする外部拡張が公開されています（[https://github.com/kmuto/review/wiki](https://github.com/kmuto/review/wiki)）。

## 動作時の負荷について

* WSL利用時のメモリ利用量は0.1GB程度です。

## Windows Subsystem for Linux のセットアップ

**Windows Subsystem for Linux**（以下、WSLと呼称）は、◆後で書く◆。

WSLは、Windows 10 April Update 2018の適用環境では、以下の操作でインストールできます。この操作は、ネットワーク回線速度に依存しますが、10～30Mbpsの環境で **30分程度**で完了できます。

### WSLのインストール

1. スタートメニュー（◆合ってる？）の「設定」から「アプリと機能」を開く。
2. 下の方へスクロールして「関連設定」の「プログラムと機能」をクリックする。
3. 「Windowsの機能の有効化または無効化」をクリックする。
4. 「Windows Subsystem for Linux」にチェックを入れる。
  * WSLのインストールが始まり、すぐ終わる。
  * インストールが終了したら「今すぐ再起動」をクリックして再起動する。

### Ubuntu 16.04のインストール

1. 再起動後、スタートメニューから「Microsoft Store」を選択し、検索ボックスに「Ubuntu」を入力して「Ubuntu 16.04」を選択して「入手」ボタンをクリックしてインストールする。
  * ダウンロードを含めて15分くらい。
2. インストールが完了すると、初期設定としてユーザー名とパスワードを聞いてくるので、Linux（Ubuntu）上で利用するユーザー名とパスワードを入力する。


## Dockerのセットアップ

**Docker**は、OSと特定用途のアプリケーションをまとめて「コンテナ」という形にし、それを必要に応じて簡単に呼び出すことができるサービスです。たとえば、Re:VIEW image for DockerはLinux（Ubuntu Linux）とRe:VIEWの動作環境をコンテナ化したものです。Re:VIEWやそれを取り巻くRubyやTeXLiveといった個々のソフトウェアをWindowsにセットアップしようとするとそれだけでもとても面倒な作業ですが、Dockerを使えばそのようなことにわずらわされることなく、すべて揃った状態からRe:VIEWのドキュメント制作を始めることができます。

Windows向けのDockerには、[Docker for Windows](https://docker.com/docker-windows)と[Docker Toolbox](https://docker.com/products/docker-toolbox)という2種類の実装があります。どちらもDockerの開発元であるDocker, Inc.社公式のものです。前者はWindowsの仮想化支援技術Hyper-Vを利用していて動作も高速ですが、Hyper-Vを利用するためProfessional以上のWindowsエディションが必要となります。後者はVirtualBoxを利用するためHomeエディションでも動作しますが、Dockerを動かすためにはオーバーヘッドの大きい仮想化ソフトウェアの上に乗っています。

一方で、Ubuntu on WSL環境に対して、Docker for Ubuntu をインストールすることでもDockerは動作します（Windows 10 April Update 2018以降）。本ドキュメントではこの方法を説明します。

Ubuntu on WSLを管理者権限で起動します。開いたUbunutのコマンドライン上から以下のコマンドを実行します。

```
sudo apt update
sudo apt upgrade
sudo apt install docker.io
sudo cgroupfs-mount
sudo usermod -aG docker $USER
sudo service docker start
```

dockerがインストールされ、デーモン (daemon)が起動します。本設定は初回のみ実施し、2回目以降は必要ありません。2回目以降の動作に準拠するため、一旦「exit」でUbuntu on WSLを終了します。

2回目以降は、以下の操作でDockerデーモンを起動します。
1. Ubuntu on WSLを管理者権限で起動する。
2. Ubuntuのコマンドライン（ターミナル）上で、以下のコマンド実行する。

```
sudo cgroupfs-mount && sudo service docker start
```

dockder が正しくセットアップされたの確認のため、Hello Worldのイメージを起動してみます。
「Hello from Docker!」が表示されれば成功です。

```
sudo docker run hello-world
```


## Re:VIEW image for Dockerの展開
続いて、Re:VIEW image for Dockerを利用するための設定に進みます。

ここでは「ドキュメント」フォルダに「work」というサブフォルダを用意して、その中で各Re:VIEWドキュメントフォルダを管理するという想定で進めます。

```
PC
└─ドキュメント（Documents）
    └─work
        ├─Dockerfile
        ├─docker-compose.yml
        ├─sampledoc
        │  ├─Dockerfile
        │  ├─docker-compose.yml
        │  ├─sampledoc.re
        │  └……
        └……
```

docker-composeの制約と思われますが、途中に空白のあるパスだとこのあとの実行に失敗します。「ドキュメント」フォルダはいわゆる「My Documents」（これは空白を含むので失敗します）のほか、「Documents」という名前でも参照できるので、その名前をここでは使います。

エクスプローラでドキュメントフォルダ内にworkフォルダを作ったら、次の2つのファイル「Dockerfile」「docker-compose.yml」をテキストエディタを使って作成し、workフォルダ内に配置します（メモ帳で作成した場合は拡張子`.txt`となっているのをエクスプローラで修正してください）。

Dockerfile
```
FROM vvakame/review
```

docker-compose.yml
```
version: '3'
services:
  review:
    volumes:
      - .:/work
    build: .
    working_dir: /work
```

docker-compose.ymlの行頭インデントの違いは重要です。本ドキュメントからコピーペーストして使ってもよいでしょう。

次にDockerターミナルで操作します。WindowsのGUIに慣れているとおどろおどろしいDockerターミナルですが、実際利用するコマンドの数はさほど多くはありません。このDockerターミナルはMinGWという小さなUnix互換環境になっており、Unixの一般的なコマンドを利用できます。

まず、作成したworkフォルダに移動します。次のように入力し、Enterを押します。

```
cd ~/Documents/work
```

次に、Dockerコンテナの元となる「Dockerイメージ」をダウンロードします。同様に次のように入力してEnterを押してください。

```
docker pull vvakame/review
```

このダウンロードと展開にはかなり時間がかかりますが、安定したネットワーク環境であれば特に問題なく終了するでしょう。

![vvakame/reviewのダウンロードと展開](windows-img/vvakame1.png)

これでWindowsでRe:VIEWを利用する準備は完了です！

## Docker+Re:VIEWドキュメント制作
workフォルダ内（`cd ~/Documents/work`をした状態）で、docker-composeコマンドを使ってRe:VIEWの各コマンドを呼び出せます。

review-initコマンドはRe:VIEWドキュメントの雛型を作るコマンドです。新規に「sampledoc」を作ってみましょう。Docker経由で呼び出すには、Dockerターミナルで次のように実行します。

```
docker-compose run review review-init sampledoc
```

* 「docker-compose」は「docker-compose.exe」としても構いません。「docker-」と入力してTabキーを押せば補完されるでしょう。
* 「run」はDockerコンテナで指定のコマンドを実行して終了する、という指令です。
* 「review」が使用するDockerイメージとなります。
* 「review-init sampledoc」がDockerコンテナの上で実行されるRe:VIEWコマンドです。sampledocという名前の新規フォルダを作業フォルダ（work）内に作り、Re:VIEWドキュメントに必要な初期ファイル群を展開します。

展開されたsampledocフォルダ内は次のようになっています。

![展開されたsampledocフォルダ](windows-img/review1.png)

この中の各ファイルについての詳細は、[Re:VIEW Quick Start Guide](https://github.com/kmuto/review/blob/master/doc/quickstart.ja.md)や[Re:VIEW Format Guide](https://github.com/kmuto/review/blob/master/doc/format.ja.md)、その他[https://github.com/kmuto/review/wiki](https://github.com/kmuto/review/wiki)にある各ドキュメントを参照してください。

次に、エクスプローラなどで**workフォルダにあるDockerfileファイルとdocker-compose.ymlファイルをこのsampledocフォルダにコピーしてください**。エクスプローラの代わりにDockerターミナル上で次のように実行することでもコピーできます。

```
cp docker-compose.yml Dockerfile sampledoc
```

コンテンツを書き込むsampledoc.reファイルに、テキストエディタを利用して適当なテキストを書き込んでみることにします。

![sampledoc.reの編集](windows-img/review2.png)

ここではメモ帳を使っていますが、冒頭で述べたとおり、より適切なテキストエディタを使ったほうがよいでしょう。また、保存時には文字エンコーディングを「UTF-8」にしておく必要があります。

では、PDFを生成してみましょう。まず、sampledocフォルダに移動する必要があるので、次のようにDockerターミナルで実行して移動します。

```
cd ~/Documents/work/sampledoc
```

PDFを生成するためには次のようにDockerターミナルで実行します。

```
docker-compose run review rake pdf
```

「rake pdf」がPDFを生成するコマンドです（内部では`review-pdfmaker config.yml`というRe:VIEWコマンドが呼び出されています）。

sampledoc.reにエラーがなければ、sampledocフォルダにbook.pdfというPDFファイルが生成されます。

[Acrobat Reader](https://get.adobe.com/jp/reader/)でPDFを開いてみます。

![book.pdfの表紙](windows-img/review3.png)

![book.pdfのコンテンツ](windows-img/review4.png)

EPUBを生成するのもほぼ同じで、次のようにDockerターミナルで実行します。「rake epub」がEPUBを生成するコマンドです（内部では`review-epubmaker config.yml`が呼び出されます）。

```
docker-compose run review rake epub
```

book.epubというEPUBファイルが生成されるので、Google Chromeブラウザの拡張機能である[Readium](http://readium.org/)でこのファイルを開いてみます。

![book.epubをReadiumに登録](windows-img/epub1.png)

![book.epubをReadiumで開く](windows-img/epub2.png)

このように、同じコンテンツからPDFとEPUBという2つの形式のファイルを作成できました！

## その他のコマンド
docker-composeコマンドの詳細については、[https://docs.docker.com/compose/](https://docs.docker.com/compose/)などを参照してください。

* docker-compose ps: 実行/停止中のDockerコンテナを一覧する
* docker-compose rm *コンテナID*: Dockerコンテナを削除する
* docker-compose images: Dockerイメージを一覧する
* docker-compose pull: Dockerイメージを更新する

コンテンツ内に動的生成をしているものがあるなどの理由でネットワークを使う必要がある場合は、次の指定をdocker-compose.yml末尾に加えます。

```
networks:
  default:
    external:
      name: bridge
```
