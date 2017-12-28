//
//  RealTimeProtectionVC.h
//  SecuritySystem
//
//  Created by Will on 2017/10/17.
//  Copyright © 2017年 Will. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FloorModel.h"

@interface RealTimeProtectionVC : UIViewController

//@property (nonatomic, strong) NSArray <FloorModel *> *floorArray;
//流地址
@property (nonatomic,copy) NSString *camRtspUrl;

- (void)loadSingleCamRtspUrl:(NSString *)camRtspUrl;

@end
