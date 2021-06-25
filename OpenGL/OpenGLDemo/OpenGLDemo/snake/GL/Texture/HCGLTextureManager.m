//
//
//  HCGLTextureManager.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/31.
//  
//
    

#import "HCGLTextureManager.h"

@interface HCGLTextureManager ()

@property(nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation HCGLTextureManager

- (void)dealloc {
    NSLog(@"dealloc %@", self);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _textureCache = YYMemoryCache.new;
        _textureCache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        _textureCache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        _serialQueue = dispatch_queue_create("HCGLTextureManager.hc", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (HCGLTexture *)textureWithUrl:(NSString *)url {
    if (url.length <= 0) {
        return nil;
    }
    
    HCGLTexture *texture = [self.textureCache objectForKey:url];
    if (texture) {
        return texture;
    }
    texture = HCGLTexture.new;
    texture.filePath = url;
    [self.textureCache setObject:texture forKey:url];
    
    return texture;
}

@end
