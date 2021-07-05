//
//
//  HCMapNode.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/16.
//  
//
    

#import "HCMapNode.h"

#define rotate(type, x, y, cr, sr) (type ? x * cr - y * sr : x * sr + y * cr)

@implementation HCMapNode

+ (instancetype)nodeWithNode:(HCMapNode *)otherNode {
    HCMapNode *node = HCMapNode.new;
    node.center = otherNode.center;
    node.size = otherNode.size;
    node.direction = otherNode.direction;
    return node;
}

- (CGRect)nodeCGRect {
    return CGRectMake(self.center.x - self.size.width * 0.5, self.center.y - self.size.height * 0.5, self.size.width, self.size.height);
}

- (HCGLRect)nodeGLRect {
    return HCGLRectMake(self.center.x - self.size.width * 0.5, self.center.y - self.size.height * 0.5, self.size.width, self.size.height);
}

- (void)calculatePoints {
    self.hasCalculated = YES;
    float x = self.center.x;
    float y = self.center.y;
    float w_2 = self.size.width / 2;
    float h_2 = self.size.height / 2;
    
    float cr = cosf(self.direction);
    float sr = sinf(self.direction);
    
    // 矩形点的位置如下
    // b   c
    // a   d
    
    _points[0] = HCGLPointMake(x + rotate(YES, -h_2, -w_2, cr, sr), y + rotate(NO, -h_2, -w_2, cr, sr));// 左下
    _points[1] = HCGLPointMake(x + rotate(YES, -h_2, w_2, cr, sr), y + rotate(NO, -h_2, w_2, cr, sr));// 左上
    _points[2] = HCGLPointMake(x + rotate(YES, h_2, w_2, cr, sr), y + rotate(NO, h_2, w_2, cr, sr));// 右上
    _points[3] = HCGLPointMake(x + rotate(YES, h_2, -w_2, cr, sr), y + rotate(NO, h_2, -w_2, cr, sr));// 右下
}

@end
