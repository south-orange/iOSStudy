//
//
//  HCGeneralAIUtils.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/28.
//  
//
    

#import "HCGeneralAIUtils.h"
#import "HCGameSnake.h"
#import "HCMapDataManager.h"
#import "MathUtils.h"

@implementation HCGeneralAIUtils

+ (void)performAiSnake:(HCGameSnake *)snake mapManager:(HCMapDataManager *)mapManager mySnake:(HCGameSnake *)mySnake {
    if (snake.isMySnake || snake.isDead) return;
    
    if ([self avoidWallWithSnake:snake mapManager:mapManager]) {
        return;
    }
    [self randomWalkSnake:snake];
}

// 避免撞墙
+ (BOOL)avoidWallWithSnake:(HCGameSnake *)snake mapManager:(HCMapDataManager *)mapManager {
    CGFloat avoidDirection = -1;
    HCGLPoint center = snake.headNode.center;
    CGFloat borderCheckDistance = snake.aiLevel.borderCheckDistance;
    if (center.x - borderCheckDistance < -mapManager.mapSize.width / 2) {
        avoidDirection = 0;
    } else if (center.x + borderCheckDistance > mapManager.mapSize.width / 2) {
        avoidDirection = M_PI;
    } else if (center.y - borderCheckDistance < -mapManager.mapSize.height / 2) {
        avoidDirection = M_PI_2;
    } else if (center.y + borderCheckDistance > mapManager.mapSize.height / 2) {
        avoidDirection = M_PI + M_PI_2;
    }
    if (avoidDirection != -1) {
        CGFloat random = [MathUtils randomDoubleBetweenA:-M_PI / 18 B:M_PI / 18];
        CGFloat dir = avoidDirection + random;
        snake.expectDirection = [MathUtils getValidDirection:dir];
        return YES;
    }
    return NO;
}

// 随机改变方向
+ (void)randomWalkSnake:(HCGameSnake *)snake {
    CGFloat directionRandom = [MathUtils randomDoubleBetweenA:0 B:1];
    if (directionRandom < 0.02) {
        CGFloat random = [MathUtils randomDoubleBetweenA:-M_PI / 6 B:M_PI / 6];
        CGFloat dir = snake.direction + random;
        snake.expectDirection = [MathUtils getValidDirection:dir];
    }
}

@end
