//
//  ViewController.m
//  OpenGLDemo
//
//  Created by wepie on 2021/3/15.
//

#import "ViewController.h"
#import "HCSnakeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *enter = UIButton.new;
    [enter setTitle:@"进入" forState:UIControlStateNormal];
    [enter setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    enter.backgroundColor = UIColor.yellowColor;
    enter.frame = CGRectMake(200, 200, 100, 50);
    [enter addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enter];
}

- (void)enter {
    [self presentViewController:HCSnakeViewController.new animated:YES completion:nil];
}


@end
