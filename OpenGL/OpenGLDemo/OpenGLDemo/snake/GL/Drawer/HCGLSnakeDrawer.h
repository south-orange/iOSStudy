//
//
//  HCGLSnakeDrawer.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/18.
//  
//
    

#import "HCGLTextureDrawer.h"

NS_ASSUME_NONNULL_BEGIN

@class HCGLSnakeDrawer;

@interface HCGLSnakeDrawerManager : NSObject

@property(nonatomic, weak) HCGLTextureManager *textureManager;
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, HCGLSnakeDrawer *> *snakeDrawerDic;

- (void)drawWithProgram:(HCGLTextureProgram *)program;

@end

@interface HCGLSnakeDrawer : HCGLTextureDrawer

@end

NS_ASSUME_NONNULL_END
