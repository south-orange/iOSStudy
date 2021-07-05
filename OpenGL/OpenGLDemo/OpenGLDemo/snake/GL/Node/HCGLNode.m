//
//
//  HCGLNode.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/26.
//  
//
    

#import "HCGLNode.h"

static NSUInteger nodeNum = 0;

@implementation HCGLNode

- (instancetype)initWithPosition:(HCGLPoint)position size:(HCGLSize)size direction:(GLfloat)direction alpha:(GLfloat)alpha {
    self = [super init];
    if (self) {
        _position = position;
        _size = size;
        _direction = direction;
        _alpha = alpha;
        
        _nodeId = nodeNum;
        nodeNum ++;
    }
    return self;
}

- (instancetype)initWithPosition:(HCGLPoint)position size:(HCGLSize)size direction:(GLfloat)direction {
    return [self initWithPosition:position size:size direction:direction alpha:1.0];
}
    
- (void)calculateVertexArray {
    
}

@end
