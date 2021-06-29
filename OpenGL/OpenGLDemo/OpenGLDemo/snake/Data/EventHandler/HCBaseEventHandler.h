//
//
//  HCBaseEventHandler.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/25.
//  
//
    

#import <Foundation/Foundation.h>
#import "MathUtils.h"

NS_ASSUME_NONNULL_BEGIN

@class HCSnakeDataManager;

@interface HCBaseEventHandler : NSObject

@property(nonatomic, weak) HCSnakeDataManager *dataManager;
@property(nonatomic, assign) NSUInteger timestamp;

- (void)update;
- (void)updateWithTimestamp:(NSUInteger)timestamp;

@end

NS_ASSUME_NONNULL_END
