//
//  UIColor+HEX.h
//  演示
//
//  Created by Will on 2017/7/28.
//  Copyright © 2017年 Will. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
//设置RGB颜色值
@interface UIColor (HEX)
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
