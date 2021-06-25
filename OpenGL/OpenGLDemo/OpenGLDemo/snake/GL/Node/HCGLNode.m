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
        
        [self p_calculateVertexArray];
        
        _nodeId = nodeNum;
        nodeNum ++;
    }
    return self;
}

- (instancetype)initWithPosition:(HCGLPoint)position size:(HCGLSize)size direction:(GLfloat)direction {
    return [self initWithPosition:position size:size direction:direction alpha:1.0];
}

- (void)setPosition:(HCGLPoint)position {
    _position = position;
    [self p_calculateVertexArray];
}

- (void)setSize:(HCGLSize)size {
    _size = size;
    [self p_calculateVertexArray];
}

- (void)setDirection:(GLfloat)direction {
    _direction = direction;
    [self p_calculateVertexArray];
}

- (void)setAlpha:(GLfloat)alpha {
    _alpha = alpha;
    [self p_calculateVertexArray];
}
    
- (void)p_calculateVertexArray {
    
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"%lf,%lf,%lf,%lf,%lf,%lf,%d", self.position.x, self.position.y, self.size.width, self.size.height, self.direction, self.alpha, self.hidden];
}

- (BOOL)isEqual:(HCGLNode *)object {
    return [self.toString isEqualToString:object.toString];
}

@end
