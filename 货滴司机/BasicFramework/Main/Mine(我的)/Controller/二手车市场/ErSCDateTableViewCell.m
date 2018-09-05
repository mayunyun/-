//
//  ErSCDateTableViewCell.m
//  BasicFramework
//
//  Created by LONG on 2018/7/17.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ErSCDateTableViewCell.h"
@interface ErSCDateTableViewCell()

@end
@implementation ErSCDateTableViewCell

- (void)setdata:(NSString *)title other:(NSString *)other{
    CGFloat margin = 15*MYWIDTH;
    UIView *contentView = self.contentView;
    
    //设置各控件的frame以及data
    //背景
    
    _bgview.sd_layout
    .leftSpaceToView(contentView,0)
    .topSpaceToView(contentView,0.5)
    .rightSpaceToView(contentView,0)
    .bottomSpaceToView(contentView,0);

    
    //标题
    _titleView.sd_layout
    .leftSpaceToView(_bgview,1)
    .topSpaceToView(_bgview,0)
    .bottomSpaceToView(_bgview,0)
    .widthIs(90*MYWIDTH);
    
    
    
    _otherView.sd_layout
    .leftSpaceToView(_titleView,margin)
    .topSpaceToView(_bgview,0)
    .bottomSpaceToView(_bgview,0)
    .rightSpaceToView(_bgview,1);
    
    
    _titleView.text = title;
    _otherView.text = other;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self bgview];
        [self titleView];
        [self otherView];
    }
    return self;
}

- (UIView *)bgview
{
    if(_bgview ==nil)
    {
        _bgview =[[UIView alloc]init];
        _bgview.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgview];
    }
    
    return _bgview;
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:15];
        _titleView.textColor = UIColorFromRGB(0x333333);
        _titleView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _titleView];
    }
    
    return _titleView;
    
}
- (UILabel *)otherView
{
    if(_otherView ==nil)
    {
        _otherView =[[UILabel alloc]init];
        _otherView.font = [UIFont systemFontOfSize:15];
        _otherView.textColor = UIColorFromRGB(0x444444);
        _otherView.numberOfLines = 0;
        [_bgview addSubview: _otherView];
    }
    
    return _otherView;
    
}


@end
