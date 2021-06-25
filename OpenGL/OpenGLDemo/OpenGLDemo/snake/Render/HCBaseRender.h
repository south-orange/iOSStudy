//
//
//  HCBaseRender.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/21.
//  
//
    

#import <Foundation/Foundation.h>
#import "HCSnakeGLKView.h"
#import "HCSnakeDataManager.h"

NS_ASSUME_NONNULL_BEGIN
@class HCSnakeGLKView;
@class HCSnakeDataManager;

@interface HCBaseRender : NSObject

@property(nonatomic, weak) HCSnakeGLKView *glkView;
@property(nonatomic, weak) HCSnakeDataManager *dataManager;

+ (instancetype)renderWithGLKView:(HCSnakeGLKView *)glkView dataManager:(HCSnakeDataManager *)dataManager;

- (void)render;

@end

NS_ASSUME_NONNULL_END
