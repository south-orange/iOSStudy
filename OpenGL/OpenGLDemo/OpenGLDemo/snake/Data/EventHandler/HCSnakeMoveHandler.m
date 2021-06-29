//
//
//  HCSnakeMoveHandler.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/25.
//  
//
    

#import "HCSnakeMoveHandler.h"
#import "HCSnakeDataManager.h"

@implementation HCSnakeMoveHandler

- (void)update {
    for (HCGameSnake *snake in self.dataManager.snakeArray) {
        if (snake.isDead) continue;
        [snake move];
    }
}

@end
