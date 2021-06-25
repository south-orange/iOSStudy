//
//
//  HCGLTextureDrawer.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/26.
//  
//
    

#import "HCGLDrawer.h"

NS_ASSUME_NONNULL_BEGIN
@class HCGLTextureManager;
@class HCGLTextureProgram;

@interface HCGLTextureDrawer : HCGLDrawer

@property(nonatomic, strong) NSMutableArray<NSNumber *> *textureArray;
@property(nonatomic, assign) BOOL reloadTextureEveryTime;
@property(nonatomic, weak) HCGLTextureManager *textureManager;

- (instancetype)initWithCapacity:(NSUInteger)capacity;

- (void)drawWithProgram:(HCGLTextureProgram *)program;

@end

NS_ASSUME_NONNULL_END
