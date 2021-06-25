//
//
//  HCGLTextureProgram.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/25.
//  
//
    

#import "HCGLBaseProgram.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCGLTextureProgram : HCGLBaseProgram

- (void)predrawTextureArray:(NSArray<NSNumber *>*)textureArray;

@end

NS_ASSUME_NONNULL_END
