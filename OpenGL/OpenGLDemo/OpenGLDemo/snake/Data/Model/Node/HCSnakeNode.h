//
//
//  HCSnakeNode.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/16.
//  
//
    

#import "HCMapNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCSnakeNode : HCMapNode

@property(nonatomic, assign) NSInteger snakeId;

+ (instancetype)nodeWithNode:(HCSnakeNode *)otherNode;

@end

NS_ASSUME_NONNULL_END
