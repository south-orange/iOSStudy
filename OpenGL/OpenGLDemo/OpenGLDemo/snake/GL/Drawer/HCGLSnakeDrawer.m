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

- (void)updateDataWithKey:(NSString *)key dataList:(HCLinkList *)dataList textureArray:(NSArray *)textureArray {
    HCGLSnakeDrawer *drawer = self.snakeDrawerDic[key];
    if (drawer == nil) {
        drawer = [HCGLSnakeDrawer.alloc initWithCapacity:10];
        drawer.textureManager = self.textureManager;
        [self.snakeDrawerDic setValue:drawer forKey:key];
    }
    drawer.linkList = dataList;
    drawer.textureArray = [NSMutableArray arrayWithArray:textureArray];
}

- (void)removeSnakeDrawerWithKey:(NSString *)key {
    [self.snakeDrawerDic removeObjectForKey:key];
}

- (void)drawWithProgram:(HCGLTextureProgram *)program {
    NSArray<NSString *> *sortedArray = [self.snakeDrawerDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        return [obj1 integerValue] < [obj2 integerValue];
    }];
    for (NSString *key in sortedArray) {
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
