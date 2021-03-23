## performSelector原理及应用

1. performSelector的调用与直接调用

- 直接调用会在编译时进行校验，如果SEL不存在，会在编译后进行提示。performSelector是运行时寻找方法进行调用，编译时不做校验，如果调用时SEL不存在，会造成程序崩溃。因此，一般在使用performSelector时会使用respondsToSelector:(SEL)aSelector进行校验。
- 直接调用方法时需要在头文件中声明方法，并import头文件。performSelector不需要在头文件中声明方法，可以直接调用方法。

2. 常用的performSelector使用方式

- 同步执行

以下方法均为同步执行，在主线程和子线程中均可调用成功，与直接调用方法等同。

```
- (id)performSelector:(SEL)aSelector;
- (id)performSelector:(SEL)aSelector withObject:(id)object;
- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
```

- 延时执行

以下方法均为延时执行。通过在当前线程的runloop中设置一个timer执行aSelector，线程会在触发计时器时，尝试从runloop中执行这个selector，如果runloop在运行状态且处于default mode，则执行成功，否则等待runloop到default mode。

由于需要在runloop中添加timer，所以在子线程中执行该方法时需要执行 [NSRunLoop.currentRunLoop run]将子线程加入runloop。

如果需要在其他mode时执行方法，可以传入modes。

```
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray *)modes;
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay;
```

以下方法可以取消未执行的delay方法

```
+(void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(id)anArgument;
+(void)cancelPreviousPerformRequestsWithTarget:(id)aTarget;
```

viewController生命周期结束的时候调用取消函数确保不会引起内存泄漏。

- 主线程阻塞执行

以下方式在主线程和子线程中均可执行，会调用主线程中的aSelector方法。

wait参数为YES时，表示同步阻塞，先执行主线程的aSelector方法，再执行该线程后续代码。

wait参数为NO时，表示异步非阻塞，两个线程并行。

```
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array;
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait
```

- 子线程阻塞执行

以下方式在指定线程中执行，类比主线程阻塞执行

```
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array;
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait;
```

- 子线程后台执行

以下方式将会创建一个子线程，在子线程中执行aSelector

```
- (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg;
```
