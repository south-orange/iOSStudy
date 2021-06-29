//
//
//  HCSnakeDataManager.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/27.
//  
//
    

#import <Foundation/Foundation.h>
#import "HCMapDataManger.h"
#import "HCGameSnake.h"
#import "HCSnakeGLKView.h"
#import "HCBaseEventHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCSnakeDataManager : NSObject

@property(nonatomic, weak) HCSnakeGLKView *glkView;

@property(nonatomic, assign) NSUInteger timestamp;

@property(nonatomic, strong) NSMutableArray<HCGameSnake *> *snakeArray;
@property(nonatomic, strong) HCGameSnake *mySnake;

@property(nonatomic, strong) HCMapDataManger *mapDataManager;

@property(nonatomic, strong) NSArray<__kindof HCBaseEventHandler *> *eventHandlerArray;

- (void)updateDatas;

- (void)addRandomSnake;
- (void)removeSnake:(HCGameSnake *)snake;

@end

NS_ASSUME_NONNULL_END
