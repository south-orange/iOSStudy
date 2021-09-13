//
//
//  shaders01.metal
//  MetalDemo
//
//  Created by 霍橙 on 2021/7/12.
//  
//
    

#include <metal_stdlib>
#import "HCShaderTypes01.h"
using namespace metal;

typedef struct {
    float4 clipSpacePosition [[position]];
    float2 textureCoordinate;
} RasterizerData;

struct HCTextureArgments {
    texture2d<float> texture [[id(0)]];
    sampler sampler [[id(1)]];
};

constant float4 vertices[] = {
    float4(-0.5, -0.5, 1.0, 1.0),
    float4(-0.5,  0.5, 0.0, 1.0),
    float4( 0.5, -0.5, 1.0, 0.0),
    float4( 0.5,  0.5, 0.0, 0.0)
};

constant uint indices[] = {0, 1, 2, 2, 1, 3};

vertex RasterizerData vertexShader(uint vertexID [[vertex_id]], constant Vertex01 *vertexArray [[buffer(0)]]) {
    RasterizerData out;
    out.clipSpacePosition = float4(vertexArray[vertexID].position, 0.0, 1.0);
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    return out;
}

fragment float4 samplingShader(RasterizerData input [[stage_in]], constant HCTextureArgments *textureParams [[buffer(0)]]) {
    float4 colorSample = textureParams[0].texture.sample(textureParams[0].sampler, input.textureCoordinate);
    return colorSample;
}

kernel void kernelFun(device Vertex02 *vertexArray [[buffer(0)]], device Vertex01 *resVertexArray [[buffer(1)]], uint2 threadPosition [[thread_position_in_threadgroup]], uint2 groupSize [[threads_per_threadgroup]], uint2 gridSize [[threadgroups_per_grid]], uint2 groupPosition [[threadgroup_position_in_grid]]) {
    uint groupOffset = groupSize.x * groupSize.y * (groupPosition.x + groupPosition.y * gridSize.x);
    uint index = threadPosition.x + threadPosition.y * groupSize.x;
    resVertexArray[index + groupOffset].position = vertices[indices[index]].xy;
    resVertexArray[index + groupOffset].textureCoordinate = vertices[indices[index]].zw;
}
