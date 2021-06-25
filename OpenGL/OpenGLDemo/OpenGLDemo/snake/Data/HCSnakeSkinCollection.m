//
//
//  HCSnakeSkinCollection.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/21.
//  
//
    

#import "HCSnakeSkinCollection.h"

@implementation HCSnakeSkin

@end

@interface HCSnakeSkinCollection ()

@property(nonatomic, strong) NSArray<NSNumber *> *skinIndexArray;

@end

@implementation HCSnakeSkinCollection

- (void)setSkinArray:(NSArray<HCSnakeSkin *> *)skinArray {
    _skinArray = skinArray;
    [self p_calculateIndex];
}

- (void)p_calculateIndex {
    NSMutableArray *indexArray = NSMutableArray.array;
    [self.skinArray enumerateObjectsUsingBlock:^(HCSnakeSkin * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (int i = 0;i < obj.stayTime;i ++) {
            [indexArray addObject:@(idx)];
        }
    }];
    self.skinIndexArray = indexArray;
}

- (NSString *)getSkinWithTimestamp:(NSUInteger)timestamp {
    NSUInteger index = timestamp % self.skinIndexArray.count;
    return self.skinArray[self.skinIndexArray[index].unsignedIntegerValue].url;
}

@end
