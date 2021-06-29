//
//
//  HCBaseEventHandler.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/25.
//  
//
    

#import "HCBaseEventHandler.h"
#import "HCSnakeDataManager.h"

@implementation HCBaseEventHandler

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (void)update {
    
}

- (void)updateWithTimestamp:(NSUInteger)timestamp {
    self.timestamp = timestamp;
    [self update];
}

@end
