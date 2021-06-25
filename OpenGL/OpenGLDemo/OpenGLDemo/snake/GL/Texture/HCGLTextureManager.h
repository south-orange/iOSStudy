//
//
//  HCGLTextureManager.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/31.
//  
//
    

#import <Foundation/Foundation.h>
#import <YYMemoryCache.h>
#import "HCGLTexture.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCGLTextureManager : NSObject

@property(nonatomic, strong, readonly) YYMemoryCache *textureCache;

- (HCGLTexture *)textureWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
