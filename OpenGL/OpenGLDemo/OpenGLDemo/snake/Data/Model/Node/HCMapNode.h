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

@interface HCMapNode : NSObject {
    @public
    HCGLPoint _points[4];
}

@property(nonatomic, assign) HCGLSize size;
@property(nonatomic, assign) HCGLPoint center;
@property(nonatomic, assign) float direction;

@property(nonatomic, assign) BOOL hasCalculated;

+ (instancetype)nodeWithNode:(HCMapNode *)otherNode;

- (HCGLRect)nodeGLRect;
- (CGRect)nodeCGRect;

- (void)calculatePoints;

@end

NS_ASSUME_NONNULL_END
