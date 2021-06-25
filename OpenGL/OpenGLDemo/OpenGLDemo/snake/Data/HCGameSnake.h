//
//
//  HCGameSnake.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/15.
//  
//
    

#import <Foundation/Foundation.h>
#import "HCSnakeNode.h"
#import "HCSnakeSkinCollection.h"
#import "HCCircularQueue.h"

@class HCMapDataManger;
@class HCSnakeNode;
NS_ASSUME_NONNULL_BEGIN

@interface HCGameSnake : NSObject

@property(nonatomic, assign) NSInteger snakeId;
@property(nonatomic, strong, readonly) NSString *snakeIdString;
@property(nonatomic, assign, readonly) BOOL isMySnake;

@property(nonatomic, assign) CGFloat direction;
@property(nonatomic, assign) CGFloat expectDirection;

@property(nonatomic, assign) CGFloat speed;// 0-1, 需要通过最大速度计算

@property(nonatomic, assign, readonly) NSUInteger length;
@property(nonatomic, assign) CGFloat width;

@property(nonatomic, strong) HCCircularQueue<HCSnakeNode *> *bodyNodeQueue;

@property(nonatomic, strong) HCSnakeSkinCollection *headSkin;
@property(nonatomic, strong) HCSnakeSkinCollection *bodySkin;

@property(nonatomic, weak) HCMapDataManger *mapDataManager;

+ (void)clearSnakeId;

+ (instancetype)randomPlayerSnakeWithSnakeId:(NSInteger)snakeId length:(NSUInteger)length headCenter:(HCGLPoint)center;

- (void)move;

- (void)die;

- (HCSnakeNode *)headNode;
- (void)printLog;

@end

NS_ASSUME_NONNULL_END
