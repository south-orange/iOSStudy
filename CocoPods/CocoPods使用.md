## CocoPods使用

[参考链接-1](https://guides.cocoapods.org/using/getting-started.html)

CocoaPods用于管理Xcode项目的库依赖关系。

在Podfile文件中指定依赖关系，由CocoaPods解析库之间的依赖关系，将其链接到Xcode工作区中。

### 安装Pods

[参考链接](https://guides.cocoapods.org/using/getting-started.html)

### 相关命令

[参考链接-1](https://guides.cocoapods.org/using/pod-install-vs-update.html)

[参考链接-2](https://guides.cocoapods.org/using/using-cocoapods.html)

- pod init

运行这个命令后，会在项目文件夹下生成一个Podfile文件

- pod install

第一次检索项目的Pod时和编辑Podfile后使用，用于添加、更新或删除Pod

运行pod install时，会解析尚未在Podfile.lock中列出的Pod，并进行更新。

每次运行时，如果出现下载并安装新的Pod，将会在Podfile.lock文件中写入每个Pod已安装的版本，这个文件会跟踪每个Pod的安装版本，并锁定这些版本。

pod install不会尝试更新已安装的Pod。添加新的Pod时，应该运行pod install。

- pod outdated

当运行这个命令时，CocoaPods会列出比Podfile.lock中的版本更高的Pod，并进行更新。

- pod update PodName

当运行这个命令时，CocoaPods会不考虑Podfile.lock，查找PodName的pod，直接将这个Pod更新到可能的最新版本。

### Podfile

[参考链接](https://guides.cocoapods.org/syntax/podfile.html#post_install)

Podfile文件是一种规范，描述Xcode项目的targets的依赖关系

1. 指定平台

```
platform :ios, '9.0'
```

2. 为target添加pod

传入target名和pod名

```
target '$TARGET_NAME' do
  pod 'POD_NAME'
end
```

带版本号的pod

```
pod 'POD_NAME', 'VERSION'
```

VERSION中可以加入逻辑运算符和乐观运算符

- '> VERSION' 任何高于VERSION的版本
- '>= VERSION' VERSION和更高的版本
- '< VERSION' 任何低于VERSION的版本
- '<= VERSION' VERSION和更低的版本
- '~> 0.1.2' 任何小于0.1.3且大于0.1.0的版本 [参考链接](https://guides.rubygems.org/patterns/#semantic-versioning)

3. 与现有workspace集成

传入.xcworkspace的文件名

```
workspace 'WORKSPACE_NAME'
```

4. 多个target公用相同的Pod

```
# There are no targets called "Shows" in any Xcode projects
abstract_target 'Shows' do
  pod 'ShowsKit'
  pod 'Fabric'

  # Has its own copy of ShowsKit + ShowWebAuth
  target 'ShowsiOS' do
    pod 'ShowWebAuth'
  end

  # Has its own copy of ShowsKit + ShowTVAuth
  target 'ShowsTV' do
    pod 'ShowTVAuth'
  end
end
```

或者

```
#Podfile的根目录有一个隐式abstract_target
pod 'ShowsKit'
pod 'Fabric'

# Has its own copy of ShowsKit + ShowWebAuth
target 'ShowsiOS' do
  pod 'ShowWebAuth'
end

# Has its own copy of ShowsKit + ShowTVAuth
target 'ShowsTV' do
  pod 'ShowTVAuth'
end
```

#### 复杂示例

```
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Artsy/Specs.git'

platform :ios, '9.0'
inhibit_all_warnings!

target 'MyApp' do
  pod 'GoogleAnalytics', '~> 3.1'

  # Has its own copy of OCMock
  # and has access to GoogleAnalytics via the app
  # that hosts the test target

  target 'MyAppTests' do
    inherit! :search_paths
    pod 'OCMock', '~> 2.0.1'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end
```

### CocoaPods工作流程

1. 创建一个workspace
2. 如果有需要，将项目添加到workspace中
3. 如果有需要，将CocoaPods static library project添加到workspace [参考链接](https://blog.carbonfive.com/using-open-source-static-libraries-in-xcode-4/)
4. 将libPods.a添加到targets => build phases => link with libraries
5. 将xcconfig添加到project文件中 [参考链接](https://www.jianshu.com/p/dc58d26038c8)
6. 修改target的设置
7. 添加 resources copy的build phase
