//
//  ViewController.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/19.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HCView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HCView *view = [HCView.alloc initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}


@end
