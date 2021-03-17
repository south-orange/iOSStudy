//
//  HCSnakeScene.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/23.
//

#import "HCSnakeScene.h"

@interface HCSnakeScene ()

@property (nonatomic, strong) SKSpriteNode *snakeHead;
@property (nonatomic, assign) NSInteger timecount;
@property (nonatomic, assign) CGFloat headAngle;
@property (nonatomic, assign) CGPoint startTouchPoint;


@end

@implementation HCSnakeScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = SKColor.whiteColor;
    self.snakeHead = [SKSpriteNode.alloc initWithImageNamed:@"player"];
    self.snakeHead.size = CGSizeMake(40, 40);
    self.snakeHead.position = CGPointMake(self.size.width * 0.1, self.size.height * 0.5);
    [self addChild:self.snakeHead];
    self.headAngle = 0;
    //self.snakeHead.zRotation = M_PI_2;
}

- (void)update:(NSTimeInterval)currentTime {
    if (self.timecount % 6 == 0) {
        self.timecount = 0;
        SKAction *moveAction = [SKAction moveTo:CGPointMake(self.snakeHead.position.x + 10 * sin(self.headAngle), self.snakeHead.position.y + 10 * cos(self.headAngle)) duration:0.1];
        SKAction *rotateAction = [SKAction rotateToAngle:-self.headAngle duration:0.1];
        [self.snakeHead runAction:[SKAction sequence:@[ rotateAction]]];
    }
    self.timecount++;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.firstObject;
    self.startTouchPoint = [touch locationInNode:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint nowPoint = [touch locationInNode:self];
    CGFloat angle = atan2(nowPoint.x - self.startTouchPoint.x, nowPoint.y - self.startTouchPoint.y);
    self.headAngle = angle;
    //NSLog(@"%f, %f, %f", angle / M_PI * 180, cos(angle) * 100, sin(angle) * 100);
}

@end
