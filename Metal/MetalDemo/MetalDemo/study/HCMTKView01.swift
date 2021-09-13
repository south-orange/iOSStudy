//
//
//  HCMTKView01.swift
//  MetalDemo
//
//  Created by 霍橙 on 2021/7/9.
//  
//
    

import UIKit
import MetalKit

class HCMTKView01: UIView, MTKViewDelegate {
    
    lazy var mtkView: MTKView = {
        let mtkView = MTKView.init(frame: self.bounds)
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.delegate = self
        return mtkView
    }()
    
    var viewportSize: vector_double2?
    
    var renderPipelineState: MTLRenderPipelineState?
    var computePipelineState: MTLComputePipelineState?
    var commandQueue: MTLCommandQueue?
    var textureLoader: MTKTextureLoader?
    var texture: MTLTexture?
    var sampler: MTLSamplerState?
    
    var textureParams: MTLBuffer?
    var textureEncoder: MTLArgumentEncoder?
    
    var fragmentFunction: MTLFunction?
    
    var vertices: MTLBuffer?
    var vertices2: MTLBuffer?
    
    var resVertices: MTLBuffer?
    var count = 0
    
    var groupSize: MTLSize!
    var groupCount: MTLSize!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mtkView)
        viewportSize = vector_double2.init(x: Double(mtkView.drawableSize.width), y: Double(mtkView.drawableSize.height))
        
        metalInit()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func metalInit() {
        setupPipeline()
        setupTexture()
    }

    func setupPipeline() {
        let library = mtkView.device?.makeDefaultLibrary()
        
        let vertexFunction = library?.makeFunction(name: "vertexShader") // 顶点着色器
        fragmentFunction = library?.makeFunction(name: "samplingShader") // 片元着色器
        let kernelFunction = library?.makeFunction(name: "kernelFun")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor.init()
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        
        guard (try? renderPipelineState = mtkView.device?.makeRenderPipelineState(descriptor: pipelineStateDescriptor)) != nil else {
            return
        }
        
        guard (try? computePipelineState = mtkView.device?.makeComputePipelineState(function: kernelFunction!)) != nil else {
            return
        }
        
        commandQueue = mtkView.device?.makeCommandQueue()
    }
    
    func setupVertex() {
        let quadVertices:[Vertex02] = [
            Vertex02(center: vector_float2(x: 0.0, y: 0.0), textureCenter: vector_float2(x: 0.0, y: 0.0)),
            Vertex02(center: vector_float2(x: -1.0, y: 0.0), textureCenter: vector_float2(x: 0.0, y: 0.0)),
        ]
        
        self.vertices = self.mtkView.device?.makeBuffer(bytes: quadVertices, length: quadVertices.count * MemoryLayout<Vertex02>.size, options: .storageModeShared)
        
        self.resVertices = self.mtkView.device?.makeBuffer(length: quadVertices.count * 6 * MemoryLayout<Vertex01>.size, options: .storageModeShared)
        
        let quadVertices2:[Vertex01] = [
            Vertex01(position: vector_float2(x: 0.5, y: 0), textureCoordinate: vector_float2(x: 1.0, y: 1.0)),
            Vertex01(position: vector_float2(x: 0, y: 0), textureCoordinate: vector_float2(x: 0.0, y: 1.0)),
            Vertex01(position: vector_float2(x: 0, y: 0.5), textureCoordinate: vector_float2(x: 0.0, y: 0.0)),
            
            Vertex01(position: vector_float2(x: 0.5, y: 0), textureCoordinate: vector_float2(x: 1.0, y: 1.0)),
            Vertex01(position: vector_float2(x: 0, y: 0.5), textureCoordinate: vector_float2(x: 0.0, y: 0.0)),
            Vertex01(position: vector_float2(x: 0.5, y: 0.5), textureCoordinate: vector_float2(x: 1.0, y: 0.0)),
        ]
        
        self.vertices2 = self.mtkView.device?.makeBuffer(bytes: quadVertices2, length: quadVertices2.count * MemoryLayout<Vertex01>.size, options: .storageModeShared)
    }
    
    func setupTexture() {
        textureLoader = MTKTextureLoader(device: mtkView.device!)
        let image = UIImage.init(named: "bgCell")
        guard (try? self.texture = textureLoader?.newTexture(cgImage: (image?.cgImage)!, options: nil)) != nil else {
            return
        }
        
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.sAddressMode = .repeat
        samplerDescriptor.tAddressMode = .repeat
        samplerDescriptor.supportArgumentBuffers = true
        self.sampler = mtkView.device?.makeSamplerState(descriptor: samplerDescriptor)
        
        textureEncoder = fragmentFunction?.makeArgumentEncoder(bufferIndex: 0)
        textureParams = mtkView.device?.makeBuffer(length: (textureEncoder?.encodedLength ?? 0) * 2, options: MTLResourceOptions(rawValue: 0))
    }
    
    //MARK: delegate
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize = vector_double2(x: Double(size.width), y: Double(size.height))
    }
    
    func draw(in view: MTKView) {
        setupVertex()
        groupSize = MTLSize(width: 2, height: 3, depth: 1)
        groupCount = MTLSize(width: 2, height: 1, depth: 1)
        
        for i in 0..<1 {
            let offset = i * (textureEncoder?.encodedLength ?? 0)
            textureEncoder?.setArgumentBuffer(textureParams, offset: offset)
            textureEncoder?.setTexture(texture, index: 0)
            textureEncoder?.setSamplerState(sampler, index: 1)
        }
        
        let commandBuffer = self.commandQueue?.makeCommandBuffer()
        if let computeEncoder = commandBuffer?.makeComputeCommandEncoder(), let computePipelineState = self.computePipelineState {
            computeEncoder.setComputePipelineState(computePipelineState)
            computeEncoder.setBuffer(self.vertices, offset: 0, index: 0)
            computeEncoder.setBuffer(self.resVertices, offset: 0, index: 1)
            computeEncoder.dispatchThreadgroups(self.groupCount, threadsPerThreadgroup: self.groupSize)
            computeEncoder.popDebugGroup()
            computeEncoder.endEncoding()
        }
        if let renderPassDescriptor = view.currentRenderPassDescriptor, let pipelineState = self.renderPipelineState, let viewportSize = self.viewportSize, let texture = texture {
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.5, 0.5, 1.0)
            if let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
                renderEncoder.setViewport(MTLViewport(originX: 0.0, originY: 0.0, width: viewportSize.x, height: viewportSize.y, znear: -1.0, zfar: 1.0))
                
                renderEncoder.useResource(texture, usage: .sample)
                
                renderEncoder.setRenderPipelineState(pipelineState)
                renderEncoder.setFragmentBuffer(textureParams, offset: 0, index: 0)
//                renderEncoder.setFragmentTexture(self.texture, index: 0)
//                renderEncoder.setFragmentSamplerState(self.sampler, index: 0)
                
                
                renderEncoder.setVertexBuffer(self.resVertices, offset: 0, index: 0)
                renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 12)
                
                renderEncoder.setVertexBuffer(self.vertices2, offset: 0, index: 0)
                renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
                
                renderEncoder.endEncoding()
            }
            commandBuffer?.present(view.currentDrawable!)
            
        }
        commandBuffer?.commit()
    }
    
}
