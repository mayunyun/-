//
//  KuaiYunTableViewCell.m
//  BasicFramework
//
//  Created by LONG on 2018/2/7.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "KuaiYunTableViewCell.h"
@interface KuaiYunTableViewCell()

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *orderstatusView;//状态
@property(nonatomic,strong) UIView *xianView1;//线

@property(nonatomic,strong) UIImageView *upView;//
@property(nonatomic,strong) UILabel *qiLab;//
@property(nonatomic,strong) UILabel *zhongLab;//
@property(nonatomic,strong) UILabel *typeLab;//

@property(nonatomic,strong) UILabel *chexiangView;//装车时间
@property(nonatomic,strong) UILabel *CarTypeView;//装车时间
@property(nonatomic,strong) UILabel *priceView;//
@property(nonatomic,strong) UIView *xianView4;//线
@property(nonatomic,strong) UILabel *timeView;
@property(nonatomic,strong) UIImageView *iconView;//头像

@property(nonatomic,strong) UILabel *nameLab;



@end
@implementation KuaiYunTableViewCell

- (void)setwithDataModel:(TCHKuaiYModel *)dataModel
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
    
    _upView.sd_layout
    .centerXEqualToView(_xianView1)
    .topSpaceToView(_xianView1, 1.5*margin)
    .widthIs(18*MYWIDTH)
    .heightIs(18*MYWIDTH);
    
    _qiLab.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topEqualToView(_xianView1)
    .rightSpaceToView(_upView, margin)
    .heightIs(5*margin);
    
    _zhongLab.sd_layout
    .leftSpaceToView(_upView, margin)
    .topEqualToView(_xianView1)
    .rightSpaceToView(_bgview, 1.5*margin)
    .heightIs(5*margin);

    _priceView.sd_layout
    .topSpaceToView(_zhongLab, -0.2*margin)
    .rightSpaceToView(_bgview, 1.5*margin)
    .widthIs(10*margin)
    .heightIs(2.5*margin);
    
    _typeLab.sd_layout
    .topSpaceToView(_zhongLab, -0.2*margin)
    .rightSpaceToView(_priceView, 0.5*margin)
    .leftSpaceToView(_bgview, 1.5*margin)
    .heightIs(2.5*margin);
    
    _chexiangView.sd_layout
    .topSpaceToView(_typeLab, 0)
    .leftSpaceToView(_bgview, 1.5*margin)
    .widthIs(7*margin)
    .heightIs(2.5*margin);
    
    _CarTypeView.sd_layout
    .topSpaceToView(_typeLab, 0)
    .leftSpaceToView(_chexiangView, 0.1*margin)
    .rightSpaceToView(_bgview, 0.1*margin)
    .heightIs(2.5*margin);
    
    _xianView4.sd_layout
    .topSpaceToView(_CarTypeView, 0.2*margin)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_bgview, 1.5*margin)
    .heightIs(1);
    
    _iconView.sd_layout
    .leftSpaceToView(_bgview, 1.3*margin)
    .topSpaceToView(_xianView4, 1.3*margin)
    .widthIs(24*MYWIDTH)
    .heightIs(24*MYWIDTH);

    _nameLab.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(_xianView4, 0)
    .widthIs(90*MYWIDTH)
    .heightIs(5*margin);
    
    _timeView.sd_layout
    .topEqualToView(_xianView4)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_nameLab, 0.1*margin)
    .heightIs(50*MYWIDTH);
    
//    self.dingdanhao.text = [NSString stringWithFormat:@"订单号:%@",model.orderno];
//    self.carType.text = [NSString stringWithFormat:@"%@",model.cartypenames];
//    self.huoWuType.text = [NSString stringWithFormat:@"%@",model.cargotypenames];
//    if ([model.weight intValue]==0) {
//        self.goods.text = [NSString stringWithFormat:@"%@件",model.volume];
//    }else if ([model.volume intValue]==0){
//        self.goods.text = [NSString stringWithFormat:@"%@Kg",model.weight];
//    }else{
//        self.goods.text = [NSString stringWithFormat:@"%@Kg/%@件",model.weight,model.volume];
//    }
//    self.priceLab.text = [NSString stringWithFormat:@"￥%@",model.settheprice];
//    self.time.text = [NSString stringWithFormat:@"%@",model.createtime];
    
    
    
    NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,_dataModel.folder,_dataModel.autoname];
    //NSLog(@"%@",image);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _iconView.layer.cornerRadius = 12*MYWIDTH;
    [_iconView.layer setMasksToBounds:YES];
    [_titleView setText:[NSString stringWithFormat:@"订单号:%@ >",_dataModel.orderno]];
    [_timeView setText:[NSString stringWithFormat:@"%@",_dataModel.createtime]];
    [_qiLab setText:[NSString stringWithFormat:@"%@%@",_dataModel.scity,_dataModel.scounty]];
    [_zhongLab setText:[NSString stringWithFormat:@"%@%@",_dataModel.ecity,_dataModel.ecounty]];
    if ([_dataModel.weight intValue]==0) {
        [_typeLab setText:[NSString stringWithFormat:@"%@ %@ %@件",[_dataModel.cartypenames stringByReplacingOccurrencesOfString:@" " withString:@"/"],_dataModel.cargotypenames,_dataModel.volume]];
        
    }else if ([_dataModel.volume intValue]==0){
        [_typeLab setText:[NSString stringWithFormat:@"%@ %@ %@Kg",[_dataModel.cartypenames stringByReplacingOccurrencesOfString:@" " withString:@"/"],_dataModel.cargotypenames,_dataModel.weight]];
        
    }else{
        [_typeLab setText:[NSString stringWithFormat:@"%@ %@ %@Kg/%@件",[_dataModel.cartypenames stringByReplacingOccurrencesOfString:@" " withString:@"/"],_dataModel.cargotypenames,_dataModel.weight,_dataModel.volume]];
        
    }
    [_priceView setText:[NSString stringWithFormat:@"￥%.2f",[_dataModel.siji_money floatValue]]];
    [_CarTypeView setText:[NSString stringWithFormat:@"%@",_dataModel.shipmenttime]];

    [_nameLab setText:[NSString stringWithFormat:@"%@",_dataModel.fname]];
    if ([_dataModel.gettype integerValue]==0) {
        self.orderstatusView.text = @"货主未确认";
    }else{
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
        [self titleView];
        [self timeView];
        [self orderstatusView];
        [self xianView1];
        [self typeLab];
        [self upView];
        [self qiLab];
        [self zhongLab];
        
        [self chexiangView];
        [self CarTypeView];
        [self priceView];
        [self xianView4];
        
        [self nameLab];
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
        _titleView.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _titleView.textColor = [UIColor blackColor];
        [_bgview addSubview: _titleView];
    }
    return _titleView;
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

- (UIImageView *)upView
{
    if(_upView ==nil)
    {
        _upView =[[UIImageView alloc]init];
        _upView.image = [UIImage imageNamed:@"dao到"];
        [_bgview addSubview:_upView];
    }
    return _upView;
}

- (UILabel *)qiLab
{
    if(_qiLab ==nil)
    {
        _qiLab =[[UILabel alloc]init];
        _qiLab.font = [UIFont systemFontOfSize:16*MYWIDTH];
        _qiLab.textAlignment = NSTextAlignmentCenter;
        _qiLab.textColor = [UIColor blackColor];
        [_bgview addSubview: _qiLab];
    }
    return _qiLab;
}
- (UILabel *)zhongLab
{
    if(_zhongLab ==nil)
    {
        _zhongLab =[[UILabel alloc]init];
        _zhongLab.font = [UIFont systemFontOfSize:16*MYWIDTH];
        _zhongLab.textAlignment = NSTextAlignmentCenter;
        _zhongLab.textColor = [UIColor blackColor];
        [_bgview addSubview: _zhongLab];
    }
    return _zhongLab;
}
- (UILabel *)typeLab
{
    if(_typeLab ==nil)
    {
        _typeLab =[[UILabel alloc]init];
        _typeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
        _typeLab.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _typeLab];
    }
    return _typeLab;
}
- (UILabel *)chexiangView
{
    if(_chexiangView ==nil)
    {
        _chexiangView =[[UILabel alloc]init];
        _chexiangView.font = [UIFont systemFontOfSize:14*MYWIDTH];
        _chexiangView.textColor = UIColorFromRGB(0x333333);
        _chexiangView.text = @"装车时间:";
        [_bgview addSubview: _chexiangView];
    }
    return _chexiangView;
}
- (UILabel *)CarTypeView
{
    if(_CarTypeView ==nil)
    {
        _CarTypeView =[[UILabel alloc]init];
        _CarTypeView.font = [UIFont systemFontOfSize:14*MYWIDTH];
        _CarTypeView.textColor = UIColorFromRGB(0x333333);
        _CarTypeView.textAlignment = NSTextAlignmentLeft;
        _CarTypeView.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [_bgview addSubview: _CarTypeView];
    }
    return _CarTypeView;
}

- (UILabel *)priceView
{
    if(_priceView ==nil)
    {
        _priceView =[[UILabel alloc]init];
        _priceView.font = [UIFont systemFontOfSize:16*MYWIDTH];
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

- (UILabel *)nameLab
{
    if(_nameLab ==nil)
    {
        _nameLab =[[UILabel alloc]init];
        _nameLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
        _nameLab.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _nameLab];
    }
    return _nameLab;
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
