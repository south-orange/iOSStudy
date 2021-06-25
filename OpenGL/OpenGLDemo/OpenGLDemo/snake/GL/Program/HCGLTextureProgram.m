//
//
//  HCGLTextureProgram.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/25.
//  
//
    

#import "HCGLTextureProgram.h"

#define MVPMatrix 0
#define TextureSmaplers 1
#define UniformCount 2

@interface HCGLTextureProgram () {
    GLuint _uniforms[UniformCount];
    BOOL _didLoadSamplerIds;
}

@end

@implementation HCGLTextureProgram

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
        
        // MVP matrix
        glUniformMatrix4fv(_uniforms[MVPMatrix], 1, 0, self.mvpMatrix.m);
        
        // texture sampler, 最多支持8个多重纹理
        if (!_didLoadSamplerIds) {
            const GLint samplerIds[kHCGLMutiTextureProgramMaxTextureNum] = {0, 1, 2, 3, 4, 5, 6, 7};
            glUniform1iv(_uniforms[TextureSmaplers], kHCGLMutiTextureProgramMaxTextureNum, (const GLint *)samplerIds);
            _didLoadSamplerIds = YES;
        }
    }
}

- (void)predrawTextureArray:(NSArray<NSNumber *> *)textureArray {
    GLuint textureUnit = 0;
    for (NSNumber *textureIndex in textureArray) {
        if (textureUnit < kHCGLMutiTextureProgramMaxTextureNum) {
            glActiveTexture(GL_TEXTURE0 + textureUnit);
            glBindTexture(GL_TEXTURE_2D, textureIndex.unsignedIntValue);
        }
        textureUnit ++;
    }
}

- (BOOL)p_loadShaders {
    self.program = glCreateProgram();
    
    NSString *vertFilePath = [NSBundle.mainBundle pathForResource:@"HCGLTextureShader" ofType:@"vsh"];
    NSString *fragFilePath = [NSBundle.mainBundle pathForResource:@"HCGLTextureShader" ofType:@"fsh"];
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
    glBindAttribLocation(self.program, GLKVertexAttribTexCoord0, "a_textureAndAlpha");
    
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
    _uniforms[TextureSmaplers] = glGetUniformLocation(self.program, "u_textureSamplers");
    
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
