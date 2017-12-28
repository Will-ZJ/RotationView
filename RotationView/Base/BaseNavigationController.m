//
//  BaseNavigationController.m
//  横竖屏切换
//
//  Created by Harvey on 16/5/19.
//  Copyright © 2016年 Halley. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIColor+HEX.h"
@implementation BaseNavigationController

#pragma mark - override method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    // 导航栏背景颜色
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#091022"];
    
    self.navigationBar.tintColor = [UIColor colorWithHexString:@"#ffffff"];
    // 标题颜色
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ffffff"]};
//     是否返回半透明背景
    self.navigationBar.translucent = NO;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}



@end
