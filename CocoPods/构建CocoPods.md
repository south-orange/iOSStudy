## 构建CocoPods

[参考链接-1](https://guides.cocoapods.org/making/index.html)

[参考链接-2](https://blog.csdn.net/qq_22982291/article/details/84870646?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control&dist_request_id=&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control)

1. 构建pods文件夹

使用以下命令构建pods

```
pod lib create GXModule
```

2. 修改podspec文件

内容示例如下

```
#
# Be sure to run `pod lib lint PodName.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = '$PodName'
  s.version          = '$PodVersion'
  s.summary          = 'A short description of HCPodDemo.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = '$PodHomepage'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '霍橙' => '752893258@qq.com' }
  s.source           = { :git => '$PodUrl', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = '$PodSourceFilesPath'

  # s.resource_bundles = {
  #   'PodName' => ['$PodResourceBundlesPath']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

```

2. 远程验证podspec

在podspec文件夹下运行以下命令

```
pod lib lint PodName.podspec
```

显示passed validation就是成功通过了验证

3. 将pod工程推送到github

提交Pod

```
git add .
git commit -m “Initial Commit"
git remote add origin $githubURL
git push -u origin master
```

添加版本tag

```
git tag 0.1.0
git push origin 0.1.0
```

验证pod

```
pod spec lint PodName.podspec
```

显示passed validation就是成功通过了验证

4. 提交pod到Specs仓库

```
pod trunk push PodName.podspec
```
