//
//  ZHKuaiYTableViewCell2.m
//  BasicFramework
//
//  Created by LONG on 2018/5/8.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ZHKuaiYTableViewCell2.h"
#import "HomeKYDetailsViewController.h"

@interface ZHKuaiYTableViewCell2()

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UIImageView *starView;//星级
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *timeView;//时间
@property(nonatomic,strong) UIView *xianView;//线
@property(nonatomic,strong) UIButton *phoneView;//电话
//@property(nonatomic,strong) UIButton *bigphoneView;//电话
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
@property(nonatomic,strong) UILabel *jiaoyiLab;

@property(nonatomic,strong) UIButton *xiangqingBut;//查看详情

@end

@implementation ZHKuaiYTableViewCell2

- (void)setwithDataModel:(ZHKuaiYModel *)dataModel
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
    
    
    _phoneView.sd_layout
    .topSpaceToView(_bgview, 0.5*margin)
    .rightSpaceToView(_bgview, 1.2*margin)
    .heightIs(60*MYWIDTH)
    .widthIs(60*MYWIDTH);
    
    _titleView.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topSpaceToView(_bgview,margin)
    .heightIs(20*MYWIDTH)
    .rightSpaceToView(_phoneView, 0.1*margin);
    
    _CarTypeView.sd_layout
    .topSpaceToView(_titleView,margin)
    .leftSpaceToView(_bgview, 1.5*margin)
    .rightSpaceToView(_phoneView, 0.1*margin)
    .heightIs(2*margin);
    
    _timeView.sd_layout
    .topSpaceToView(_phoneView, 0.2*margin)
    .rightSpaceToView(_bgview, 1.5*margin)
    .widthIs(80*MYWIDTH)
    .heightIs(40*MYWIDTH);
    
    _iconView.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topSpaceToView(_CarTypeView, 0.8*margin)
    .widthIs(25*MYWIDTH)
    .heightIs(25*MYWIDTH);
    
    _juliLab.sd_layout
    .leftSpaceToView(_iconView, 0.6*margin)
    .topSpaceToView(_CarTypeView, 0.4*margin)
    .rightSpaceToView(_timeView, margin)
    .heightIs(2*margin);
    
    _starView.sd_layout
    .topSpaceToView(_juliLab, 0)
    .heightIs(10*MYWIDTH)
    .widthIs([_dataModel.cust_star intValue]*margin*1.1)
    .leftSpaceToView(_iconView, 0.6*margin);
    
    _jiaoyiLab.sd_layout
    .leftSpaceToView(_starView, 0.5*margin)
    .topSpaceToView(_CarTypeView, 1.9*margin)
    .rightSpaceToView(_timeView, margin)
    .heightIs(2*margin);
    
    _xiangqingBut.sd_layout
    .leftEqualToView(_bgview)
    .topEqualToView(_bgview)
    .rightSpaceToView(_phoneView, margin)
    .bottomEqualToView(_bgview);
    
    _phoneView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    // button标题的偏移量
    _phoneView.titleEdgeInsets = UIEdgeInsetsMake(29*MYWIDTH, -24*MYWIDTH, 0,0);
    // button图片的偏移量
    _phoneView.imageEdgeInsets = UIEdgeInsetsMake(0, 12*MYWIDTH, 10*MYWIDTH, 0);
    
    NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,_dataModel.folder,_dataModel.autoname];
    //NSLog(@"%@",image);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _iconView.layer.cornerRadius = 3*MYWIDTH;
    [_iconView.layer setMasksToBounds:YES];
    _starView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@个",_dataModel.cust_star]];
    NSString *scity = _dataModel.scity;
    NSString *scounty = _dataModel.scounty;
    NSString *ecity = _dataModel.ecity;
    NSString *ecounty = _dataModel.ecounty;
    if (_dataModel.scity.length>0) {
        scity = [_dataModel.scity substringToIndex:_dataModel.scity.length-1];
    }
    if (_dataModel.scounty.length>0) {
        scounty = [_dataModel.scounty substringToIndex:_dataModel.scounty.length-1];
    }
    if (_dataModel.ecity.length>0) {
        ecity = [_dataModel.ecity substringToIndex:_dataModel.ecity.length-1];
    }
    if (_dataModel.ecounty.length>0) {
        ecounty = [_dataModel.ecounty substringToIndex:_dataModel.ecounty.length-1];
    }
    [_titleView setText:[NSString stringWithFormat:@"%@%@-%@%@",scity,scounty,ecity,ecounty]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    if ([NSString stringWithFormat:@"%@",_dataModel.createtime].length>10) {
        NSLog(@"%@  %@>>%f",_dataModel.createtime,dateTime,[self dateTimeDifferenceWithStartTime:[NSString stringWithFormat:@"%@",_dataModel.createtime] endTime:dateTime]);
        if ([self dateTimeDifferenceWithStartTime:[NSString stringWithFormat:@"%@",_dataModel.createtime] endTime:dateTime]<30) {
            [_timeView setText:@"刚刚   "];
        }else{
            [_timeView setText:[[[NSString stringWithFormat:@"%@",_dataModel.createtime] substringFromIndex:5] substringToIndex:11]];
        }
        
    }
    
    NSString * use_type;
    if ([_dataModel.use_car_type intValue]==0) {
        use_type = @"整车 ";
    }else if ([_dataModel.volume intValue]==0){
        use_type = @"零担 ";
    }else{
        use_type = @"";
    }
    NSString *chestr = [_dataModel.lengthname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableString *chechang;
    if (chestr.length<1) {
        chechang = (NSMutableString *)@"";
    }else{
        chechang = [NSMutableString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%@米",chestr] stringByReplacingOccurrencesOfString:@" " withString:@"/"]];
    }
    
    if ([_dataModel.weight intValue]==0) {
        [_CarTypeView setText:[NSString stringWithFormat:@"%@%@ %@ %@ %@件",use_type,chechang,[_dataModel.cartypenames stringByReplacingOccurrencesOfString:@" " withString:@"/"],_dataModel.cargotypenames,_dataModel.volume]];
        
    }else if ([_dataModel.volume intValue]==0){
        [_CarTypeView setText:[NSString stringWithFormat:@"%@%@ %@ %@ %@Kg",use_type,chechang,[_dataModel.cartypenames stringByReplacingOccurrencesOfString:@" " withString:@"/"],_dataModel.cargotypenames,_dataModel.weight]];
        
    }else{
        [_CarTypeView setText:[NSString stringWithFormat:@"%@%@ %@ %@ %@Kg/%@件",use_type,chechang,[_dataModel.cartypenames stringByReplacingOccurrencesOfString:@" " withString:@"/"],_dataModel.cargotypenames,_dataModel.weight,_dataModel.volume]];
        
    }
    //[_priceView setText:[NSString stringWithFormat:@"￥%.2f",[_dataModel.siji_money floatValue]]];
    NSString *numer = [NSString stringWithFormat:@"%@",_dataModel.cust_num];
    if ([numer isEqualToString:@"(null)"]) {
        numer=@"0";
    }
    [_juliLab setText:[NSString stringWithFormat:@"%@",_dataModel.contactname]];
    [_jiaoyiLab setText:[NSString stringWithFormat:@"交易%@笔",numer]];
    
    
}
/**
 * 开始到结束的时间差
 */
- (float)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    if (value<0) {
        value = 0;
    }
    return value/60;
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
        [self starView];
        [self titleView];
        [self timeView];
        
        [self phoneView];
        [self CarTypeView];
        
        [self juliLab];
        [self jiaoyiLab];
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
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = 12.5*MYWIDTH;
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
        [_phoneView setImage:[UIImage imageNamed:@"img_dadianhua11"] forState:UIControlStateNormal];
        [_phoneView addTarget:self action:@selector(phoneViewClick) forControlEvents:UIControlEventTouchUpInside];
        [_phoneView setTitle:@"联系货主" forState:UIControlStateNormal];
        _phoneView.titleLabel.font = [UIFont boldSystemFontOfSize:11*MYWIDTH];
        [_phoneView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bgview addSubview:_phoneView];
    }
    return _phoneView;
}
//- (UIButton *)bigphoneView{
//    if (_bigphoneView == nil) {
//        _bigphoneView = [[UIButton alloc]init];
//        _bigphoneView.backgroundColor = [UIColor clearColor];
//        [_bigphoneView addTarget:self action:@selector(phoneViewClick) forControlEvents:UIControlEventTouchUpInside];
//        [_bgview addSubview:_bigphoneView];
//    }
//    return _bigphoneView;
//}
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
        _CarTypeView.font = [UIFont boldSystemFontOfSize:14*MYWIDTH];
        _CarTypeView.textColor = UIColorFromRGB(0x555555);
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
- (UILabel *)jiaoyiLab
{
    if(_jiaoyiLab ==nil)
    {
        _jiaoyiLab =[[UILabel alloc]init];
        _jiaoyiLab.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _jiaoyiLab.textColor = UIColorFromRGB(0x555555);
        [_bgview addSubview: _jiaoyiLab];
    }
    return _jiaoyiLab;
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
                HomeKYDetailsViewController *detailsVC = [[HomeKYDetailsViewController alloc]init];
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
