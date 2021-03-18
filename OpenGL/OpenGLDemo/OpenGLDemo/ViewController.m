//
//  ViewController.m
//  OpenGLDemo
//
//  Created by wepie on 2021/3/15.
//

#import "ViewController.h"
#import "HCGLKView01.h"
#import "HCGLKView02.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HCGLKView01 *glkView = [HCGLKView01.alloc initWithFrame:self.view.frame];
    [self.view addSubview:glkView];
//    HCGLKView02 *glkView = [HCGLKView02.alloc initWithFrame:self.view.frame];
//    [self.view addSubview:glkView];
//    [glkView display];
}


@end
