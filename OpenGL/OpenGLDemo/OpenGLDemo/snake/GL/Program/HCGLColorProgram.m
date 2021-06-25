//
//
//  HCGLColorProgram.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/24.
//  
//
    

#import "HCGLColorProgram.h"

#define MVPMatrix 0
#define UniformCount 1

@interface HCGLColorProgram () {
    GLuint _uniforms[UniformCount];
}

@end

@implementation HCGLColorProgram

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_loadShaders];
    }
    return self;
}

- (void)preuseProgram {
    if (0 == self.program) {
        [self p_loadShaders];
    }
    
    if (0 != self.program) {
        glUseProgram(self.program);
        glUniformMatrix4fv(_uniforms[MVPMatrix], 1, 0, self.mvpMatrix.m);
    }
}


#pragma mark - private

- (BOOL)p_loadShaders {
    self.program = glCreateProgram();
    
    NSString *vertFilePath = [NSBundle.mainBundle pathForResource:@"HCGLColorShader" ofType:@"vsh"];
    NSString *fragFilePath = [NSBundle.mainBundle pathForResource:@"HCGLColorShader" ofType:@"fsh"];
    GLuint vertShader, fragShader;
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertFilePath]) {
        NSLog(@"failed to compile vertex shader");
        return NO;
    }
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragFilePath]) {
        NSLog(@"failed to compile fragment shader");
        return NO;
    }
    
    glAttachShader(self.program, vertShader);
    glAttachShader(self.program, fragShader);
    
    glBindAttribLocation(self.program, GLKVertexAttribPosition, "a_position");
    glBindAttribLocation(self.program, GLKVertexAttribColor, "a_color");
    
    if (![self linkProgram]) {
        NSLog(@"failed to link program: %d", self.program);
        if (vertShader) {
            glDetachShader(self.program, vertShader);
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDetachShader(self.program, fragShader);
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (self.program) {
            glDeleteProgram(self.program);
            self.program = 0;
        }
        return NO;
    }
    
    _uniforms[MVPMatrix] = glGetUniformLocation(self.program, "u_mvpMatrix");
    
    if (vertShader) {
        glDetachShader(self.program, vertShader);
        glDeleteShader(vertShader);
        vertShader = 0;
    }
    if (fragShader) {
        glDetachShader(self.program, fragShader);
        glDeleteShader(fragShader);
        fragShader = 0;
    }
    
    return YES;
}

@end
