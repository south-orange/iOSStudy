//
//  ViewController.m
//  PerformSelectorDemo
//
//  Created by wepie on 2021/3/23.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self performSelector:@selector(funTest)];
    //[self performSelector:@selector(funTest:) withObject:@"Hello performSelector"];
    
//    NSLog(@"performSelector delay 5s");
//    [self performSelector:@selector(funTest:) withObject:@"delay 5" afterDelay:5];
    
//    [self performSelectorOnMainThread:@selector(funTest) withObject:nil waitUntilDone:YES];
//    NSLog(@"wait");
    
//    [self performSelectorInBackground:@selector(funTest) withObject:nil];
}

- (void)funTest {
    NSLog(@"funTest!");
}

- (void)funTest:(NSString *)str {
    NSLog(@"funTest! %@", str);
}


@end
