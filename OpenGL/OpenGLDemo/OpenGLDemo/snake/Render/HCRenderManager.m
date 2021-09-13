//
//
//  HCRenderManager.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/21.
//  
//
    

#import "HCRenderManager.h"
#import "HCSnakeRender.h"
#import "HCGLSnakeDrawer.h"

@interface HCRenderManager ()

@property(nonatomic, weak) HCSnakeGLKView *glkView;
@property(nonatomic, weak) HCSnakeDataManager *dataManager;

@property(nonatomic, strong) NSMutableDictionary<NSNumber *, HCSnakeRender *> *snakeRenderDic;

@end

@implementation HCRenderManager

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

+ (instancetype)managerWithGLKView:(HCSnakeGLKView *)glkView dataManager:(HCSnakeDataManager *)dataManager {
    HCRenderManager *manager = [self new];
    manager.glkView = glkView;
    manager.dataManager = dataManager;
    manager.snakeRenderDic = NSMutableDictionary.dictionary;
    return manager;
}

- (void)render {
    
    [self.glkView updateCenter:self.dataManager.mySnake.headNode.center scale:0.1];
    for (HCGameSnake *snake in self.dataManager.snakeArray) {
        NSNumber *snakeId = snake.snakeIdObj;
        if (snake.isDead) {
            [self.snakeRenderDic removeObjectForKey:snakeId];
            [self.glkView.snakeDrawerManager.snakeDrawerDic removeObjectForKey:snakeId];
            continue;
        }
        HCSnakeRender *snakeRender = self.snakeRenderDic[snakeId];
        if (snakeRender == nil) {
            snakeRender = [HCSnakeRender renderWithGLKView:self.glkView dataManager:self.dataManager];
            snakeRender.snake = snake;
            [self.snakeRenderDic setValue:snakeRender forKey:snake.snakeIdObj];
        }
        [snakeRender render];
    }
}

@end
