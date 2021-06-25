//
//
//  HCSnakeNode.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/16.
//  
//
    

#import "HCSnakeNode.h"

@implementation HCSnakeNode

+ (instancetype)nodeWithNode:(HCSnakeNode *)otherNode {
    HCSnakeNode *node = HCSnakeNode.new;
    node.center = otherNode.center;
    node.size = otherNode.size;
    node.direction = otherNode.direction;
    node.snakeId = otherNode.snakeId;
    return node;
}

@end
