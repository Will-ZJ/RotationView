//
//  UIView+ZJAdditions.h
//  CCCamera
//
//  Created by Will on 2017/8/30.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZJAdditions)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

- (UIViewController *)viewController;

/**
 // logo 一般放在表头
 
 @param logoName logo图片
 */
+ (instancetype)ViewWithLogo:(NSString *)logoName title:(NSString *)title height:(CGFloat)heigth;
@end
