//
//
//  HCGLBaseProgram.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/24.
//  
//
    

#import "HCGLBaseProgram.h"

@implementation HCGLBaseProgram

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mvpMatrix = GLKMatrix4Identity;
    }
    return self;
}

- (void)dealloc {
    if (self.program) {
        glDeleteProgram(self.program);
        self.program = 0;
    }
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)filePath {
    
    const GLchar *source = (GLchar *)[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil].UTF8String;
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"shader compile log:\n%s", log);
        free(log);
    }
    
    GLint compileSuccess;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram {
    glLinkProgram(self.program);
    
    GLint logLength;
    glGetShaderiv(self.program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(self.program, logLength, &logLength, log);
        NSLog(@"program link log:%s", log);
        free(log);
    }
    
    GLint linkSuccess;
    glGetProgramiv(self.program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        return NO;
    }
    return YES;
}


- (void)preuseProgram {
    
}

@end
