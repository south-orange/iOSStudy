## GLSL基础语法

[参考链接](https://www.jianshu.com/p/66b10062bd67)

GLSL(OpenGL着色语言OpenGL Shading Language)语法跟C语言很类似，在可编程管线中我们必须要纯手写顶点和片源着色器

### 基本数据类型

- void
- bool
- int
- float
- vec2,vec3,vec4,bvec2,bvec3,bvec4,ivec2,ivec3,ivec4
- mat2,mat3,mat4
- sampler1D,sampler2D,sampler3D,samplerCube
  sameler表示纹理采样器，sampler2D表示二维纹理采样器，samplerCube表示立方体地图纹理采样器

每种数据类型都支持创建数组，只支持创建一维数组
另外，还可以通过struct创建自己的数据类型

### 存储修饰符

- const: 常量或者只读参数
- in(新)/attribute(老): 输入值，<font color="red">不可用于顶点着色器</font>，顶点着色器的out和片段着色器的in名称相同时构成接口，必须具有相同的类型和精度
- out(新)/varying(老): 输出值，<font color="red">不可用于顶点着色器</font>。一般在顶点着色器中修改varying变量值，然后在片段着色器中使用该变量
- uniform: 全局变量，通过外部app传递

### 精度修饰符

- highp
- mediump
- lowp
