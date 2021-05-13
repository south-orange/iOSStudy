## App启动

### App启动方式

- 冷启动

App启动时，App的进程不在系统中，需要创建一个新进程分配给App使用，这是一次完整的启动过程

- 热启动

App在冷启动后用户退到后台，App的进程还在系统里的情况下，用户重新启动进入App的启动过程

### App冷启动

#### App启动的三个阶段

1. main()函数执行前
2. main()函数执行后
3. 首屏渲染完成后

#### main()函数执行前

在这个阶段，系统主要操作如下：

- 加载可执行文件(.o文件)
- 加载动态链接库，进行rebase指针调整和bind符号绑定
- objc运行时的初始处理，包括objc相关类的注册、category的注册、selector唯一性检查等
- 初始化，包括执行+load()方法、attribute((constructor))修饰的函数的调用、创建c++静态全局变量

这个阶段可以优化的方式如下：

- 减少动态库加载，数量上，苹果公司建议最多使用6个非系统动态库
- 减少加载启动后不会去使用的类或者方法
- +load()的内容可以放到首屏渲染完成后执行，或使用+initialize()替换。+load()里进行运行时方法替换会消耗4 ms，执行的越多，对启动速度的影响越大
- 控制c++全局变量的数量

#### main()函数执行后

这一阶段是指从main()函数执行开始，到AppDelegate的didFinishLaunchingWithOptions方法里首屏渲染相关方法执行完成

首页的业务代码都是要在这个阶段执行的，主要操作如下：

- 首屏初始化所需配置文件的读写操作
- 首屏列表大数据的读取
- 首屏渲染的大量计算

这个阶段可以优化的方式为减少不必要的初始化操作，从功能上区分，只执行必要的初始化功能

#### 首屏渲染完成后

这一阶段是指didFinishLaunchingWithOptions方法里执行首屏渲染开始到didFinishLaunchingWithOptions方法执行结束

这一阶段主要完成非首屏其他业务模块的初始化、监听的注册、配置文件的读取

这一阶段用户已经可以看到App的首页了，因此不需要优先处理，但是还是要处理会卡住主线程的方法，否则会影响到用户的交互操作

#### 查看数据

- Product -> Scheme -> Edit Scheme -> Run -> Arguments -> Environment Variables -> DYLD_PRINT_STATISTICS设置为YES，可以查看main函数执行前花费时间长度
- Product -> Scheme -> Edit Scheme -> Run -> Diagnostics -> Logging -> 勾选Dynamic Library Loads可以查看当前项目中加载的所有动态库


#### 启动速度的监控

启动速度的监控主要有两种手段

##### 定时抓取主线程上的方法调用堆栈

xcode profile里的time profile采用的就是定时抓取主线程上的方法调用堆栈，计算一段时间里各个方法的耗时

定时间隔的设置会对结果产生影响

- 设置过长会漏掉一些方法，导致检查的耗时不准确
- 设置过短会导致这个方法调用过多影响整体耗时，导致结果不准确

一般设置间隔为0.01 s

总体上说，虽然定时抓取的方式准确度不够高，但是也够用了

##### 对objc_msgSend方法进行hook

hook的意思是在原方法开始执行时换成执行其他你指定的方法，或者在原有方法执行前后执行你指定的方法，来达到掌握和改变指定方法的目的

hook objc_msgSend的优点是非常精确，缺点是只能针对objective-c的方法。

也可以使用libffi的ffi_call达成c方法和block的hook，但是编写维护相关工具门槛高

objc_msgSend的执行逻辑如下

- 获取对象对应类的信息
- 获取方法的缓存
- 根据selector查找函数指针
- 异常错误处理
- 跳到对应函数的实现
