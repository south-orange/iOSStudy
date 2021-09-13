//
//
//  HCGLTextureDrawer.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/26.
//  
//
    

#import "HCGLTextureDrawer.h"
#import <OpenGLES/ES3/gl.h>
#import "HCGLTextureNode.h"
#import "HCGLTextureProgram.h"

@interface HCGLTextureDrawer () {
    GLuint _vbo;
    GLuint _vao;
    GLuint _ebo;
    
    HCGLTextureNodeVertex *_vertexArray;
    GLuint *_indiceArray;
    
}

@property(nonatomic, assign) NSUInteger capacity;
@property(nonatomic, assign) NSUInteger count;

@end

@implementation HCGLTextureDrawer

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        self.textureArray = [NSMutableArray arrayWithCapacity:kHCGLMutiTextureProgramMaxTextureNum];
        [self p_applyArrayMemoryWithCapacity:capacity];
        [self p_setVAOVBO];
    }
    return self;
}

- (void)dealloc {
    glDeleteBuffers(1, &_vbo);
    glDeleteBuffers(1, &_ebo);
    glDeleteVertexArrays(1, &_vao);
    glBindVertexArray(0);
    
    HCGL_FREE(_vertexArray);
    HCGL_FREE(_indiceArray);
}

- (void)drawWithProgram:(HCGLTextureProgram *)program {
    HCGLTextureNodeVertex *start = &(_vertexArray[0]);
    
    if (self.reloadTextureEveryTime) {
        [self.textureArray removeAllObjects];
    }
    
    HCLinkNode *node = self.linkList.headNode;
    self.count = 0;
    while (node.next) {
        HCGLTextureNode *textureNode = (HCGLTextureNode *)node.value;
        if (textureNode.hidden) {
            node = node.next;
            continue;
        }
        self.count ++;
        if (self.reloadTextureEveryTime) {
            NSUInteger textureIndex = [self.textureArray indexOfObject:@(textureNode.texture.name)];

            if (textureIndex == NSNotFound) {
                if (self.textureArray.count < kHCGLMutiTextureProgramMaxTextureNum) {
                    [self.textureArray addObject:@(textureNode.texture.name)];
                    textureIndex = self.textureArray.count;
                } else {
                    NSAssert(NO, @"too much texture infos:%@", self);
                }
            }
            [textureNode updateTextureIndex:textureIndex];
        }
        
        // 数组扩容
        if (self.count > self.capacity) {
            [self p_applyArrayMemoryWithCapacity:self.capacity * 2 copyCount:self.capacity];
            start = &(_vertexArray[0]) + (self.count - 1) * kHCGLVertexCount;
        }
        
        for (int i = 0;i < kHCGLVertexCount;i ++) {
            (start + i)->position = textureNode->_textureVertexArray[i].position;
            (start + i)->textureAndAlpha = textureNode->_textureVertexArray[i].textureAndAlpha;
        }
        
        start += kHCGLVertexCount;
        
        node = node.next;
    }
    
    if (self.count <= 0) {
        return;
    }
    
    if (self.textureArray.count == 1 && self.textureArray[0] == 0) {
        return;
    }
    
    [program predrawTextureArray:self.textureArray];
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    GLsizeiptr length = sizeof(HCGLTextureNodeVertex) * self.count * kHCGLVertexCount;
    glBufferData(GL_ARRAY_BUFFER, length, _vertexArray, GL_DYNAMIC_DRAW);
    
    glBindVertexArray(_vao);
    glDrawElements(GL_TRIANGLES, kHCGLIndiceCount * (GLsizei)self.count, GL_UNSIGNED_INT, 0);
    glBindVertexArray(0);
}

#pragma mark - setup

- (void)p_applyArrayMemoryWithCapacity:(NSUInteger)capacity {
    _capacity = capacity;
    HCGLTextureNodeVertex *vertexArray = (HCGLTextureNodeVertex *)malloc(capacity * kHCGLVertexCount * sizeof(HCGLTextureNodeVertex));
    memset(vertexArray, 0, capacity * kHCGLVertexCount * sizeof(HCGLTextureNodeVertex));
    
    GLuint *indicesArray = (GLuint *)malloc(capacity * kHCGLIndiceCount * sizeof(GLuint));
    
    HCGL_FREE(_vertexArray);
    HCGL_FREE(_indiceArray);
    _vertexArray = vertexArray;
    _indiceArray = indicesArray;
    
    [self p_setIndiceArray];
}

- (void)p_applyArrayMemoryWithCapacity:(NSUInteger)capacity copyCount:(NSUInteger)copyCount {
    if (copyCount > 0 && capacity / copyCount == 2) {
        capacity = copyCount + MIN(copyCount, 200);
    }
    
    _capacity = capacity;
    
    HCGLTextureNodeVertex *vertexArray = (HCGLTextureNodeVertex *)malloc(capacity * kHCGLVertexCount * sizeof(HCGLTextureNodeVertex));
    memcpy(vertexArray, _vertexArray, copyCount * kHCGLVertexCount * sizeof(HCGLTextureNodeVertex));
    
    GLuint *indiceArray = (GLuint *)malloc(capacity * kHCGLIndiceCount * sizeof(GLuint));
    
    HCGL_FREE(_vertexArray);
    HCGL_FREE(_indiceArray);
    _vertexArray = vertexArray;
    _indiceArray = indiceArray;
    
    [self p_setIndiceArray];
}

- (void)p_setVAOVBO {
    glDeleteBuffers(1, &_vbo);
    glDeleteBuffers(1, &_ebo);
    glDeleteVertexArrays(1, &_vao);
    glBindVertexArray(0);
    
    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    
    glGenBuffers(1, &_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(HCGLTextureNodeVertex), NULL + offsetof(HCGLTextureNodeVertex, position));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 4, GL_FLOAT, GL_FALSE, sizeof(HCGLTextureNodeVertex), NULL + offsetof(HCGLTextureNodeVertex, textureAndAlpha));
    
    glGenBuffers(1, &_ebo);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLuint) * self.capacity * kHCGLIndiceCount, _indiceArray, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    glBindVertexArray(0);
}

- (void)p_setIndiceArray {
    GLuint startIndex = 0;
    GLuint *indice = &(_indiceArray[0]);
    for (NSUInteger i = 0;i < self.capacity;i ++) {
        GLuint *p = indice;
        *p = startIndex + 0;
        p ++;
        *p = startIndex + 2;
        p ++;
        *p = startIndex + 1;
        p ++;
        *p = startIndex + 0;
        p ++;
        *p = startIndex + 3;
        p ++;
        *p = startIndex + 2;
        
        startIndex += kHCGLVertexCount;
        indice += kHCGLIndiceCount;
    }
    
    if (_ebo) {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLuint) * self.capacity * kHCGLIndiceCount, _indiceArray, GL_STATIC_DRAW);
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    }
}

@end
