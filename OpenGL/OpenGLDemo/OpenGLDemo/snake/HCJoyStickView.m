//
//
//  HCJoyStickView.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/2.
//  
//
    

#import "HCJoyStickView.h"
#import "MathUtils.h"

@interface HCJoyStickView ()

@property(nonatomic, strong) UIView *joyStickView;

@end

@implementation HCJoyStickView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.joyStickView = UIView.new;
        self.joyStickView.frame = CGRectMake(0, 0, 20, 20);
        self.joyStickView.backgroundColor = UIColor.grayColor;
        self.joyStickView.layer.cornerRadius = 10;
        [self addSubview:self.joyStickView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = frame.size.width / 2;
    self.joyStickView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touchCenter = touches.anyObject;
    CGPoint point = [touchCenter locationInView:self];
    [self changeWithPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touchCenter = touches.anyObject;
    CGPoint point = [touchCenter locationInView:self];
    [self changeWithPoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.joyStickView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.width / 2);
    if (self.changeDirectionBlock) {
        self.changeDirectionBlock(0, 0);
    }
}

- (void)changeWithPoint:(CGPoint)point {
    CGFloat r = self.frame.size.width / 2;
    CGPoint center = CGPointMake(r, r);
    
    CGFloat distance = 0;
    CGFloat direction = [MathUtils directionCGFromA:center toB:point distance:&distance];
    
    if (distance <= r) {
        self.joyStickView.center = point;
    } else {
        self.joyStickView.center = CGPointMake(center.x + r * cos(direction), center.y - r * sin(direction));
        distance = r;
    }
    if (self.changeDirectionBlock) {
        self.changeDirectionBlock(direction, distance / self.frame.size.width * 2);
    }
}

@end
