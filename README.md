# Perfect Swift API Demo

[Perfect](https://github.com/PerfectlySoft/Perfect) を使用し、Swift で Web API を作成するデモプロジェクトです。

## 動作確認環境

### macOS

- macOS 10.12.2
- Xcode 8.2.1
- Swift 3.0.2

### Linux

- Ubuntu 16.04.1 (x64)
- Swift 3.0.2 (Release)

### Windows

- Windows 10 Home 1607 (x64)
- Bash on Ubuntu on Windows (Ubuntu 14.04.5)
- Swift 3.0.2 (Release)

Ubuntu では以下のパッケージが必要でした。

```
$ sudo apt-get install uuid uuid-dev sqlite3 libsqlite3-dev libssl-dev libcurl4-openssl-dev
```

Windows ではさらに以下が必要でした。（execstack については[こちら](https://github.com/Microsoft/BashOnWindows/issues/286)を参照しました）

```
$ sudo apt-get install clang-3.6
$ sudo update-alternatives --install /usr/bin/clang /usr/bin/clang-3.6 100
$ sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100
$ sudo apt-get install execstack
$ /usr/sbin/execstack -c /path/to/swift-3.0.2-RELEASE-ubuntu14.04/usr/lib/swift/linux/libFoundation.so
```

## 使い方

Swift のバージョンを確認します。

```
$ swift --version
Apple Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
Target: x86_64-apple-macosx10.9
```

このリポジトリをクローンします。

```
$ git clone https://github.com/yaslab/PerfectSwiftAPIDemo.git
$ cd PerfectSwiftAPIDemo/
```

リソースファイルのパスを修正します。`path` に clone したディレクトリの Resources ディレクトリのフルパスを指定してください。

```
// Sources/Paths.swift

class Paths {

    private class var documentURL: URL {
        let path = "<clone したディレクトリ>/PerfectSwiftAPIDemo/Resources"
        return URL(fileURLWithPath: path, isDirectory: true)
    }

    ...
```

書き換えたらビルドします。

```
$ swift build
Compile COpenSSL xts128.c
Compile COpenSSL xcbc_enc.c
...
Compile Swift Module 'PerfectThread' (2 sources)
Compile Swift Module 'PerfectLib' (10 sources)
Compile Swift Module 'SwiftMoment' (6 sources)
Compile Swift Module 'SQLite' (1 sources)
Linking COpenSSL
Compile Swift Module 'PerfectNet' (5 sources)
Compile Swift Module 'PerfectLogger' (1 sources)
Compile Swift Module 'StORM' (11 sources)
Compile Swift Module 'SQLiteStORM' (9 sources)
Compile Swift Module 'PerfectHTTP' (9 sources)
Compile CHTTPParser http_parser.c
Linking CHTTPParser
Compile Swift Module 'PerfectHTTPServer' (7 sources)
Compile Swift Module 'PerfectSwiftAPIDemo' (3 sources)
Linking ./.build/debug/PerfectSwiftAPIDemo
```

ビルドが成功したら実行します。

```
$ .build/debug/PerfectSwiftAPIDemo

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

`Ctrl + C` でデモアプリを終了します。

## Xcode プロジェクトを作成

もし、必要であれば `*.xcodeproj` を作成することもできます。

```
$ swift package generate-xcodeproj
$ open PerfectSwiftAPIDemo.xcodeproj
```

## ライセンス

- このプロジェクト (PerfectSwiftAPIDemo) は MIT ライセンスです。
- このプロジェクトには CC BY 2.1 JP ライセンスで提供されている、青空文庫の[書架情報](http://www.aozora.gr.jp/index_pages/person_all.html)が含まれています。
