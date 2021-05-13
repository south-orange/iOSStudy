//
//
//  ViewController.m
//  AutoLayoutDemo
//
//  Created by 霍橙 on 2021/5/12.
//  
//
    

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) UIView *redView;
@property(nonatomic, strong) UIView *yellowView;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) NSLayoutConstraint *constraint1;
@property(nonatomic, strong) NSLayoutConstraint *constraint2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.redView];
    [self.view addSubview:self.yellowView];
    [self.view addSubview:self.textLabel];
    
    [self.view addConstraints:@[
        self.constraint1, self.constraint2,
        [NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50],
        [NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50],
        [NSLayoutConstraint constraintWithItem:self.yellowView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50],
        [NSLayoutConstraint constraintWithItem:self.yellowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50],
        [NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.yellowView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
    ]];
    
    UIButton *changeButton = UIButton.new;
    changeButton.frame = CGRectMake(self.view.frame.size.width / 2, 100, 100, 30);
    changeButton.backgroundColor = UIColor.systemPinkColor;
    
    [changeButton addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:changeButton];
}

- (void)changeClick {
    NSLog(@"%@", NSStringFromCGRect(self.redView.frame));
    
    self.constraint1.constant += 10;
//    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
//    [self.view updateConstraintsIfNeeded];
    
    NSLog(@"%@", NSStringFromCGRect(self.redView.frame));

    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
}

- (UIView *)redView {
    if (!_redView) {
        _redView = UIView.new;
        _redView.frame = CGRectMake(0, 0, 50, 50);
        _redView.backgroundColor = UIColor.redColor;
        _redView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _redView;
}

- (UIView *)yellowView {
    if (!_yellowView) {
        _yellowView = UIView.new;
        _yellowView.frame = CGRectMake(0, 0, 50, 50);
        _yellowView.backgroundColor = UIColor.yellowColor;
        _yellowView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _yellowView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = UILabel.new;
        _textLabel.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0);
        _textLabel.text = @"测试";
        [_textLabel sizeToFit];
    }
    return _textLabel;
}

- (NSLayoutConstraint *)constraint1 {
    if (!_constraint1) {
        _constraint1 = [NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-50];
    }
    return _constraint1;
}

- (NSLayoutConstraint *)constraint2 {
    if (!_constraint2) {
        _constraint2 = [NSLayoutConstraint constraintWithItem:self.yellowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:50];
    }
    return _constraint2;
}


@end
