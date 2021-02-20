//
//  HCTriScene.m
//  SpriteKitDemo
//
//  Created by wepie on 2021/2/20.
//

#import "HCTriScene.h"
#import <CoreMotion/CoreMotion.h>

#define darkenOpacity 0.8f
#define darkenDuration 2
#define playerMissileSpeed 300

#define degreesToRadius (M_PI / 180)
#define radiusToDegrees (180 / M_PI)

#define maxPlayerAcceleration 400.0
#define maxPlayerSpeed 200.0
#define borderCollisionDampling 0.4
#define maxHealth 100.0
#define healthBarHeight 4.0
#define healthBarWidth 40.0
#define cannonCollisionRadius 20.0
#define playerCollisonRadius 10.0
#define collisionDampling 0.8
#define playerCollisionSpin 180.0
#define playerMissileRadius 20.0

#define orbiterSpeed 120.0
#define orbiterRadius 60.0
#define orbiterCollisionRadius 20.0

@interface HCTriScene () {
    bool gameOver;
    double gameOBerElapsed;
    double gameOverDampen;
    
    double accelerometerX;
    double accelerometerY;
    CGVector playerAcceleration;
    CGVector playerVelocity;
    double lastUpdateTime;
    double playerAngle;
    double previousAngle;
    double playerHP;
    double cannonHP;
    double playerSpin;
    
    double orbiterAngle;
    
    CGPoint touchLocation;
    double touchTime;
}

@property(nonatomic, strong) SKSpriteNode *darkenLayer;
@property(nonatomic, strong) SKLabelNode *gameOverLabel;
@property(nonatomic, strong) SKSpriteNode *playerHealthBar;
@property(nonatomic, strong) SKSpriteNode *cannonHealthBar;

@property(nonatomic, strong) SKSpriteNode *playerSprite;
@property(nonatomic, strong) SKSpriteNode *cannonSprite;
@property(nonatomic, strong) SKSpriteNode *turretSprite;
@property(nonatomic, strong) SKSpriteNode *playerMissileSprite;
@property(nonatomic, strong) SKSpriteNode *orbiterSprite;

@property(nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation HCTriScene

- (instancetype)init
{
    self = [super init];
    if (self) {
        playerHP = maxHealth;
        cannonHP = maxHealth;
        self.playerSprite = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        self.playerSprite.size = CGSizeMake(50, 50);
        self.cannonSprite = [SKSpriteNode spriteNodeWithImageNamed:@"monster"];
        self.cannonSprite.size = CGSizeMake(40, 40);
        self.turretSprite = [SKSpriteNode spriteNodeWithImageNamed:@"monster"];
        self.turretSprite.size = CGSizeMake(20, 20);
        self.playerMissileSprite = [SKSpriteNode spriteNodeWithImageNamed:@"shot"];
        self.playerMissileSprite.size = CGSizeMake(20, 20);
        self.orbiterSprite = [SKSpriteNode spriteNodeWithImageNamed:@"monster"];
        self.orbiterSprite.size = CGSizeMake(20, 20);
        
        self.motionManager = CMMotionManager.new;
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    self.size = view.bounds.size;
    self.backgroundColor = [SKColor colorWithRed:94.0 / 255 green:63.0 / 255 blue:107.0 / 255 alpha:1.0];
    
    self.cannonSprite.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:self.cannonSprite];
    
    self.turretSprite.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:self.turretSprite];
    
    self.playerSprite.position = CGPointMake(self.size.width - 50, 60);
    [self addChild:self.playerSprite];
    
    [self addChild:self.playerHealthBar];
    [self addChild:self.cannonHealthBar];
    
    self.cannonHealthBar.position = CGPointMake(self.cannonSprite.position.x, self.cannonSprite.position.y - self.cannonSprite.size.height / 2 - 10);
    
    [self addChild:self.orbiterSprite];
    
    [self.playerMissileSprite setHidden:YES];
    [self addChild:self.playerMissileSprite];
}

#pragma mark - private

- (void)startMonitoringAcceleration {
    if (self.motionManager.isAccelerometerAvailable) {
        [self.motionManager startAccelerometerUpdates];
    }
}

- (void)stopMonitoringAcceleration {
    if (self.motionManager.isAccelerometerAvailable) {
        [self.motionManager stopAccelerometerUpdates];
    }
}

- (void)updatePlayerAccelerationFromMotionManager {
    if (self.motionManager.accelerometerData == nil) {
        return;
    }
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    double filterFactor = 0.75;
    
    accelerometerX = acceleration.x * filterFactor + accelerometerX * (1 - filterFactor);
    accelerometerY = acceleration.y * filterFactor + accelerometerY * (1 - filterFactor);
    
    playerAcceleration.dx = accelerometerY * (-maxPlayerAcceleration);
    playerAcceleration.dy = accelerometerX * maxPlayerAcceleration;
}

- (void)updatePlayer:(double)dt {
    playerVelocity.dx = playerVelocity.dx + playerAcceleration.dx * dt;
    playerVelocity.dy = playerVelocity.dy + playerAcceleration.dy * dt;
    
    playerVelocity.dx = MAX(-maxPlayerSpeed, MIN(maxPlayerSpeed, playerVelocity.dx));
    playerVelocity.dy = MAX(-maxPlayerSpeed, MIN(maxPlayerSpeed, playerVelocity.dy));
    
    double newX = self.playerSprite.position.x + playerVelocity.dx * dt;
    double newY = self.playerSprite.position.y + playerVelocity.dy * dt;
    
    bool collidedWithVerticalBorder = NO;
    bool collidedWithHorizontalBorder = NO;
    
    if (newX < 0) {
        newX = 0;
        collidedWithVerticalBorder = YES;
    } else if (newX > self.size.width) {
        newX = self.size.width;
        collidedWithVerticalBorder = YES;
    }
    
    if (newY < 0) {
        newY = 0;
        collidedWithHorizontalBorder = YES;
    } else if (newY > self.size.height) {
        newY = self.size.height;
        collidedWithHorizontalBorder = YES;
    }
    
    if (collidedWithVerticalBorder) {
        playerAcceleration.dx = -playerAcceleration.dx * borderCollisionDampling;
        playerVelocity.dx = -playerVelocity.dx * borderCollisionDampling;
        playerAcceleration.dy = playerAcceleration.dy * borderCollisionDampling;
        playerVelocity.dy = playerVelocity.dy * borderCollisionDampling;
    }
    
    if (collidedWithHorizontalBorder) {
        playerAcceleration.dx = playerAcceleration.dx * borderCollisionDampling;
        playerVelocity.dx = playerVelocity.dx * borderCollisionDampling;
        playerAcceleration.dy = -playerAcceleration.dy * borderCollisionDampling;
        playerVelocity.dy = -playerVelocity.dy * borderCollisionDampling;
    }
    
    self.playerSprite.position = CGPointMake(newX, newY);
    
    double rotationThreshold = 40;
    double rotationBlendFactor = 0.2;
    
    double speed = sqrt(playerVelocity.dx * playerVelocity.dx + playerVelocity.dy * playerVelocity.dy);
    if (speed > rotationThreshold) {
        double angle = atan2(playerVelocity.dy, playerVelocity.dx);
        if (angle - previousAngle > M_PI) {
            playerAngle += 2 * M_PI;
        } else if (previousAngle - angle > M_PI) {
            playerAngle -= 2 * M_PI;
        }
        
        previousAngle = angle;
        playerAngle = angle * rotationBlendFactor + playerAngle * (1 - rotationBlendFactor);
        
        if (playerSpin > 0) {
            playerAngle += playerSpin * degreesToRadius;
            previousAngle = playerAngle;
            playerSpin -= playerCollisionSpin * dt;
            if (playerSpin < 0) {
                playerSpin = 0;
            }
        }
        self.playerSprite.zRotation = playerAngle - 90 * degreesToRadius;
    }
    self.playerHealthBar.position = CGPointMake(self.playerSprite.position.x, self.playerSprite.position.y - self.playerSprite.size.height / 2 - 15);
}

- (void)updateTurret:(double)dt {
    double deltaX = self.playerSprite.position.x - self.turretSprite.position.x;
    double deltaY = self.playerSprite.position.y - self.turretSprite.position.y;
    double angle = atan2(deltaX, deltaY);
    
    self.turretSprite.zRotation = angle - 90 * degreesToRadius;
}

- (void)updateHealthBar:(SKSpriteNode *)node healthPoints:(int)hp {
    CGSize barSize = CGSizeMake(healthBarWidth, healthBarHeight);
    
    UIColor *fillColor = [UIColor colorWithRed:113.0 / 255 green:202.0 / 255 blue:53.0 / 255 alpha:1.0];
    UIColor *borderColor = [UIColor colorWithRed:35.0 / 255 green:28.0 / 255 blue:40.0 / 255 alpha:1.0];
    
    UIGraphicsBeginImageContextWithOptions(barSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [borderColor setStroke];
    CGRect borderRect = CGRectMake(0, 0, barSize.width, barSize.height);
    CGContextSetLineWidth(context, 1);
    CGContextStrokeRect(context, borderRect);
    
    [fillColor setFill];
    double barWidth = (barSize.width - 1) * hp / maxHealth;
    CGRect barRect = CGRectMake(0.5, 0.5, barWidth, barSize.height - 1);
    CGContextFillRect(context, barRect);
    
    UIImage *spriteImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    node.texture = [SKTexture textureWithImage:spriteImage];
    node.size = barSize;
}

- (void)checkShipCannonCollision {
    double deltaX = self.playerSprite.position.x - self.turretSprite.position.x;
    double deltaY = self.playerSprite.position.y - self.turretSprite.position.y;
    
    double distance = sqrt(deltaX * deltaX + deltaY * deltaY);
    if (distance > cannonCollisionRadius + playerCollisonRadius) {
        return;
    }
    playerAcceleration.dx = -playerAcceleration.dx * collisionDampling;
    playerAcceleration.dy = -playerAcceleration.dy * collisionDampling;
    playerVelocity.dx = -playerVelocity.dx * collisionDampling;
    playerVelocity.dy = -playerVelocity.dy * collisionDampling;
    
    double offsetDistance = cannonCollisionRadius + playerCollisonRadius - distance;
    double offsetX = deltaX / distance * offsetDistance;
    double offsetY = deltaY / distance * offsetDistance;
    self.playerSprite.position = CGPointMake(self.playerSprite.position.x + offsetX, self.playerSprite.position.y + offsetY);
    
    playerSpin = playerCollisionSpin;
    
    playerHP = MAX(0, playerHP - 20);
    cannonHP = MAX(0, cannonHP - 5);
    
    [self updateHealthBar:self.playerHealthBar healthPoints:playerHP];
    [self updateHealthBar:self.cannonHealthBar healthPoints:cannonHP];
}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.firstObject;
    touchLocation = [touch locationInNode:self];
    touchTime = CACurrentMediaTime();
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (gameOver) {
        HCTriScene *scene = [HCTriScene sceneWithSize:self.size];
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1];
        [self.view presentScene:scene transition:reveal];
        return;
    }
    double touchTimeThreshold = 0.3;
    double touchDistanceThreshold = 4;
    if (CACurrentMediaTime() - touchTime >= touchTimeThreshold || self.playerMissileSprite.isHidden) {
        return;
    }
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint location = [touch locationInNode:self];
    CGVector swipe = CGVectorMake(location.x - touchLocation.x, location.y - touchLocation.y);
    double swipeLength = sqrt(swipe.dx * swipe.dx + swipe.dy * swipe.dy);
    
    if (swipeLength <= touchDistanceThreshold) {
        return;
    }
    double angle = atan2(swipe.dy, swipe.dx);
    self.playerMissileSprite.zRotation = angle - 90 * degreesToRadius;
    self.playerMissileSprite.position = self.playerSprite.position;
    [self.playerMissileSprite setHidden:NO];
    
    CGPoint destination1 = CGPointZero;
    if (swipe.dy > 0) {
        destination1.y = self.size.height + playerMissileRadius;
    } else {
        destination1.y = -playerMissileRadius;
    }
    destination1.x = self.playerSprite.position.x + ((destination1.y - self.playerSprite.position.y) / swipe.dy * swipe.dx);
    
    CGPoint destination2 = CGPointZero;
    if (swipe.dx > 0) {
        destination2.x = self.size.width + playerMissileRadius;
    } else {
        destination2.x = -playerMissileRadius;
    }
    destination2.y = self.playerSprite.position.y + ((destination2.x - self.playerSprite.position.x) / swipe.dx * swipe.dy);
    
    CGPoint destination = destination2;
    if (fabs(destination1.x) < fabs(destination2.x) || fabs(destination1.y) < fabs(destination2.y)) {
        destination = destination1;
    }
    double distance = sqrt(pow(destination.x - self.playerSprite.position.x, 2) + pow(destination.y - self.playerSprite.position.y, 2));
    double duration = distance / playerMissileSpeed;
    SKAction *missileMoveAction = [SKAction moveTo:destination duration:duration];
    [self.playerMissileSprite runAction:missileMoveAction completion:^{
        [self.playerMissileSprite setHidden:YES];
    }];
    
}

#pragma mark - lazy

- (SKSpriteNode *)darkenLayer {
    if (!_darkenLayer) {
        _darkenLayer = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] size:self.size];
        _darkenLayer.alpha = 0;
        _darkenLayer.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    }
    return _darkenLayer;
}

- (SKLabelNode *)gameOverLabel {
    if (!_gameOverLabel) {
        _gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"PingFang SC"];
        _gameOverLabel.fontSize = 24;
        _gameOverLabel.position = CGPointMake(self.size.width / 2 + 0.5, self.size.height / 2 + 50);
    }
    return _gameOverLabel;
}

@end
