//
//  ViewController.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/19.
//

#import "ViewController.h"
#import "HCSimpleViewController.h"
#import "HCGameViewController.h"
#import "HCTriViewController.h"
#import "HCSnakeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.view addSubview:HCSimpleViewController.new.view];
    
//    HCGameViewController *gameController = HCGameViewController.new;
//    gameController.view.frame = self.view.bounds;
//    [gameController configGame];
//    [self.view addSubview:gameController.view];
    
//    HCTriViewController *triController = HCTriViewController.new;
//    triController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50);
//    [self.view addSubview:triController.view];
    
    HCSnakeViewController *snakeController = HCSnakeViewController.new;
    snakeController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50);
    [snakeController configScene];
    [self.view addSubview:snakeController.view];
}


@end
