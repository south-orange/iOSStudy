//
//
//  MathUtils.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/15.
//  
//
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MathUtils : NSObject

+ (NSInteger)randomIntegerBetweenA:(NSUInteger)a B:(NSUInteger)b;
+ (CGFloat)randomDoubleBetweenA:(CGFloat)a B:(CGFloat)b;

+ (HCGLPoint)randomGLPointInRect:(HCGLRect)rect;

+ (CGFloat)randomDirection;

+ (CGFloat)deltaDirectionWithA:(CGFloat)a B:(CGFloat)b;

+ (CGFloat)changeDirectionFrom:(CGFloat)from to:(CGFloat)to limit:(CGFloat)limit;

+ (CGFloat)getValidDirection:(CGFloat)direction;

+ (CGFloat)directionCGFromA:(CGPoint)a toB:(CGPoint)b distance:(CGFloat *)distance;
+ (CGFloat)directionGLFromA:(HCGLPoint)a toB:(HCGLPoint)b distance:(CGFloat *)distance;

+ (BOOL)isCollideBetweenA:(HCGLRect)a B:(HCGLRect)b;

@end

NS_ASSUME_NONNULL_END
