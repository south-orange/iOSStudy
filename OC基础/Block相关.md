## Block相关内容

### Block的本质

block是带有自动变量的匿名函数

局部变量 = 自动变量（栈区）+静态局部变量（全局区）
这里说的自动变量是指block里捕获的外部局部变量

### Block的种类以及储存区域
- NSGlobalBlock: 存放在全局区的block
  只有当block里面仅捕获了外部的静态局部变量、全局变量、静态全局变量时，这个block会被存放在全局区，当block不捕获外部变量时，也在全局区
- NSStackBlock: 存放在栈区的block
- NSMallocBlock: 存放在栈区的block
  arc下，截获了外部自动变量的block被创建出来时存放在栈区，如果该block被strong/copy修饰时，会将该block从栈区copy一份到堆区，并将指针指向堆区的block

### __block的本质

block截获对象的方式
- 局部变量
  - 自动变量
    - 基本类型 截获值
    - 对象类型 截获指针
  - 静态局部变量 截获指针
- 静态全局变量 截获指针
- 全局变量 截获指针
- 成员变量 截获指针

只有当截获的是自动变量的基本类型时，才会截获值，在block内不能对他进行修改

strong/copy修饰的block里截获对象时，会使对象的引用计数+1

当我们截获了自动变量的基本类型数据，又想在block中修改时，需要加上__block修饰符

```
__block int i = 0;

struct __Block_byref_i_0 {
  void *isa;// isa指针
  __Block_byref_i_0 *__forwarding;// 指针指向自身
  int __flags;// 标记
  int __size;// 大小
  int i;// 变量值
}；

struct __main block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0 *Desc;
  __Block_byref_i_0 *i;// by ref
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_i_0 *i, int flags = 0) : i(_i->__forwarding) {
    impl.isa = &NSContreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_i_0 *i = _cself->i; // bound by ref
  (i->__forwarding->i) ++;
  NSLog((NSString *)&__NSConstantStringImpl__var_folders_45_k1d9q7c52vz50wz1683_hk9r0000gn_T_main_3b0837_mi_0, (i->__forwarding->i));
}

```
系统将带有__block的变量转换成一个block结构体，并且当block被copy到堆上时，把__block变量的结构体也copy一份到堆上，其中堆中block结构体的__forwarding指针指向其变量本身

这样，block可以截获到__block变量的结构体里面的__forwarding指针，指针指向堆上__block变量，这样，block就可以修改该变量了
