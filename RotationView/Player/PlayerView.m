//
//  PlayerView.m
//  Player
//
//  Created by zqnb on 16/6/14.
//  Copyright © 2016年 yxy. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView


-(void)setUrl:(NSURL *)url
{
    //直播视频
    
    _url = url;
    if (!_player) {
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
        NSLog(@"---ijk : %@",url);
    }

    
    if (!self.PlayerView){
    UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.PlayerView = displayView;
    self.PlayerView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.PlayerView];
    }
    //蒙版
    if (!_loadingV){
        
        _loadingV = [[ZJLoading alloc] initWithFrame:self.PlayerView.bounds Title:@"加载中" Image:[UIImage imageNamed:@"加载"]];
        [self addSubview:_loadingV];
    }
    _loadingV.hidden = NO;
    UIView *playerView = [self.player view];
    playerView.frame = self.PlayerView.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.PlayerView insertSubview:playerView atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    [self installMovieNotificationObservers];
    
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];

    [UIView animateWithDuration:0.5 animations:^{
        self.PlayerView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _loadingV.frame = self.bounds;
    }];
    
}
- (void)startPlay{
    
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
}
- (void)stopPlay{
    if ([self.player isPlaying]){
        [self.player stop];
    }
}
- (void)pausePlay{
    if ([self.player isPlaying]) {
        [self.player pause];
    }
}

- (void)shutDowm{
    if ([self.player isPlaying]){
        [self.player shutdown];
        [self removeMovieNotificationObservers];
        self.player = nil;
        [self.PlayerView removeFromSuperview];
        self.PlayerView = nil;
        _loadingV = nil;
    }
}
- (void)changeStreamWithURLStr:(NSString *)urlStr{
    [self shutDowm];
    
    self.url = [NSURL URLWithString:urlStr];
//    [self startPlay];
}
#pragma mark 通知调用方法
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    NSLog(@"loadState-------%lu",(unsigned long)loadState);
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
                
        if (![self.player isPlaying]) {
            [self.player prepareToPlay];
        }
        
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    NSLog(@"reason------%d",reason);
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n---%@",notification);
    
   
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
    _loadingV.hidden = YES;
    [_loadingV removeFromSuperview];
}

#pragma mark 注册Notifiacation

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}
#pragma mark 移除通知
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}
- (void)dealloc {
    
    [self.player shutdown];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
