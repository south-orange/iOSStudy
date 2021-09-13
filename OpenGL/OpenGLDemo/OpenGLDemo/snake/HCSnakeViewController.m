//
//
//  HCSnakeViewController.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/2.
//  
//
    

#import "HCSnakeViewController.h"
#import "HCSnakeGLKView.h"
#import "HCJoyStickView.h"
#import "HCSnakeDataManager.h"
#import "HCRenderManager.h"

@interface HCSnakeViewController ()

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) HCSnakeGLKView *glkView;

@property(nonatomic, strong) HCSnakeDataManager *dataManager;

@property(nonatomic, strong) HCRenderManager *renderManager;

@property(nonatomic, strong) UILabel *fpsLabel;
@property(nonatomic, assign) CGFloat fpsTime;

@end

@implementation HCSnakeViewController

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataManager = HCSnakeDataManager.new;
    
    self.glkView = [HCSnakeGLKView.alloc initWithFrame:self.view.frame];
    self.glkView.mapSize = self.dataManager.mapDataManager.mapSize;
    [self.glkView setup];
    [self.view addSubview:self.glkView];
    
    self.renderManager = [HCRenderManager managerWithGLKView:self.glkView dataManager:self.dataManager];
    
    UIButton *back = UIButton.new;
    [back setTitle:@"back" forState:UIControlStateNormal];
    [back setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    back.backgroundColor = UIColor.yellowColor;
    back.frame = CGRectMake(0, 0, 100, 50);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIButton *printSnake = UIButton.new;
    [printSnake setTitle:@"printSnake" forState:UIControlStateNormal];
    [printSnake setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    printSnake.backgroundColor = UIColor.redColor;
    printSnake.frame = CGRectMake(200, 0, 100, 50);
    [printSnake addTarget:self action:@selector(printSnake) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printSnake];
    
    UIButton *addSnake = UIButton.new;
    [addSnake setTitle:@"addSnake" forState:UIControlStateNormal];
    [addSnake setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    addSnake.backgroundColor = UIColor.orangeColor;
    addSnake.frame = CGRectMake(300, 0, 100, 50);
    [addSnake addTarget:self action:@selector(addSnake) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addSnake];
    
    self.fpsLabel = UILabel.new;
    self.fpsLabel.frame = CGRectMake(0, 50, 200, 50);
    self.fpsLabel.text = @"FPS: ";
    [self.view addSubview:self.fpsLabel];
    
    HCJoyStickView *joyStickView = HCJoyStickView.new;
    joyStickView.frame = CGRectMake(50, self.view.frame.size.height - 150, 100, 100);
    WEAKSELF
    joyStickView.changeDirectionBlock = ^(CGFloat direction, CGFloat distance) {
        if (distance > 0.1) {
            weakSelf.dataManager.mySnake.expectDirection = direction;
        }
        weakSelf.dataManager.mySnake.speed = distance;
    };
    [self.view addSubview:joyStickView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0 target:self selector:@selector(updateGLKView) userInfo:nil repeats:YES];
    
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)printSnake {
    for (HCGameSnake *snake in self.dataManager.snakeArray) {
        [snake printLog];
    }
}

- (void)addSnake {
    [self.dataManager addRandomSnake];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateGLKView {
    CGFloat start = CFAbsoluteTimeGetCurrent();
    [self.renderManager render];
    NSLog(@"cost 1 %lf", CFAbsoluteTimeGetCurrent() - start);
    start = CFAbsoluteTimeGetCurrent();
    [self.dataManager updateDatas];
    NSLog(@"cost 1 %lf", CFAbsoluteTimeGetCurrent() - start);
    start = CFAbsoluteTimeGetCurrent();
    [self.glkView display];
    NSLog(@"cost 1 %lf", CFAbsoluteTimeGetCurrent() - start);
    NSLog(@"cost \n");
    CGFloat fps = 1 / (CFAbsoluteTimeGetCurrent() - self.fpsTime);
    self.fpsLabel.text = [NSString stringWithFormat:@"fps: %lf", fps];
    self.fpsTime = CFAbsoluteTimeGetCurrent();
}

@end
