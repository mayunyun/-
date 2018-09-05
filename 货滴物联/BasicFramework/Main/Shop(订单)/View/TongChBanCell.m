//
//  TongChBanCell.m
//  BasicFramework
//
//  Created by LONG on 2018/2/7.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "TongChBanCell.h"
@interface TongChBanCell()

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *orderstatusView;//状态
@property(nonatomic,strong) UIView *xianView1;//线

@property(nonatomic,strong) UIImageView *qiView;//起点
@property(nonatomic,strong) UILabel *qiLab;//
@property(nonatomic,strong) UIImageView *xuxianView;//虚线
@property(nonatomic,strong) UIImageView *zhongView;//终点
@property(nonatomic,strong) UILabel *zhongLab;//
@property(nonatomic,strong) UIView *xianView2;//线

@property(nonatomic,strong) UILabel *chexiangView;//车型
@property(nonatomic,strong) UILabel *CarTypeView;//
@property(nonatomic,strong) UILabel *priceView;//
@property(nonatomic,strong) UIView *xianView4;//线

@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *nameView;//姓名
@property(nonatomic,strong) UILabel *timeView;//时间


@end
@implementation TongChBanCell
- (void)setwithDataModel:(TCHBanJModel *)dataModel
{
    self.dataModel = dataModel;
    UIView *contentView = self.contentView;
    CGFloat margin = 10*MYWIDTH;
    
    //设置各控件的frame以及data
    //背景
    _bgview.sd_layout
    .leftSpaceToView(contentView, 0)
    .topSpaceToView(contentView, 0.8*margin)
    .rightSpaceToView(contentView, 0)
    .bottomSpaceToView(contentView, 0.8*margin);
    
    _orderstatusView.sd_layout
    .rightSpaceToView(_bgview, 1.5*margin)
    .topEqualToView(_bgview)
    .heightIs(40*MYWIDTH)
    .widthIs(100*MYWIDTH);
    
    _titleView.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topEqualToView(_bgview)
    .heightIs(40*MYWIDTH)
    .rightSpaceToView(_orderstatusView, margin);
    
    _xianView1.sd_layout
    .topSpaceToView(_titleView, 0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_bgview, 1.5*margin)
    .heightIs(1);
    
    _qiView.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topSpaceToView(_xianView1, 1.5*margin)
    .widthIs(14*MYWIDTH)
    .heightIs(18*MYWIDTH);
    
    _zhongView.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topSpaceToView(_qiView, 3.2*margin)
    .widthIs(14*MYWIDTH)
    .heightIs(18*MYWIDTH);
    
    _xuxianView.sd_layout
    .leftSpaceToView(_bgview, 2.2*margin)
    .topSpaceToView(_qiView, 0)
    .widthIs(1)
    .heightIs(3.2*margin);
    
    _qiLab.sd_layout
    .leftSpaceToView(_qiView, 1.5*margin)
    .topEqualToView(_xianView1)
    .rightSpaceToView(_bgview, 1.5*margin)
    .heightIs(5*margin);
    
    _zhongLab.sd_layout
    .leftSpaceToView(_qiView, 1.5*margin)
    .topSpaceToView(_qiLab, 0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .heightIs(5*margin);
    
    _xianView2.sd_layout
    .topSpaceToView(_zhongLab, 0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_bgview, 1.5*margin)
    .heightIs(1);
    
    
    _chexiangView.sd_layout
    .topEqualToView(_xianView2)
    .leftSpaceToView(_bgview, 1.5*margin)
    .widthIs(8*margin)
    .heightIs(3.5*margin);
    
    _priceView.sd_layout
    .topEqualToView(_xianView2)
    .rightSpaceToView(_bgview, 1.5*margin)
    .widthIs(8*margin)
    .heightIs(3.5*margin);
    
    _CarTypeView.sd_layout
    .topEqualToView(_xianView2)
    .leftSpaceToView(_chexiangView, 0)
    .rightSpaceToView(_priceView, 0)
    .heightIs(3.5*margin);
    
    _xianView4.sd_layout
    .topSpaceToView(_chexiangView, 0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_bgview, 1.5*margin)
    .heightIs(1);
    
    _iconView.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topSpaceToView(_xianView4, 1.3*margin)
    .widthIs(24*MYWIDTH)
    .heightIs(24*MYWIDTH);
    
    _nameView.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(_xianView4, 0)
    .widthIs(90*MYWIDTH)
    .heightIs(50*MYWIDTH);
    
    _timeView.sd_layout
    .topSpaceToView(_xianView4,0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_nameView, 0.1*margin)
    .heightIs(50*MYWIDTH);
    
    NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,_dataModel.folder,_dataModel.autoname];
    //NSLog(@"%@",image);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _iconView.layer.cornerRadius = 12*MYWIDTH;
    [_iconView.layer setMasksToBounds:YES];
    [_timeView setText:[NSString stringWithFormat:@"订单生成时间:%@",_dataModel.owner_createtime]];
    [_titleView setText:[NSString stringWithFormat:@"订单号:%@ >",_dataModel.owner_orderno]];
    [_qiLab setText:[NSString stringWithFormat:@"%@",_dataModel.owner_address]];
    [_zhongLab setText:[NSString stringWithFormat:@"%@",_dataModel.owner_send_address]];
    [_chexiangView setText:[NSString stringWithFormat:@"%@",_dataModel.car_type]];
    [_CarTypeView setText:[NSString stringWithFormat:@"取货时间:%@",_dataModel.owner_sendtime]];
    [_priceView setText:[NSString stringWithFormat:@"￥%.2f",[_dataModel.siji_money floatValue]]];
    if ([[Command convertNull:_dataModel.owner_link_name] isEqualToString:@""]) {
        _nameView.text = @"";
    }else{
        [_nameView setText:[NSString stringWithFormat:@"%@",_dataModel.owner_link_name]];
    }
    if ([_dataModel.driver_orderstatus integerValue]==-1) {
        self.orderstatusView.text = @"已取消";
    }else if ([_dataModel.driver_orderstatus integerValue]==0){
        self.orderstatusView.text = @"前往中";
    }else if ([_dataModel.driver_orderstatus integerValue]==1){
        self.orderstatusView.text = @"开始订单";
    }else if ([_dataModel.driver_orderstatus integerValue]==2){
        self.orderstatusView.text = @"已完成";
    }else if ([_dataModel.driver_orderstatus integerValue]==-2){
        self.orderstatusView.text = @"未接单";
    }
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self bgview];
        [self iconView];
        [self orderstatusView];
        [self titleView];
        [self timeView];
        [self xianView1];
        
        [self qiView];
        [self qiLab];
        [self xuxianView];
        [self zhongView];
        [self zhongLab];
        [self xianView2];
        [self nameView];
        [self chexiangView];
        [self CarTypeView];
        [self priceView];
        [self xianView4];
        
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
        _iconView.layer.cornerRadius = 12*MYWIDTH;
        [_bgview addSubview:_iconView];
    }
    return _iconView;
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:16*MYWIDTH];
        _titleView.textColor = [UIColor blackColor];
        [_bgview addSubview: _titleView];
    }
    return _titleView;
}

- (UILabel *)orderstatusView
{
    if(_orderstatusView ==nil)
    {
        _orderstatusView =[[UILabel alloc]init];
        _orderstatusView.font = [UIFont systemFontOfSize:16*MYWIDTH];
        _orderstatusView.textColor = [UIColor blackColor];
        _orderstatusView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _orderstatusView];
    }
    return _orderstatusView;
}
- (UILabel *)timeView
{
    if(_timeView ==nil)
    {
        _timeView =[[UILabel alloc]init];
        _timeView.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _timeView.textColor = UIColorFromRGB(0x555555);
        _timeView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _timeView];
    }
    return _timeView;
}
- (UIView *)xianView1
{
    if(_xianView1 ==nil)
    {
        _xianView1 =[[UIView alloc]init];
        _xianView1.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_bgview addSubview: _xianView1];
    }
    return _xianView1;
}

- (UIImageView *)qiView
{
    if(_qiView ==nil)
    {
        _qiView =[[UIImageView alloc]init];
        _qiView.image = [UIImage imageNamed:@"定位绿"];
        [_bgview addSubview:_qiView];
    }
    return _qiView;
}
- (UIImageView *)xuxianView
{
    if(_xuxianView ==nil)
    {
        _xuxianView =[[UIImageView alloc]init];
        _xuxianView.image = [UIImage imageNamed:@"竖虚线"];
        [_bgview addSubview:_xuxianView];
    }
    return _xuxianView;
}
- (UIImageView *)zhongView
{
    if(_zhongView ==nil)
    {
        _zhongView =[[UIImageView alloc]init];
        _zhongView.image = [UIImage imageNamed:@"定位红"];
        [_bgview addSubview:_zhongView];
    }
    return _zhongView;
}
- (UILabel *)qiLab
{
    if(_qiLab ==nil)
    {
        _qiLab =[[UILabel alloc]init];
        _qiLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _qiLab.numberOfLines = 0;
        _qiLab.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _qiLab];
    }
    return _qiLab;
}
- (UILabel *)zhongLab
{
    if(_zhongLab ==nil)
    {
        _zhongLab =[[UILabel alloc]init];
        _zhongLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _zhongLab.numberOfLines = 0;
        _zhongLab.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _zhongLab];
    }
    return _zhongLab;
}
- (UIView *)xianView2
{
    if(_xianView2 ==nil)
    {
        _xianView2 =[[UIView alloc]init];
        _xianView2.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_bgview addSubview: _xianView2];
    }
    return _xianView2;
}

- (UILabel *)chexiangView
{
    if(_chexiangView ==nil)
    {
        _chexiangView =[[UILabel alloc]init];
        _chexiangView.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _chexiangView.textColor = UIColorFromRGB(0x333333);
        _chexiangView.text = @"取货时间:";
        [_bgview addSubview: _chexiangView];
    }
    return _chexiangView;
}
- (UILabel *)CarTypeView
{
    if(_CarTypeView ==nil)
    {
        _CarTypeView =[[UILabel alloc]init];
        _CarTypeView.font = [UIFont systemFontOfSize:12*MYWIDTH];
        _CarTypeView.textColor = UIColorFromRGB(0x333333);
        _CarTypeView.textAlignment = NSTextAlignmentLeft;
        [_bgview addSubview: _CarTypeView];
    }
    return _CarTypeView;
}

- (UILabel *)priceView
{
    if(_priceView ==nil)
    {
        _priceView =[[UILabel alloc]init];
        _priceView.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _priceView.textColor = MYColor;
        _priceView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _priceView];
    }
    return _priceView;
}
- (UIView *)xianView4
{
    if(_xianView4 ==nil)
    {
        _xianView4 =[[UIView alloc]init];
        _xianView4.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_bgview addSubview: _xianView4];
    }
    return _xianView4;
}

- (UILabel *)nameView
{
    if(_nameView ==nil)
    {
        _nameView =[[UILabel alloc]init];
        _nameView.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _nameView.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _nameView];
    }
    return _nameView;
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
