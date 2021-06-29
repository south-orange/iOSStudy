//
//
//  HCAILevel.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/28.
//  
//
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCAILevel : NSObject

@property(nonatomic, assign) CGFloat borderCheckDistance;

+ (instancetype)randomAILevel;

@end

NS_ASSUME_NONNULL_END
