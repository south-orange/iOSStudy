//
//
//  HCAILevel.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/28.
//  
//
    

#import "HCAILevel.h"
#import "MathUtils.h"

@implementation HCAILevel

+ (instancetype)randomAILevel {
    HCAILevel *aiLevel = HCAILevel.new;
    aiLevel.borderCheckDistance = [MathUtils randomDoubleBetweenA:100 B:200];
    return aiLevel;
}

@end
