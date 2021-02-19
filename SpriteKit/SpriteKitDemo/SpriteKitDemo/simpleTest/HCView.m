//
//  HCView.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/19.
//

#import "HCView.h"
#import "HCScene.h"

@implementation HCView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.yellowColor;
        HCScene *scene = [HCScene sceneWithSize:self.bounds.size];
        scene.backgroundColor = UIColor.lightGrayColor;
        [self presentScene:scene];
    }
    return self;
}

@end
