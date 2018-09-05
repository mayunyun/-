//
//  MyPingLunTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyPingLunTableViewCell.h"

@interface MyPingLunTableViewCell()

@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *nameView;//昵称
@property(nonatomic,strong) UILabel *PLtimeView;//评论时间
@property(nonatomic,strong) UILabel *PingLView;//评论：
@property(nonatomic,strong) UILabel *textView;//正文
@property(nonatomic,strong) UIView *xianView;//线
@property(nonatomic,strong) UIImageView *photoView;//照片
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *timeView;//时间



@end

@implementation MyPingLunTableViewCell

//头像view
- (UIImageView *)iconView
{
    if(_iconView ==nil)
    {
        _iconView =[[UIImageView alloc]init];
        
        [self.contentView addSubview:_iconView];
    }
    
    return _iconView;
}

//昵称
- (UILabel *)nameView
{
    if(_nameView ==nil)
    {
        _nameView =[[UILabel alloc]init];
        [_nameView setFont:[UIFont systemFontOfSize:14]];
        [_nameView setTextColor:UIColorFromRGB(0x333333)];
        
        [self.contentView addSubview:_nameView];
    }
    
    return _nameView;
}

//评论时间
- (UILabel *)PLtimeView
{
    if(_PLtimeView ==nil)
    {
        _PLtimeView =[[UILabel alloc]init];
        [_PLtimeView setFont:[UIFont systemFontOfSize:12]];
        [_PLtimeView setTextColor:UIColorFromRGB(0xAAAAAA)];
        
        [self.contentView addSubview:_PLtimeView];
    }
    
    return _PLtimeView;
}
//PingLView;//评论：
- (UILabel *)PingLView
{
    if(_PingLView ==nil)
    {
        _PingLView =[[UILabel alloc]init];
        [_PingLView setFont:[UIFont systemFontOfSize:14]];
        [_PingLView setTextColor:UIColorFromRGB(0x555555)];
        
        [self.contentView addSubview:_PingLView];
    }
    
    return _PingLView;
}
//评论正文
- (UILabel *)textView
{
    if(_textView ==nil)
    {
        _textView =[[UILabel alloc]init];
        [_textView setFont:[UIFont systemFontOfSize:14]];
        [_textView setTextColor:UIColorFromRGB(0x333333)];
        _textView.numberOfLines = 0;
        [self.contentView addSubview: _textView];
    }
    
    return _textView;
    
}
//线
- (UIView *)xianView
{
    if(_xianView ==nil)
    {
        _xianView =[[UIView alloc]init];
        _xianView.backgroundColor = UIColorFromRGB(MYLine);
        [self.contentView addSubview:_xianView];
    }
    
    return _xianView;
}


//photoView;//照片
- (UIImageView *)photoView
{
    if(_photoView ==nil)
    {
        _photoView =[[UIImageView alloc]init];
        
        [self.contentView addSubview:_photoView];
    }
    
    return _photoView;
}
//titleView;//标题
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        [_titleView setFont:[UIFont systemFontOfSize:14]];
        [_titleView setTextColor:UIColorFromRGB(0x333333)];
        
        [self.contentView addSubview:_titleView];
    }
    
    return _titleView;
}
//时间
- (UILabel *)timeView
{
    if(_timeView ==nil)
    {
        _timeView =[[UILabel alloc]init];
        [_timeView setFont:[UIFont systemFontOfSize:12]];
        [_timeView setTextColor:UIColorFromRGB(0xAAAAAA)];
        
        [self.contentView addSubview:_timeView];
    }
    
    return _timeView;
}
- (void)setData:(MyPingLModel *)data
{
    _data = data;
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    //设置各控件的frame以及data
    
    //头像
    _iconView.sd_layout
    .leftSpaceToView(contentView,1.5*margin)
    .topSpaceToView(contentView,2 * margin)
    .heightIs(20)
    .widthIs(20);
    
    //昵称
    _nameView.sd_layout
    .leftSpaceToView(_iconView,margin)
    .topSpaceToView(contentView,1.5 * margin)
    .heightIs(16);
    [_nameView setSingleLineAutoResizeWithMaxWidth:200];
    
    //时间
    _timeView.sd_layout
    .leftEqualToView(_nameView)
    .topSpaceToView(_nameView,margin)
    .heightIs(18);
    [_timeView setSingleLineAutoResizeWithMaxWidth:250];
    
    //文本
    _textView.sd_layout
    .leftEqualToView(_nameView)
    .topSpaceToView(_timeView,margin)
    .rightSpaceToView(contentView,2 * margin)
    .autoHeightRatio(0);
    
    
    
    
    
    
    _iconView.image= [UIImage imageNamed:data.icon];
    _iconView.layer.cornerRadius = _iconView.width * 0.5;
    _iconView.clipsToBounds = YES;
    [_nameView setText:data.name];
   
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self iconView];//头像
        [self nameView];//昵称
        [self textView];//正文
        [self timeView];//时间
       
    }
    return self;
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
