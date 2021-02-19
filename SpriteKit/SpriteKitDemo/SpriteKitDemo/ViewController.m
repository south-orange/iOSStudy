//
//  ViewController.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/19.
//

#import "ViewController.h"
#import "HCSimpleViewController.h"
#import "HCGameViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.view addSubview:HCSimpleViewController.new.view];
    HCGameViewController *gameController = HCGameViewController.new;
    gameController.view.frame = self.view.bounds;
    [gameController configGame];
    [self.view addSubview:gameController.view];
}


@end
