//
//
//  HCGLHeader.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/24.
//  
//
    

#ifndef HCGLHeader_h
#define HCGLHeader_h

#import <GLKit/GLKit.h>

#define HCGL_FREE(p) do {if (p) {free(p); (p) = NULL;}} while(0)

static int const kHCGLMutiTextureProgramMaxTextureNum = 8;

static NSUInteger const kHCGLVertexAttribTextureIndexAndWidth = 100;

typedef struct {
    GLfloat x;
    GLfloat y;
} HCGLPoint;

typedef struct {
    GLfloat width;
    GLfloat height;
} HCGLSize;

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat width;
    GLfloat height;
} HCGLRect;

static inline HCGLPoint HCGLPointMake(GLfloat x, GLfloat y) {
    HCGLPoint point;
    point.x = x;
    point.y = y;
    return point;
}

static inline BOOL HCGLPointIsEqual(HCGLPoint l, HCGLPoint r) {
    return l.x == r.x && l.y == r.y;
}

static inline HCGLSize HCGLSizeMake(GLfloat w, GLfloat h) {
    HCGLSize size;
    size.width = w;
    size.height = h;
    return size;
}

static inline BOOL HCGLSizeIsEqual(HCGLSize a, HCGLSize b) {
    return a.width == b.width && a.height == b.height;
}

static inline HCGLRect HCGLRectMake(GLfloat x, GLfloat y, GLfloat w, CGFloat h) {
    HCGLRect rect;
    rect.x = x;
    rect.y = y;
    rect.width = w;
    rect.height = h;
    return rect;
}

#define HCGLPointZero HCGLPointMake(0.0, 0.0)
#define HCGLSizeZero HCGLSizeMake(0.0, 0.0)
#define HCGLRectZero HCGLRectMake(0.0, 0.0, 0.0, 0.0)

#define kHCGLVertexCount 4
#define kHCGLIndiceCount 6

typedef struct {
    GLKVector2 position;
    GLKVector4 color;
} HCGLColorNodeVertex;

typedef struct {
    GLKVector2 position;
    GLKVector4 textureAndAlpha;// x,y,z,alpha
} HCGLTextureNodeVertex;


#endif /* HCGLHeader_h */
