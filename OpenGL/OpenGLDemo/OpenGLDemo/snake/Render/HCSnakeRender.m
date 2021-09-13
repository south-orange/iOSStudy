//
//
//  HCSnakeRender.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/21.
//  
//
    

#import "HCSnakeRender.h"
#import "HCGLTextureNode.h"
#import "HCGLTextureManager.h"
#import "HCGLSnakeDrawer.h"
#import "GameConfig.h"

@interface HCSnakeRender ()

@property(nonatomic, strong) HCGLSnakeDrawer *snakeDrawer;

@property(nonatomic, strong) HCGLTexture *headTexture;
@property(nonatomic, strong) HCGLTexture *bodyTexture;

@property(nonatomic, assign) NSUInteger loadTextureIndex;

@end

@implementation HCSnakeRender

- (void)setSnake:(HCGameSnake *)snake {
    if (_snake == nil) {
        self.snakeDrawer = [HCGLSnakeDrawer.alloc initWithCapacity:10];
        self.snakeDrawer.textureManager = self.glkView.textureManager;
        [self.glkView.snakeDrawerManager.snakeDrawerDic setValue:self.snakeDrawer forKey:snake.snakeIdObj];
    }
    _snake = snake;
}

- (void)render {
    [self loadTexture];
//    CGFloat start = CFAbsoluteTimeGetCurrent();
    [self setupDrawerData];
//    NSLog(@"cost 1 %lf", CFAbsoluteTimeGetCurrent() - start);
//    NSLog(@"cost \n");
}

- (void)setupDrawerData {
    self.snakeDrawer.textureArray = [NSMutableArray arrayWithArray:self.textureArray];
    HCLinkNode *currentNode = self.snakeDrawer.linkList.headNode;
    
    for (NSUInteger i = 0;i < self.snake.length;i += NODE_INDEX_INTERVAL + 1) {
        HCSnakeNode *bodyNode = self.snake.bodyNodeArray[i];
        HCGLTextureNode *drawBodyNode = [HCGLTextureNode.alloc initWithPosition:bodyNode.center size:HCGLSizeMake(self.snake.width * 2, self.snake.width * 2) direction:bodyNode.direction];
        drawBodyNode.texture = self.bodyTexture;
        [drawBodyNode calculateVertexArray];
        if (currentNode.next == nil) {
            currentNode = HCLinkNode.new;
            [self.snakeDrawer.linkList addNode:currentNode];
        }
        currentNode.value = drawBodyNode;
        currentNode = currentNode.next;
    }
    HCSnakeNode *headNode = self.snake.headNode;
    HCGLTextureNode *drawHeadNode = [HCGLTextureNode.alloc initWithPosition:headNode.center size:HCGLSizeMake(self.snake.width * 2, self.snake.width * 2) direction:self.snake.direction];
    drawHeadNode.texture = self.headTexture;
    [drawHeadNode calculateVertexArray];
    if (currentNode.next == nil) {
        currentNode = HCLinkNode.new;
        [self.snakeDrawer.linkList addNode:currentNode];
    }
    currentNode.value = drawHeadNode;
    currentNode = currentNode.next;
    if (currentNode.next != nil) {
        [self.snakeDrawer.linkList removeAllNodesAfterNode:currentNode.prev];
    }
}

- (void)loadTexture {
    if (self.loadTextureIndex == 0) {
        NSString *headUrl = [self.snake.headSkin getSkinWithTimestamp:self.dataManager.timestamp];
        self.headTexture = [self loadTextureWithUrl:headUrl];
        self.headTexture.textureIndex = 0;
        
        NSString *bodyUrl = [self.snake.bodySkin getSkinWithTimestamp:self.dataManager.timestamp];
        self.bodyTexture = [self loadTextureWithUrl:bodyUrl];
        self.bodyTexture.textureIndex = 1;
    }
    self.loadTextureIndex ++;
    if (self.loadTextureIndex == 10) {
        self.loadTextureIndex = 0;
    }
}

- (HCGLTexture *)loadTextureWithUrl:(NSString *)url {
    HCGLTexture *texture = [self.glkView.textureManager textureWithUrl:url];
    texture.isRepeat = NO;
    [texture loadTexture];
    return texture;
}

- (NSArray *)textureArray {
    return @[@(self.headTexture.name), @(self.bodyTexture.name)];
}

@end
