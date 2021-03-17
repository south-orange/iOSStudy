//
//  HCSnakeViewController.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/23.
//

#import "HCSnakeViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HCSnakeScene.h"

@interface HCSnakeViewController ()

@end

@implementation HCSnakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)configScene {
    HCSnakeScene *scene = [HCSnakeScene.alloc initWithSize:self.view.bounds.size];
    SKView *skView = (SKView *)self.view;
    [skView presentScene:scene];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    scene.scaleMode = SKSceneScaleModeResizeFill;
}

@end
