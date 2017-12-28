//
//  BaseTabBarController.m
//  SecurityMonitoring
//
//  Created by Will on 2017/11/13.
//  Copyright © 2017年 Will. All rights reserved.
//

#import "BaseTabBarController.h"
#import "RealTimeProtectionVC.h"
#import "AlarmLogVC.h"
#import "UIColor+HEX.h"
#import "PAZCLDefineTool.h"
#import "BaseNavigationController.h"

@interface BaseTabBarController ()
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpTabarVc];
    [self setTabarApperance];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)setUpTabarVc {
    RealTimeProtectionVC *c1 = [[RealTimeProtectionVC alloc]init];
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:c1];
    c1.title = @"实时监控";
    c1.tabBarItem.title = @"实时监控";
    
    AlarmLogVC *c2 = [AlarmLogVC new];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:c2];
    c2.title = @"报警日志";
    c2.tabBarItem.title = @"报警日志";
    
    // 自定义底部图片
    c1.tabBarItem.image = [[UIImage imageNamed:@"监控icon_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c1.tabBarItem.selectedImage = [[UIImage imageNamed:@"监控icon_click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    c2.tabBarItem.image = [[UIImage imageNamed:@"报警icon_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c2.tabBarItem.selectedImage = [[UIImage imageNamed:@"报警icon_click拷贝"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 自定义字体颜色
    NSMutableDictionary *textArrays = [NSMutableDictionary dictionary];
    textArrays[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#888888"];
    [c1.tabBarItem setTitleTextAttributes:textArrays forState:UIControlStateNormal];
    [c2.tabBarItem setTitleTextAttributes:textArrays forState:
     UIControlStateNormal];
     
     self.viewControllers = @[nav1,nav2];

}
- (void)setTabarApperance{
    [UITabBar appearance].translucent = NO;
    [[UITabBar appearance] setBarTintColor: [UIColor blueColor]];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (void)deviceOrientationDidChange
{
    NSLog(@"NAV deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [self orientationChange:NO];
        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        [self orientationChange:YES];
    }
}

- (void)orientationChange:(BOOL)landscapeRight
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (landscapeRight) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.view.bounds = CGRectMake(0, 0, width, height);
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(0);
            self.view.bounds = CGRectMake(0, 0, width, height);
        }];
    }
}

@end
