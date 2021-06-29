//
//
//  HCSnakeBehaviorHandler.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/28.
//  
//
    

#import "HCSnakeBehaviorHandler.h"
#import "HCSnakeDataManager.h"
#import "HCGeneralAIUtils.h"

@implementation HCSnakeBehaviorHandler

- (void)update {
    if (!self.dataManager.mySnake.isDead) {
        [self checkCollisionWithSnake:self.dataManager.mySnake];
    }
    for (HCGameSnake *snake in self.dataManager.snakeArray) {
        if (snake.isMySnake) continue;
        [self checkCollisionWithSnake:snake];
        [HCGeneralAIUtils performAiSnake:snake mapManager:self.dataManager.mapDataManager mySnake:self.dataManager.mySnake];
    }
}

- (void)checkCollisionWithSnake:(HCGameSnake *)snake {
    if (snake.isDead) {
        return;
    }
    if ([self checkCollisionBetweenWallAndSnake:snake]) {
        return;
    }
}

- (BOOL)checkCollisionBetweenWallAndSnake:(HCGameSnake *)snake {
    HCGLSize mapSize = self.dataManager.mapDataManager.mapSize;
    if ([MathUtils isCollideBetweenA:snake.headNode.nodeGLRect B:HCGLRectMake(-mapSize.width / 2, -mapSize.height / 2, mapSize.width, mapSize.height)]) {
        [snake die];
        return YES;
    }
    return NO;
}

@end
