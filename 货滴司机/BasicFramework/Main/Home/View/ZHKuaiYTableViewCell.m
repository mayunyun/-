//
//  ZHKuaiYTableViewCell.m
//  BasicFramework
//
//  Created by LONG on 2018/3/8.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ZHKuaiYTableViewCell.h"
#import "HomeKYDetailsViewController.h"

@interface ZHKuaiYTableViewCell()

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *timeView;//时间
@property(nonatomic,strong) UIView *xianView;//线
@property(nonatomic,strong) UIButton *phoneView;//电话
@property(nonatomic,strong) UIButton *bigphoneView;//电话
@property(nonatomic,strong) UIView *xianView1;//线

@property(nonatomic,strong) UIImageView *upView;//
@property(nonatomic,strong) UILabel *qiLab;//
@property(nonatomic,strong) UILabel *zhongLab;//
@property(nonatomic,strong) UIView *xianView2;//线

@property(nonatomic,strong) UILabel *chexiangView;//装车时间
@property(nonatomic,strong) UILabel *CarTypeView;//
@property(nonatomic,strong) UILabel *priceView;//
@property(nonatomic,strong) UIView *xianView4;//线

@property(nonatomic,strong) UILabel *juliLab;

@property(nonatomic,strong) UIButton *xiangqingBut;//查看详情


@end
@implementation ZHKuaiYTableViewCell
- (void)setwithDataModel:(ZHKuaiYModel *)dataModel
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
    
    _iconView.sd_layout
    .leftSpaceToView(_bgview, 1.3*margin)
    .topSpaceToView(_bgview, 0.8*margin)
    .widthIs(24*MYWIDTH)
    .heightIs(24*MYWIDTH);
    
    _titleView.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_bgview)
    .heightIs(40*MYWIDTH)
    .widthIs(100*MYWIDTH);
    
    _phoneView.sd_layout
    .topSpaceToView(_bgview, 1.2*margin)
    .rightSpaceToView(_bgview, 1.2*margin)
    .heightIs(16*MYWIDTH)
    .widthIs(16*MYWIDTH);
    
    _bigphoneView.sd_layout
    .topSpaceToView(_bgview, 0)
    .rightSpaceToView(_bgview, 0)
    .heightIs(40*MYWIDTH)
    .widthIs(40*MYWIDTH);
    
    _xianView.sd_layout
    .topSpaceToView(_bgview, 0.8*margin)
    .rightSpaceToView(_phoneView, 0.8*margin)
    .widthIs(1)
    .heightIs(24*MYWIDTH);
    
    _timeView.sd_layout
    .topEqualToView(_bgview)
    .rightSpaceToView(_xianView, 0.8*margin)
    .leftSpaceToView(_titleView, 0.8*margin)
    .heightIs(40*MYWIDTH);
    
    _xianView1.sd_layout
    .topSpaceToView(_titleView, 0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_iconView, margin)
    .heightIs(1);
    
    _upView.sd_layout
    .centerXEqualToView(_xianView1)
    .topSpaceToView(_xianView1, 1.5*margin)
    .widthIs(18*MYWIDTH)
    .heightIs(18*MYWIDTH);
    
    _qiLab.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_xianView1)
    .rightSpaceToView(_upView, margin)
    .heightIs(5*margin);
    
    _zhongLab.sd_layout
    .leftSpaceToView(_upView, margin)
    .topEqualToView(_xianView1)
    .rightSpaceToView(_bgview, 1.5*margin)
    .heightIs(5*margin);
    
    _xianView2.sd_layout
    .topSpaceToView(_zhongLab, 0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_iconView, margin)
    .heightIs(1);
    
    _priceView.sd_layout
    .topEqualToView(_xianView2)
    .rightSpaceToView(_bgview, 1.5*margin)
    .widthIs(10*margin)
    .heightIs(4*margin);
    
    _CarTypeView.sd_layout
    .topEqualToView(_xianView2)
    .leftSpaceToView(_iconView, margin)
    .rightSpaceToView(_priceView, 0.1*margin)
    .heightIs(4*margin);
    
    _xianView4.sd_layout
    .topSpaceToView(_CarTypeView, 0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_iconView, margin)
    .heightIs(1);
    
    _chexiangView.sd_layout
    .topEqualToView(_xianView4)
    .leftSpaceToView(_iconView, margin)
    .widthIs(6*margin)
    .heightIs(5*margin);

    _xiangqingBut.sd_layout
    .topSpaceToView(_xianView4, 1.3*margin)
    .rightSpaceToView(_bgview, 1.5*margin)
    .widthIs(91*MYWIDTH)
    .heightIs(24*MYWIDTH);
    
    _juliLab.sd_layout
    .leftSpaceToView(_chexiangView, margin)
    .topSpaceToView(_xianView4, 0)
    .rightSpaceToView(_xiangqingBut, margin)
    .heightIs(5*margin);
    
    NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,_dataModel.folder,_dataModel.autoname];
    //NSLog(@"%@",image);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _iconView.layer.cornerRadius = 12*MYWIDTH;
    [_iconView.layer setMasksToBounds:YES];
    [_titleView setText:[NSString stringWithFormat:@"%@",_dataModel.contactname]];
    [_timeView setText:[NSString stringWithFormat:@"%@",_dataModel.createtime]];
    [_qiLab setText:[NSString stringWithFormat:@"%@%@",_dataModel.scity,_dataModel.scounty]];
    [_zhongLab setText:[NSString stringWithFormat:@"%@%@",_dataModel.ecity,_dataModel.ecounty]];
    if ([_dataModel.weight intValue]==0) {
        [_CarTypeView setText:[NSString stringWithFormat:@"%@ %@ %@方",[_dataModel.cartypenames stringByReplacingOccurrencesOfString:@" " withString:@"/"],_dataModel.cargotypenames,_dataModel.volume]];

    }else if ([_dataModel.volume intValue]==0){
        [_CarTypeView setText:[NSString stringWithFormat:@"%@ %@ %@吨",[_dataModel.cartypenames stringByReplacingOccurrencesOfString:@" " withString:@"/"],_dataModel.cargotypenames,_dataModel.weight]];

    }else{
        [_CarTypeView setText:[NSString stringWithFormat:@"%@ %@ %@吨/%@方",[_dataModel.cartypenames stringByReplacingOccurrencesOfString:@" " withString:@"/"],_dataModel.cargotypenames,_dataModel.weight,_dataModel.volume]];

    }
    [_priceView setText:[NSString stringWithFormat:@"￥%.2f",[_dataModel.siji_money floatValue]]];
    [_juliLab setText:[NSString stringWithFormat:@"%@",_dataModel.shipmenttime]];

    
}

- (void)phoneViewClick{
    
    NSString *phone = [NSString stringWithFormat:@"确定拨打电话：%@？",self.dataModel.contactphone];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:phone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.dataModel.contactphone]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self.controller presentViewController:alertController animated:YES completion:nil];
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
        [self xianView];
        [self phoneView];
        [self bigphoneView];
        [self xianView1];
        
        [self upView];
        [self qiLab];
        [self zhongLab];
        [self xianView2];
        
        [self chexiangView];
        [self CarTypeView];
        [self priceView];
        [self xianView4];
        
        [self juliLab];
        [self xiangqingBut];
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
- (UIView *)xianView
{
    if(_xianView ==nil)
    {
        _xianView =[[UIView alloc]init];
        _xianView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_bgview addSubview: _xianView];
    }
    return _xianView;
}
- (UIButton *)phoneView{
    if (_phoneView == nil) {
        _phoneView = [[UIButton alloc]init];
        _phoneView.backgroundColor = [UIColor whiteColor];
        [_phoneView setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
        [_bgview addSubview:_phoneView];
    }
    return _phoneView;
}
- (UIButton *)bigphoneView{
    if (_bigphoneView == nil) {
        _bigphoneView = [[UIButton alloc]init];
        _bigphoneView.backgroundColor = [UIColor clearColor];
        [_bigphoneView addTarget:self action:@selector(phoneViewClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_bigphoneView];
    }
    return _bigphoneView;
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
        _chexiangView.textColor = UIColorFromRGB(0x555555);
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
        _CarTypeView.font = [UIFont systemFontOfSize:13*MYWIDTH];
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
        _priceView.font = [UIFont systemFontOfSize:14*MYWIDTH];
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

- (UILabel *)juliLab
{
    if(_juliLab ==nil)
    {
        _juliLab =[[UILabel alloc]init];
        _juliLab.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _juliLab.textColor = UIColorFromRGB(0x555555);
        [_bgview addSubview: _juliLab];
    }
    return _juliLab;
}
- (UIButton *)xiangqingBut{
    if (_xiangqingBut == nil) {
        _xiangqingBut = [[UIButton alloc]init];
        _xiangqingBut.backgroundColor = MYColor;
        [_xiangqingBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_xiangqingBut addTarget:self action:@selector(xiangqingButClick) forControlEvents:UIControlEventTouchUpInside];
        [_xiangqingBut setTitle:@"查看详情" forState:UIControlStateNormal];
        _xiangqingBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
        [_bgview addSubview:_xiangqingBut];
    }
    return _xiangqingBut;
}
- (void)xiangqingButClick{
    HomeKYDetailsViewController *detailsVC = [[HomeKYDetailsViewController alloc]init];
    detailsVC.idstr = _dataModel.id;
    [self.controller.navigationController pushViewController:detailsVC animated:YES];
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
