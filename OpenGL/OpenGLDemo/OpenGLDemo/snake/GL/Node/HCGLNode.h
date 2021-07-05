//
//
//  HCGLNode.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/26.
//  
//

NS_ASSUME_NONNULL_BEGIN

#define rotate(type, x, y, cr, sr) (type ? x * cr - y * sr : x * sr + y * cr)

@interface HCGLNode : NSObject

@property(nonatomic, assign) HCGLPoint position;
@property(nonatomic, assign) HCGLSize size;
@property(nonatomic, assign) GLfloat direction;
@property(nonatomic, assign) GLfloat alpha;
@property(nonatomic, assign) BOOL hidden;

@property(nonatomic, assign) NSUInteger nodeId;

- (instancetype)initWithPosition:(HCGLPoint)position size:(HCGLSize)size direction:(GLfloat)direction alpha:(GLfloat)alpha;
- (instancetype)initWithPosition:(HCGLPoint)position size:(HCGLSize)size direction:(GLfloat)direction;

- (void)calculateVertexArray;

@end

NS_ASSUME_NONNULL_END
