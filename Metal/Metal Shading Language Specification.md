## Metal 着色语言规范

### 简述

metal着色器语言是用来编写3D图形渲染逻辑、并行Metal计算核心逻辑的语言

使用clang和llvm进行编译处理，基于C++11设计，增加了一些扩展和限制

### 数据类型

#### 标量类型

- bool
- char
- unsigned char/uchar
- short
- unsigned short/ushort
- int
- unsigned int/uint
- half    16-bit浮点数
- float    32-bit浮点数
- size_t    64-bit无符号整数，表示sizeof的结果
- ptrdiff_t    64-bit有符号整数，表示2个指针的差
- void    空值

其中，half相当于oc的float，float相当于oc的double

#### 向量类型

- booln
- charn
- shortn
- intn
- ucharn
- ushortn
- uintn
- halfn
- floatn

其中，n表示向量的维度，最多不超过4

例如 float4

#### 矩阵类型

- halfnxm
- floatnxm

其中n和m分别表示矩阵的行和列，最大不超过4

例如 float4x4

#### 纹理类型

- texture1d<T, access::sample>
- texture2d<T, access::sample>
- texture3d<T, access::sample>

其中，T可以使用half、float、short、int等

#### 采样器类型

采样器决定如何对一个纹理进行操作

其中，采样器有如下属性

- coord: 从纹理中采样是否需要归一化
  - normalized
  - pixel
- filter: 采样过滤方式，放大/缩小过滤方式
  - nearest
  - linear
- min_filter: 采样的缩小过滤方式
  - nearest
  - linear
- mag_filter: 采样的放大过滤方式
  - nearest
  - linear
- s_address/t_address/r_address: 纹理s、t、r坐标的寻址方式
  - clamp_to_zero
  - clamp_to_edge
  - repeat
  - mirrored_repeat
- address: 设置所有纹理坐标的寻址方式
  - clamp_to_zero
  - clamp_to_edge
  - repeat
  - mirrored_repeat
- mip_filter: 设置纹理采样的mipMap过滤模式，none值表示只有一层纹理生效
  - none
  - nearest
  - linear

### 函数修饰符

- kernel 数据并行计算着色函数，可以被分配在一维/二维/三维线程组中执行，表示函数要并行计算，返回值必须是void，是一个高并发函数
- vertex 顶点着色函数，对顶点数据流的每个顶点数据执行一次，生成数据输出到绘制管线
- fragment 片元着色函数，将片元数据流中的每个片元和数据执行一次，将生成的颜色数据输出到绘制管线

注：
- 这三种修饰符修饰的函数不能被其他函数调用，但是可以在任意函数中调用普通函数
- metal中除了这三种修饰符之外，还可以使用普通函数，就是不带任何修饰符的函数

### 变量修饰符

- device 设备地址空间
- threadgroup 线程组地址空间
- constant 常量地址空间
- thread 线程地址空间

注：
- 三种着色函数的参数，如果是指针/引用，必须带有地址空间修饰符
- vertex/fragment修饰的函数，指针/引用类型的参数必须是device/constant地址空间
- kernel修饰的函数，指针/引用类型的参数必须是device/threadgroup/constant地址空间

#### device

设备地址空间指向设备内存池分配的缓存，设备指的是显存

其中，纹理对象默认在GPU分配内存

#### threadgroup

线程组地址空间用于并行计算着色器函数分配内存变量，这些变量被一个线程组的所有线程共享，vertex/fragment函数不能使用这些变量

#### constant

常量地址空间指向的缓存对象也是从设备内存池分配存储，仅可读

#### thread

每个线程准备的地址空间


### 内建变量修饰符

- [[vertex_id]] 顶点id标识符
- [[instance_id]] 实例id标识符
- [[position]] vertex函数中当前顶点的信息，类型是float4
- [[point_size]] 点的大小，类型是float
- [[color(m)]] 颜色，m在编译前就确定
- [[stage_in]] 片元函数使用的单个片元输入数据，由vertex函数输出经过光栅化生成
