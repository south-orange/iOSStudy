//
//
//  HCSnakeGLKView.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/24.
//  
//
    

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HCLinkList;
@class HCGLTextureManager;
@class HCGLSnakeDrawerManager;

@interface HCSnakeGLKView : GLKView

@property(nonatomic, assign) HCGLSize mapSize;

@property(nonatomic, strong) HCGLTextureManager *textureManager;

@property(nonatomic, strong) HCGLSnakeDrawerManager *snakeDrawerManager;

- (void)setup;

- (void)updateCenter:(HCGLPoint)center scale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
