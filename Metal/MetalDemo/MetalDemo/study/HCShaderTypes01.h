//
//
//  HCShaderTypes01.h
//  MetalDemo
//
//  Created by 霍橙 on 2021/7/9.
//  
//
    

#ifndef HCShaderTypes01_h
#define HCShaderTypes01_h

#include <simd/simd.h>

typedef struct {
    vector_float2 center;
    vector_float2 textureCenter;
} Vertex02;

typedef struct {
    vector_float2 position;
    vector_float2 textureCoordinate;
} Vertex01;


#endif /* HCShaderTypes01_h */
