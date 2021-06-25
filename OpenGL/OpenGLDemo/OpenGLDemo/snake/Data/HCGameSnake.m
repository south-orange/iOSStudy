//
//
//  HCGameSnake.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/15.
//  
//
    

#import "HCGameSnake.h"
#import "MathUtils.h"
#import "GameConfig.h"
#import "HCMapDataManger.h"

@interface HCGameSnake ()

@property(nonatomic, assign) NSUInteger length;
@property(nonatomic, assign) NSUInteger moveFrame;

@property(nonatomic, assign) NSUInteger growUpCD;

@end

@implementation HCGameSnake

static NSInteger p_snakeId = 2;

+ (NSInteger)randomSnakeId {
    p_snakeId ++;
    return p_snakeId;
}

+ (void)clearSnakeId {
    p_snakeId = 0;
}

+ (instancetype)randomPlayerSnakeWithSnakeId:(NSInteger)snakeId length:(NSUInteger)length headCenter:(HCGLPoint)center {
    HCGameSnake *snake = HCGameSnake.new;
    snake.snakeId = (snakeId == -1) ? [HCGameSnake randomSnakeId] : snakeId;
    snake.width = NODE_DISTANCE_INTERVAL * NODE_INDEX_INTERVAL;
    snake.length = length;
    snake.direction = MathUtils.randomDirection;
    snake.expectDirection = snake.direction;
    snake.bodyNodeQueue = HCCircularQueue.new;
    HCSnakeNode *node = HCSnakeNode.new;
    node.snakeId = snake.snakeId;
    node.size = HCGLSizeMake(snake.width * 2, snake.width * 2);
    node.center = center;
    node.direction = snake.direction;
    for (NSInteger i = length - 1;i >= 0;i --) {
        [snake.bodyNodeQueue addNode:[HCSnakeNode nodeWithNode:node]];
    }
    return snake;
}

- (void)setMapDataManager:(HCMapDataManger *)mapDataManager {
    _mapDataManager = mapDataManager;
    for (NSUInteger i = 0;i < self.length;i ++) {
        [mapDataManager addNode:[self.bodyNodeQueue nodeAtIndex:i]];
    }
}

- (void)move {
    [self updateMoveFrame];
    if (self.moveFrame == 0) {
        return;
    }
    self.direction = [MathUtils changeDirectionFrom:self.direction to:self.expectDirection limit:MAX_DIRECTION_CHANGE];
    [self growUp];
    [self moveBodyNodes];
}

- (void)updateMoveFrame {
    self.moveFrame = ceil(self.speed * 2);
}

- (void)growUp {
    self.growUpCD ++;
    if (self.growUpCD == 10) {
        self.growUpCD = 0;
    }
    if (self.growUpCD == 0) {
        HCSnakeNode *node = [HCSnakeNode nodeWithNode:self.bodyNodeQueue.firstNode];
        [self.bodyNodeQueue addNodeToFront:node];
        self.length ++;
    }
}

- (void)moveBodyNodes {
    CGFloat moveX = NODE_DISTANCE_INTERVAL * cos(self.direction);
    CGFloat moveY = NODE_DISTANCE_INTERVAL * sin(self.direction);
    for (int i = 0;i < self.moveFrame;i ++) {
        HCSnakeNode *lastNode = [self.bodyNodeQueue removeFirstNode];
        [self.mapDataManager removeNode:lastNode];
        
        float newHeadX = self.headNode.center.x + moveX;
        float newHeadY = self.headNode.center.y + moveY;
        HCSnakeNode *newHeadNode = HCSnakeNode.new;
        newHeadNode.snakeId = self.snakeId;
        newHeadNode.center = HCGLPointMake(newHeadX, newHeadY);
        newHeadNode.direction = self.direction;
        newHeadNode.size = self.headNode.size;
        [self.bodyNodeQueue addNode:newHeadNode];
        [self.mapDataManager addNode:newHeadNode];
    }
}

- (void)die {
    
}

- (HCSnakeNode *)headNode {
    return self.bodyNodeQueue.lastNode;
}

- (void)printLog {
    NSMutableString *log = NSMutableString.string;
    [log appendFormat:@"Snake snakeId : %ld, length : %lu \nheadPos : (%lf, %lf), \ndirection : %f, \nexpectedDirection : %f\n", self.snakeId, self.length, self.headNode.center.x, self.headNode.center.y, self.direction / M_PI * 180, self.expectDirection / M_PI * 180];
    __weak typeof(log) weakLog = log;
    [self.bodyNodeQueue enumerateObjectsUsingBlock:^(HCSnakeNode * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        [weakLog appendFormat:@"index : %lu, snakeId : %lu, center : (%lf, %lf), direction : %f \n", index, obj.snakeId, obj.center.x, obj.center.y, obj.direction];
    }];
    NSLog(@"%@", log);
}

- (HCSnakeSkinCollection *)headSkin {
    if (!_headSkin) {
        NSArray *urlArray = @[@"head-0"];
//        NSArray *staytimeArray = @[@5, @5];
        NSMutableArray *skinArray = NSMutableArray.array;
        for (NSUInteger i = 0;i < urlArray.count;i ++) {
            HCSnakeSkin *skin = HCSnakeSkin.new;
            skin.url = urlArray[i];
            skin.stayTime = 12;
            [skinArray addObject:skin];
        }
        _headSkin = HCSnakeSkinCollection.new;
        _headSkin.skinArray = skinArray;
    }
    return _headSkin;
}

- (HCSnakeSkinCollection *)bodySkin {
    if (!_bodySkin) {
        NSArray *urlArray = @[@"body-0", @"body-1", @"body-2", @"body-3", @"body-4"];
//        NSArray *staytimeArray = @[@5, @5, @5, @5, @5];
        NSMutableArray *skinArray = NSMutableArray.array;
        for (NSUInteger i = 0;i < urlArray.count;i ++) {
            HCSnakeSkin *skin = HCSnakeSkin.new;
            skin.url = urlArray[i];
            skin.stayTime = 6;
            [skinArray addObject:skin];
        }
        _bodySkin = HCSnakeSkinCollection.new;
        _bodySkin.skinArray = skinArray;
    }
    return _bodySkin;
}

- (NSString *)snakeIdString {
    return [NSString stringWithFormat:@"%ld", self.snakeId];
}

- (BOOL)isMySnake {
    return self.snakeId == MY_SNAKE_ID;
}

@end
