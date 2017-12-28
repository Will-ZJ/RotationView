//
//  PlayerView.h
//  Player
//
//  Created by zqnb on 16/6/14.
//  Copyright © 2016年 yxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJLoading.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface PlayerView : UIView

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, retain) id <IJKMediaPlayback> player;
@property (weak, nonatomic) UIView *PlayerView;
@property (nonatomic, strong) ZJLoading *loadingV;
- (void)startPlay;
- (void)stopPlay;
- (void)pausePlay;
//关闭(切换流之前调用)
- (void)changeStreamWithURLStr:(NSString *)urlStr;

@end
