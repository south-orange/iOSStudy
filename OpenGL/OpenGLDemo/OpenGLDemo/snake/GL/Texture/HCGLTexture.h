//
//
//  HCGLTexture.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/27.
//  
//
    

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HCGLTextureLoadStatus) {
    HCGLTextureLoadStatusNotLoad,
    HCGLTextureLoadStatusLoaded,
};

@interface HCGLTexture : NSObject

@property(nonatomic, strong) NSString *filePath;

@property(nonatomic, assign) HCGLTextureLoadStatus status;
@property(nonatomic, assign) GLuint name;
@property(nonatomic, assign) HCGLRect frame;
@property(nonatomic, assign) HCGLSize size;
@property(nonatomic, assign) NSUInteger textureIndex;
@property(nonatomic, assign) BOOL isRepeat;

- (void)loadTexture;

@end

NS_ASSUME_NONNULL_END
