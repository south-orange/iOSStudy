//
//
//  HCGLSnakeDrawer.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/18.
//  
//
    

#import "HCGLSnakeDrawer.h"
#import "HCGLTextureProgram.h"
#import "HCGLTextureManager.h"

@implementation HCGLSnakeDrawerManager

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.snakeDrawerDic = NSMutableDictionary.dictionary;
    }
    return self;
}

- (void)drawWithProgram:(HCGLTextureProgram *)program {
    NSArray<NSNumber *> *sortedArray = [self.snakeDrawerDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber * obj1, NSNumber * obj2) {
        return [obj1 integerValue] < [obj2 integerValue];
    }];
    for (NSNumber *key in sortedArray) {
        [self.snakeDrawerDic[key] drawWithProgram:program];
    }
}

@end

@implementation HCGLSnakeDrawer

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super initWithCapacity:capacity];
    if (self) {
        self.reloadTextureEveryTime = NO;
    }
    return self;
}

@end
