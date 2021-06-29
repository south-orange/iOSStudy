//
//
//  HCBaseRender.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/21.
//  
//
    

#import "HCBaseRender.h"

@implementation HCBaseRender

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

+ (instancetype)renderWithGLKView:(HCSnakeGLKView *)glkView dataManager:(HCSnakeDataManager *)dataManager {
    HCBaseRender *render = [self new];
    render.glkView = glkView;
    render.dataManager = dataManager;
    return render;
}

- (void)render {
    
}

@end
