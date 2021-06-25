//
//
//  HCRenderManager.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/21.
//  
//
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HCSnakeGLKView;
@class HCSnakeDataManager;

@interface HCRenderManager : NSObject

+ (instancetype)managerWithGLKView:(HCSnakeGLKView *)glkView dataManager:(HCSnakeDataManager *)dataManager;

- (void)render;

@end

NS_ASSUME_NONNULL_END
