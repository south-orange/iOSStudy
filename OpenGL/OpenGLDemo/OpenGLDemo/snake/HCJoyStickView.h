//
//
//  HCJoyStickView.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/6/2.
//  
//
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCJoyStickView : UIView

@property(nonatomic, copy) void (^changeDirectionBlock)(CGFloat direction, CGFloat distance);

@end

NS_ASSUME_NONNULL_END
