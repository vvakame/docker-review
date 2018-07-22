# Windows 10でDocker+Re:VIEWを使う：概要

Windows 10 April Update 2018（10.0.17134）以降の環境において、「Windows Subsystem for Linux」と「Re:VIEW image for Docker」の組み合わせが動作するようになったようです（※**Docker for WindowsとDocker Toolboxは使いません**）。その導入方法を紹介します。


## 必要なもの
* 2018年4月以降のアップデートを適用した**Microsoft Windows 10**環境。
  * Windows 10 **Home**エディション（Hyper-V無し）の環境で動作確認しました。
  * Windows 10 April Update 2018（10.0.17134）以降の環境と対象とします。
* ストレージ内に最低でも**3.2GB以上の空き領域**。
  * Windows Subsystem for Linuxをインストールすると1.10GB使用します。
  * Re:VIEW image for Dockerをインストールすると2.03GBを使用します(Re:VIEW 2.5)。
  * このほかにドキュメント自体などを収納するための空き領域も必要です。

## 動作時の負荷について

* WSL利用時のメモリ利用量は0.1GB程度です。

## 完了まで全体像

以下の操作を行います。ネットワーク回線の速度に依存しますが、10～30Mbpsの下り速度の環境で「1.」を30分くらい、「2.」と「3.」を30分くらい、合計１ｈと少しで完了できます。

1. Windows Subsystem for Linux (Ubuntu)のセットアップ
2. Docker のセットアップ
3. Re:VIEW image for Dockerの取得

# Windows Subsystem for Linux のセットアップ

**Windows Subsystem for Linux**（以下、WSLと呼称）は、Windows 10 April Update 2018の適用環境では、以下の操作でセットアップできます。WSLではUbuntu16.04ディストリビューションを利用します。

## WSLの機能を有効化

以下の操作で、WSLを有効化します。

1. スタートメニューの「設定」から「アプリと機能」を開く。
2. 下の方へスクロールして「関連設定」の「プログラムと機能」を開く。
3. 「Windowsの機能の有効化または無効化」を開く。
4. 「Windows Subsystem for Linux」にチェックを入れる。
5. WSLのインストールが始まるので、終了したら「今すぐ再起動」をクリックして再起動する。

※WSLの有効化自体はすぐ終わります。再起動時の追加処理もほぼありません。



## Ubuntu 16.04のインストール

つづいて、WSL環境の上で実際に動作するLinuxディストリビューションアプリをインストールします。「Ubuntu 16.04」を取得します。具体的には以下の操作を行います。

1. 再起動後、スタートメニューから「Microsoft Store」を選択し、検索ボックスに「Ubuntu」を入力して「Ubuntu 16.04」を選択する。

2. 「入手」ボタンをクリックして（ダウンロード＆）インストールする。

3. インストールが完了すると、初期設定としてユーザー名とパスワードを聞いてくるので、Linux（Ubuntu）上で利用するユーザー名とパスワードを入力する。

4. 初期設定が完了すると、Ubuntu on WSLのコマンドプロンプト（ターミナル）が表示される。


以上で、Docker for UbuntuをインストールするためのWSL側のセットアップが完了しました。

# Dockerのセットアップ

Ubuntu on WSL環境に対して、以下の手順でDocker for Ubuntu をインストールします。

Ubuntu on WSLを管理者権限で起動します。開いたUbunutのコマンドライン上から以下のコマンドを実行します。初回のsudo実行時は、パスワードを要求されるので、先ほどの「Ubuntuの初期設定」で設定したパスワード入れます。

```sh
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

```sh
sudo docker run hello-world
```


「Hello from Docker!」が表示されれば成功です。


## Re:VIEW image for Dockerの取得と実行

続いて、Re:VIEW image for Dockerの取得します。
以下のリポジトリで公開されているので、こちらを利用します。
https://github.com/vvakame/docker-review

3.0は「preview」とのことなので、2.5を選択します。
具体的には、上述の「Ubuntu on WSL上でDockerデーモンを起動した」状態で、以下のコマンドを実行します。

```sh
shdo docker pull vvakame/review:2.5
```

イメージのダウンロードが終わるのを待ちます。


ダウンロードが終わりましたら、以下の操作を行います。

1. 作成するReviewのドキュメントを格納するフォルダを作成（ここでは仮にDドライブのルートに「repo-doc」とします）。
2. dockerイメージを起動してreview環境に入る。
3. reviewのサンプルファイルを作成してビルドする。

具体的には以下のコマンドを実行します。
(※Windows側のドライブは、WSL上からは「/mnt/」配下に参照できます)

```
$ mkdir /mnt/d/repo-doc
$ sudo docker run -v /mnt/d/repo-doc:/work -it vvakame/review:2.5 /bin/sh
# review-init review-sample
# cd review-sample
# review-pdfmaker config.yml
# exit
$ exit
```

ここで、「$」マークの行はWSL上のコマンドラインを意味します。「#」マークの行は、docker上のコマンドラインを意味します（※実行時には、「＄」も「＃」も入力しません）。

「`sudo docker run -v /mnt/d/repo-doc:/work -it vvakame/review:2.5 /bin/sh`」コマンドは、
以下を行うコマンドです。

1. 「Re:VIEW image for Docker」を起動する。
2. Windows側のDドライブのルートの「repo-doc」フォルダを、docker側のルートの「work」フォルダとしてマウントする。
3. Dockerのコマンドラインに入る。

Docker側のコマンドラインも、WSLのコマンドラインも、「exit」コマンドで抜けることができます。

Windows上のDドライブのルートにある「repo-doc」フォルダの中に、「review-sample」というフォルダが作成され、フォルダ内に「book.pdf」ファイルが生成されていることを確認してください。このpefファイルが、「review-sample」のReviewドキュメントから作成されたpdfです。

以上で、Ubuntu on WSL上にUbuntus for Dockerをセットアップして、「Re:VIEW image for Docker」を用いてreviewのコンパイルを実行する環境構築が完了しました。

# 普段のReviewコンパイルについて

実際のWindows上での利用方法としては、以下のようになると思います。

1. 任意のエディタ（Visual Studio Codeとか）でReviewファイルを作成する。
2. 作成したReviewファイルを、**reviewコマンドでpdfへコンパイル**する。

一般的なreviewファイルは、以下の様なフォルダ構造で作成すると思います。

```
ドキュメントのフォルダ
　＋articles
　　＋実際のreview.reファイル
    ＋config.yml
    ＋catalog.yml
```

WSL上でDockerサービスを立ち上げた状態で、「ドキュメントのフォルダ」まで移動しておきます（`cd /mnt/d/～`）。「ls」コマンドで「articles」が見えている状態です。この状態であれば、「2.」のコンパイル操作はWSL上から以下の**コマンド一行で実行**することができます。

```
sudo docker run --rm -v `pwd`/articles:/work vvakame/review:2.5 /bin/sh -c "cd /work && review-pdfmaker config.yml"
```

上記のコマンドは、以下を纏めて実行しています。

1. dockerイメージを起動（生成）：run
2. カレントフォルダの直下にあるarticlesフォルダを、docker上のルートのworkフォルダとしてマウント：-v
3. docker起動後に、「workフォルダへ移動、reviewコンパイル」を実行：/bin/sh -c
4. dockerイメージを終了（破棄）：-rm

以上で、エディタの他にUbuntu on WSLのコマンドラインを立ち上げておく必要はありますが、仮想マシンなどを立ち上げることなく、Windows上からreviewコマンドのpdfコンパイルを簡単に実行できるようになりました。


# 蛇足

## Microsoft Storeで「Linux」ではなく、「Ubuntu」で検索する理由

Storeで「Linux」で検索すると、以下の画面が表示されます。

ここで、「アプリを入手する」ボタンを押すと、以下の画面が表示されます。
こちらのUbuntuを選んでも、現状はバージョンが「16.04」で同一なので問題はないと思われます（未確認）。しかし、面倒避けるため動作実績のある「Ubunt16.04」を明確に選択するため、「Ubuntu」のキーワードで検索しました。



# 参考サイトなど

Windows 10でLinuxプログラムを利用可能にするWSL（Windows Subsystem for Linux）をインストールする（バージョン1803対応版）
http://www.atmarkit.co.jp/ait/articles/1608/08/news039.html

WSL（Windows Subsystem for Linux）を使ってみた
https://qiita.com/Brutus/items/f26af71d3cc6f50d1640

＠mattn_jp: Windows 10 Home Edition でも WSL から docker 動いちゃった。最高かよ。
https://twitter.com/mattn_jp/status/1015993682594488320

Windows10 Home の WSL で Docker を使う
https://qiita.com/kogaH/items/534560dd1e4004e80df4

vvakame_docker-review  Re VIEW build container by docker
https://github.com/vvakame/docker-review

WSL vs VM for 開発作業
https://qiita.com/satoru_takeuchi/items/a54812806bba0eb48f02

docker コマンド チートシート
https://qiita.com/voluntas/items/68c1fd04dd3d507d4083

マンガでわかるDocker_技術書典4_電子版（700円）
https://booth.pm/ja/items/825879

