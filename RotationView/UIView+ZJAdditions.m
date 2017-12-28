//
//  UIView+ZJAdditions.m
//  CCCamera
//
//  Created by Will on 2017/8/30.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import "UIView+ZJAdditions.h"

@implementation UIView (ZJAdditions)
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIViewController *)viewController
{
    if ([[self nextResponder] isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)[self nextResponder];
    }
    
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (instancetype)ViewWithLogo:(NSString *)logoName title:(NSString *)title  height:(CGFloat)heigth
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, heigth)];
    UIImage * img = [UIImage imageNamed:logoName];
    UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
    imgView.size = img.size;
    imgView.center = view.center;
    
    [view addSubview:imgView];
    if (title.length) {
        imgView.top = 30.f;
        UILabel * label = [UILabel new];
        label.text = title;
        label.font = [UIFont systemFontOfSize:15.f];
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width-30, 16);
        label.textAlignment = NSTextAlignmentCenter;
        label.top = imgView.bottom;
        [view addSubview:label];
    }
    return view;
}

@end
