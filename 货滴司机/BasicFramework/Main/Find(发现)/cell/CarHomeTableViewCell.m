//
//  CarHomeTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarHomeTableViewCell.h"

@implementation CarHomeTableViewCell

- (void)setData:(CarBrandModel *)data
{
    _data = data;
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    //设置各控件的frame以及data
    
    
    

    
    //线
    _xianview.sd_layout
    .leftSpaceToView(contentView,1.5 * margin)
    .topEqualToView(contentView)
    .rightSpaceToView(contentView,1.5 * margin)
    .heightIs(0.5);
    
    //头像
    _iconView.sd_layout
    .leftSpaceToView(contentView,1.5 * margin)
    .topSpaceToView(contentView,1.1 * margin)
    .widthIs(33*MYWIDTH)
    .heightIs(33*MYWIDTH);
    
    //标题
    _titleView.sd_layout
    .leftSpaceToView(_iconView,1.5 * margin)
    .topSpaceToView(contentView,0)
    .rightSpaceToView(contentView,1.5 * margin)
    .bottomSpaceToView(contentView,0);
    
    
    NSString *strurl = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,_data.folder,_data.autoname];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:strurl] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
    [_titleView setText:[NSString stringWithFormat:@"%@",_data.brandname]];
  
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;

        [self xianview];
        [self iconView];//头像
        [self titleView];
        
        
    }
    return self;
}


- (UIView *)xianview
{
    if(_xianview ==nil)
    {
        _xianview =[[UIView alloc]init];
        _xianview.backgroundColor = UIColorFromRGB(MYLine);
        [self.contentView addSubview:_xianview];
    }
    
    return _xianview;
}
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
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:13];
        _titleView.textColor = UIColorFromRGB(0x333333);
        _titleView.numberOfLines = 0;
        [self.contentView addSubview: _titleView];
    }
    
    return _titleView;
    
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
