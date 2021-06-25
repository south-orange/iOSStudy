//
//
//  HCMapDataManger.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/16.
//  
//
    

#import "HCMapDataManger.h"
#import "HCLinkList.h"
#import "GameConfig.h"
#import "HCMapNode.h"

@interface HCMapDataManger ()

@property(nonatomic, assign) NSUInteger widthCellCount;
@property(nonatomic, assign) NSUInteger heightCellCount;

@property(nonatomic, strong) NSMutableArray<NSMutableSet *> *mapCellArray;

@end

@implementation HCMapDataManger

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (void)setMapSize:(HCGLSize)mapSize {
    _mapSize = mapSize;
    self.widthCellCount = ceil(mapSize.width / MAP_UNIT);
    self.heightCellCount = ceil(mapSize.height / MAP_UNIT);
    self.mapCellArray = [NSMutableArray arrayWithCapacity:self.widthCellCount * self.heightCellCount];
    for (NSUInteger i = 0;i < self.widthCellCount * self.heightCellCount;i ++) {
        [self.mapCellArray addObject:NSMutableSet.set];
    }
}

- (void)addNode:(HCMapNode *)node {
    NSUInteger leftIndex = (node.center.x - node.size.width / 2) / MAP_UNIT + _widthCellCount / 2;
    NSUInteger topIndex = (node.center.y + node.size.width / 2) / MAP_UNIT + _heightCellCount / 2;
    NSUInteger rightIndex = (node.center.x + node.size.width / 2) / MAP_UNIT + _widthCellCount / 2;
    NSUInteger bottomIndex = (node.center.y - node.size.width / 2) / MAP_UNIT + _heightCellCount / 2;
    if (leftIndex < 0) leftIndex = 0;
    if (topIndex >= self.heightCellCount) topIndex = self.heightCellCount - 1;
    if (rightIndex >= self.widthCellCount) rightIndex = self.widthCellCount - 1;
    if (bottomIndex < 0) bottomIndex = 0;
    for (NSUInteger i = leftIndex;i <= rightIndex;i ++) {
        for (NSUInteger j = bottomIndex;j <= topIndex;j ++) {
            NSUInteger cellIndex = j + self.widthCellCount * i;
            [self.mapCellArray[cellIndex] addObject:node];
        }
    }
}

- (void)removeNode:(HCMapNode *)node {
    NSUInteger leftIndex = (node.center.x - node.size.width / 2) / MAP_UNIT + _widthCellCount / 2;
    NSUInteger topIndex = (node.center.y + node.size.width / 2) / MAP_UNIT + _heightCellCount / 2;
    NSUInteger rightIndex = (node.center.x + node.size.width / 2) / MAP_UNIT + _widthCellCount / 2;
    NSUInteger bottomIndex = (node.center.y - node.size.width / 2) / MAP_UNIT + _heightCellCount / 2;
    if (leftIndex < 0) leftIndex = 0;
    if (topIndex >= self.heightCellCount) topIndex = self.heightCellCount - 1;
    if (rightIndex >= self.widthCellCount) rightIndex = self.widthCellCount - 1;
    if (bottomIndex < 0) bottomIndex = 0;
    for (NSUInteger i = leftIndex;i <= rightIndex;i ++) {
        for (NSUInteger j = bottomIndex;j <= topIndex;j ++) {
            NSUInteger cellIndex = j + self.widthCellCount * i;
            [self.mapCellArray[cellIndex] removeObject:node];
        }
    }
}

@end
