//
//
//  HCSnakeGLKView.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/24.
//  
//
    

#import "HCSnakeGLKView.h"
#import "HCGLTextureProgram.h"
#import "HCGLColorProgram.h"
#import "HCGLBgDrawer.h"
#import "HCGLSnakeDrawer.h"
#import "HCGLTextureManager.h"

@interface HCSnakeGLKView ()

@property(nonatomic, assign) float xScale;
@property(nonatomic, assign) float yScale;

@property(nonatomic, assign) float scale;

@property(nonatomic, strong) HCGLTextureProgram *textureProgram;
@property(nonatomic, strong) HCGLColorProgram *colorProgram;

@property(nonatomic, strong) HCGLBgDrawer *bgDrawer;

@end

@implementation HCSnakeGLKView

- (void)dealloc
{
    [self deleteDrawable];
    NSLog(@"dealloc %@", self);
}

- (void)setup {
    EAGLContext *context = [EAGLContext.alloc initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.context = context;
    [EAGLContext setCurrentContext:context];
    
    glClearColor(0, 1, 0, 1);
    glDisable(GL_DITHER);// 关闭抖动算法
    glDisable(GL_DEPTH_TEST);// 关闭深度缓冲区
    glDepthMask(GL_FALSE);// 将深度缓冲区设置为只读
    glEnable(GL_CULL_FACE);// 开启面剔除，可以丢弃多边形的一个面，节省片段着色器的调用 https://learnopengl-cn.github.io/04%20Advanced%20OpenGL/04%20Face%20culling/
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    self.textureManager = HCGLTextureManager.new;
    
    self.scale = 1;
    self.xScale = UIScreen.mainScreen.scale / self.frame.size.width;
    self.yScale = UIScreen.mainScreen.scale / self.frame.size.height;
        
    self.textureProgram = HCGLTextureProgram.new;
    self.textureProgram.mvpMatrix = GLKMatrix4MakeScale(self.xScale * self.scale, self.yScale * self.scale, 1.0);
    
    self.bgDrawer = [HCGLBgDrawer.alloc initWithCapacity:1];
    self.bgDrawer.textureManager = self.textureManager;
    [self.bgDrawer setupWithMapSize:self.mapSize];
    
    self.snakeDrawerManager = HCGLSnakeDrawerManager.new;
    self.snakeDrawerManager.textureManager = self.textureManager;
        
    self.colorProgram = HCGLColorProgram.new;
    self.colorProgram.mvpMatrix = GLKMatrix4MakeScale(self.xScale * self.scale, self.yScale * self.scale, 1.0);
}

- (void)drawRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.textureProgram preuseProgram];
    [self.bgDrawer drawWithProgram:self.textureProgram];
    [self.snakeDrawerManager drawWithProgram:self.textureProgram];
}

- (void)updateCenter:(HCGLPoint)center scale:(CGFloat)scale {
    self.scale = scale;
    GLKMatrix4 matrix = GLKMatrix4MakeScale(self.xScale * self.scale, self.yScale * self.scale, 1.0);
    matrix = GLKMatrix4Translate(matrix, -center.x, -center.y, 0.0);
    self.colorProgram.mvpMatrix = matrix;
    self.textureProgram.mvpMatrix = matrix;
}

@end
