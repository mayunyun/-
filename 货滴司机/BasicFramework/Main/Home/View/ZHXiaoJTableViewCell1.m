//
//  ZHXiaoJTableViewCell1.m
//  BasicFramework
//
//  Created by LONG on 2018/5/16.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ZHXiaoJTableViewCell1.h"
#import "HomeSYXiaoJDetailsViewController.h"

@interface ZHXiaoJTableViewCell1()

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UIImageView *starView;//星级
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

@implementation ZHXiaoJTableViewCell1

- (void)setwithDataModel:(ZHXiaoJModel *)dataModel locationStr:(CLLocationCoordinate2D)location
{
    self.dataModel = dataModel;
    UIView *contentView = self.contentView;
    CGFloat margin = 10*MYWIDTH;
    
    //设置各控件的frame以及data
    //背景
    _bgview.sd_layout
    .leftSpaceToView(contentView, 0)
    .topSpaceToView(contentView, 0.1*margin)
    .rightSpaceToView(contentView, 0)
    .bottomSpaceToView(contentView, 0*margin);
    
    _iconView.sd_layout
    .leftSpaceToView(_bgview, 1.3*margin)
    .topSpaceToView(_bgview, 0.8*margin)
    .widthIs(50*MYWIDTH)
    .heightIs(50*MYWIDTH);
    
    _starView.sd_layout
    .topSpaceToView(_iconView, margin)
    .heightIs(10*MYWIDTH)
    .widthIs([_dataModel.cust_star intValue]*margin)
    .centerXEqualToView(_iconView);
    
    _timeView.sd_layout
    .topEqualToView(_bgview)
    .rightSpaceToView(_bgview, 0.8*margin)
    .widthIs(120*MYWIDTH)
    .heightIs(40*MYWIDTH);
    
    _titleView.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(_bgview,margin)
    .heightIs(20*MYWIDTH)
    .rightSpaceToView(_timeView, 0.1*margin);
    
    _phoneView.sd_layout
    .topSpaceToView(_timeView, 0.5*margin)
    .rightSpaceToView(_bgview, 1.2*margin)
    .heightIs(50*MYWIDTH)
    .widthIs(50*MYWIDTH);
    
    _priceView.sd_layout
    .topSpaceToView(_titleView,margin)
    .rightSpaceToView(_phoneView, margin)
    .heightIs(20*MYWIDTH)
    .widthIs(80*MYWIDTH);
    
    _CarTypeView.sd_layout
    .topSpaceToView(_titleView,margin)
    .leftSpaceToView(_iconView, margin)
    .rightSpaceToView(_priceView, 0.1*margin)
    .heightIs(2*margin);
    
    
    _juliLab.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(_CarTypeView, margin)
    .rightSpaceToView(_phoneView, margin)
    .heightIs(2*margin);
    
    _xiangqingBut.sd_layout
    .leftEqualToView(_bgview)
    .topEqualToView(_bgview)
    .rightSpaceToView(_phoneView, margin)
    .bottomEqualToView(_bgview);
    
    NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,_dataModel.folder,_dataModel.autoname];
    //NSLog(@"%@",image);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _iconView.layer.cornerRadius = 3*MYWIDTH;
    [_iconView.layer setMasksToBounds:YES];
    _starView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@个",_dataModel.cust_star]];
    NSString *scity = [_dataModel.sprocitcou componentsSeparatedByString:@" "][1];
    NSString *scounty = [_dataModel.sprocitcou componentsSeparatedByString:@" "][2];
    NSString *ecity = [_dataModel.eprocitcou componentsSeparatedByString:@" "][1];
    NSString *ecounty = [_dataModel.eprocitcou componentsSeparatedByString:@" "][2];
    if (scity.length>0) {
        scity = [scity substringToIndex:scity.length-1];
    }
    if (scounty.length>0) {
        scounty = [scounty substringToIndex:scounty.length-1];
    }
    if (ecity.length>0) {
        ecity = [ecity substringToIndex:ecity.length-1];
    }
    if (ecounty.length>0) {
        ecounty = [ecounty substringToIndex:ecounty.length-1];
    }
    [_titleView setText:[NSString stringWithFormat:@"%@%@-%@%@",scity,scounty,ecity,ecounty]];
    if ([NSString stringWithFormat:@"%@",_dataModel.createtime].length>16) {
        [_timeView setText:[[NSString stringWithFormat:@"%@",_dataModel.createtime] substringToIndex:16]];
    }

    [_priceView setText:[NSString stringWithFormat:@"￥%.2f",[_dataModel.siji_money floatValue]]];
    NSString *numer = [NSString stringWithFormat:@"%@",_dataModel.cust_num];
    if ([numer isEqualToString:@"(null)"]) {
        numer=@"0";
    }
    [_juliLab setText:[NSString stringWithFormat:@"%@  交易%@笔 %@",_dataModel.consigneename,numer,_dataModel.beizhu]];
    
    CLLocationDegrees latitude = [_dataModel.startlatitude floatValue];
    CLLocationDegrees longitude = [_dataModel.startlongitude floatValue];
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 0;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:location.latitude
                                           longitude:location.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:latitude
                                                longitude:longitude];
    [self.search AMapDrivingRouteSearch:navi];
}
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    
    if (response.route == nil)
    {
        return;
    }
    if (response.route.paths.count) {
        NSLog(@">>>>>%zd",response.route.paths[0].distance);
        float distance = response.route.paths[0].distance;
        
        [_CarTypeView setText:[NSString stringWithFormat:@"起点距您：%.2f公里",distance/1000]];
        
    }else{
        //jxt_showToastTitle(@"路线计算错误，请重新选点", 1);
        [_CarTypeView setText:[NSString stringWithFormat:@"计算错误"]];
        
    }
}

- (void)phoneViewClick{
    
    NSString *phone = [NSString stringWithFormat:@"确定拨打电话：%@？",self.dataModel.consigneephone];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:phone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.dataModel.consigneephone]]];
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
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
        
        [self bgview];
        [self iconView];
        [self starView];
        [self titleView];
        [self timeView];
        //[self xianView];
        [self phoneView];
        //[self bigphoneView];
        //[self xianView1];
        
        //        [self upView];
        //        [self qiLab];
        //        [self zhongLab];
        //[self xianView2];
        
        //[self chexiangView];
        [self CarTypeView];
        [self priceView];
        //[self xianView4];
        
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
- (UIImageView *)starView
{
    if(_starView ==nil)
    {
        _starView =[[UIImageView alloc]init];
        [_bgview addSubview:_starView];
    }
    return _starView;
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont boldSystemFontOfSize:17*MYWIDTH];
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
        _timeView.font = [UIFont systemFontOfSize:12*MYWIDTH];
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
        [_phoneView setImage:[UIImage imageNamed:@"img_dadianhua11"] forState:UIControlStateNormal];
        [_phoneView addTarget:self action:@selector(phoneViewClick) forControlEvents:UIControlEventTouchUpInside];
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
        _CarTypeView.font = [UIFont boldSystemFontOfSize:15*MYWIDTH];
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
        _xiangqingBut.backgroundColor = [UIColor clearColor];
        //        [_xiangqingBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_xiangqingBut addTarget:self action:@selector(xiangqingButClick) forControlEvents:UIControlEventTouchUpInside];
        //        [_xiangqingBut setTitle:@"查看详情" forState:UIControlStateNormal];
        //        _xiangqingBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
        [_bgview addSubview:_xiangqingBut];
    }
    return _xiangqingBut;
}
- (void)xiangqingButClick{
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/drivercertification?action=checkDriverSPStatus" Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSString* str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        if (str.length<10) {
            //jxt_showAlertTitleMessage(@"您还没通过司机认证", @"请到 我的-司机认证 提交相应信息");
            jxt_showAlertTwoButton(@"您还没通过司机认证", @"请到 我的-司机认证 提交相应信息", @"确定", ^(NSInteger buttonIndex) {
                WuLiuSJRZViewController*ZHVC = [[WuLiuSJRZViewController alloc]init];
                ZHVC.hidesBottomBarWhenPushed = YES;
                [self.controller.navigationController pushViewController:ZHVC animated:YES];
            }, @"取消", ^(NSInteger buttonIndex) {
                
            });
        }else if ([str rangeOfString:@"司机已被停用"].location!=NSNotFound){
            NSString * string = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            jxt_showAlertOneButton(@"提示", string, @"取消", ^(NSInteger buttonIndex) {
                
            });
        }else{
            NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[Arr[0] objectForKey:@"driver_info_status"] intValue]==1){//审核通过
                HomeSYXiaoJDetailsViewController *detailsVC = [[HomeSYXiaoJDetailsViewController alloc]init];
                detailsVC.idstr = _dataModel.id;
                [self.controller.navigationController pushViewController:detailsVC animated:YES];
            }else{//审核拒绝
                //jxt_showAlertTitleMessage(@"您还没通过司机认证", @"请到 我的-司机认证 提交相应信息");
                jxt_showAlertTwoButton(@"您还没通过司机认证", @"请到 我的-司机认证 提交相应信息", @"确定", ^(NSInteger buttonIndex) {
                    NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    
                    WuLiuSjrzIngViewController*ZHVC = [[WuLiuSjrzIngViewController alloc]init];
                    ZHVC.status = [[Arr[0] objectForKey:@"driver_info_status"] intValue];
                    ZHVC.hidesBottomBarWhenPushed = YES;
                    [self.controller.navigationController pushViewController:ZHVC animated:YES];
                }, @"取消", ^(NSInteger buttonIndex) {
                    
                });
            }
            
        }
        NSLog(@">>%@",str);
        
    }];
    
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
