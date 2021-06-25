//
//
//  HCGLColorNode.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/27.
//  
//
    

#import "HCGLNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCGLColorNode : HCGLNode {
    @public
    HCGLColorNodeVertex _colorVertexArray[kHCGLVertexCount];
}

- (void)setColorWithHex:(uint32_t)hex alpha:(GLfloat)alpha;
- (void)setColorWithHex:(uint32_t)hex;

- (instancetype)initWithPosition:(HCGLPoint)position size:(HCGLSize)size colorHex:(uint32_t)hex alpha:(GLfloat)alpha;

@end

NS_ASSUME_NONNULL_END
