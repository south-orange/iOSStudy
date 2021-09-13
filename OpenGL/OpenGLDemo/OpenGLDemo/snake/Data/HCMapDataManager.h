//
//
//  HCMapDataManager.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/16.
//  
//
    

#import <Foundation/Foundation.h>

@class HCMapNode;

NS_ASSUME_NONNULL_BEGIN

@interface HCMapDataManager : NSObject

@property(nonatomic, assign) HCGLSize mapSize;

- (void)addNode:(HCMapNode *)node;
- (void)removeNode:(HCMapNode *)node;

@end

NS_ASSUME_NONNULL_END
