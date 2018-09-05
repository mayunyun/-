//
//  WuLiuSeaPolTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WuLiuSeaPolTableViewCell.h"
@interface WuLiuSeaPolTableViewCell()

@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *addressView;//副标题
@property(nonatomic,strong) UIView *xianView;//

@end

@implementation WuLiuSeaPolTableViewCell
-(void)setDataCity:(NSString *)city Address:(NSString *)address;
{

    UIView *contentView = self.contentView;
    CGFloat margin = 10*MYWIDTH;
    
    //设置各控件的frame以及data
    
        
    
    _titleView.sd_layout
    .topSpaceToView(contentView, 0.01 * margin)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView,2 * margin)
    .heightIs(25*MYWIDTH);
    
    _addressView.sd_layout
    .topSpaceToView(_titleView, 0.01 * margin)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView,2 * margin)
    .heightIs(25*MYWIDTH);
    
    _xianView.sd_layout
    .leftSpaceToView(contentView, 1.5*margin)
    .rightSpaceToView(contentView, 1.5*margin)
    .bottomSpaceToView(contentView, 0)
    .heightIs(1);
    
    
    _titleView.text = [NSString stringWithFormat:@"%@",city];
    _addressView.text = [NSString stringWithFormat:@"%@",address];

    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self titleView];
        [self addressView];
        [self xianView];
        
    }
    return self;
}

- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:14];
        _titleView.textColor = UIColorFromRGBValueValue(0x333333);
        [self.contentView addSubview: _titleView];
    }
    
    return _titleView;
    
}
- (UILabel *)addressView
{
    if(_addressView ==nil)
    {
        _addressView =[[UILabel alloc]init];
        _addressView.font = [UIFont systemFontOfSize:13];
        _addressView.textColor = UIColorFromRGBValueValue(0x666666);
        [self.contentView addSubview: _addressView];
    }
    
    return _addressView;
    
}
- (UIView *)xianView
{
    if(_xianView ==nil)
    {
        _xianView =[[UIView alloc]init];
        _xianView.backgroundColor = UIColorFromRGBValueValue(0xeeeeee);
        [self.contentView addSubview: _xianView];
    }
    
    return _xianView;
    
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
