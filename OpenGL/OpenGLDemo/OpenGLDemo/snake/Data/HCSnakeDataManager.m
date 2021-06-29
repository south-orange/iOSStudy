//
//
//  HCSnakeDataManager.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/27.
//  
//
    

#import "HCSnakeDataManager.h"
#import "HCSnakeMoveHandler.h"
#import "HCSnakeBehaviorHandler.h"
#import "GameConfig.h"
#import "MathUtils.h"

@implementation HCSnakeDataManager

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapDataManager = HCMapDataManger.new;
        self.mapDataManager.mapSize = HCGLSizeMake(MAP_WIDTH, MAP_HEIGHT);
        self.snakeArray = NSMutableArray.array;
        self.mySnake = [HCGameSnake randomPlayerSnakeWithSnakeId:MY_SNAKE_ID length:300 headCenter:[self randomHeadPosition:YES]];
        self.mySnake.mapDataManager = self.mapDataManager;
        [self.snakeArray addObject:self.mySnake];
        
        self.eventHandlerArray = @[HCSnakeMoveHandler.new, HCSnakeBehaviorHandler.new];
        
        for (HCBaseEventHandler *handler in self.eventHandlerArray) {
            handler.dataManager = self;
        }
    }
    return self;
}

- (void)updateDatas {
    for (HCBaseEventHandler *handler in self.eventHandlerArray) {
        [handler update];
    }
    self.timestamp ++;
}

- (void)addRandomSnake {
    HCGameSnake *snake = [HCGameSnake randomPlayerSnakeWithSnakeId:-1 length:300 headCenter:[self randomHeadPosition:NO]];
    snake.mapDataManager = self.mapDataManager;
    snake.speed = 0.5;
    [self.snakeArray addObject:snake];
    [snake printLog];
}

- (void)removeSnake:(HCGameSnake *)snake {
    [self.snakeArray removeObject:snake];
}

- (HCGLPoint)randomHeadPosition:(BOOL)isMySnake {
    CGFloat border = SNAKE_BORDER;
    if (isMySnake) {
        border = MY_SNAKE_BORDER;
    }
    HCGLRect rect = HCGLRectMake(border, border, self.mapDataManager.mapSize.width - 2 * border, self.mapDataManager.mapSize.height - 2 * border);
    HCGLPoint point = [MathUtils randomGLPointInRect:rect];
    return HCGLPointMake(point.x - self.mapDataManager.mapSize.width / 2, point.y - self.mapDataManager.mapSize.height / 2);
}

@end
