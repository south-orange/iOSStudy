//
//
//  HCMapNode.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/16.
//  
//
    

#import "HCLinkList.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCMapNode : NSObject

@property(nonatomic, assign) HCGLSize size;
@property(nonatomic, assign) HCGLPoint center;
@property(nonatomic, assign) float direction;

+ (instancetype)nodeWithNode:(HCMapNode *)otherNode;

@end

NS_ASSUME_NONNULL_END
