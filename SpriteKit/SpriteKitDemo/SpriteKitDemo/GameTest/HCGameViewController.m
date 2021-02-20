//
//  HCGameViewController.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/19.
//

#import "HCGameViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HCGameScene.h"

@interface HCGameViewController ()

@end

@implementation HCGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HCGameScene *gameScene = [HCGameScene.alloc initWithSize:self.view.bounds.size];
    SKView *skView = (SKView *)self.view;
    [skView presentScene:gameScene];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.ignoresSiblingOrder = YES;
    gameScene.scaleMode = SKSceneScaleModeResizeFill;
}

@end
