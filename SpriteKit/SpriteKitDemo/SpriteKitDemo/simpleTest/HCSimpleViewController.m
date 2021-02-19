//
//  HCSimpleViewController.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/19.
//

#import "HCSimpleViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HCView.h"

@interface HCSimpleViewController ()

@end

@implementation HCSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HCView *view = [HCView.alloc initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}

@end
