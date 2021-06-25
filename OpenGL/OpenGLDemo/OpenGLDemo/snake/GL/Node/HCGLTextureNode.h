//
//
//  HCGLTextureNode.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/27.
//  
//
    

#import "HCGLNode.h"
#import "HCGLTexture.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCGLTextureNode : HCGLNode {
    @public
    HCGLTextureNodeVertex _textureVertexArray[kHCGLVertexCount];
}

@property(nonatomic, strong) HCGLTexture *texture;

- (instancetype)initWithPosition:(HCGLPoint)position texture:(HCGLTexture *)texture;

- (void)updateTextureIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
