//
//  HCTriViewController.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/20.
//

#import "HCTriViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HCTriScene.h"

@interface HCTriViewController ()

@end

@implementation HCTriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HCTriScene *scene = [HCTriScene.alloc initWithSize:self.view.bounds.size];
    SKView *skView = (SKView *)self.view;
    [skView presentScene:scene];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.ignoresSiblingOrder = YES;
    scene.scaleMode = SKSceneScaleModeResizeFill;
}

@end
