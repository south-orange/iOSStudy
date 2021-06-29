//
//
//  HCMapNode.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/16.
//  
//
    

#import "HCMapNode.h"

@implementation HCMapNode

+ (instancetype)nodeWithNode:(HCMapNode *)otherNode {
    HCMapNode *node = HCMapNode.new;
    node.center = otherNode.center;
    node.size = otherNode.size;
    node.direction = otherNode.direction;
    return node;
}

- (CGRect)nodeCGRect {
    return CGRectMake(self.center.x - self.size.width * 0.5, self.center.y - self.size.height * 0.5, self.size.width, self.size.height);
}

- (HCGLRect)nodeGLRect {
    return HCGLRectMake(self.center.x - self.size.width * 0.5, self.center.y - self.size.height * 0.5, self.size.width, self.size.height);
}

@end
