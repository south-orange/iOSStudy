## Method Swizzling

Runtime Method Swizzling编程方式，也可以叫做AOP(Aspect-Oriented Programming，面向切面编程)

AOP是一种编程范式，也是一种编程思想，使用AOP可以解决OOP(Object Oriented Programming，面向对象编程)由于切面需求导致单一职责被破坏的问题。通过AOP可以不侵入OOP开发，非常方便的插入切面需求功能

一些与主业务无关的逻辑功能，也可以通过AOP来完成，这样主业务逻辑就能够满足OOP单一职责的要求

但是，iOS在运行时进行AOP会有风险，不能简单地使用Runtime进行方法交换实现AOP

### Runtime方法进行方法交换的风险

Runtime进行方法交换的代码如下

```
#import "SMHook.h"
#import <objc/runtime.h>

@implementation SMHook

+ (void)hookClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    Class class = classObject;
    // 得到被交换类的实例方法
    Method fromMethod = class_getInstanceMethod(class, fromSelector);
    // 得到交换类的实例方法
    Method toMethod = class_getInstanceMethod(class, toSelector);

    // class_addMethod() 函数返回成功表示被交换的方法没实现，然后会通过 class_addMethod() 函数先实现；返回失败则表示被交换方法已存在，可以直接进行 IMP 指针交换
    if(class_addMethod(class, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        // 进行方法的交换
        class_replaceMethod(class, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    } else {
        // 交换 IMP 指针
        method_exchangeImplementations(fromMethod, toMethod);
    }
}
@end
```

通过class_getInstanceMethod()函数可以得到被交换类的实例方法和交换类的实例方法。使用class_addMethod()函数来添加方法，返回成功表示被交换的方法没被实现，然后通过class_replaceMethod()实现；返回失败表示被交换的方法已存在，可以通过method_exchangeImplementations()函数直接进行IMP指针交换以实现方法交换

直接使用runtime进行方法交换存在以下风险：[参考链接](https://github.com/rabovik/RSSwizzle/)

1. 需要在+load方法中进行方法交换。因为如果在其他时候进行方法交换，有可能另一个线程正在调用被交换的方法，导致交换与预期不符
2. 被交换的方法必须是当前类的方法，不能是父类的方法，直接把父类的实现拷贝不会起作用，父类的方法必须在调用的时候使用，而不是方法交换的时候使用
3. 交换的方法如果依赖了_cmd，当_cmd发生变化时，会出现各种难排查的问题，特别是交换了系统方法，无法保证系统方法内部是否依赖了_cmd
4. 方法交换命名冲突，如果出现冲突，可能会导致方法交换失败

#### 更安全的方法交换库Aspects

[参考链接](https://github.com/steipete/Aspects)

Aspects实现方法交换的原理如下

Aspects的整体流程是，先判断是否可进行方法交换，如果没有风险，再针对要交换的是类对象还是实例对象分别进行处理

- 对于类对象的方法交换，会先修改类的forwardInvocation，将类的实现转成自己的，然后重新生成一个方法用于交换，最后，交换方法的IMP，方法调用时就会直接对交换方法进行消息转发
- 对于实例对象的方法交换，会先创建一个类，并将当前实例对象的isa指向新创建的类，然后在修改类的方法

整个流程的入口是aspect_add()方法，这个方法包含了Aspects的两个核心方法，第一个是进行安全判断的aspect_isSelectorAllowedAndTrack，第二个是执行类对象和实例对象方法交换的aspect_prepareClassAndHookSelector

aspect_isSelectorAllowedAndTrack会对一些方法比如retain、release、autorelease、forwardInvocation进行过滤，并对dealloc方法交换做了限制，要求只能使用AspectPositionBefore选项，同时还会过滤没有响应的方法，直接返回NO

安全判断完就开始执行方法交换的aspect_prepareClassAndHookSelector方法

实现代码如下

```
static void aspect_prepareClassAndHookSelector(NSObject *self, SEL selector, NSError **error) {
    NSCParameterAssert(selector);
    Class klass = aspect_hookClass(self, error);
    Method targetMethod = class_getInstanceMethod(klass, selector);
    IMP targetMethodIMP = method_getImplementation(targetMethod);
    if (!aspect_isMsgForwardIMP(targetMethodIMP)) {
        // 创建方法别名
        const char *typeEncoding = method_getTypeEncoding(targetMethod);
        SEL aliasSelector = aspect_aliasForSelector(selector);
        if (![klass instancesRespondToSelector:aliasSelector]) {
            __unused BOOL addedAlias = class_addMethod(klass, aliasSelector, method_getImplementation(targetMethod), typeEncoding);
            NSCAssert(addedAlias, @"Original implementation for %@ is already copied to %@ on %@", NSStringFromSelector(selector), NSStringFromSelector(aliasSelector), klass);
        }

        // 使用 forwardInvocation 进行方法交换.
        class_replaceMethod(klass, selector, aspect_getMsgForwardIMP(self, selector), typeEncoding);
        AspectLog(@"Aspects: Installed hook for -[%@ %@].", klass, NSStringFromSelector(selector));
    }
}
```

通过aspect_hookClass()函数可以判断出class的selector是实例方法还是类方法，如果是实例方法，会通过class_addMethod方法生成一个交换方法，这样在forwordInvocation时就能够直接执行交换方法，aspect_hookClass还会对类对象、元类、KVO子类化的实例对象、class和isa指向不同的情况进行处理，使用aspect_swizzleClassInPlace混写baseClass
