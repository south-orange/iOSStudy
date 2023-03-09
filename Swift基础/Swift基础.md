## Swift基础

### Swift与OC的区别

- 语言特性
  Swift是静态语言，OC是动态语言，静态语言在编译器中做类型判断，一旦确定不能改变类型，动态语言在运行时可以改变结构
- 命名空间
  Swift有命名空间，OC没有
- 方法调用
  Swift采用直接调用/函数表调用/消息转发，OC只采用消息转发

### Struct和Class的区别
- 继承
  Struct不支持继承，Class可以继承
- 类型
  Struct是值类型的，Class是引用类型的

  值类型存放在栈区，赋值是深拷贝，采用copy on write优化

  引用类型存放在堆区，赋值是浅拷贝
- 析构方法
  Struct没有析构方法，不关系引用计数，Class有析构方法
- 初始方法
  Struct有默认构造器，初始化必须要给属性赋值，Class可以指定构造器，Class初始化的时候可以暂时不赋值
- 属性
  Struct声明属性的时候不需要赋值，Class声明属性必须要赋值或包装成Optional

### Copy on write

写时复制，struct类型在赋值时不会一开始就去复制，只有在需要修改时才会进行复制

### !,?,??,is,as,as!,as?
- !表示强制解包，如果值为nil，会报错
- ?表示声明可选值，如果未初始化会自动初始化为nil，操作可选值时，如果可选值为nil，则不响应操作，使用as?进行向下转型操作
- ?? 用来表示左侧可选值为空的判断，左侧为空则返回右侧的值
- is表示判断某个对象是否为某个特定类的对象
- as表示从子类转换为父类对象，向上转型，进行数值转换，switch中进行模式匹配
- as!表示父类对象强制转换为子类对象，如果失败会crash，属于向下转型
- as?表示父类对象转换为子类对象，转型不成功会返回一个nil对象，成功返回可选类型，需要解包

### Swift修饰符

- static 修饰存储属性，计算属性，类方法，修饰的方法不能被继承
- class修饰计算属性，类方法，修饰的方法可以被继承
- final修饰的类、方法、变量不能被继承或重写，通过他可以显示指定函数的派发机制

- open: 可以被所有实体访问，且可以被继承和重写
- public: 可以被所有实体访问，可以在同一模块内被继承和重写，不能在模块外被继承和重写
- internal: 可以被同一模块的实体访问，模块外不能访问，默认是internal
- fileprivate: 可以被同一文件的实体访问，文件外不能访问
- private: 只能被它定义的作用域和同一文件的extension中访问

### 关联值和原始值

- 关联值
关联值的值与他的成员变量关联存储在一起
```
enum Date {
  case digit(year: Int, month: Int, day: Int)
  case string(String)
}
```
- 原始值
原始值可以使用相同类型的默认值预先关联

### 闭包

```
{
  (Params) -> return in
  body
}
```

- 尾随闭包
函数最后一个参数，调用时可以写在圆括号之后
```
func func1(p1: Int, p2: Int, fn: (Int, Int) -> Int) { fn(p1, p2) }

func1(p1: 1, p2: 2) {
  $0 + $1
}
```
- 逃逸闭包
逃逸闭包在函数结束后调用，逃离了函数的作用域，用@escaping声明
```
var completions: [() -> ()] = []
func func1(completion: @escaping () -> ()) {
  completions.append(completion)
}

func1(_ : )
```
- 自动闭包
自动闭包不接收任何参数，通过添加@autoclosure关键字使得闭包内的代码可以延迟到被调用时执行，这样比直接在参数内写表达式的性能要更好

### throws和rethrows

throws表示当前函数可能抛出异常，需要处理
```
func test(a: Any) throws -> String {
  if type(of: a) == Int.self {
    return "Int"
  }
  throw Error.none
}
```

rethrows表示参数中的闭包或函数可能出现异常，但是当前函数调用不处理
```
func testRethrow(testThrowCall: (Int) throws -> String, num: Int) rethrows -> String {
  try testThrowCall(num)
}

// 不处理异常
let str = testRethrow(testThrowCall: { (int) -> String in
  return "\(int)"
}, num: 10)

do {
  let testResult: String = try testRethrow(testThrowCall: { (int) -> String
    return try test(a: 10.0)
  }, num: 10)
} catch Error.unknow {
  print(Error.unknow)
}
```

### try? 和 try!
try?会在报错时返回一个nil值，没有报错时返回一个可选值
try!则会在报错时产生崩溃

### associatedtype
关联类型，由于协议不支持<T>的泛型，可以使用关联类型达到一个泛型的效果

```
protocol Pro1 {
  associatedtype T
  func print(_ value: T)
}

class Cls1 {
  var name: String?
}

class Cls2: Pro1 {
  // 在使用协议时需要明确指定协议中的关联类型
  typealias T = Cls1

  func print(_ value: Cls1) {
    print("\(value.name)")
  }
}
```

### Sequence和Iterator

- Sequence
Sequence是一系列相同类型的值的集合，并对这些值提供迭代能力
迭代最常见的方式就是for-in
```
for element in someSequence {
  body
}
```

Sequence Protocol 只有一个必须要实现的方法
```
protocol Sequence {
  associatedtype Iterator: IteratorProtocol
  func makeIterator() -> Iterator
}
```

makeIterator()需要返回一个Iterator

- Iterator
Iterator在Swift标准器中就是IteratorProtocol，用来为Sequence提供迭代能力
```
public protocol IteratorProtocol {
  associatedtype element
  public mutating func next() -> Self.Element?
}
```

其中仅声明了一个next()方法，用来返回Sequence中的下一个元素，或者当没有下一个元素时返回nil

### 高阶函数
- map 用于映射，可以将一个列表转换为另一个列表
- flatmap 与map类似，但是会丢弃掉可选值nil，或者返回一个与当前数组类型相同的数组
- filter 用于过滤，可以筛选出需要的元素
- reduce 合并，将数组内进行合并
