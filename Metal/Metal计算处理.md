## Metal计算处理

在GPGPU模型中，GPU可以用于处理任何类型的任务，不限于图像数据。
图像和计算工作不是互斥的，Metal提供统一的框架和语言，可实现图形和计算工作的集成

### 计算处理管道

计算处理流水线仅有一个阶段，可编程内核函数，用于执行计算传递

MTLComputePipelineState表示计算处理管道，与图形渲染管道不同，可以使用单个内核函数创建MTLComputePipelineState

```
id<MTLFunction> kernelFunction = [defaultLibrary newFunctionWithName:@"grayscaleKernel"];

_computePipelineState = [_device newComputePipelineStateWithFunction:kernelFunction error:&error];
```

### 计算函数

```
kernel void grayscaleKernel(texture2d<half, access::read> inTexture [[texture(0)]], texture2d<half, access::write> outTexture [[texture(1)]], uint2 gid [[thread_position_in_grid]])
```

inTexture 包含输入颜色像素的只读2D纹理
outTexture 是一种只写的2D纹理，用于存储输出灰度像素

计算函数每个线程执行一次，类似于顶点函数每个顶点执行一次的方式

### 计算传递

MTLComputeCommandEncoder用于执行计算传递的命令和对内核函数及其资源的引用

```
id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];

[computeEncoder setComputePipelineState:_computePipelineState];

[computeEncoder setTexture:_inputTexture atIndex:0];

[computeEncoder setTexture:_outputTexture atIndex:1];
```

计算传递必须制定执行线程组和线程组的大小，线程组的数量和线程组的大小决定计算函数的调用次数

```
self.threadgroupSize = MTLSizeMake(6, 1, 1);

self.threadgroupCount = MTLSizeMake(2, 3, 1);
```

调度调用并结束计算

```
[computeEncoder dispatchThreadgroups:self.threadgroupCount threadsPerThreadgroup:self.threadgroupSize];

[computeEncoder endEncoding];
```
