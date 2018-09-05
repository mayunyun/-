//
//  MyPurseTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyPurseTableViewCell.h"
@interface MyPurseTableViewCell()

@end
@implementation MyPurseTableViewCell
- (void)setdata:(NSString *)title image:(NSString *)image push:(NSString *)push{
    CGFloat margin = 15*MYWIDTH;
    UIView *contentView = self.contentView;
    
    //设置各控件的frame以及data
    //背景
    
    if ([push isEqualToString:@"4"]) {
        _bgview.sd_layout
        .leftSpaceToView(contentView,0)
        .topSpaceToView(contentView,0.5)
        .rightSpaceToView(contentView,0)
        .bottomSpaceToView(contentView,0);
    }else{
        _bgview.sd_layout
        .leftSpaceToView(contentView,0)
        .topSpaceToView(contentView,0.7 * margin)
        .rightSpaceToView(contentView,0)
        .bottomSpaceToView(contentView,0);
    }
    
    
    if ([push isEqualToString:@"1"]) {
        //头像
        _iconView.sd_layout
        .leftSpaceToView(_bgview,1 * margin)
        .centerYEqualToView(_bgview)
        .heightIs(20)
        .widthIs(25);
    }else{
        //头像
        _iconView.sd_layout
        .leftSpaceToView(_bgview,1 * margin)
        .centerYEqualToView(_bgview)
        .heightIs(25)
        .widthIs(25);
    }
    
    _rightimage.sd_layout
    .rightSpaceToView(_bgview,1 * margin)
    .centerYEqualToView(_bgview)
    .heightIs(20)
    .widthIs(10);
    
    //标题
    _titleView.sd_layout
    .leftSpaceToView(_iconView,1 * margin)
    .centerYEqualToView(_bgview)
    .rightSpaceToView(_rightimage, margin)
    .heightIs(25);
    
    
    
    _otherView.sd_layout
    .centerYEqualToView(_bgview)
    .rightSpaceToView(_rightimage,1 * margin)
    .widthIs(200)
    .heightIs(25);
    
    
    _iconView.image = [UIImage imageNamed:image];
    _titleView.text = title;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self bgview];
        [self iconView];//头像
        [self titleView];
        [self otherView];
        [self rightimage];
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

//头像view
- (UIImageView *)iconView
{
    if(_iconView ==nil)
    {
        _iconView =[[UIImageView alloc]init];
        
        [_bgview addSubview:_iconView];
    }
    
    return _iconView;
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:15];
        _titleView.textColor = UIColorFromRGB(0x333333);
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
        _otherView.textColor = UIColorFromRGB(0x666666);
        _otherView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _otherView];
    }
    
    return _otherView;
    
}
- (UIImageView *)rightimage{
    if(_rightimage ==nil)
    {
        _rightimage =[[UIImageView alloc]init];
        _rightimage.image = [UIImage imageNamed:@"rightRed"];
        [_bgview addSubview:_rightimage];
    }
    
    return _rightimage;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
