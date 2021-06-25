//
//
//  HCGLDrawer.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/25.
//  
//
    

#import "HCGLDrawer.h"
#import "HCGLBaseProgram.h"

@implementation HCGLDrawer

- (void)dealloc {
    NSLog(@"dealloc %@", self);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.linkList = HCLinkList.new;
    }
    return self;
}

- (void)drawWithProgram:(HCGLBaseProgram *)program {
    
}

@end
