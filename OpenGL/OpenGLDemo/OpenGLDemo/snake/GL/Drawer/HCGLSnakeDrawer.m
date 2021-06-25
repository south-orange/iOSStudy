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

- (void)drawWithProgram:(HCGLTextureProgram *)program {
    for (HCGLSnakeDrawer *drawer in self.snakeDrawerDic.allValues) {
        [drawer drawWithProgram:program];
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
