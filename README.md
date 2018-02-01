# Perfect Swift API Demo

[Perfect](https://github.com/PerfectlySoft/Perfect) を使用し、Swift で Web API を作成するデモプロジェクトです。

## 動作確認環境

### macOS

- macOS 10.13.2
- Xcode 9.2
- Swift 4.0.3

### Linux

- Ubuntu 16.04.1 (x64)
- Swift 4.0.3 (Release)

### Windows

- Hyper-V
- Docker

Ubuntu では以下のパッケージが必要でした。

```
$ git clone https://github.com/PerfectlySoft/Perfect-Ubuntu.git && \
cd Perfect-Ubuntu/ && \
chmod +x ./install.sh && \
sudo ./install.sh --sure
```

Windows ではさらに以下が必要でした。

```
$ docker run -it -v $pwd:/home -w /home -p 8181:8181 rockywei/swift:4.0 /bin/bash -c "swift run"
```

## 使い方

Swift のバージョンを確認します。

```
$ swift --version
Apple Swift version 4.0.3 (swiftlang-900.0.74.1 clang-900.0.39.2)
Target: x86_64-apple-macosx10.9
```

このリポジトリをクローンします。

```
$ git clone https://github.com/yaslab/PerfectSwiftAPIDemo.git
$ cd PerfectSwiftAPIDemo/
$ swift run
```

ビルドが成功したら実行します。

```
Linking ./.build/x86_64-apple-macosx10.10/debug/PerfectSwiftAPIDemo

GET:
/+h
/api
	/books+h
		/{id}+h

[INFO] Starting HTTP server  on 0.0.0.0:8181
```

`curl` 等で API の動作確認をします。

```
$ curl -v http://localhost:8181/api/books
$ curl -v 'http://localhost:8181/api/books?limit=5&offset=5000'
$ curl -v http://localhost:8181/api/books/000005
```

HTTP エラーになる場合は、リソースファイルのパスを確認してみましょう。

`Ctrl + C` / `docker ps ` && `docker kill ` でデモアプリを終了します。

## Xcode プロジェクトを作成

もし、必要であれば `*.xcodeproj` を作成することもできます。

```
$ swift package generate-xcodeproj
$ open PerfectSwiftAPIDemo.xcodeproj
```

Xcode -> "Product > Scheme > Edit Scheme…" 设定 "Use Custom Working Directory" プロジェクトフォルダに追加します。

## ライセンス

- このプロジェクト (PerfectSwiftAPIDemo) は MIT ライセンスです。
- このプロジェクトには CC BY 2.1 JP ライセンスで提供されている、青空文庫の[書架情報](http://www.aozora.gr.jp/index_pages/person_all.html)が含まれています。
