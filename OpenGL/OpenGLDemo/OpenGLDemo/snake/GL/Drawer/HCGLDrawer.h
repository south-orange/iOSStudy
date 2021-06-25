//
//
//  HCGLDrawer.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/25.
//  
//

#import "HCLinkList.h"
NS_ASSUME_NONNULL_BEGIN
@class HCGLBaseProgram;

@interface HCGLDrawer : NSObject

@property(nonatomic, strong) HCLinkList *linkList;

- (void)drawWithProgram:(HCGLBaseProgram *)program;

@end

NS_ASSUME_NONNULL_END
