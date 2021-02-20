//
//  HCGameScene.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/19.
//

#import "HCGameScene.h"


typedef NS_ENUM(u_int32_t, PhysicsCategory) {
    PhysicsCategoryNone,
    PhysicsCategoryAll,
    PhysicsCategoryMonster,
    PhysicsCategoryShot
};

@interface HCGameScene ()<SKPhysicsContactDelegate>

@property (nonatomic, strong) SKSpriteNode *player;

@end

@implementation HCGameScene

//presentScene后调用
- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = SKColor.whiteColor;
    self.player = [SKSpriteNode.alloc initWithImageNamed:@"player"];
    self.player.size = CGSizeMake(40, 40);
    self.player.position = CGPointMake(self.size.width * 0.1, self.size.height * 0.5);
    [self addChild:self.player];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction runBlock:^{
        [self addMonster];
    }], [SKAction waitForDuration:1]]]]];
    
    //physics
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
}

//添加Monster
- (void)addMonster {
    SKSpriteNode *monster = [SKSpriteNode.alloc initWithImageNamed:@"monster"];
    monster.size = CGSizeMake(40, 40);
    CGFloat actualY = [self random:monster.size.height / 2 :self.size.height - monster.size.height / 2];
    monster.position = CGPointMake(self.size.width + monster.size.width / 2, actualY);
    [self addChild:monster];
    
    CGFloat actualDuration = [self random:2 :4];
    SKAction *actionMove = [SKAction moveTo:CGPointMake(-monster.size.width / 2, actualY) duration:actualDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    //physics
    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size];
    [monster.physicsBody setDynamic:YES];
    monster.physicsBody.categoryBitMask = PhysicsCategoryMonster;
    monster.physicsBody.contactTestBitMask = PhysicsCategoryShot;
    monster.physicsBody.collisionBitMask = PhysicsCategoryNone;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint location = [touch locationInNode:self];
    
    SKSpriteNode *shot = [SKSpriteNode.alloc initWithImageNamed:@"shot"];
    shot.size = CGSizeMake(30, 30);
    shot.position = self.player.position;
    
    CGPoint offset = [self sub:location :shot.position];
    if (offset.x < 0) {
        return;
    }
    
    [self addChild:shot];
    
    CGPoint direction = [self normalized:offset];
    CGPoint shotAmount = [self mul:direction :1000];
    CGPoint realDest = [self add:shotAmount :shot.position];
    
    SKAction *actionMove = [SKAction moveTo:realDest duration:2];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [shot runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    //physics
    shot.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:shot.size.width / 2];
    [shot.physicsBody setDynamic:YES];
    shot.physicsBody.categoryBitMask = PhysicsCategoryShot;
    shot.physicsBody.contactTestBitMask = PhysicsCategoryMonster;
    shot.physicsBody.collisionBitMask = PhysicsCategoryNone;
    shot.physicsBody.usesPreciseCollisionDetection = YES;
}

//碰撞时调用
- (void)didBeginContact:(SKPhysicsContact *)contact {
    //获取两个对象
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    //判断是否是怪物和子弹发生碰撞
    if (((firstBody.categoryBitMask & PhysicsCategoryMonster) != 0) && ((secondBody.categoryBitMask & PhysicsCategoryShot) != 0)) {
        if (firstBody.node != nil && secondBody.node != nil) {
            [self shotDidCollideWithMonster:secondBody.node :firstBody.node];
        }
    }
}

- (void)shotDidCollideWithMonster:(SKSpriteNode *)shot :(SKSpriteNode *)monster {
    //NSLog(@"hit");
    [shot removeFromParent];
    [monster removeFromParent];
}

#pragma mark - utils

- (CGFloat)random {
    return (CGFloat)((CGFloat)arc4random() / 0xFFFFFFFF);
}

- (CGFloat)random:(CGFloat)min :(CGFloat)max {
    return [self random] * (max - min) + min;
}

- (CGPoint)add:(CGPoint)left :(CGPoint)right {
    return CGPointMake(left.x + right.x, left.y + right.y);
}

- (CGPoint)sub:(CGPoint)left :(CGPoint)right {
    return CGPointMake(left.x - right.x, left.y - right.y);
}

- (CGPoint)mul:(CGPoint)point :(CGFloat)scale {
    return CGPointMake(point.x * scale, point.y * scale);
}

- (CGPoint)div:(CGPoint)point :(CGFloat)scale {
    return CGPointMake(point.x / scale, point.y / scale);
}

- (CGFloat)length:(CGPoint)point {
    return sqrt(point.x * point.x + point.y * point.y);
}

- (CGPoint)normalized:(CGPoint)point {
    return [self div:point :[self length:point]];
}

@end
