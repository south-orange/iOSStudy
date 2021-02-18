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
