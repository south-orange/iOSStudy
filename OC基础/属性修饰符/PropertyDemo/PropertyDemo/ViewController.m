//
//  ViewController.m
//  PropertyDemo
//
//  Created by wepie on 2021/2/18.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy)NSString *stringCopy;
@property (nonatomic, strong)NSString *stringStrong;
@property (nonatomic, copy)NSMutableString *mutableStringCopy;
@property (nonatomic, strong)NSMutableString *mutableStringStrong;

@property (nonatomic, weak) UIView *weakPoint;
@property (nonatomic, assign) UIView *assignPoint;

//@property(nonatomic, strong)CGFloat floatStrong;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view = UIView.new;
    view.backgroundColor = UIColor.redColor;
    self.weakPoint = view;
    self.assignPoint = view;
}

//比较ARC下strong和copy
- (IBAction)strongAndCopy:(UIButton *)sender {
    NSString *s1 = @"132";
    self.stringCopy = s1;
    self.stringStrong = s1;
    self.mutableStringCopy = s1;
    self.mutableStringStrong = s1;
    s1 = @"123";
    NSLog(@"%@,%@,%@,%@",self.stringCopy, self.stringStrong, self.mutableStringCopy, self.mutableStringStrong);
    NSLog(@"%p,%p,%p,%p,%p",self.stringCopy, self.stringStrong, self.mutableStringCopy, self.mutableStringStrong,s1);
    //132,132,132,132
    
    NSMutableString *s2 = [NSMutableString.alloc initWithString:@"132"];
    self.stringCopy = s2;
    self.stringStrong = s2;
    self.mutableStringCopy = s2;
    self.mutableStringStrong = s2;
    NSLog(@"%p,%p,%p",self.stringCopy, [s2 copy], [s2 mutableCopy]);
    [s2 appendString:@"1"];
    NSLog(@"%@,%@,%@,%@",self.stringCopy, self.stringStrong, self.mutableStringCopy, self.mutableStringStrong);
    NSLog(@"%p,%p,%p,%p,%p,%p,%p",self.stringCopy, self.stringStrong, self.mutableStringCopy, self.mutableStringStrong,s2,[s2 copy], [s2 mutableCopy]);
    //132,1321,132,1321
}

//比较weak和assign
- (IBAction)assignAndWeak:(id)sender {
    NSLog(@"weak属性：%@",self.weakPoint);
    NSLog(@"assign属性：%@",self.assignPoint);//会产生野指针
}

@end
