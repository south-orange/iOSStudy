//
//
//  HCSnakeSkinCollection.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/21.
//  
//
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface HCSnakeSkin : NSObject

@property(nonatomic, strong) NSString *url;
@property(nonatomic, assign) NSUInteger stayTime;

@end

@interface HCSnakeSkinCollection : NSObject

@property(nonatomic, strong) NSArray<HCSnakeSkin *> *skinArray;

- (NSString *)getSkinWithTimestamp:(NSUInteger)timestamp;

@end

NS_ASSUME_NONNULL_END
