//
//  ZJLoading.m
//  SecurityMonitoring
//
//  Created by Will on 2017/11/22.
//  Copyright © 2017年 Will. All rights reserved.
//

#import "ZJLoading.h"
#import "UIView+ZJAdditions.h"
#import "UIColor+HEX.h"
@interface ZJLoading ()
{
    UIImageView *_imageView;
    UILabel *_title_label;
    
}

@end
@implementation ZJLoading
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Image:(UIImage *)Image{
    self = [super initWithFrame:frame];
    if (self){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52/2, 52/2)];
        _imageView.image = Image;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        _title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) + 5, 0, 0)];
        _title_label.font = [UIFont systemFontOfSize:13];
        _title_label.text = title;
        _title_label.textColor = [UIColor colorWithHexString:@"50f1f6"];
        [_title_label sizeToFit];
         _title_label.centerX = _imageView.centerX;
        [self addSubview:_title_label];
    }
    
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [UIView animateWithDuration:0.5 animations:^{
        _imageView.center = self.center;
        _title_label.top = _imageView.bottom + 5;
        _title_label.centerX = _imageView.centerX;
    }];
    
}



@end
