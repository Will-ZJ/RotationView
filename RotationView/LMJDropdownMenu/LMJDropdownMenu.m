//
//  LMJDropdownMenu.m
//
//  Version:1.0.0
//
//  Created by MajorLi on 15/5/4.
//  Copyright (c) 2015年 iOS开发者公会. All rights reserved.
//
//  iOS开发者公会-技术1群 QQ群号：87440292
//  iOS开发者公会-技术2群 QQ群号：232702419
//  iOS开发者公会-议事区  QQ群号：413102158
//

#import "LMJDropdownMenu.h"
#import "UIColor+HEX.h"
#import "UIView+ZJAdditions.h"
#import "PAZCLDefineTool.h"
//#import "FSCalendar.h"

#define VIEW_CENTER(aView)       ((aView).center)
#define VIEW_CENTER_X(aView)     ((aView).center.x)
#define VIEW_CENTER_Y(aView)     ((aView).center.y)

#define FRAME_ORIGIN(aFrame)     ((aFrame).origin)
#define FRAME_X(aFrame)          ((aFrame).origin.x)
#define FRAME_Y(aFrame)          ((aFrame).origin.y)

#define FRAME_SIZE(aFrame)       ((aFrame).size)
#define FRAME_HEIGHT(aFrame)     ((aFrame).size.height)
#define FRAME_WIDTH(aFrame)      ((aFrame).size.width)



#define VIEW_BOUNDS(aView)       ((aView).bounds)

#define VIEW_FRAME(aView)        ((aView).frame)

#define VIEW_ORIGIN(aView)       ((aView).frame.origin)
#define VIEW_X(aView)            ((aView).frame.origin.x)
#define VIEW_Y(aView)            ((aView).frame.origin.y)

#define VIEW_SIZE(aView)         ((aView).frame.size)
#define VIEW_HEIGHT(aView)       ((aView).frame.size.height)
#define VIEW_WIDTH(aView)        ((aView).frame.size.width)


#define VIEW_X_Right(aView)      ((aView).frame.origin.x + (aView).frame.size.width)
#define VIEW_Y_Bottom(aView)     ((aView).frame.origin.y + (aView).frame.size.height)






#define AnimateTime 0.25f   // 下拉动画时间

@interface LMJDropdownMenu ()

@end

@implementation LMJDropdownMenu
{
    UIImageView * _arrowMark;   // 尖头图标
    UIView      * _listView;    // 下拉列表背景View
    UITableView * _tableView;   // 下拉列表
    
    NSArray     * _titleArr;    // 选项数组
    CGFloat       _rowHeight;   // 下拉列表行高
    
    UIImageView *_onlyImage;   //只有图片，不带动画
    
    BOOL _isCalendar;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createMainBtnWithFrame:frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];

    [self createMainBtnWithFrame:frame];
}


- (void)createMainBtnWithFrame:(CGRect)frame{
    
    [_mainBtn removeFromSuperview];
    _mainBtn = nil;
    
    // 主按钮 显示在界面上的点击按钮
    // 样式可以自定义
    _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mainBtn.tag = self.tag;
    [_mainBtn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_mainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_mainBtn setTitle:@"请选择我" forState:UIControlStateNormal];
    [_mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
//    _mainBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _mainBtn.titleLabel.font    = [UIFont systemFontOfSize:12.f];
    _mainBtn.titleEdgeInsets    = UIEdgeInsetsMake(0,-20, 0, 0);
    _mainBtn.selected           = NO;
    _mainBtn.backgroundColor    = [UIColor colorWithHexString:@"111b34"];
//    _mainBtn.backgroundColor = [UIColor redColor];

    [self addSubview:_mainBtn];
    
    
    // 旋转尖头
    _arrowMark = [[UIImageView alloc] initWithFrame:CGRectMake(_mainBtn.frame.size.width - 10, 0, 0, 0)];
    _arrowMark.center = CGPointMake(VIEW_CENTER_X(_arrowMark), VIEW_HEIGHT(_mainBtn)/2);
    _arrowMark.image  = [UIImage imageNamed:@"形状1"];
    [_arrowMark sizeToFit];
    [_mainBtn addSubview:_arrowMark];
    
    //图片居中（只有图片）
    _onlyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _onlyImage.center = CGPointMake(VIEW_CENTER_X(_arrowMark), VIEW_HEIGHT(_mainBtn)/2);
    [_mainBtn addSubview:_onlyImage];
}


- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight ButtonTitle:(NSString *)title{
    
    if (self == nil) {
        return;
    }
    
    [_mainBtn setTitle:title forState:UIControlStateNormal];
    _mainBtn.centerY = self.centerY;
    
    _titleArr  = [NSArray arrayWithArray:titlesArr];
    _rowHeight = rowHeight;
    
    
    // 下拉列表背景View
    _listView = [[UIView alloc] init];
    _listView.frame = CGRectMake(VIEW_X(self) , VIEW_Y_Bottom(self), VIEW_WIDTH(self),  0);
//    _listView.clipsToBounds       = YES;
//    _listView.layer.masksToBounds = NO;
//    _listView.layer.borderColor   = [UIColor lightTextColor].CGColor;
//    _listView.layer.borderWidth   = 0.5f;

    
    // 下拉列表TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView))];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.bounces         = NO;
    _tableView.showsVerticalScrollIndicator= NO;
    [_listView addSubview:_tableView];
}

- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight OnlyImage:(UIImage*)image{
    if (self == nil) {
        return;
    }
    _onlyImage.image = image;
    [_onlyImage sizeToFit];
    _onlyImage.center = _mainBtn.center;
    
    _titleArr  = [NSArray arrayWithArray:titlesArr];
    _rowHeight = rowHeight;

    // 下拉列表背景View
    _listView = [[UIView alloc] init];
    _listView.frame = CGRectMake(VIEW_X(self) , VIEW_Y_Bottom(self), VIEW_WIDTH(self),  0);
    // 下拉列表TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView))];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.bounces         = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_listView addSubview:_tableView];

}


- (void)clickMainBtn:(UIButton *)button{
    
    [self.superview addSubview:_listView]; // 将下拉视图添加到控件的俯视图上
    
    if(button.selected == NO) {
        [self showDropDown];
    }
    else {
        [self hideDropDown];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTappedMainBtn:)]){
        [self.delegate didTappedMainBtn:button];
    }
}

- (void)showDropDown{
        // 显示下拉列表
    if (self.tag == 4){
         _onlyImage.hidden = NO;
        [_mainBtn setTitle:nil forState:UIControlStateNormal];
    }
    [_listView.superview bringSubviewToFront:_listView]; // 将下拉列表置于最上层
   
    
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillShow:)]) {
        [self.delegate dropdownMenuWillShow:self]; // 将要显示回调代理
    }
    
//    if (_isCalendar){
//        [UIView animateWithDuration:(AnimateTime) animations:^{
//            _arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
//            _calendarView.height += 260;
//        }];
//        
//        
//    }else{
    [UIView animateWithDuration:AnimateTime animations:^{
        
        _arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        //最多显示5条的高度
        if (_titleArr.count > 5){
             _listView.frame  = CGRectMake(VIEW_X(_listView), VIEW_Y(_listView), VIEW_WIDTH(_listView), _rowHeight *5);
        }else{
        _listView.frame  = CGRectMake(VIEW_X(_listView), VIEW_Y(_listView), VIEW_WIDTH(_listView), _rowHeight *_titleArr.count);
        }
        _tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView));
        
    }completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
            [self.delegate dropdownMenuDidShow:self]; // 已经显示回调代理
        }
    }];
    
    
    _mainBtn.selected = YES;
}
- (void)hideDropDown{  // 隐藏下拉列表

    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillHidden:)]) {
        [self.delegate dropdownMenuWillHidden:self]; // 将要隐藏回调代理
    }
  
    
    [UIView animateWithDuration:AnimateTime animations:^{
        
        _arrowMark.transform = CGAffineTransformIdentity;
        _listView.frame  = CGRectMake(VIEW_X(_listView), VIEW_Y(_listView), VIEW_WIDTH(_listView), 0);
        _tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView));
        
    }completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidHidden:)]) {
            [self.delegate dropdownMenuDidHidden:self]; // 已经隐藏回调代理
        }
    }];
    
    
    
    _mainBtn.selected = NO;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //---------------------------下拉选项样式，可在此处自定义-------------------------
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font          = [UIFont systemFontOfSize:11.f];
        cell.textLabel.textColor     = [UIColor blackColor];
        cell.selectionStyle          = UITableViewCellSelectionStyleNone;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _rowHeight -0.5, VIEW_WIDTH(cell), 0.5)];
        line.backgroundColor = [UIColor blackColor];
        [cell addSubview:line];
        //---------------------------------------------------------------------------
    }
    
    cell.textLabel.text =[_titleArr objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_mainBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
    _onlyImage.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:selectedCellNumber:)]) {
        [self.delegate dropdownMenu:self selectedCellNumber:indexPath.row]; // 回调代理
    }
    
    [self hideDropDown];
}


@end
