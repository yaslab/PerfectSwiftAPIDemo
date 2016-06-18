# Perfect Swift API Demo

[Perfect](https://github.com/PerfectlySoft/Perfect) を使用し、Swift で Web API を作成するデモプロジェクトです。

## 動作確認環境

- OSX 10.11.5
- Swift 3.0 Preview 1 (June 13, 2016)

## 使い方

Swift のバージョンを確認します。

```
$ swift -version
Apple Swift version 3.0 (swiftlang-800.0.30 clang-800.0.24)
Target: x86_64-apple-macosx10.9
```

このリポジトリをクローンします。

```
$ git clone https://github.com/yaslab/PerfectSwiftAPIDemo.git
```

Xcode プロジェクトを作成します。

```
$ cd PerfectSwiftAPIDemo/
$ swift package generate-xcodeproj
$ open PerfectSwiftAPIDemo.xcodeproj
```

リソースファイルのパスを修正します。
`path` に clone したディレクトリの Resources ディレクトリのフルパスを指定してください。

Sources/Paths.swift

```
class Paths {

    private class var documentURL: URL {
        let path = "<clone したディレクトリ>/PerfectSwiftAPIDemo/Resources"
        return URL(fileURLWithPath: path, isDirectory: true)
    }

    ...
```

書き換えたら実行します。

```
$ swift build
Compile Swift Module 'PerfectThread' (2 sources)
Compile Swift Module 'SQLite' (1 sources)
Compile Swift Module 'PerfectNet' (5 sources)
Compile Swift Module 'PerfectLib' (26 sources)
Compile Swift Module 'PerfectSwiftAPIDemo' (3 sources)
Linking .build/debug/PerfectSwiftAPIDemo

$ .build/debug/PerfectSwiftAPIDemo
Load libs from: ./PerfectLibraries/
/+h
/**+h

GET:
/api
	/books+h
		/{id}+h

Starting HTTP server on 0.0.0.0:8181 with document root /xxxx
```

`curl` 等で API の動作確認をします。

```
$ curl -v http://localhost:8181/api/books
$ curl -v 'http://localhost:8181/api/books?limit=5&offset=5000'
$ curl -v http://localhost:8181/api/books/000005
```

HTTP エラーになる場合は、リソースファイルのパスを確認してみましょう。

`Command + C` でデモアプリを終了します。

## ライセンス

- このプロジェクト (PerfectSwiftAPIDemo) は MIT ライセンスです。
- このプロジェクトには CC BY 2.1 JP ライセンスで提供されている、青空文庫の書架情報が含まれています。
