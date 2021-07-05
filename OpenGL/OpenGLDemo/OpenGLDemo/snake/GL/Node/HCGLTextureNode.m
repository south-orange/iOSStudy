//
//
//  HCGLTextureNode.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/27.
//  
//
    

#import "HCGLTextureNode.h"

@implementation HCGLTextureNode

- (instancetype)initWithPosition:(HCGLPoint)position texture:(HCGLTexture *)texture {
    self = [super initWithPosition:position size:texture.size direction:0.0];
    if (self) {
        self.texture = texture;
    }
    return self;
}

- (void)calculateVertexArray {
    if (!self.texture || self.hidden) {
        return;
    }
    GLfloat x = self.position.x;
    GLfloat y = self.position.y;
    float w_2 = self.size.width / 2;
    float h_2 = self.size.height / 2;
    
    float cr = cosf(self.direction);
    float sr = sinf(self.direction);
    
    // 矩形点的位置如下
    // b   c
    // a   d
    
    _textureVertexArray[0].position = GLKVector2Make(x + rotate(YES, -h_2, -w_2, cr, sr), y + rotate(NO, -h_2, -w_2, cr, sr));// 左下
    _textureVertexArray[1].position = GLKVector2Make(x + rotate(YES, -h_2, w_2, cr, sr), y + rotate(NO, -h_2, w_2, cr, sr));// 左上
    _textureVertexArray[2].position = GLKVector2Make(x + rotate(YES, h_2, w_2, cr, sr), y + rotate(NO, h_2, w_2, cr, sr));// 右上
    _textureVertexArray[3].position = GLKVector2Make(x + rotate(YES, h_2, -w_2, cr, sr), y + rotate(NO, h_2, -w_2, cr, sr));// 右下

    [self calculateVertexArrayTexture];
}

- (void)calculateVertexArrayTexture {
    if (!self.texture || self.hidden) {
        return;
    }
    
    float tx = _texture.frame.x;
    float ty = _texture.frame.y;
    float tw = _texture.frame.width;
    float th = _texture.frame.height;
    
    _textureVertexArray[0].textureAndAlpha.x = tx + 1 * tw;//左下 (1, 0)
    _textureVertexArray[0].textureAndAlpha.y = ty + 0 * th;
    _textureVertexArray[1].textureAndAlpha.x = tx + 0 * tw;//左上 (0, 0)
    _textureVertexArray[1].textureAndAlpha.y = ty + 0 * th;
    _textureVertexArray[2].textureAndAlpha.x = tx + 0 * tw;//右上 (0, 1)
    _textureVertexArray[2].textureAndAlpha.y = ty + 1 * th;
    _textureVertexArray[3].textureAndAlpha.x = tx + 1 * tw;//右下 (1, 1)
    _textureVertexArray[3].textureAndAlpha.y = ty + 1 * th;
    
    for (int i = 0;i < kHCGLVertexCount;i ++) {
        _textureVertexArray[i].textureAndAlpha.z = _texture.textureIndex;
        _textureVertexArray[i].textureAndAlpha.w = self.alpha;
    }
}

- (void)updateTextureIndex:(NSUInteger)index {
    for (int i = 0;i < kHCGLVertexCount;i ++) {
        _textureVertexArray[i].textureAndAlpha.z = _texture.textureIndex;
    }
}

@end
