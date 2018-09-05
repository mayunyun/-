//
//  MeTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 17/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MeTableViewCell.h"

@interface MeTableViewCell()

@property(nonatomic,strong) UIImageView *bgview;//背景
@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UIImageView *jiantouView;//箭头


@end

@implementation MeTableViewCell

- (void)setdata:(NSString *)title{
    CGFloat margin = 10;
    UIView *contentView = self.contentView;

    //设置各控件的frame以及data
    //背景
    
    _bgview.sd_layout
    .leftSpaceToView(contentView,1.5 * margin)
    .topSpaceToView(contentView,0.5 * margin)
    .rightSpaceToView(contentView,1.5 * margin)
    .bottomSpaceToView(contentView,0.5 * margin);
    
    //头像
    _iconView.sd_layout
    .leftSpaceToView(_bgview,2 * margin)
    .centerYEqualToView(_bgview)
    .heightIs(18)
    .widthIs(18);
    
    //标题
    _titleView.sd_layout
    .leftSpaceToView(_iconView,1.5 * margin)
    .centerYEqualToView(_bgview)
    .rightSpaceToView(_bgview,3 * margin)
    .heightIs(25);
    
    //箭头
    _jiantouView.sd_layout
    .rightSpaceToView(_bgview,1 * margin)
    .centerYEqualToView(_bgview)
    .heightIs(15*MYWIDTH)
    .widthIs(10*MYWIDTH);

    _iconView.image = [UIImage imageNamed:title];
    _titleView.text = title;
    _jiantouView.image = [UIImage imageNamed:@"右箭头"];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self bgview];
        [self iconView];//头像
        [self titleView];
        [self jiantouView];
        
    }
    return self;
}

- (UIImageView *)bgview
{
    if(_bgview ==nil)
    {
        _bgview =[[UIImageView alloc]init];
        _bgview.image = [UIImage imageNamed:@"发现_边框"];
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
//
- (UIImageView *)jiantouView
{
    if(_jiantouView ==nil)
    {
        _jiantouView =[[UIImageView alloc]init];
        
        [_bgview addSubview:_jiantouView];
    }
    
    return _jiantouView;
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
