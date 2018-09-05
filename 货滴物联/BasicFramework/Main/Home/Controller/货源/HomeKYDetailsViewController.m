//
//  HomeKYDetailsViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/3/8.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "HomeKYDetailsViewController.h"
#import "ShopPageVC.h"

@interface HomeKYDetailsViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *ScrollView;
@property(nonatomic,strong) NSMutableDictionary *Dictionary;

@end

@implementation HomeKYDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.Dictionary = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"货源详情";
    [self loadData];
}
#pragma 在这里面请求数据
- (void)loadData
{
    //
    NSString *URLStr = @"/mbtwz/find?action=selectKuaiyunOrderDetail";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",self.idstr]};
    NSLog(@"参数==%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSArray* arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"zulin%@",arr);
        if (arr.count) {
            self.Dictionary = [[NSMutableDictionary alloc]initWithDictionary:arr[0]];
            [self setUIBGWithView];
        }
        
        
    }];
    
    //
    
}

-(void)setUIBGWithView{
   
    //
    self.ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    self.ScrollView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.showsVerticalScrollIndicator = NO;
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.contentSize = CGSizeMake(UIScreenW, 780*MYWIDTH);
    self.ScrollView.bounces = NO;
    self.ScrollView.delegate = self;
    [self.view addSubview:self.ScrollView];
    
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20*MYWIDTH, UIScreenW, 430*MYWIDTH)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgView1];
    
    UIImageView *iconView =[[UIImageView alloc]initWithFrame:CGRectMake(13*MYWIDTH, 8*MYWIDTH, 24*MYWIDTH, 24*MYWIDTH)];
    iconView.layer.cornerRadius = 12*MYWIDTH;
    [iconView.layer setMasksToBounds:YES];
    NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,[_Dictionary objectForKey:@"folder"],[_Dictionary objectForKey:@"autoname"]];
    [iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [bgView1 addSubview:iconView];
    
    UILabel *titleView =[[UILabel alloc]initWithFrame:CGRectMake(iconView.right+5, 0, 150, 40*MYWIDTH)];
    titleView.font = [UIFont systemFontOfSize:15*MYWIDTH];
    titleView.textColor = UIColorFromRGB(0x333333);
    [titleView setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"fname"]]];
    [bgView1 addSubview: titleView];
    
    UIButton *phoneView = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-28*MYWIDTH, 12*MYWIDTH, 16*MYWIDTH, 16*MYWIDTH)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [phoneView setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [bgView1 addSubview:phoneView];
    
    UIButton *bigphoneView = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-40*MYWIDTH, 0, 40*MYWIDTH, 40*MYWIDTH)];
    bigphoneView.backgroundColor = [UIColor clearColor];
    [bigphoneView addTarget:self action:@selector(phoneViewClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:bigphoneView];
    
    UIView *xianView1 =[[UIView alloc]initWithFrame:CGRectMake(0, 40*MYWIDTH, UIScreenW, 1)];
    xianView1.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView1];
    
    UIImageView *qiView =[[UIImageView alloc]initWithFrame:CGRectMake(18*MYWIDTH, xianView1.bottom+15*MYWIDTH, 14*MYWIDTH, 18*MYWIDTH)];
    qiView.image = [UIImage imageNamed:@"定位绿"];
    [bgView1 addSubview:qiView];
    
    UIImageView *xuxianView =[[UIImageView alloc]initWithFrame:CGRectMake(25*MYWIDTH, qiView.bottom, 1, 32*MYWIDTH)];
    xuxianView.image = [UIImage imageNamed:@"竖虚线"];
    [bgView1 addSubview:xuxianView];
    
    UIImageView *zhongView =[[UIImageView alloc]initWithFrame:CGRectMake(18*MYWIDTH, qiView.bottom+32*MYWIDTH, 14*MYWIDTH, 18*MYWIDTH)];
    zhongView.image = [UIImage imageNamed:@"定位红"];
    [bgView1 addSubview:zhongView];
    
    UILabel *qiLab =[[UILabel alloc]initWithFrame:CGRectMake(qiView.right+15*MYWIDTH, xianView1.bottom, UIScreenW-qiView.right-30*MYWIDTH, 50*MYWIDTH)];
    qiLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    qiLab.numberOfLines = 0;
    qiLab.textColor = UIColorFromRGB(0x333333);
    [qiLab setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"startaddress"]]];
    [bgView1 addSubview: qiLab];
    
    UILabel *zhongLab =[[UILabel alloc]initWithFrame:CGRectMake(qiView.right+15*MYWIDTH, qiLab.bottom, UIScreenW-qiView.right-30*MYWIDTH, 50*MYWIDTH)];
    zhongLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    zhongLab.numberOfLines = 0;
    zhongLab.textColor = UIColorFromRGB(0x333333);
    [zhongLab setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"endaddress"]]];
    [bgView1 addSubview: zhongLab];
    //
    UIView *xianView211 =[[UIView alloc]initWithFrame:CGRectMake(0, zhongLab.bottom, UIScreenW, 1)];
    xianView211.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView211];
    
    UILabel *zhengLiLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView211.bottom, 100, 40*MYWIDTH)];
    zhengLiLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    zhengLiLab.textColor = UIColorFromRGB(0x333333);
    [zhengLiLab setText:@"用车类型"];
    [bgView1 addSubview: zhengLiLab];
    
    UILabel *zhengLiLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView211.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    zhengLiLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    zhengLiLab1.textColor = UIColorFromRGB(0x333333);
    zhengLiLab1.textAlignment = NSTextAlignmentRight;
    if ([[_Dictionary objectForKey:@"use_car_type"] intValue]==0) {
        [zhengLiLab1 setText:@"整车"];
    }else if ([[_Dictionary objectForKey:@"use_car_type"] intValue]==1){
        [zhengLiLab1 setText:@"零担"];
    }else{
        [zhengLiLab1 setText:@"不限"];
    }
    
    [bgView1 addSubview: zhengLiLab1];
    
    UIView *xianView222 =[[UIView alloc]initWithFrame:CGRectMake(0, zhengLiLab1.bottom, UIScreenW, 1)];
    xianView222.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView222];
    
    UILabel *chechangLiLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView222.bottom, 100, 40*MYWIDTH)];
    chechangLiLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    chechangLiLab.textColor = UIColorFromRGB(0x333333);
    [chechangLiLab setText:@"车长"];
    [bgView1 addSubview: chechangLiLab];
    
    UILabel *chechangLiLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView222.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    chechangLiLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    chechangLiLab1.textColor = UIColorFromRGB(0x333333);
    chechangLiLab1.textAlignment = NSTextAlignmentRight;
    NSString *chestr = [[_Dictionary objectForKey:@"lengthname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableString *chechang = [NSMutableString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%@m",chestr] stringByReplacingOccurrencesOfString:@" " withString:@"m、"]];
    //[chechang deleteCharactersInRange:NSMakeRange(chechang.length-1, 1)];
    [chechangLiLab1 setText:chechang];
    [bgView1 addSubview: chechangLiLab1];
    //
    UIView *xianView2 =[[UIView alloc]initWithFrame:CGRectMake(0, chechangLiLab1.bottom, UIScreenW, 1)];
    xianView2.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView2];
    
    UILabel *qiJuLiLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView2.bottom, 100, 40*MYWIDTH)];
    qiJuLiLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    qiJuLiLab.textColor = UIColorFromRGB(0x333333);
    [qiJuLiLab setText:@"车型"];
    [bgView1 addSubview: qiJuLiLab];
    
    UILabel *qiJuLiLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView2.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    qiJuLiLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    qiJuLiLab1.textColor = UIColorFromRGB(0x333333);
    qiJuLiLab1.textAlignment = NSTextAlignmentRight;
    [qiJuLiLab1 setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"cartypenames"]]];
    [bgView1 addSubview: qiJuLiLab1];
    
    UIView *xianView3 =[[UIView alloc]initWithFrame:CGRectMake(0, qiJuLiLab.bottom, UIScreenW, 1)];
    xianView3.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView3];
    
    UILabel *typeLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView3.bottom, 100, 40*MYWIDTH)];
    typeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    typeLab.textColor = UIColorFromRGB(0x333333);
    [typeLab setText:@"货物类型"];
    [bgView1 addSubview: typeLab];
    
    UILabel *typeLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView3.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    typeLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    typeLab1.textColor = UIColorFromRGB(0x333333);
    typeLab1.textAlignment = NSTextAlignmentRight;
    [typeLab1 setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"cargotypenames"]]];
    [bgView1 addSubview: typeLab1];
    
    UIView *xianView4 =[[UIView alloc]initWithFrame:CGRectMake(0, typeLab.bottom, UIScreenW, 1)];
    xianView4.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView4];
    
    UILabel *timeLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView4.bottom, 100, 40*MYWIDTH)];
    timeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    timeLab.textColor = UIColorFromRGB(0x333333);
    [timeLab setText:@"货物重量/数量"];
    [bgView1 addSubview: timeLab];
    
    UILabel *timeLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView4.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    timeLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    timeLab1.textColor = UIColorFromRGB(0x333333);
    timeLab1.textAlignment = NSTextAlignmentRight;
    if ([[_Dictionary objectForKey:@"weight"] intValue]==0) {
        if ([[_Dictionary objectForKey:@"ton_weight"] intValue]==0) {
            [timeLab1 setText:[NSString stringWithFormat:@"%@件",[_Dictionary objectForKey:@"volume"]]];
        }else if ([[_Dictionary objectForKey:@"volume"] intValue]==0){
            [timeLab1 setText:[NSString stringWithFormat:@"%@吨",[_Dictionary objectForKey:@"ton_weight"]]];
        }else{
            [timeLab1 setText:[NSString stringWithFormat:@"%@吨/%@件",[_Dictionary objectForKey:@"ton_weight"],[_Dictionary objectForKey:@"volume"]]];
        }
    }else{
        if ([[_Dictionary objectForKey:@"volume"] intValue]==0){
            [timeLab1 setText:[NSString stringWithFormat:@"%@Kg",[_Dictionary objectForKey:@"weight"]]];
        }else{
            [timeLab1 setText:[NSString stringWithFormat:@"%@Kg/%@件",[_Dictionary objectForKey:@"weight"],[_Dictionary objectForKey:@"volume"]]];
        }
    }
    [bgView1 addSubview: timeLab1];
    
    UIView *xianView5 =[[UIView alloc]initWithFrame:CGRectMake(0, timeLab.bottom, UIScreenW, 1)];
    xianView5.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView5];
    
    UILabel *ordertimeLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView5.bottom, 100, 40*MYWIDTH)];
    ordertimeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    ordertimeLab.textColor = UIColorFromRGB(0x333333);
    [ordertimeLab setText:@"装车时间"];
    [bgView1 addSubview: ordertimeLab];
    
    UILabel *ordertimeLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView5.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    ordertimeLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    ordertimeLab1.textColor = UIColorFromRGB(0x333333);
    ordertimeLab1.textAlignment = NSTextAlignmentRight;
    [ordertimeLab1 setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"shipmenttime"]]];
    [bgView1 addSubview: ordertimeLab1];
    
    UIView *xianView6 =[[UIView alloc]initWithFrame:CGRectMake(0, ordertimeLab.bottom, UIScreenW, 1)];
    xianView6.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView6];
    
    UILabel *createtimeLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView6.bottom, 100, 40*MYWIDTH)];
    createtimeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    createtimeLab.textColor = UIColorFromRGB(0x333333);
    [createtimeLab setText:@"订单发布时间"];
    [bgView1 addSubview: createtimeLab];
    
    UILabel *createtimeLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView6.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    createtimeLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    createtimeLab1.textColor = UIColorFromRGB(0x333333);
    createtimeLab1.textAlignment = NSTextAlignmentRight;
    [createtimeLab1 setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"createtime"]]];
    [bgView1 addSubview: createtimeLab1];
    
    UIView *bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView1.bottom+12*MYWIDTH, UIScreenW, 45*MYWIDTH+50*MYWIDTH)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgView2];
    
    UILabel *xuqiuLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 100, 45*MYWIDTH)];
    xuqiuLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    xuqiuLab.textColor = UIColorFromRGB(0x333333);
    [xuqiuLab setText:@"备注"];
    [bgView2 addSubview: xuqiuLab];
    
    UIView *xianView7 =[[UIView alloc]initWithFrame:CGRectMake(0, xuqiuLab.bottom, UIScreenW, 1)];
    xianView7.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView2 addSubview: xianView7];
    
    UILabel *remarksLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView7.bottom, xianView7.width-30*MYWIDTH, 50*MYWIDTH)];
    remarksLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    remarksLab.textColor = UIColorFromRGB(0x333333);
    remarksLab.numberOfLines = 0;
    [remarksLab setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"remarks"]]];
    [bgView2 addSubview: remarksLab];
    
    UIView *bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView2.bottom+12*MYWIDTH, UIScreenW, 76*MYWIDTH)];
    bgView3.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgView3];
    
    UILabel *zongLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 100, 76*MYWIDTH)];
    zongLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    zongLab.textColor = UIColorFromRGB(0x333333);
    [zongLab setText:@"总计"];
    [bgView3 addSubview: zongLab];
    
    //    UILabel *zongLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, 2*MYWIDTH, UIScreenW-100-30*MYWIDTH, 35*MYWIDTH)];
    //    zongLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    //    zongLab1.textColor = UIColorFromRGB(0x333333);
    //    zongLab1.textAlignment = NSTextAlignmentRight;
    //    [zongLab1 setText:[NSString stringWithFormat:@"%@公里",[_Dictionary objectForKey:@"total_mileage"]]];
    //    //[self changeLineSpaceForLabel:zongLab1 WithSpace:5.0];
    //    [bgView3 addSubview: zongLab1];
    
    UILabel *zongLab2 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, 0, UIScreenW-100-30*MYWIDTH, 76*MYWIDTH)];
    zongLab2.font = [UIFont systemFontOfSize:15*MYWIDTH];
    zongLab2.textColor = MYColor;
    zongLab2.textAlignment = NSTextAlignmentRight;
    [zongLab2 setText:[NSString stringWithFormat:@"%.2f元",[[_Dictionary objectForKey:@"siji_money"] floatValue]]];
    //[self changeLineSpaceForLabel:zongLab1 WithSpace:5.0];
    [bgView3 addSubview: zongLab2];
    
//    UIButton *qiangdanBut = [[UIButton alloc]initWithFrame:CGRectMake(0, UIScreenH-50*MYWIDTH, UIScreenW, 50*MYWIDTH)];
//    qiangdanBut.backgroundColor = MYColor;
//    [qiangdanBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [qiangdanBut addTarget:self action:@selector(qiangdanButClick) forControlEvents:UIControlEventTouchUpInside];
//    [qiangdanBut setTitle:@"抢单" forState:UIControlStateNormal];
//    qiangdanBut.titleLabel.font = [UIFont systemFontOfSize:17*MYWIDTH];
//
//    [self.view addSubview:qiangdanBut];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0,0, UIScreenW, statusbarHeight+44)];
    headview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headview];
}
//- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
//
//    NSString *labelText = label.text;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:space];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
//    label.attributedText = attributedString;
//    [label sizeToFit];
//
//}

- (void)qiangdanButClick{
    //
    //    jxt_showAlertTwoButton(@"提示", @"您确定进行抢单吗？", @"取消", ^(NSInteger buttonIndex) {
    //
    //    }, @"确定", ^(NSInteger buttonIndex) {
    NSString *URLStr = @"/mbtwz/find?action=updateGrabASingle_ky";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\",\"ordertype\":\"%@\"}",self.idstr,@"2"]};
    NSLog(@"抢单参数==%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:kCFStringEncodingUTF8];
        
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self paySuccess];
        }else if ([str rangeOfString:@"self"].location!=NSNotFound){
            jxt_showAlertOneButton(@"提示:抢单失败", @"自己不能抢自己的订单", @"确定", ^(NSInteger buttonIndex) {
            });
        }else if ([str rangeOfString:@"berobbed"].location!=NSNotFound){
            jxt_showAlertOneButton(@"提示:抢单失败", @"该订单已被抢或货主取消了订单", @"确定", ^(NSInteger buttonIndex) {
            });
        }else if ([str rangeOfString:@"already"].location!=NSNotFound){
            jxt_showAlertOneButton(@"提示:抢单失败", @"已经抢过此单", @"确定", ^(NSInteger buttonIndex) {
            });
        }else{
            jxt_showAlertOneButton(@"提示", @"抢单失败", @"确定", ^(NSInteger buttonIndex) {
            });
        }
        
    }];
    //});
    
}
- (void)paySuccess{
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(40*MYWIDTH, 0, UIScreenW-80*MYWIDTH, 200*MYWIDTH)];
    imageview.userInteractionEnabled = YES;
    imageview.image = [UIImage imageNamed:@"抢单成功"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(3, imageview.height/2+5*MYWIDTH, imageview.width, 45*MYWIDTH)];
    lab.numberOfLines = 2;
    lab.text = @"抢单成功\n联系货主沟通价格";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = UIColorFromRGB(0x333333);
    [imageview addSubview:lab];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, lab.bottom+5*MYWIDTH, imageview.width, 30*MYWIDTH)];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"关闭"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:MYColor  range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:MYColor range:(NSRange){0,[tncString length]}];
    [but setAttributedTitle:tncString forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but addTarget:self action:@selector(fahuodanButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:but];
    
    [SMAlert showCustomView:imageview];
    [SMAlert hideCompletion:^{
        //[self.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)fahuodanButClicked:(UIButton *)but{
    [SMAlert hide:NO];
    //[self.navigationController popViewControllerAnimated:YES];
//    ShopPageVC *tongch = [[ShopPageVC alloc]init];
//    tongch.push = @"1";
//    [self.navigationController pushViewController:tongch animated:YES];
     
}
-(void)phoneViewClick{
    NSString *phone = [NSString stringWithFormat:@"确定拨打电话：%@？",[_Dictionary objectForKey:@"fphone"]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:phone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[_Dictionary objectForKey:@"fphone"]]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)phoneViewClick1{
    NSString *phone = [NSString stringWithFormat:@"确定拨打电话：%@？",[_Dictionary objectForKey:@"owner_link_phone"]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:phone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[_Dictionary objectForKey:@"owner_link_phone"]]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
