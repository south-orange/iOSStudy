//
//  HCScene.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/19.
//

#import "HCScene.h"

@interface HCScene ()

@property (nonatomic, strong) SKSpriteNode *node;

@end

@implementation HCScene

- (void)didMoveToView:(SKView *)view {
    self.node = [SKSpriteNode.alloc initWithImageNamed:@"phone"];
    self.node.size = CGSizeMake(128, 128);
    [self addChild:self.node];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startAnimationWithNode:self.node];
}

#pragma mark - private

- (void)startAnimationWithNode:(SKSpriteNode *)node {
    SKAction *moveAction = [SKAction moveTo:CGPointMake(300, 500) duration:2];
    [node runAction:moveAction completion:^{
        [self resetPosition];
    }];
    
    SKAction *scaleAction = [SKAction resizeToWidth:64 height:64 duration:2];
    [node runAction:scaleAction completion:^{
        [self resetPosition];
    }];
}

- (void)resetPosition {
    SKAction *moveAction = [SKAction moveTo:CGPointMake(0, 0) duration:2];
    [self.node runAction:moveAction];
    
    SKAction *scaleAction = [SKAction resizeToWidth:128 height:128 duration:2];
    [self.node runAction:scaleAction];
}

@end
