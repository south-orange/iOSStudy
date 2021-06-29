//
//
//  HCGeneralAIUtils.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/28.
//  
//
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HCGameSnake;
@class HCMapDataManger;

@interface HCGeneralAIUtils : NSObject

+ (void)performAiSnake:(HCGameSnake *)snake mapManager:(HCMapDataManger *)mapManager mySnake:(HCGameSnake *)mySnake;

@end

NS_ASSUME_NONNULL_END
