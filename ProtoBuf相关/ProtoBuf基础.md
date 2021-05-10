## ProtoBuf基础

与JSON和XML类似，ProtoBuf是Google提供的一种序列化结构数据的方法。

[参考链接01](https://www.jianshu.com/p/8c6c009bc500/)

[参考链接02](https://hyichao.github.io/ios-protobuf/)

[参考链接03](https://github.com/alexeyxo/protobuf-objc)

### ProtoBuf

protocol buffers 是一种语言无关、平台无关、可扩展的序列化结构数据的方法，它可用于（数据）通信协议、数据存储等。

Protocol Buffers 是一种灵活，高效，自动化机制的结构数据序列化方法－可类比 XML，但是比 XML 更小（3 ~ 10倍）、更快（20 ~ 100倍）、更为简单。

你可以定义数据的结构，然后使用特殊生成的源代码轻松的在各种数据流中使用各种语言进行编写和读取结构数据。你甚至可以更新数据结构，而不破坏由旧数据结构编译的已部署程序。

### 使用

1. 配置protobuf编译环境

- 检查是否安装homebrew
-
```
brew -v
```

- 若没有安装使用以下命令安装

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

- 安装protobuf编译器及工具

```
brew install automake
brew install libtool
brew install protobuf
```

最后会生成一个protoc-gen-objc插件，安装在/usr/local/bin目录下

2. 使用pod导入proto

```
pod 'Protobuf'
```

3. 创建.proto文件，定义数据结构

```
syntax = "proto3";
package user;

option go_package = "proto/user";

message User{
    optional int32 id = 1;
    optional string username = 2;
    optional string age = 3;
    optional string gender = 4;
    optional string imageurl = 5;
}
```

4. 编译.proto文件生成源代码文件

```
protoc --plugin=/usr/local/bin/protoc-gen-objc User.proto --objc_out="./"
```
