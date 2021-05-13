## AutoLayout

### AutoLayout的来历

- 1997年，Autolayout使用的布局算法Cassowary被发明
- 2011年，苹果公司将Cassowary算法用于Autolayout中

Cassowary能够有效解析线性等式系统和线性不等式系统，用来表示用户界面中的相等关系和不等关系。

Cassowary规定通过约束来描述视图间的关系，约束可以表示出一个视图相对于另一个视图的位置

[参考链接](https://constraints.cs.washington.edu/cassowary/)

### AutoLayout的生命周期

AutoLayout的核心是一整套布局引擎系统Layout Engine，主导整个界面布局

每个视图太得到自己的布局之前，Layout Engine会将视图、约束、优先级、固定大小通过计算转换成最终的大小和位置

在Layout Engine中，每当约束发生变化，就会重新计算布局，获取到布局后调用superView.setNeedsLayout()，然后触发Deffered Layout Pass，完成后进入监听约束变化的状态

当再次监听到约束变化，即进入下一轮循环中

Deffered Layout Pass主要是用于容错处理，如果有些视图在更新约束时没有确定或缺失布局声明的话，会现在这里做容错处理

Deffered Layout Pass后，Layout Engine会从上到下调用layoutSubviews()，通过Cassowary算法计算各个子视图的位置，算出来后将子视图的frame从Layout Engine中拷贝出来

### AutoLayout的常见问题

1. 相关更新方法

- setNeedsLayout: 告知页面需要更新，但不会立刻开始更新。执行后会立刻调用layoutSubviews
- layoutIfNeeded: 如果有需要刷新的标记，立即调用layoutSubviews进行布局；如果没有标记，不会调用layoutSubviews
- layoutSubviews: 对subviews进行布局，不能主动调用，需要的时候在子类重写，系统会在合适的时候自动调用
- setNeedsUpdateConstraints: 告知需要更新约束，但不会立刻开始
- updateConstraintsIfNeeded: 告知立刻更新约束
- updateConstraints: 系统更新约束

> 如果要立即刷新frame，要先调用setNeedsLayout()，把标记设置为需要布局，然后马上调用layoutIfNeeded()，实现frame的计算

> 实际测试只调用layoutIfNeeded()也可以，会默认调用setNeedsLayout()
