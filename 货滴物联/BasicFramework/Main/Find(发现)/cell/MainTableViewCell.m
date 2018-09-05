//
//  MainTableViewCell.m
//  PetrpleumLove
//
//  Created by LONG on 16/8/24.
//  Copyright © 2016年 徐番茄丶. All rights reserved.
//

#import "MainTableViewCell.h"

@interface MainTableViewCell()


@end

@implementation MainTableViewCell
- (void)setData:(XWMainModel *)data
{
    _data = data;
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    //设置各控件的frame以及data
    
    //背景
    _bgview.sd_layout
    .leftSpaceToView(contentView,margin)
    .topEqualToView(contentView)
    .rightSpaceToView(contentView,margin)
    .bottomEqualToView(contentView);
    
    //线
    _xianview.sd_layout
    .leftSpaceToView(_bgview,margin)
    .topSpaceToView(_bgview,0)
    .rightSpaceToView(_bgview,margin)
    .heightIs(0.5);
    
    //头像
    _iconView.sd_layout
    .leftSpaceToView(_bgview,margin)
    .topSpaceToView(_xianview,1.5 * margin)
    .widthIs(75*MYWIDTH)
    .heightIs(75*MYWIDTH);
    
    //标题
    _titleView.sd_layout
    .leftSpaceToView(_iconView,1.5 * margin)
    .topSpaceToView(_xianview,1.5 * margin)
    .rightSpaceToView(_bgview,1.5 * margin)
    .heightIs(16);
    
    //时间
    _timeView.sd_layout
    .bottomEqualToView(_bgview)
    .rightSpaceToView(_bgview,margin)
    .leftSpaceToView(_iconView,1.5 * margin)
    .heightIs(20);
    
    //描述
    _textView.sd_layout
    .leftSpaceToView(_iconView,1.5 * margin)
    .topSpaceToView(_titleView,0.5 * margin)
    .rightSpaceToView(_bgview, margin)
    .bottomSpaceToView(_timeView,0.3 * margin);
    
    NSString *image = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,_data.folder,_data.autoname];
    NSLog(@"%@",image);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
    
    [_titleView setText:[NSString stringWithFormat:@"%@",_data.title]];
    [_textView setText:[NSString stringWithFormat:@"%@",_data.content]];
    [_timeView setText:[NSString stringWithFormat:@"%@",_data.createtime]];
    
    
}
- (void)setModel:(HuoDongModel *)model
{
    _model = model;
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    //设置各控件的frame以及data
    
    //背景
    _bgview.sd_layout
    .leftSpaceToView(contentView,0)
    .topEqualToView(contentView)
    .rightSpaceToView(contentView,0)
    .bottomEqualToView(contentView);
    
    //线
    _xianview.sd_layout
    .leftSpaceToView(_bgview,margin)
    .topSpaceToView(_bgview,0)
    .rightSpaceToView(_bgview,margin)
    .heightIs(0.5);
    
    //头像
    _iconView.sd_layout
    .leftSpaceToView(_bgview,margin)
    .topSpaceToView(_xianview,1.5 * margin)
    .widthIs(100*MYWIDTH)
    .heightIs(75*MYWIDTH);
    
    //标题
    _titleView.sd_layout
    .leftSpaceToView(_iconView,1.5 * margin)
    .topSpaceToView(_xianview,1.5 * margin)
    .rightSpaceToView(_bgview,1.5 * margin)
    .heightIs(16);
    
    //时间
    _timeView.sd_layout
    .topSpaceToView(_titleView,0.1 * margin)
    .rightSpaceToView(_bgview,margin)
    .leftSpaceToView(_iconView,1.5 * margin)
    .heightIs(18*MYWIDTH);
    
    //描述
    _textView.sd_layout
    .leftSpaceToView(_iconView,1.5 * margin)
    .topSpaceToView(_timeView,0)
    .rightSpaceToView(_bgview, margin)
    .bottomSpaceToView(_bgview, 0.5*margin);
    
    NSString *image = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,_model.folder,_model.autoname];
    NSLog(@"%@",image);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
    
    [_titleView setText:[NSString stringWithFormat:@"%@",_model.activityname]];
    [_textView setText:[NSString stringWithFormat:@"%@",_model.content]];
    [_timeView setText:[NSString stringWithFormat:@"%@",_model.createtime]];
    
    _xianview.backgroundColor = UIColorFromRGB(0xff4b52);

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self bgview];
        [self xianview];
        [self iconView];//头像
        [self titleView];
        [self textView];
        [self timeView];
        
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
- (UIView *)xianview
{
    if(_xianview ==nil)
    {
        _xianview =[[UIView alloc]init];
        _xianview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_bgview addSubview:_xianview];
    }
    
    return _xianview;
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
        _titleView.font = [UIFont systemFontOfSize:13];
        _titleView.textColor = UIColorFromRGB(0x333333);
        _titleView.numberOfLines = 0;
        [_bgview addSubview: _titleView];
    }
    
    return _titleView;
    
}
- (UILabel *)textView
{
    if(_textView ==nil)
    {
        _textView =[[UILabel alloc]init];
        _textView.font = [UIFont systemFontOfSize:11];
        _textView.textColor = UIColorFromRGB(0x555555);
        _textView.numberOfLines = 0;
        [_bgview addSubview: _textView];
    }
    
    return _textView;
}

- (UILabel *)timeView
{
    if(_timeView ==nil)
    {
        _timeView =[[UILabel alloc]init];
        _timeView.font = [UIFont systemFontOfSize:13];
        _timeView.textColor = UIColorFromRGB(0xAAAAAA);
        _timeView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _timeView];
    }
    
    return _timeView;
    
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

