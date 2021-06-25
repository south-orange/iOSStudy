//
//
//  HCGLTexture.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/27.
//  
//
    

#import "HCGLTexture.h"

@implementation HCGLTexture

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = HCGLRectMake(0, 0, 1, 1);
        self.size = HCGLSizeZero;
    }
    return self;
}

- (void)loadTexture {
    
    if (self.status == HCGLTextureLoadStatusNotLoad) {
        [self p_loadTexture];
    }
    
}

- (HCGLRect)frame {
    if (self.status == HCGLTextureLoadStatusNotLoad) {
        [self p_loadTexture];
    }
    
    return _frame;
}

- (void)p_loadTexture {
    
    WEAKSELF
    dispatch_block_t loadBlock = ^{
        NSError *error = nil;
        HCGLSize size;
        GLuint textureID = [HCGLTexture textureWithContentsOfFile:weakSelf.filePath isRepeat:weakSelf.isRepeat size:&size error:&error];
        if (textureID == 0) {
            NSLog(@"加载纹理失败，文件路径：%@", weakSelf.filePath);
        } else {
            weakSelf.name = textureID;
            weakSelf.status = HCGLTextureLoadStatusLoaded;
            weakSelf.size = size;
        }
    };
    if (NSThread.isMainThread) {
        loadBlock();
    } else {
        dispatch_sync(dispatch_get_main_queue(), loadBlock);
    }
}

+ (GLuint)textureWithContentsOfFile:(NSString *)file isRepeat:(BOOL)isRepeat size:(HCGLSize *)size error:(__autoreleasing NSError **)error {
    UIImage *image = nil;
    if (file.isAbsolutePath) {
        image = [UIImage imageWithContentsOfFile:file];
    } else {
        image = [UIImage imageNamed:file];
    }
    
    if (!image) {
        *error = [NSError errorWithDomain:@"HCGLERROR" code:404 userInfo:@{NSLocalizedDescriptionKey : @"找不到图片"}];
        return 0;
    }
    
    return [self textureWithUIImage:image isRepeat:isRepeat size:size error:error];
}

+ (GLuint)textureWithUIImage:(UIImage *)image isRepeat:(BOOL)isRepeat size:(HCGLSize *)size error:(__autoreleasing NSError **)error {
    return [self textureWithCGImage:image.CGImage isRepeat:isRepeat size:size error:error];
}

+ (GLuint)textureWithCGImage:(CGImageRef)cgImage isRepeat:(BOOL)isRepeat size:(HCGLSize *)size error:(__autoreleasing NSError **)error {
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    *size = HCGLSizeMake(width, height);
    
    void *textureData = malloc(width * height * 4);
    CGContextRef textureContext = CGBitmapContextCreate(textureData, width, height, 8, width * 4, CGImageGetColorSpace(cgImage), kCGImageAlphaPremultipliedLast);
    //翻转坐标系
    CGContextTranslateCTM(textureContext, 0, height);
    CGContextScaleCTM(textureContext, 1, -1);
    //绘制
    CGContextDrawImage(textureContext, CGRectMake(0, 0, width, height), cgImage);
    //释放内存
    CGContextRelease(textureContext);
    
    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    if (isRepeat) {
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    } else {
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    }
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (float)width, (float)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
    
    free(textureData);
    
    return textureID;
}

@end
