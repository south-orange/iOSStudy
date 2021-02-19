### 属性修饰符简述

OC定义属性@property时需要使用属性修饰符
主要的属性修饰符有以下几种
- copy
- assign
- retain (MRC)
- strong/weak (ARC)
- readwrite/readonly (访问权限相关)
- nonatomic/atomic (线程安全相关)

#### 属性修饰符详述
##### copy

用于修饰不可变属性如NSArray、NSString等，也可修饰block

在属性的setter方法中，不增加旧值的retainCount，调用copy方法创建出一个新的对象

block与copy
```
全局block NSContreteGlobalBlock:存储在全局区，未使用局部变量
栈block NSContreteStackBlock:存储在栈中，运行结束就会被销毁
堆block NSContreteMallocBlock:存储在堆中，ARC中赋值会隐式调用copy
```
MRC中，retain会让堆block的retainCount加一，但是有可能会出现空指针

ARC中，strong和copy修饰的block都会调用copy方法，将block复制到堆上

在ARC中，以下几种情况会将block复制到堆中
- 被执行copy方法
- 作为方法返回值
- 将block赋值给strong修饰的对象时
- 在方法名中含有usingBlock的Cocoa框架方法或者GDC的API中传递的时候

block要注意循环引用

##### assign
一般用于修饰基础数据类型

修饰对象时，不会对retainCount加一，在对象释放后，不会自动将指针置nil，会导致野指针

##### retain/strong
只能修饰对象，会将修饰的对象retainCount加一

使用retain/strong修饰的对象要注意循环引用

##### weak
只能用于修饰对象，不会将修饰的对象retainCount加一

对象释放之后，会自动将对象置nil

##### readwrite/readonly
readwrite对外提供getter/setter方法，readonly对外只提供getter方法

##### nonatomic/atomic
nonatomic性能较高，但是多线程访问不安全

atomic性能较差，需要消耗更多资源，在getter/setter方法上加锁

atomic只在getter/setter上加锁，如果在多线程中调用对象的其他方法，不能保证完全的线程安全
