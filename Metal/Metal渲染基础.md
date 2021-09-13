## Metal 渲染

### 基本渲染流程

- 顶点函数
- 光栅化阶段
- 片段函数

顶点函数和片段函数是可编程的，光栅化阶段是固定的

![](Metal渲染流程图.webp)

#### Vertex Data 顶点数据

position是必须的顶点属性，color是可选的
管道使用两个顶点属性将彩色三角形渲染到drawable的特定区域

#### SIMD数据类型

建议使用SIMD库提供的vector表示三角形顶点数据

#### Vertex Function 顶点函数

又称顶点着色器，vertex shader
主要任务是处理传入的顶点数据并将顶点映射到viewport中的位置，这样，管道后续的操作可以使用这个位置并将像素渲染到drawable中。

Metal的顶点坐标系与OpenGL相同，纹理坐标系原点为左上角

顶点函数对于绘制的每个顶点执行一次

顶点函数使用Metal着色语言Metal shading language编写，基于C++14，专门在GPU上执行

GPU提供了更大的处理贷款，并且可以在大量顶点和片段上并行工作，但是，比CPU内存更小，不能有效的处理控制流操作，并且通常具有更高的延迟

##### 函数声明和参数

```
vertex RasterizerData vertexShader(uint vertexID [[vertex_id]], constant Vertex *vertices [[buffer(0)]])
```

第一个参数vertexID使用[[vertex_id]]属性限定符并保存当前正在执行的顶点的索引，绘制顶点函数会从0开始，并在每次调用vertexShader函数时递增

第二个参数vertices是包含顶点的数组，每个顶点定义为Vertex数据类型，指向此结构的指针定义了这些顶点的数组，使用[[buffer(index)]]获取对应值

其中，这些参数使用SIMD数据可以确保内存布局在CPU/GPU中完全匹配，有助于顶点数据从CPU发送到GPU

##### 函数返回值

```
typedef struct {
  float4 clipSpacePosition [[position]];
  float4 color;
} RasterizerData;
```

顶点函数必须通过[[position]]属性限定符为clipSpacePosition返回每个顶点的位置，下一个阶段栅格化中会使用这个属性来标识三角形角的位置，并确定要渲染的像素

##### 函数主体

- 执行坐标系转换，将生成的顶点位置传入out.clipSpacePosition
- 将顶点的颜色传递给out.color

要获取输入的顶点，使用vertexID索引顶点数组

```
vertexArray[vertexID]
```

#### Rasterization 光栅化

顶点函数执行三次后，对于每个三角形的顶点执行一次

光栅化确定目标可绘制的那些像素，并确定发送到下一阶段的值

由于光栅化是固定的管道阶段，因此无法通过自定义代码修改行为

#### 片段函数

又称片段着色器 fragment shader

```
fragment float4 fragmentShader(RasterizationData in [[stage_in]])
```

顶点函数返回的RasterizationData结构通过光栅化的[[stage_in]]属性限定符传入片段函数，这个函数返回一个四分量浮点向量，其中包含要传递给drawable的最终rgba颜色值

#### 获取函数库和创建管道

在构建实例时，Xcode会编译.metal文件以及其他代码，但是，Xcode无法在构建时链接vertexShader和fragmentShader函数。应用程序要在运行时显示链接这些函数

default.metallib文件是Metal着色语言函数库，有运行时通过调用newDefaultLibrary方法检索的MTLLibrary对象表示

可以由MTLFunction对象表示特定的函数

```
id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
```

这些MTLFunction对象用于创建表示图像渲染管道的MTLRenderPipelineState对象
调用MTLDevice对象的newRenderPipelineStateWithDescriptor:error:方法开始后端编译过程，该过程连接vertexShader和fragmentShader，产生完全编译的管道

MTLRenderPipelineState对象包含MTLRenderPipelineDescriptor对象配置的其他管道设置。除了顶点函数和片段函数外，还有colorAttachments中的第一个条目pixelFormat的值，表示只渲染到单个目标

```
MTLRenderPipelineDescriptor *pipelineStateDescriptor = [MTLRenderPipelineDescriptor new];
pipelineStateDescriptor.label = @"Simple Pipeline";
pipelineStateDescriptor.vertexFunction = vertexFunction;
pipelineStateDescriptor.fragmentFunction = fragmentFunction;
pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;

_pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
```
