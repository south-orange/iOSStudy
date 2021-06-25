//
//
//  MathUtils.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/15.
//  
//
    

#import "MathUtils.h"

@implementation MathUtils

+ (CGFloat)randomDoubleBetweenA:(CGFloat)a B:(CGFloat)b {
    CGFloat random = arc4random() % 10000 / 10000.0;
    return a + (b - a) * random;
}

+ (CGPoint)randomCGPointInRect:(CGRect)rect {
    CGFloat x = [self randomDoubleBetweenA:0 B:rect.size.width];
    CGFloat y = [self randomDoubleBetweenA:0 B:rect.size.height];
    return CGPointMake(rect.origin.x + x, rect.origin.y + y);
}

+ (HCGLPoint)randomGLPointInRect:(HCGLRect)rect {
    CGFloat x = [self randomDoubleBetweenA:0 B:rect.width];
    CGFloat y = [self randomDoubleBetweenA:0 B:rect.height];
    return HCGLPointMake(rect.x + x, rect.y + y);
}

+ (CGFloat)randomDirection {
    return (arc4random() % 36000 / 36000.0) * M_PI * 2;
}

+ (CGFloat)deltaDirectionWithA:(CGFloat)a B:(CGFloat)b {
    CGFloat delta = fabs(a - b);
    if (delta > M_PI) {
        delta = M_PI * 2 - delta;
    }
    return delta;
}

+ (CGFloat)changeDirectionFrom:(CGFloat)from to:(CGFloat)to limit:(CGFloat)limit {
    CGFloat delta = [self deltaDirectionWithA:from B:to];
    if (delta <= limit) {
        return to;
    }
    CGFloat res1 = [self getValidDirection:from + limit];
    CGFloat res2 = [self getValidDirection:from - limit];
    CGFloat res = [self deltaDirectionWithA:res1 B:to] < [self deltaDirectionWithA:res2 B:to] ? res1 : res2;
    return res;
}

+ (CGFloat)getValidDirection:(CGFloat)direction {
    if (direction > M_PI * 2) {
        return direction - M_PI * 2;
    }
    if (direction < 0) {
        return direction + M_PI * 2;
    }
    return direction;
}

+ (CGFloat)directionCGFromA:(CGPoint)a toB:(CGPoint)b distance:(CGFloat *)distance {
    return [self directionWithAx:a.x Ay:a.y Bx:b.x By:b.y distance:distance];
}

+ (CGFloat)directionGLFromA:(HCGLPoint)a toB:(HCGLPoint)b distance:(CGFloat *)distance {
    return [self directionWithAx:a.x Ay:a.y Bx:b.x By:b.y distance:distance];
}

+ (CGFloat)directionWithAx:(CGFloat)ax Ay:(CGFloat)ay Bx:(CGFloat)bx By:(CGFloat)by distance:(CGFloat *)distance {
    double a = fabs(bx - ax);
    double b = fabs(by - ay);
    double c = hypot(a, b);
    
    double cos = (bx - ax) / c;
    double sin = (by - ay) / c;
    
    CGFloat direction = acos(cos);
    if (asin(sin) > 0) {
        direction = M_PI * 2 - direction;
    }
    *distance = c;
    return direction;
}

@end
