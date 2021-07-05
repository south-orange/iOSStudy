//
//
//  HCGLColorNode.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/27.
//  
//
    

#import "HCGLColorNode.h"

@interface HCGLColorNode ()

@property(nonatomic, assign) GLubyte r;
@property(nonatomic, assign) GLubyte g;
@property(nonatomic, assign) GLubyte b;
@property(nonatomic, assign) GLubyte a;


@end

@implementation HCGLColorNode

- (void)setColorWithHex:(uint32_t)hex alpha:(GLfloat)alpha {
    self.r = (hex >> 16) & 0xff;
    self.g = (hex >> 8) & 0xff;
    self.b = hex& 0xff;
    self.a = alpha * 255;
    self.alpha = self.a;
}

- (void)setColorWithHex:(uint32_t)hex {
    [self setColorWithHex:hex alpha:1.0];
}

- (instancetype)initWithPosition:(HCGLPoint)position size:(HCGLSize)size colorHex:(uint32_t)hex alpha:(GLfloat)alpha {
    self = [super initWithPosition:position size:size direction:0.0];
    if (self) {
        [self setColorWithHex:hex alpha:alpha];
    }
    return self;
}

- (instancetype)initWithPosition:(HCGLPoint)position size:(HCGLSize)size direction:(GLfloat)direction {
    return [super initWithPosition:position size:size direction:direction alpha:0.0];
}

- (void)calculateVertexArray {
    if (self.alpha == 0) {
        return;
    }
    float w_2 = self.size.width / 2;
    float h_2 = self.size.height / 2;
    
    float cr = cosf(self.direction);
    float sr = sinf(self.direction);
    
    _colorVertexArray[0].position = GLKVector2Make(rotate(YES, -w_2, h_2, cr, sr), rotate(NO, -w_2, h_2, cr, sr));// 左上
    _colorVertexArray[1].position = GLKVector2Make(rotate(YES, w_2, h_2, cr, sr), rotate(NO, w_2, h_2, cr, sr));// 右上
    _colorVertexArray[2].position = GLKVector2Make(rotate(YES, w_2, -h_2, cr, sr), rotate(NO, w_2, -h_2, cr, sr));// 右下
    _colorVertexArray[3].position = GLKVector2Make(rotate(YES, -w_2, -h_2, cr, sr), rotate(NO, -w_2, -h_2, cr, sr));// 左下
    
    for (int i = 0;i < kHCGLVertexCount;i ++) {
        _colorVertexArray[i].color = GLKVector4Make(self.r, self.g, self.b, self.a);
    }
}

@end
