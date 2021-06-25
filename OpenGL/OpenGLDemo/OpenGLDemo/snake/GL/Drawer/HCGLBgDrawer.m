//
//
//  HCGLBgDrawer.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/31.
//  
//
    

#import "HCGLBgDrawer.h"
#import "HCGLTextureNode.h"
#import "HCGLTextureManager.h"

@implementation HCGLBgDrawer

- (void)setupWithMapSize:(HCGLSize)size {
    HCGLTexture *texture = [self.textureManager textureWithUrl:@"bgCell"];
    texture.isRepeat = YES;
    [texture loadTexture];
    texture.frame = HCGLRectMake(0, 0, size.width / texture.size.width, size.height / texture.size.height);
    [self.textureArray addObject:@(texture.name)];
    texture.textureIndex = self.textureArray.count - 1;
    HCGLTextureNode *bg = [HCGLTextureNode.alloc initWithPosition:HCGLPointZero size:size direction:0.0];
    bg.texture = texture;
    if (bg) {
        [self.linkList addNode:[HCLinkNode nodeWithValue:bg]];
    }
    self.reloadTextureEveryTime = NO;
}


@end
