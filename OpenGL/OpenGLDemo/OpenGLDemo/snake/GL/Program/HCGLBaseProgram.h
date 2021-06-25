//
//
//  HCGLBaseProgram.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/24.
//  
//
    
NS_ASSUME_NONNULL_BEGIN

@interface HCGLBaseProgram : NSObject

@property(nonatomic, assign) GLuint program;
@property(nonatomic, assign) GLKMatrix4 mvpMatrix;

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)filePath;
- (BOOL)linkProgram;

// 继承
- (void)preuseProgram;

@end

NS_ASSUME_NONNULL_END
