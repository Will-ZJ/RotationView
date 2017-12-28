//
//  RealTimeProtectionVC.m
//  SecuritySystem
//
//  Created by Will on 2017/10/17.
//  Copyright © 2017年 Will. All rights reserved.
//

#import "RealTimeProtectionVC.h"
#import "PAZCLDefineTool.h"
#import "UIColor+HEX.h"
#import "PlayerView.h"
#import "UIView+ZJAdditions.h"
#import "LMJDropdownMenu.h"
#import "UIColor+HEX.h"



@interface RealTimeProtectionVC ()<LMJDropdownMenuDelegate>
@property (nonatomic, strong) UIView *menueView;
@property (nonatomic, assign) UIInterfaceOrientation InterfaceOrientation;
@property (nonatomic, strong) PlayerView *first_PV;
@property (nonatomic, strong) PlayerView *sencond_PV;
@property (nonatomic, strong) PlayerView *third_PV;
@property (nonatomic, strong) PlayerView *Fourth_PV;
@property (nonatomic, strong) UIView *videoMonitoringView;
@property (nonatomic, strong) UIView *rotateView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIButton *HDButton;
@property (nonatomic, strong) UIButton *multiButtoon;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIView *topMenu;
@property (nonatomic, strong) UIButton *luPing_btn;
@property (nonatomic, strong) UIButton *jiePing_btn;
@property (nonatomic, strong) UIButton *control_btn;
@property (nonatomic, strong) UIButton *palyBack_btn;
@property (nonatomic, strong) UIButton *bigger_btn;
@property (nonatomic, strong) UIButton *voice_btn;
@property (nonatomic, strong) UIButton *talk_btn;
@property (nonatomic, strong) UILabel *luPing_label;
@property (nonatomic, strong) UILabel *jiePing_label;
@property (nonatomic, strong) UILabel *Control_label;
@property (nonatomic, strong) UILabel *playBack_label;
@property (nonatomic, strong) UILabel *bigger_label;
@property (nonatomic, strong) UILabel *vocie_label;
@property (nonatomic, strong) UILabel *talk_label;
//假按钮
@property (nonatomic, strong) UIImageView *fullScreenB;
@property (nonatomic, strong) UIImageView *multiScreenB;
@property (nonatomic, strong) UIImageView *HudImageV;
//多屏切换标签
@property (nonatomic, assign) BOOL isMultiScreen;
//选择楼层
@property (nonatomic, strong) LMJDropdownMenu *selectFloor;
@property (nonatomic, strong) LMJDropdownMenu *selectAreas;
@property (nonatomic, strong) LMJDropdownMenu *deviceID;
@property (nonatomic, strong) LMJDropdownMenu *videoMonitor;
//假导航条
@property (nonatomic, strong) UIView *custombar;
//区域ID集合
@property (nonatomic, strong) NSArray *areaIdArr;

//选中播放器
@property (nonatomic, assign) int selectedPlayer;
//动画属性
@property (nonatomic, strong) UIView *touchView;
@property (nonatomic, strong) UIImageView *animateV;
@end

@implementation RealTimeProtectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"111b34"];
    self.isMultiScreen = YES;

    [self addUI];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (UIView *)custombar{
    if (!_custombar){
        _custombar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 32)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.text = @"实时监控";
        label.textColor = [UIColor whiteColor];
        [_custombar addSubview:label];
        [label sizeToFit];
        label.center = _custombar.center;
        _custombar.backgroundColor = [UIColor colorWithHexString:@"#091022"];
    }
    return _custombar;
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    UIInterfaceOrientation status=[UIApplication sharedApplication].statusBarOrientation;
    self.InterfaceOrientation = status;
    NSLog(@"UIInterfaceOrientation %ld",(long)status);
    if (status == UIInterfaceOrientationPortrait){

        self.tabBarController.tabBar.hidden = NO;

        [self portraitLayout];

    }else if(status == UIInterfaceOrientationLandscapeRight){
        // 强制隐藏tabbar
        NSArray *views = self.tabBarController.view.subviews;
        UIView *contentView = [views objectAtIndex:0];
        contentView.height += 49;
        self.view.height += 49;
        self.tabBarController.tabBar.hidden = YES;
        
        [self landScapeLayout];
    }
}
#pragma mark 竖屏布局
- (void)portraitLayout{
    [self.custombar removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO];
    self.rotateView.frame = CGRectMake(0, CGRectGetMaxY(self.topMenu.frame), kScreenWidth, self.view.bounds.size.height-CGRectGetHeight(self.topMenu.bounds));

    self.HudImageV.hidden = YES;
    self.HDButton.hidden = NO;
    self.HDButton.frame = CGRectMake(kScreenWidth_Ratio(54/2), kScreenHeight_Ratio(26/2), kScreenWidth_Ratio(67/2), kScreenHeight_Ratio(36/2));
    [self.HDButton setBackgroundImage:[UIImage imageNamed:@"HD白"] forState:UIControlStateNormal];
    
    self.multiScreenB.hidden = YES;
    self.multiButtoon.hidden = NO;
    self.multiButtoon.frame = CGRectMake(0, CGRectGetMinY(self.HDButton.frame), kScreenWidth_Ratio(24), kScreenHeight_Ratio(34/2));
    self.multiButtoon.centerY = self.HDButton.centerY;
    self.multiButtoon.centerX = self.rotateView.centerX;
    [self.multiButtoon setBackgroundImage:[UIImage imageNamed:@"多屏图标"] forState:UIControlStateNormal];
    
    self.fullScreenButton.hidden = NO;
    self.fullScreenB.hidden = YES;
    self.fullScreenButton.frame = CGRectMake(kScreenWidth-kScreenWidth_Ratio(54/2)-CGRectGetWidth(self.HDButton.bounds), CGRectGetMinY(self.HDButton.frame), kScreenWidth_Ratio(51/2), kScreenWidth_Ratio(51/2));
    [self.fullScreenButton setBackgroundImage:[UIImage imageNamed:@"全屏白"] forState:UIControlStateNormal];
    //视屏监控区域
    self.videoMonitoringView.frame = CGRectMake(0, 40.5 +kScreenHeight_Ratio(184/2), kScreenWidth, kScreenHeight_Ratio(408/2));

    [self videoMonitoringViewAdaptScreen:self.selectedPlayer];
    //底部菜单栏
//    self.menueView.frame = CGRectMake(0,CGRectGetMaxY(self.rotateView.bounds)-kScreenHeight_Ratio(188/2), kScreenWidth, kScreenHeight_Ratio(188/2));
//    self.changeBtn.frame = CGRectMake(0, CGRectGetMinY(self.menueView.frame)-kScreenHeight_Ratio(15), kScreenWidth_Ratio(62/2), kScreenHeight_Ratio(15));
    self.menueView.frame = CGRectMake(0,CGRectGetMaxY(self.rotateView.bounds)-12, kScreenWidth, 12);
    self.changeBtn.frame = CGRectMake(0, CGRectGetMinY(self.menueView.frame)-kScreenHeight_Ratio(15), kScreenWidth_Ratio(62/2), kScreenHeight_Ratio(15));
    self.changeBtn.centerX = self.menueView.centerX;
    [self.changeBtn setImage:[UIImage imageNamed:@"组34"] forState:UIControlStateNormal];
    [self.changeBtn setImage:[UIImage imageNamed:@"组35"] forState:UIControlStateSelected];
    self.changeBtn.selected = NO;
    
    self.luPing_btn.frame = CGRectMake(kScreenWidth_Ratio(26/2), kScreenHeight_Ratio(50/2), kScreenWidth_Ratio(54/2), kScreenWidth_Ratio(54/2));
    self.jiePing_btn.frame = CGRectMake(CGRectGetMaxX(self.luPing_btn.frame) + kScreenWidth_Ratio(52/2), CGRectGetMinY(self.luPing_btn.frame), CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.control_btn.frame = CGRectMake(CGRectGetMaxX(self.jiePing_btn.frame)+kScreenWidth_Ratio(54/2), CGRectGetMinY(self.luPing_btn.frame), CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.palyBack_btn.frame = CGRectMake(CGRectGetMaxX(self.Control_label.frame)+kScreenWidth_Ratio(53/2), CGRectGetMinY(self.luPing_btn.frame), CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.bigger_btn.frame = CGRectMake(CGRectGetMaxX(self.palyBack_btn.frame)+kScreenWidth_Ratio(55/2), CGRectGetMinY(self.luPing_btn.frame), CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.voice_btn.frame = CGRectMake(CGRectGetMaxX(self.bigger_btn.frame)+kScreenWidth_Ratio(53/2), CGRectGetMinY(self.luPing_btn.frame), CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.talk_btn.frame = CGRectMake(CGRectGetMaxX(self.voice_btn.frame)+kScreenWidth_Ratio(53/2), CGRectGetMinY(self.luPing_btn.frame), CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    
    self.luPing_label.frame = CGRectMake(0, CGRectGetMaxY(self.luPing_btn.frame) + kScreenHeight_Ratio(21/2), 0, 0);
    [self.luPing_label sizeToFit];
    self.luPing_label.centerX = self.luPing_btn.centerX;
    
    self.jiePing_label.frame = CGRectMake(0, CGRectGetMinY(self.luPing_label.frame), 0, 0);
    [self.jiePing_label sizeToFit];
    self.jiePing_label.centerX = self.jiePing_btn.centerX;
    
    self.Control_label.frame = CGRectMake(0, CGRectGetMinY(self.luPing_label.frame), 0, 0);
    [self.Control_label sizeToFit];
    self.Control_label.centerX = self.control_btn.centerX;
    
     self.playBack_label.frame = CGRectMake(0, CGRectGetMinY(self.luPing_label.frame), 0, 0);
    [self.playBack_label sizeToFit];
    self.playBack_label.centerX = self.palyBack_btn.centerX;
    
    self.bigger_label.frame = CGRectMake(0, CGRectGetMinY(self.luPing_label.frame), 0, 0);
    [self.bigger_label sizeToFit];
    self.bigger_label.centerX = self.bigger_btn.centerX;
    
    self.vocie_label.frame = CGRectMake(0, CGRectGetMinY(self.luPing_label.frame), 0, 0);
    [self.vocie_label sizeToFit];
    self.vocie_label.centerX = self.voice_btn.centerX;

    self.talk_label.frame = CGRectMake(0, CGRectGetMinY(self.luPing_label.frame), 0, 0);
    [self.talk_label sizeToFit];
    self.talk_label.centerX = self.talk_btn.centerX;
}
#pragma mark 添加控件
- (void)addUI{
    UIView *topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    //    UIView *topMenu = [UIView new];
    self.topMenu = topMenu;
    [self.view addSubview:topMenu];
    
    LMJDropdownMenu *topV1 = [[LMJDropdownMenu alloc]init];
    topV1.tag = 1;
    topV1.frame = CGRectMake(0,0,(kScreenWidth-1.5)/4, 40);
    topV1.backgroundColor = [UIColor colorWithHexString:@"111b34"];

    [topV1 setMenuTitles:@[] rowHeight:30 ButtonTitle:@"选择楼层"];
    topV1.delegate = self;
    [topMenu bringSubviewToFront:topV1];
    self.selectFloor = topV1;
    [self.view addSubview:topV1];
    
    LMJDropdownMenu *topV2 = [[LMJDropdownMenu alloc]init];
    topV2.tag = 2;
    topV2.frame = CGRectMake(CGRectGetMaxX(topV1.frame)+0.5, 0, (kScreenWidth-1.5)/4, 40);
    [topV2 setMenuTitles:@[] rowHeight:30 ButtonTitle:@"选择区域"];
    topV2.backgroundColor = [UIColor colorWithHexString:@"111b34"];
    topV2.delegate = self;
    self.selectAreas = topV2;
    [self.view addSubview:topV2];
    
    LMJDropdownMenu *topV3 = [[LMJDropdownMenu alloc]init];
    topV3.tag = 3;
    topV3.frame = CGRectMake(CGRectGetMaxX(topV2.frame)+0.5, 0, CGRectGetWidth(topV1.frame), 40);
    topV3.backgroundColor = [UIColor colorWithHexString:@"111b34"];
    [topV3 setMenuTitles:@[] rowHeight:30 ButtonTitle:@"设备ID" ];
    topV3.delegate = self;
    self.deviceID = topV3;
    [self.view addSubview:topV3];
    
    LMJDropdownMenu *topV4 = [[LMJDropdownMenu alloc] init];
    topV4.tag = 4;
    topV4.frame = CGRectMake(CGRectGetMaxX(topV3.frame)+0.5, 0, CGRectGetWidth(topV1.bounds), 40);
    [topV4 setMenuTitles:@[@"监控一",@"监控二",@"监控三",@"监控四"] rowHeight:30 OnlyImage:[UIImage imageNamed:@"形状1892拷贝"]];
    topV4.backgroundColor = [UIColor colorWithHexString:@"111b34"];
    self.videoMonitor = topV4;
    topV4.delegate = self;
//    UIButton *topV4 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topV3.frame)+0.5, 0, CGRectGetWidth(topV1.bounds), 40)];
//    [topV4 setImage:[UIImage imageNamed:@"形状1892拷贝"] forState:UIControlStateNormal];
//    topV4.backgroundColor = [UIColor colorWithHexString:@"111b34"];
    [self.view addSubview:topV4];

    UIView *cover = [[UIView alloc] initWithFrame:topV4.frame];
    [self.view addSubview:cover];
    self.touchView = cover;
    
    

    UIView *line1 = [[UIView alloc]init];
    line1.frame = CGRectMake((kScreenWidth-1.5)/4, 0, 0.5, 40);
    line1.backgroundColor = [UIColor colorWithHexString:@"2c3d67"];
    [topMenu addSubview:line1];
    
     UIView *line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(CGRectGetMaxX(topV2.frame), 0, 0.5, 40);
    line2.backgroundColor = [UIColor colorWithHexString:@"2c3d67"];
    [topMenu addSubview:line2];

    
    UIView *line3 = [[UIView alloc]init];
    line3.frame = CGRectMake(CGRectGetMaxX(topV3.frame), 0, 0.5, 40);
    line3.backgroundColor = [UIColor colorWithHexString:@"2c3d67"];;
    [topMenu addSubview:line3];
    
    
    UIView *line4 = [[UIView alloc]init];
    line4.frame = CGRectMake(0, CGRectGetMaxY(topMenu.frame), kScreenWidth, 0.5);
    line4.backgroundColor = [UIColor colorWithHexString:@"2c3d67"];;
    [self.view addSubview:line4];

    UIView *rotateV = [[UIView alloc] init];
//    rotateV.backgroundColor = [UIColor lightGrayColor];
    self.rotateView = rotateV;
    [self.view addSubview:rotateV];
    
    UIButton *HDBtn = [[UIButton alloc] init];
    self.HDButton = HDBtn;
    
    [HDBtn setBackgroundImage:[UIImage imageNamed:@"HD白"] forState:UIControlStateNormal];
    [rotateV addSubview:HDBtn];
    
    UIButton *multiScreenBtn = [[UIButton alloc] init];
    self.multiButtoon = multiScreenBtn;
    [multiScreenBtn addTarget:self action:@selector(MultiScreenChange) forControlEvents:UIControlEventTouchUpInside];
    [multiScreenBtn setBackgroundImage:[UIImage imageNamed:@"多屏图标"] forState:UIControlStateNormal];
    [rotateV addSubview:multiScreenBtn];
    
    UIButton *fullScreenBtn = [[UIButton alloc] init];
    self.fullScreenButton = fullScreenBtn;
    
    fullScreenBtn.centerY = HDBtn.centerY;
    [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"全屏白"] forState:UIControlStateNormal];
    [fullScreenBtn addTarget:self action:@selector(enterFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [rotateV addSubview:fullScreenBtn];
    
    //视频监控
    UIView *VideoMonitoringView = [[UIView alloc] init];
    [rotateV addSubview:VideoMonitoringView];
    self.videoMonitoringView = VideoMonitoringView;
    
    PlayerView *pv1 = [[PlayerView alloc] init];
    pv1.layer.borderWidth = 0.5;
    pv1.layer.borderColor = [UIColor colorWithHexString:@"50f1f6"].CGColor;
    [VideoMonitoringView addSubview:pv1];
    
    self.first_PV = pv1;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedPV1:)];
    [pv1 addGestureRecognizer:tap1];
    
    PlayerView *pv2 = [[PlayerView alloc] init];
   
    [VideoMonitoringView addSubview:pv2];
    pv2.layer.borderWidth = 0.5;
    pv2.layer.borderColor = [UIColor colorWithHexString:@"50f1f6"].CGColor;
    self.sencond_PV = pv2;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedPV2:)];
    [pv2 addGestureRecognizer:tap2];
    PlayerView *pv3 = [[PlayerView alloc] init];
    
    [VideoMonitoringView addSubview:pv3];
    pv3.layer.borderWidth = 0.5;
    pv3.layer.borderColor = [UIColor colorWithHexString:@"50f1f6"].CGColor;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedPV3:)];
    [pv3 addGestureRecognizer:tap3];
    self.third_PV = pv3;

    
    PlayerView *pv4 = [[PlayerView alloc] init];
   
    pv4.layer.borderWidth = 0.5;
    pv4.layer.borderColor = [UIColor colorWithHexString:@"50f1f6"].CGColor;
    [VideoMonitoringView addSubview:pv4];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedPV4:)];
    [pv4 addGestureRecognizer:tap4];
    self.Fourth_PV = pv4;
   

    //底部菜单
    UIView *bottomMenuV = [[UIView alloc] init];
    
    bottomMenuV.backgroundColor = [UIColor colorWithHexString:@"1c2742"];
    self.menueView = bottomMenuV;
    [rotateV addSubview:bottomMenuV];
    
    UIButton *changeBtn = [[UIButton alloc] init];
    self.changeBtn = changeBtn;
    [changeBtn setImage:[UIImage imageNamed:@"组34"] forState:UIControlStateNormal];
    [changeBtn setImage:[UIImage imageNamed:@"组35"] forState:UIControlStateSelected];
    [changeBtn addTarget:self action:@selector(changeLayOut:) forControlEvents:UIControlEventTouchUpInside];
    [rotateV addSubview:changeBtn];
    
    UIButton *LuPing = [[UIButton alloc] init];
    self.luPing_btn = LuPing;
    [LuPing setBackgroundImage:[UIImage imageNamed:@"录屏"] forState:UIControlStateNormal];
    [bottomMenuV addSubview:LuPing];
    
    UIButton *JiePing = [[UIButton alloc] init];
    self.jiePing_btn = JiePing;
    [JiePing setBackgroundImage:[UIImage imageNamed:@"剪刀"] forState:UIControlStateNormal];
    [bottomMenuV addSubview:JiePing];
    
    UIButton *control = [[UIButton alloc] init];
    self.control_btn = control;
    [control setBackgroundImage:[UIImage imageNamed:@"组24"] forState:UIControlStateNormal];
    [bottomMenuV addSubview:control];
    
    UIButton *playBack = [[UIButton alloc] init];
    self.palyBack_btn = playBack;
    [playBack setBackgroundImage:[UIImage imageNamed:@"回放"] forState:UIControlStateNormal];
    [bottomMenuV addSubview:playBack];
    
    UIButton *bigger = [[UIButton alloc] init];
    self.bigger_btn = bigger;
    [bigger setBackgroundImage:[UIImage imageNamed:@"放大"] forState:UIControlStateNormal];
    [bottomMenuV addSubview:bigger];
    
    UIButton *voice = [[UIButton alloc] init];
    self.voice_btn = voice;
    [voice setBackgroundImage:[UIImage imageNamed:@"声音"] forState:UIControlStateNormal];
    [bottomMenuV addSubview:voice];
    
    UIButton *talk = [[UIButton alloc] init];
    self.talk_btn = talk;
    [talk setBackgroundImage:[UIImage imageNamed:@"对讲"] forState:UIControlStateNormal];
    [bottomMenuV addSubview:talk];
    
    UILabel *lP_label = [[UILabel alloc] init];
    self.luPing_label = lP_label;
    lP_label.text = @"录屏";
    lP_label.font = [UIFont systemFontOfSize:13];
    lP_label.textColor = [UIColor colorWithHexString:@"ffffff"];
    
    [bottomMenuV addSubview:lP_label];
    
    UILabel *JP_label = [[UILabel alloc] init];
    self.jiePing_label = JP_label;
    JP_label.text = @"截屏";
    JP_label.font = [UIFont systemFontOfSize:13];
    JP_label.textColor = [UIColor colorWithHexString:@"ffffff"];
    
    [bottomMenuV addSubview:JP_label];
    
    UILabel *CL_label = [[UILabel alloc] init];
    self.Control_label = CL_label;
    CL_label.text = @"云台控制";
    CL_label.font = [UIFont systemFontOfSize:13];
    CL_label.textColor = [UIColor colorWithHexString:@"ffffff"];
 
    [bottomMenuV addSubview:CL_label];
    
    UILabel *PB_label = [[UILabel alloc] init];
    self.playBack_label = PB_label;
    PB_label.text = @"回放";
    PB_label.font = [UIFont systemFontOfSize:13];
    PB_label.textColor = [UIColor colorWithHexString:@"ffffff"];
    
    [bottomMenuV addSubview:PB_label];
    
    UILabel *BG_label = [[UILabel alloc] init];
    self.bigger_label = BG_label;
    BG_label.text = @"电子放大";
    BG_label.font = [UIFont systemFontOfSize:13];
    BG_label.textColor = [UIColor colorWithHexString:@"ffffff"];
   
    [bottomMenuV addSubview:BG_label];
    
    UILabel *VC_label = [[UILabel alloc] init];
    self.vocie_label = VC_label;
    VC_label.text = @"声音";
    VC_label.font = [UIFont systemFontOfSize:13];
    VC_label.textColor = [UIColor colorWithHexString:@"ffffff"];
    
    [bottomMenuV addSubview:VC_label];
    
    UILabel *TK_label = [[UILabel alloc] init];
    self.talk_label = TK_label;
    TK_label.text = @"对讲";
    TK_label.font = [UIFont systemFontOfSize:13];
    TK_label.textColor = [UIColor colorWithHexString:@"ffffff"];
    
    [bottomMenuV addSubview:TK_label];

}
#pragma mark 播放器手势
- (void)tappedPV1:(UITapGestureRecognizer *)gesture{
    self.isMultiScreen = !self.isMultiScreen;
    self.selectedPlayer = 0;
    [self hideMenuView];
   
    [self videoMonitoringViewAdaptScreen:self.selectedPlayer];

}
- (void)tappedPV2:(UITapGestureRecognizer *)gesture{
    self.isMultiScreen = !self.isMultiScreen;
    self.selectedPlayer = 1;
    [self hideMenuView];
   
    [self videoMonitoringViewAdaptScreen:self.selectedPlayer];
}
- (void)tappedPV3:(UITapGestureRecognizer *)gesture {
    self.isMultiScreen = !self.isMultiScreen;
    self.selectedPlayer = 2;
    [self hideMenuView];
    
    [self videoMonitoringViewAdaptScreen:self.selectedPlayer];
}
- (void)tappedPV4:(UITapGestureRecognizer *)gesture{
    self.isMultiScreen = !self.isMultiScreen;
    self.selectedPlayer = 3;
    [self hideMenuView];
    
    [self videoMonitoringViewAdaptScreen:self.selectedPlayer];
}
#pragma mark 横屏布局
- (void)landScapeLayout{
    
    [self.navigationController setNavigationBarHidden:true];
  
    [self.view addSubview:self.custombar];
    [self.view bringSubviewToFront:self.custombar];
    
    self.rotateView.frame = CGRectMake(0, 32, kScreenWidth,kScreenHeight-32);
    //左侧按钮
    self.multiButtoon.hidden = YES;
    if (!self.multiScreenB){
        UIImageView *MSimgeView = [[UIImageView alloc] init];
        MSimgeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MultiScreenChange)];
        [MSimgeView addGestureRecognizer:tap];
        [self.rotateView addSubview:MSimgeView];
        self.multiScreenB = MSimgeView;
    }
    self.multiScreenB.hidden = NO;
    self.multiScreenB.frame = CGRectMake(kScreenHeight_Ratio(15) , (CGRectGetHeight(self.rotateView.bounds))/2 - 35/2, 35, 35);
    self.multiScreenB.image = [UIImage imageNamed:@"全屏"];
    
    self.fullScreenButton.hidden = YES;
    if (!self.fullScreenB){
        UIImageView *FSimgeView = [[UIImageView alloc] init];
        FSimgeView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterFullScreen)];
        [FSimgeView addGestureRecognizer:tap];
        [self.rotateView addSubview:FSimgeView];
        self.fullScreenB = FSimgeView;
    }
    self.fullScreenB.hidden = NO;
    self.fullScreenB.frame = CGRectMake(CGRectGetMinX(self.multiScreenB.frame), CGRectGetMinY(self.multiScreenB.frame) - kScreenHeight_Ratio(77) - 35, CGRectGetWidth(self.multiScreenB.bounds), CGRectGetHeight(self.multiScreenB.bounds));
    self.fullScreenB.image = [UIImage imageNamed:@"组51"];
    
    self.HDButton.hidden = YES;
    if (!self.HudImageV){
        UIImageView *HUDimgeView = [[UIImageView alloc] init];
        HUDimgeView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *HUDTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TappedHUD)];
        [HUDimgeView addGestureRecognizer:HUDTap];
        [self.rotateView addSubview:HUDimgeView];
        self.HudImageV = HUDimgeView;
    }
    self.HudImageV.hidden = NO;
    self.HudImageV.frame =CGRectMake(CGRectGetMinX(self.multiScreenB.frame), CGRectGetMaxY(self.multiScreenB.frame) + kScreenHeight_Ratio(77), 35, 35);
    self.HudImageV.image = [UIImage imageNamed:@"HD"];
    //视屏监控区域
    self.videoMonitoringView.frame = CGRectMake(0, 0, CGRectGetWidth(self.rotateView.bounds), CGRectGetHeight(self.rotateView.bounds));

    [self videoMonitoringViewAdaptScreen:self.selectedPlayer];
    //右侧菜单
//    self.menueView.frame = CGRectMake(CGRectGetMaxX(self.rotateView.bounds)-95, 0, 95, CGRectGetHeight(self.rotateView.bounds));
//    self.changeBtn.frame = CGRectMake(CGRectGetMinX(self.menueView.frame)-15, 0, 15, 31);
    self.menueView.frame = CGRectMake(CGRectGetMaxX(self.rotateView.bounds)-12, 0, 12, CGRectGetHeight(self.rotateView.bounds));
    self.changeBtn.frame = CGRectMake(CGRectGetMinX(self.menueView.frame)-15, 0, 15, 31);
    self.changeBtn.centerY = self.menueView.centerY;
    self.changeBtn.selected = NO;
    
    [self.changeBtn setImage:[UIImage imageNamed:@"组40"] forState:UIControlStateNormal];
    [self.changeBtn setImage:[UIImage imageNamed:@"组41"] forState:UIControlStateSelected];
    
    self.luPing_btn.frame = CGRectMake(41/2, 14/2, 54/2, 54/2);
    self.luPing_label.frame = CGRectMake(CGRectGetMaxX(self.luPing_btn.frame) + 9/2, 0, 0, 0);
    [self.luPing_label sizeToFit];
    self.luPing_label.centerY = self.luPing_btn.centerY ;
    
    self.jiePing_btn.frame = CGRectMake(CGRectGetMinX(self.luPing_btn.frame), CGRectGetMaxY(self.luPing_btn.frame) + 38/2, CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.jiePing_label.frame = CGRectMake(CGRectGetMaxX(self.jiePing_btn.frame) + 9/2, 0, 0, 0);
    [self.jiePing_label sizeToFit];
    self.jiePing_label.centerY = self.jiePing_btn.centerY ;
    
    self.control_btn.frame = CGRectMake(CGRectGetMinX(self.luPing_btn.frame), CGRectGetMaxY(self.jiePing_btn.frame) + 38/2, CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.Control_label.frame = CGRectMake(CGRectGetMaxX(self.control_btn.frame) + 9/2, 0, 28, 0);
    self.Control_label.lineBreakMode = UILineBreakModeWordWrap;
    self.Control_label.numberOfLines = 0;
    [self.Control_label sizeToFit];
    self.Control_label.centerY = self.control_btn.centerY ;
    
    self.palyBack_btn.frame = CGRectMake(CGRectGetMinX(self.luPing_btn.frame), CGRectGetMaxY(self.control_btn.frame) + 38/2, CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.playBack_label.frame = CGRectMake(CGRectGetMaxX(self.palyBack_btn.frame) + 9/2, 0, 0, 0);
    [self.playBack_label sizeToFit];
    self.playBack_label.centerY = self.palyBack_btn.centerY ;
    
    self.bigger_btn.frame = CGRectMake(CGRectGetMinX(self.luPing_btn.frame), CGRectGetMaxY(self.palyBack_btn.frame) + 38/2, CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.bigger_label.frame = CGRectMake(CGRectGetMaxX(self.bigger_btn.frame) + 9/2, 0, 28, 0);
    self.bigger_label.lineBreakMode = UILineBreakModeWordWrap;
    self.bigger_label.numberOfLines = 0;
    [self.bigger_label sizeToFit];
    self.bigger_label.centerY = self.bigger_btn.centerY ;
    
    self.voice_btn.frame = CGRectMake(CGRectGetMinX(self.luPing_btn.frame), CGRectGetMaxY(self.bigger_btn.frame) + 38/2, CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.vocie_label.frame = CGRectMake(CGRectGetMaxX(self.voice_btn.frame) + 9/2, 0, 0, 0);
    [self.vocie_label sizeToFit];
    self.vocie_label.centerY = self.voice_btn.centerY ;
    
    self.talk_btn.frame = CGRectMake(CGRectGetMinX(self.luPing_btn.frame), CGRectGetMaxY(self.voice_btn.frame) + 38/2, CGRectGetWidth(self.luPing_btn.bounds), CGRectGetHeight(self.luPing_btn.bounds));
    self.talk_label.frame = CGRectMake(CGRectGetMaxX(self.voice_btn.frame) + 9/2, 0, 0, 0);
    [self.talk_label sizeToFit];
    self.talk_label.centerY = self.talk_btn.centerY ;
    
}

#pragma mark 展开按钮点击事件
- (void)changeLayOut:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self hideMenuView];
    UIInterfaceOrientation status=[UIApplication sharedApplication].statusBarOrientation;
    if (status == UIInterfaceOrientationPortrait){
        
        if (sender.selected){
            [UIView animateWithDuration:0.5 animations:^{
                
//                self.menueView.top += 82;
//                self.changeBtn.top += 82;
                self.menueView.top -= 82;
                self.menueView.height += 82;
                self.changeBtn.top -= 82;
                
            }];
            
        }else{
            [UIView animateWithDuration:0.5 animations:^{
//                self.menueView.top -= 82;
//                self.changeBtn.top -= 82;
                self.menueView.top += 82;
                self.menueView.height -= 82;
                self.changeBtn.top += 82;
            }];
        }

    }else{
        
        if (sender.selected){
            [UIView animateWithDuration:0.5 animations:^{
                
//                self.menueView.left += 82;
//                self.changeBtn.left += 82;
                self.menueView.left -= 82;
                self.menueView.width += 82;
                self.changeBtn.left -= 82;
            }];
            
        }else{
            [UIView animateWithDuration:0.5 animations:^{
//                self.menueView.left -= 82;
//                self.changeBtn.left -= 82;
                self.menueView.left += 82;
                self.menueView.width -= 82;
                self.changeBtn.left += 82;
            }];
            
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 全屏切换
-(void)enterFullScreen{

    [self hideMenuView];
    if (self.InterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        [self interfaceOrientation: UIInterfaceOrientationPortrait];
        
    }else{
        
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        
    }
}
#pragma mark 多屏切换
- (void)MultiScreenChange{
    self.isMultiScreen = !self.isMultiScreen;
    self.selectedPlayer = 0;
    [self hideMenuView];
    //横屏
    [self videoMonitoringViewAdaptScreen:self.selectedPlayer];
}
#pragma mark 点击HUD
- (void)TappedHUD{
    NSLog(@"%s----点我了",__func__);
}
#pragma mark 视频监控区域适配
- (void)videoMonitoringViewAdaptScreen:(int)PV_Num{
    NSArray <PlayerView *>*PVArr =  @[self.first_PV,self.sencond_PV,self.third_PV,self.Fourth_PV];
    //横屏
    if (self.InterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        if (!self.isMultiScreen) {
            
            for (int i = 0; i < 4; i ++) {
                
                if (i == PV_Num){
                    PVArr[i].frame = CGRectMake(0, 0, CGRectGetWidth(self.videoMonitoringView.bounds), CGRectGetHeight(self.videoMonitoringView.bounds));
                }else{
                    PVArr[i].frame = CGRectZero;
                    if (PVArr[i].loadingV){
                        PVArr[i].loadingV.hidden = YES;
                    }
                }
                
            }
            
        }else{
            for (PlayerView *pv in PVArr) {
                if(pv.loadingV){
                    pv.loadingV.hidden = NO;
                }
            }
                self.first_PV.frame = CGRectMake(0, 0, (CGRectGetWidth(self.videoMonitoringView.bounds)-1)/2, (CGRectGetHeight(self.videoMonitoringView.bounds)-1)/2);
                self.sencond_PV.frame = CGRectMake(CGRectGetMaxX(self.first_PV.frame) + 1, 0, CGRectGetWidth(self.first_PV.bounds), CGRectGetHeight(self.first_PV.bounds));
                self.third_PV.frame = CGRectMake(0, CGRectGetMaxY(self.first_PV.bounds) + 1, CGRectGetWidth(self.first_PV.bounds), CGRectGetHeight(self.first_PV.bounds));
                self.Fourth_PV.frame = CGRectMake(CGRectGetMinX(self.sencond_PV.frame), CGRectGetMinY(self.third_PV.frame), CGRectGetWidth(self.first_PV.bounds), CGRectGetHeight(self.first_PV.bounds));
            
        }
        
        [self landscapeSetButtomImage];
        
    }else{
        //竖屏
        
        if (!self.isMultiScreen){
            
            for (int i = 0; i < 4; i ++) {
                
                if (i == PV_Num){
                    PVArr[i].frame = CGRectMake(0, 0, CGRectGetWidth(self.videoMonitoringView.bounds), CGRectGetHeight(self.videoMonitoringView.bounds));
                }else{
                    PVArr[i].frame = CGRectZero;
                    if (PVArr[i].loadingV){
                        PVArr[i].loadingV.hidden = YES;
                        
                    }
                }
                
            }

            
        }else{
            for (PlayerView *pv in PVArr) {
                if (pv.loadingV){
                    pv.loadingV.hidden = NO;
                }
            }
            self.first_PV.frame = CGRectMake(0, 0, kScreenWidth_Ratio(374/2), kScreenHeight_Ratio(203/2));
            self.first_PV.url = [NSURL URLWithString:@"rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov"];
            
            self.sencond_PV.frame = CGRectMake(CGRectGetMaxX(self.first_PV.frame) + 1, CGRectGetMinY(self.first_PV.frame), CGRectGetWidth(self.first_PV.bounds), CGRectGetHeight(self.first_PV.bounds));
            self.sencond_PV.url = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];

            
            self.third_PV.frame = CGRectMake(0 , CGRectGetMaxY(self.first_PV.frame)+1, CGRectGetWidth(self.first_PV.bounds), CGRectGetHeight(self.first_PV.bounds));
            
            self.third_PV.url = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
            
            self.Fourth_PV.frame = CGRectMake(CGRectGetMaxX(self.third_PV.frame) + 1, CGRectGetMinY(self.third_PV.frame), CGRectGetWidth(self.first_PV.bounds), CGRectGetHeight(self.first_PV.bounds));
            self.Fourth_PV.url =  [NSURL URLWithString:@"rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov"];
            
        }
        
    }
    
    [self portraitSetButtomImage];
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    self.InterfaceOrientation = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        
    }
}
//竖屏屏按钮的图片
- (void)portraitSetButtomImage{
    if (self.isMultiScreen){
        
        [self.multiButtoon setBackgroundImage:[UIImage imageNamed:@"多屏图标"] forState:UIControlStateNormal];
    }else{
        
        [self.multiButtoon setBackgroundImage:[UIImage imageNamed:@"单屏图标"] forState:UIControlStateNormal];
    }
}
//横屏按钮图片
- (void)landscapeSetButtomImage{
    if (self.isMultiScreen){
        
        [self.multiScreenB setImage:[UIImage imageNamed:@"全屏"]];
        
    }else{
        
        [self.multiScreenB setImage:[UIImage imageNamed:@"组52"]];
    }

}
#pragma mark - LMJDropdownMenu Delegate
//点击了按钮
-(void)didTappedMainBtn:(UIButton *)sender{
    NSArray *array = @[self.selectFloor,self.selectAreas,self.deviceID,self.videoMonitor];
    for (LMJDropdownMenu* obj in array) {
        NSLog(@"---%ld",(long)obj.tag);
        if (obj.tag!=sender.tag){
            [obj hideDropDown];
        }
    }
}

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
        //test流
//    NSString *testStr = @"rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov";
        NSLog(@"你选择了：%ld",number);
    [menu hideDropDown];
}

- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    NSLog(@"--将要显示--");
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    NSLog(@"--已经显示--");
}

- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--将要隐藏--");
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--已经隐藏--");
}


//收起菜单
- (void)hideMenuView{
    NSArray *array = @[self.selectFloor,self.selectAreas,self.deviceID,self.videoMonitor];
    for (LMJDropdownMenu* obj in array) {
        [obj hideDropDown];
    }

}

//- (void)touchedTopV4:(UIButton *)sender{
//    if (!self.animateV){
//        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"形状1892拷贝"]];
//        [imgV sizeToFit];
//        [self.view addSubview:imgV];
//        imgV.center = self.touchView.center;
//        self.animateV = imgV;
//    }
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self hideMenuView];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.touchView];
    
    if ([self.touchView.layer containsPoint:point]){
        if (!self.animateV){
            UIImageView *animateV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"形状1892拷贝"]];
            [animateV sizeToFit];
            self.animateV = animateV;
            [self.view addSubview:animateV];
            animateV.center = self.touchView.center;
        }
    }
    
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGPoint pa = [self.view convertPoint:point toView:self.animateV];
    NSLog(@"%s--%@---%@",__func__,NSStringFromCGPoint(point),NSStringFromCGPoint(pa));
    [UIView animateWithDuration:CGFLOAT_MIN animations:^{
        self.animateV.center = point;
    } completion:nil];
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.animateV removeFromSuperview];
    self.animateV = nil;
}

@end
