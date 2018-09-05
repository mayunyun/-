//
//  TongChBanOrderDetail.m
//  BasicFramework
//
//  Created by LONG on 2018/2/27.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "TongChBanOrderDetail.h"
#import "CDZStarsControl.h"
#import "PLTagView.h"
@interface TongChBanOrderDetail ()<UIScrollViewDelegate,AMapSearchDelegate,CDZStarsControlDelegate,UITextViewDelegate,PLTagViewDelegate, PLTagViewDataSource>
@property(nonatomic,strong) UIScrollView *ScrollView;
@property(nonatomic,strong) NSMutableDictionary *Dictionary;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong)UILabel *qiJuLiLab1;
@property (nonatomic, strong) CDZStarsControl *starsControl;
@property (nonatomic,strong)UITextView * inputTV;
@property (nonatomic,strong)UIButton * exitBtn;
@property (nonatomic,strong)UIButton * commitBtn;
@end

@implementation TongChBanOrderDetail
{
    UIView * starView;
    UILabel *_placeHolderLabel;
    NSString * starScore;
    UIButton *_PLbutton;
    PLTagView *_typeview;
    NSMutableArray *_arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.Dictionary = [[NSMutableDictionary alloc]init];
    _arr = [[NSMutableArray alloc]init];

    // Do any additional setup after loading the view.
    
    starScore = @"5";

    self.navigationItem.title = @"同城搬家单详情";
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self loadData];
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
}
#pragma 在这里面请求数据
- (void)loadData
{
    //
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=searchorder";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderno]};
    NSLog(@"参数==%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSArray* arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"zulin%@",arr);
        if (arr.count) {
            self.Dictionary = [[NSMutableDictionary alloc]initWithDictionary:arr[0]];
            
            NSString *URLStr1 = @"/mbtwz/find?action=selectLogisticsOrderDetailServ";
            NSDictionary* params1 = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",[_Dictionary objectForKey:@"id"]]};
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr1 Parameters:params1 FinishedLogin:^(id responseObject) {
                
                NSArray* array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                [self.Dictionary setObject:array forKey:@"service"];
                NSLog(@"zulin%@",array);
                [self setUIBGWithView];
                [self configLocationManager:[[_Dictionary objectForKey:@"latitude"] doubleValue] longitude:[[_Dictionary objectForKey:@"longitude"] doubleValue]];
                
                
            }];
        }
        
        
    }];
    
    //
    //
    NSString *PLURLStr = @"/mbtwz/logisticssendwz?action=selectEvaluationList";
    NSDictionary* PLparams = @{@"params":[NSString stringWithFormat:@"{\"type\":\"1\",\"custid\":\"%@\"}",self.custid]};
    NSLog(@"参数==%@",PLparams);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:PLURLStr Parameters:PLparams FinishedLogin:^(id responseObject) {
        
        NSDictionary *dataarr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSMutableDictionary *dic in [dataarr objectForKey:@"response"]) {
            [dic setValue:@"0" forKey:@"up"];
            [_arr addObject:dic];
        }
        NSLog(@"zulin%@",_arr);
        
        
        [_typeview reloadData];
    }];
}

-(void)setUIBGWithView{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in [_Dictionary objectForKey:@"service"]) {
        [arr addObject:[dic objectForKey:@"service_name"]];
        if ([[dic objectForKey:@"owner_service_price"] floatValue]==0) {
            [arr1 addObject:@"免费"];
        }else{
            [arr1 addObject:[NSString stringWithFormat:@"%.2f元",[[dic objectForKey:@"owner_service_price"] floatValue]]];
        }
    }
    //
    self.ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavBarHeight, UIScreenW, UIScreenH-NavBarHeight)];
    self.ScrollView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.showsVerticalScrollIndicator = NO;
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.contentSize = CGSizeMake(UIScreenW, 806*MYWIDTH+arr.count*40*MYWIDTH);
    self.ScrollView.bounces = NO;
    self.ScrollView.delegate = self;
    [self.view addSubview:self.ScrollView];
    
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20*MYWIDTH, UIScreenW, 430*MYWIDTH)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgView1];
    
    UILabel *ordernoView =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0,UIScreenW-100*MYWIDTH, 40*MYWIDTH)];
    ordernoView.font = [UIFont systemFontOfSize:15*MYWIDTH];
    ordernoView.textColor = [UIColor blackColor];
    [ordernoView setText:[NSString stringWithFormat:@"订单号:%@",[_Dictionary objectForKey:@"owner_orderno"]]];
    [bgView1 addSubview: ordernoView];
    
    UILabel *orderstatus =[[UILabel alloc]initWithFrame:CGRectMake(UIScreenW-115*MYWIDTH, 0,100*MYWIDTH, 40*MYWIDTH)];
    orderstatus.font = [UIFont systemFontOfSize:15*MYWIDTH];
    orderstatus.textColor = [UIColor blackColor];
    orderstatus.textAlignment = NSTextAlignmentRight;
    if ([[_Dictionary objectForKey:@"driver_orderstatus"] integerValue]==-1) {
        orderstatus.text = @"已取消";
    }else if ([[_Dictionary objectForKey:@"driver_orderstatus"] integerValue]==0){
        orderstatus.text = @"前往中";
    }else if ([[_Dictionary objectForKey:@"driver_orderstatus"] integerValue]==1){
        orderstatus.text = @"开始订单";
    }else if ([[_Dictionary objectForKey:@"driver_orderstatus"] integerValue]==2){
        orderstatus.text = @"已完成";
    }else if ([[_Dictionary objectForKey:@"driver_orderstatus"] integerValue]==-2){
        orderstatus.text = @"未接单";
    }
    [bgView1 addSubview: orderstatus];
    
    UIView *xianVie =[[UIView alloc]initWithFrame:CGRectMake(0, ordernoView.bottom, UIScreenW, 1)];
    xianVie.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianVie];
    
    UIImageView *iconView =[[UIImageView alloc]initWithFrame:CGRectMake(13*MYWIDTH, xianVie.bottom + 8*MYWIDTH, 24*MYWIDTH, 24*MYWIDTH)];
    iconView.layer.cornerRadius = 12*MYWIDTH;
    [iconView.layer setMasksToBounds:YES];
    NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,[_Dictionary objectForKey:@"folder"],[_Dictionary objectForKey:@"autoname"]];
    [iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [bgView1 addSubview:iconView];
    
    UILabel *titleView =[[UILabel alloc]initWithFrame:CGRectMake(iconView.right+5, xianVie.bottom, 150, 40*MYWIDTH)];
    titleView.font = [UIFont systemFontOfSize:15*MYWIDTH];
    titleView.textColor = UIColorFromRGB(0x333333);
    [titleView setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"fname"]]];
    [bgView1 addSubview: titleView];
    
    UIButton *phoneView = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-28*MYWIDTH, xianVie.bottom + 12*MYWIDTH, 16*MYWIDTH, 16*MYWIDTH)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [phoneView setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [bgView1 addSubview:phoneView];
    
    UIButton *bigphoneView = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-40*MYWIDTH, xianVie.bottom, 40*MYWIDTH, 40*MYWIDTH)];
    bigphoneView.backgroundColor = [UIColor clearColor];
    [bigphoneView addTarget:self action:@selector(phoneViewClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:bigphoneView];
    
    UIView *xianView1 =[[UIView alloc]initWithFrame:CGRectMake(0, titleView.bottom, UIScreenW, 1)];
    xianView1.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView1];
    //
    UILabel *titleView1 =[[UILabel alloc]initWithFrame:CGRectMake(13*MYWIDTH, xianView1.bottom, 250, 40*MYWIDTH)];
    titleView1.font = [UIFont systemFontOfSize:15*MYWIDTH];
    titleView1.textColor = UIColorFromRGB(0x333333);
    [titleView1 setText:[NSString stringWithFormat:@"收货人：%@",[_Dictionary objectForKey:@"owner_link_name"]]];
    [bgView1 addSubview: titleView1];
    
    UIButton *phoneView1 = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-28*MYWIDTH, xianView1.bottom + 12*MYWIDTH, 16*MYWIDTH, 16*MYWIDTH)];
    phoneView1.backgroundColor = [UIColor whiteColor];
    [phoneView1 setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [bgView1 addSubview:phoneView1];
    
    UIButton *bigphoneView1 = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-40*MYWIDTH, xianView1.bottom, 40*MYWIDTH, 40*MYWIDTH)];
    bigphoneView1.backgroundColor = [UIColor clearColor];
    [bigphoneView1 addTarget:self action:@selector(phoneViewClick1) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:bigphoneView1];
    
    UIView *xianView11 =[[UIView alloc]initWithFrame:CGRectMake(0, titleView1.bottom, UIScreenW, 1)];
    xianView11.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView11];
    //
    
    UIImageView *qiView =[[UIImageView alloc]initWithFrame:CGRectMake(18*MYWIDTH, xianView11.bottom+15*MYWIDTH, 14*MYWIDTH, 18*MYWIDTH)];
    qiView.image = [UIImage imageNamed:@"定位绿"];
    [bgView1 addSubview:qiView];
    
    UIImageView *xuxianView =[[UIImageView alloc]initWithFrame:CGRectMake(25*MYWIDTH, qiView.bottom, 1, 32*MYWIDTH)];
    xuxianView.image = [UIImage imageNamed:@"竖虚线"];
    [bgView1 addSubview:xuxianView];
    
    UIImageView *zhongView =[[UIImageView alloc]initWithFrame:CGRectMake(18*MYWIDTH, qiView.bottom+32*MYWIDTH, 14*MYWIDTH, 18*MYWIDTH)];
    zhongView.image = [UIImage imageNamed:@"定位红"];
    [bgView1 addSubview:zhongView];
    
    UILabel *qiLab =[[UILabel alloc]initWithFrame:CGRectMake(qiView.right+15*MYWIDTH, xianView11.bottom, UIScreenW-qiView.right-30*MYWIDTH, 50*MYWIDTH)];
    qiLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    qiLab.numberOfLines = 0;
    qiLab.textColor = UIColorFromRGB(0x333333);
    [qiLab setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_address"]]];
    [bgView1 addSubview: qiLab];
    
    UILabel *zhongLab =[[UILabel alloc]initWithFrame:CGRectMake(qiView.right+15*MYWIDTH, qiLab.bottom, UIScreenW-qiView.right-30*MYWIDTH, 50*MYWIDTH)];
    zhongLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    zhongLab.numberOfLines = 0;
    zhongLab.textColor = UIColorFromRGB(0x333333);
    [zhongLab setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_send_address"]]];
    [bgView1 addSubview: zhongLab];
    
    UIView *xianView2 =[[UIView alloc]initWithFrame:CGRectMake(0, zhongLab.bottom, UIScreenW, 1)];
    xianView2.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView2];
    
    UILabel *qiJuLiLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView2.bottom, 100, 40*MYWIDTH)];
    qiJuLiLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    qiJuLiLab.textColor = UIColorFromRGB(0x333333);
    [qiJuLiLab setText:@"货物起点距离"];
    [bgView1 addSubview: qiJuLiLab];
    
    self.qiJuLiLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView2.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    _qiJuLiLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    _qiJuLiLab1.textColor = UIColorFromRGB(0x333333);
    _qiJuLiLab1.textAlignment = NSTextAlignmentRight;
    [bgView1 addSubview: _qiJuLiLab1];
    
    UIView *xianView3 =[[UIView alloc]initWithFrame:CGRectMake(0, qiJuLiLab.bottom, UIScreenW, 1)];
    xianView3.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView3];
    
    UILabel *typeLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView3.bottom, 100, 40*MYWIDTH)];
    typeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    typeLab.textColor = UIColorFromRGB(0x333333);
    [typeLab setText:@"用车类型"];
    [bgView1 addSubview: typeLab];
    
    UILabel *typeLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView3.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    typeLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    typeLab1.textColor = UIColorFromRGB(0x333333);
    typeLab1.textAlignment = NSTextAlignmentRight;
    [typeLab1 setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"car_type"]]];
    [bgView1 addSubview: typeLab1];
    
    UIView *xianView4 =[[UIView alloc]initWithFrame:CGRectMake(0, typeLab.bottom, UIScreenW, 1)];
    xianView4.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView4];
    
    UILabel *timeLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView4.bottom, 100, 40*MYWIDTH)];
    timeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    timeLab.textColor = UIColorFromRGB(0x333333);
    [timeLab setText:@"路程距离"];
    [bgView1 addSubview: timeLab];
    
    UILabel *timeLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView4.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    timeLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    timeLab1.textColor = UIColorFromRGB(0x333333);
    timeLab1.textAlignment = NSTextAlignmentRight;
    [timeLab1 setText:[NSString stringWithFormat:@"%@公里",[_Dictionary objectForKey:@"total_mileage"]]];
    [bgView1 addSubview: timeLab1];
    
    UIView *xianView5 =[[UIView alloc]initWithFrame:CGRectMake(0, timeLab.bottom, UIScreenW, 1)];
    xianView5.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView5];
    
    UILabel *ordertimeLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView5.bottom, 100, 40*MYWIDTH)];
    ordertimeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    ordertimeLab.textColor = UIColorFromRGB(0x333333);
    [ordertimeLab setText:@"用车时间"];
    [bgView1 addSubview: ordertimeLab];
    
    UILabel *ordertimeLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView5.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    ordertimeLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    ordertimeLab1.textColor = UIColorFromRGB(0x333333);
    ordertimeLab1.textAlignment = NSTextAlignmentRight;
    [ordertimeLab1 setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_sendtime"]]];
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
    [createtimeLab1 setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_createtime"]]];
    [bgView1 addSubview: createtimeLab1];
    
    UIView *bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView1.bottom+12*MYWIDTH, UIScreenW, 45*MYWIDTH+arr.count*40*MYWIDTH)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgView2];
    
    UILabel *xuqiuLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 100, 45*MYWIDTH)];
    xuqiuLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    xuqiuLab.textColor = UIColorFromRGB(0x333333);
    [xuqiuLab setText:@"额外需求"];
    [bgView2 addSubview: xuqiuLab];
    
    for (int i=0; i<arr.count; i++) {
        UIView *xianView =[[UIView alloc]initWithFrame:CGRectMake(0, xuqiuLab.bottom+i*40*MYWIDTH, UIScreenW, 1)];
        xianView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [bgView2 addSubview: xianView];
        
        UILabel *Lab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView.bottom, 100, 40*MYWIDTH)];
        Lab.font = [UIFont systemFontOfSize:14*MYWIDTH];
        Lab.textColor = UIColorFromRGB(0x333333);
        [Lab setText:arr[i]];
        [bgView2 addSubview: Lab];
        
        UILabel *Lab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
        Lab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
        Lab1.textColor = UIColorFromRGB(0x333333);
        Lab1.textAlignment = NSTextAlignmentRight;
        [Lab1 setText:[NSString stringWithFormat:@"%@",arr1[i]]];
        [bgView2 addSubview: Lab1];
    }
    
    UIView *bgView4 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView2.bottom+12*MYWIDTH, UIScreenW, 90*MYWIDTH)];
    bgView4.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgView4];
    
    UILabel *beizhu =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 100, 45*MYWIDTH)];
    beizhu.font = [UIFont systemFontOfSize:14*MYWIDTH];
    beizhu.textColor = UIColorFromRGB(0x333333);
    [beizhu setText:@"备注"];
    [bgView4 addSubview: beizhu];
    
    UIView *xianView8 =[[UIView alloc]initWithFrame:CGRectMake(0, beizhu.bottom, UIScreenW, 1)];
    xianView8.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView4 addSubview: xianView8];
    
    UILabel *beizhuLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView8.bottom, UIScreenW-30*MYWIDTH, 45*MYWIDTH)];
    beizhuLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    beizhuLab.textColor = UIColorFromRGB(0x333333);
    if ([[_Dictionary objectForKey:@"owner_note"] length]>0) {
        [beizhuLab setText:[_Dictionary objectForKey:@"owner_note"]];
    }else{
        [beizhuLab setText:@"无"];
    }
    [bgView4 addSubview: beizhuLab];
    
    //
    UIView *bgView41 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView4.bottom+12*MYWIDTH, UIScreenW, 50*MYWIDTH)];
    bgView41.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgView41];
    
    UILabel *typeLabtype1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 100, 50*MYWIDTH)];
    typeLabtype1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    typeLabtype1.textColor = UIColorFromRGB(0x333333);
    [typeLabtype1 setText:@"支付方式"];
    [bgView41 addSubview: typeLabtype1];
    
    
    UILabel *typeLabtype2 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, 0, UIScreenW-100-30*MYWIDTH, 50*MYWIDTH)];
    typeLabtype2.font = [UIFont systemFontOfSize:15*MYWIDTH];
    typeLabtype2.textColor = MYColor;
    typeLabtype2.textAlignment = NSTextAlignmentRight;
    switch ([[_Dictionary objectForKey:@"paytype"] intValue]) {
        case 0:
            [typeLabtype2 setText:@"支付宝支付"];
            break;
        case 1:
            [typeLabtype2 setText:@"微信支付"];
            break;
        case 2:
            [typeLabtype2 setText:@"余额支付"];
            break;
        case 3:
            [typeLabtype2 setText:@"线下支付"];
            break;
        case 4:
            [typeLabtype2 setText:@"签约用户"];
            break;
        default:
            [typeLabtype2 setText:@"未支付"];
            break;
    }
    [bgView41 addSubview: typeLabtype2];
    
    UIView *bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView41.bottom+12*MYWIDTH, UIScreenW, 76*MYWIDTH)];
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
    
    
    if ([[_Dictionary objectForKey:@"driver_orderstatus"] intValue]==2&&[[_Dictionary objectForKey:@"isevaluate_dri"] intValue]==0) {
        _PLbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bottom-50*MYWIDTH, UIScreenW, 50*MYWIDTH)];
        _PLbutton.backgroundColor = MYColor;
        [_PLbutton setTitle:@"去评价" forState:UIControlStateNormal];
        [_PLbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_PLbutton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_PLbutton];
    }
    _typeview = [[PLTagView alloc] init];
    _typeview.frame = CGRectMake(1, 1, UIScreenW-90*MYWIDTH, 0);
    _typeview.themeColor = MYColor;
    _typeview.backgroundColor = [UIColor whiteColor];
    _typeview.tagCornerRadius = 0;
    _typeview.dataSource = self;
    _typeview.delegate = self;
    _typeview.numer = 3;
    [self.view addSubview:_typeview];
}
- (void)buttonClick{
    starView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW-60, UIScreenH*1.4/3)];
    starView.backgroundColor = [UIColor whiteColor];
    starView.layer.cornerRadius = 8.f;
    starView.layer.masksToBounds = YES;
    _typeview.frame = CGRectMake(20*MYWIDTH, 50*MYWIDTH, starView.width-40*MYWIDTH, 100*MYWIDTH);
    [starView addSubview:_typeview];
    [starView addSubview:self.starsControl];
    [starView addSubview:self.exitBtn];
    [starView addSubview:self.inputTV];
    [starView addSubview:self.commitBtn];
    [SMAlert showCustomView:starView];
}
- (NSInteger)PLnumOfItemstagView:(PLTagView *)tagView  {
    
    if (_typeview == tagView){
        return _arr.count;
    }
    return 0;
}

- (NSString *)PLtagView:(PLTagView *)tagView titleForItemAtIndex:(NSInteger)index {
    if (_typeview == tagView){
        return [NSString stringWithFormat:@"%@(%@)",[_arr[index] objectForKey:@"content"],[_arr[index] objectForKey:@"usenumber"]];
    }
    return nil;
}
- (void)PLtagView:(PLTagView *)tagView heightUpdated:(CGFloat)height{
    NSLog(@">>>>>>>???>>>>>%.2f",height);
    
}

- (void)PLtagView:(PLTagView *)tagView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@">>>>>>>???>>>>>%zd",index);
    //创建一个消息对象
    //_integer = [NSString stringWithFormat:@"%zd",index];
    if ([[NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"up"]] isEqualToString:@"0"]) {
        [_arr[index] setValue:@"1" forKey:@"up"];
    }else{
        [_arr[index] setValue:@"0" forKey:@"up"];
    }
    
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
- (void)configLocationManager:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
            //            CLLocationCoordinate2D locationStr = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
            //
            //            CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            //            //1.将两个经纬度点转成投影点
            //            MAMapPoint point1 = MAMapPointForCoordinate(centerCoordinate);
            //            MAMapPoint point2 = MAMapPointForCoordinate(locationStr);
            //            //2.计算距离
            //            CLLocationDistance distances = MAMetersBetweenMapPoints(point1,point2);
            //            [_qiJuLiLab1 setText:[NSString stringWithFormat:@"%.2f公里",distances/1000]];
            
            AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
            
            navi.requireExtension = YES;
            navi.strategy = 0;
            /* 出发点. */
            navi.origin = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude
                                                   longitude:location.coordinate.longitude];
            /* 目的地. */
            navi.destination = [AMapGeoPoint locationWithLatitude:latitude
                                                        longitude:longitude];
            [self.search AMapDrivingRouteSearch:navi];
        }
        
    }];
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
        
        [_qiJuLiLab1 setText:[NSString stringWithFormat:@"%.2f公里",distance/1000]];
        
    }else{
        //jxt_showToastTitle(@"路线计算错误，请重新选点", 1);
        [_qiJuLiLab1 setText:[NSString stringWithFormat:@"计算错误"]];
        
    }
}
#pragma mark -- 懒加载
- (CDZStarsControl *)starsControl{
    if (!_starsControl) {
        
        _starsControl = [CDZStarsControl.alloc initWithFrame:CGRectMake(starView.width/2-100*MYWIDTH, 20*MYWIDTH, 200*MYWIDTH , 20*MYWIDTH) stars:5 starSize:CGSizeMake(20*MYWIDTH, 20*MYWIDTH) noramlStarImage:[UIImage imageNamed:@"11.2"] highlightedStarImage:[UIImage imageNamed:@"11.1"]];
        _starsControl.delegate = self;
        _starsControl.allowFraction = NO;
        _starsControl.score = 5.0f;
    }
    return _starsControl;
}
-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn.frame = CGRectMake(starView.width- 140*MYWIDTH, starView.height-50*MYWIDTH, 100*MYWIDTH, 30*MYWIDTH);
        [_exitBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:MYColor forState:UIControlStateNormal];
        _exitBtn.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        [_exitBtn setBackgroundColor:[UIColor whiteColor]];
        _exitBtn.layer.cornerRadius = 10.f;
        _exitBtn.layer.masksToBounds = YES;
        _exitBtn.layer.borderWidth = 0.5;
        _exitBtn.layer.borderColor = MYColor.CGColor;
        [_exitBtn addTarget:self action:@selector(exitRemarkPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
    
}
-(UITextView *)inputTV{
    if (!_inputTV) {
        _inputTV = [[UITextView alloc] initWithFrame:CGRectMake(20*MYWIDTH, self.starsControl.bottom+130*MYWIDTH, starView.width-40*MYWIDTH, starView.height/4)];
        _inputTV.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _inputTV.layer.cornerRadius = 8.f;
        _inputTV.layer.borderWidth = 1.0f;
        _inputTV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _inputTV.delegate = self;
        _inputTV.backgroundColor = [UIColor clearColor];
        _inputTV.textColor = [UIColor blackColor];
        [starView addSubview:_inputTV];
        _inputTV.text = @"";
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*MYWIDTH, 5*MYWIDTH,starView.width-40*MYWIDTH, 20*MYWIDTH)];
        _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        _placeHolderLabel.font = [UIFont systemFontOfSize:17*MYWIDTH];
        _placeHolderLabel.text = @"请输入您的宝贵意见!";
        [_inputTV addSubview:_placeHolderLabel];
        //给键盘加一个view收起键盘
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 30)];
        [topView setBarStyle:UIBarStyleBlack];
        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
        [topView setItems:buttonsArray];
        [_inputTV setInputAccessoryView:topView];
        
    }
    return _inputTV;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.frame = CGRectMake(40*MYWIDTH, starView.height-50*MYWIDTH, 100*MYWIDTH, 30*MYWIDTH);
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        [_commitBtn setBackgroundColor:MYColor];
        [_commitBtn addTarget:self action:@selector(CommitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.cornerRadius = 10.f;
        _commitBtn.layer.masksToBounds = YES;
    }
    return _commitBtn;
}
-(void)exitRemarkPage{
    [SMAlert hide:NO];
}
#pragma remark -- 星星评价
- (void)starsControl:(CDZStarsControl *)starsControl didChangeScore:(CGFloat)score{
    //    self.label.text = [NSString stringWithFormat:@"%.1f",score];
    starScore = [NSString stringWithFormat:@"%.f",score];
    NSLog(@"星星的分数%@",starScore);
}
-(void)dismissKeyBoard
{
    [_inputTV resignFirstResponder];
}
-(void)CommitBtnClicked:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    NSString *selevalueids;
    for (NSDictionary *dic in _arr) {
        if ([[dic objectForKey:@"up"] isEqualToString:@"1"]) {
            selevalueids = [NSString stringWithFormat:@"%@,%@",selevalueids,[dic objectForKey:@"id"]];
        }
    }
    NSString *str1 = [selevalueids substringFromIndex:7];
    
    NSString *url = @"/mbtwz/logisticssendwz?action=evlateOrder_by_sel";
    NSDictionary * dic;
    if ([_inputTV.text isEqualToString:@""]) {//默认不填任何信息是好评
        dic =@{@"order_id":[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"id"]],@"driver_fraction":starScore,@"note":@"默认好评",@"driverid":[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_custid"]],@"ordertype":@"0",@"evalute_type":@"1",@"selevalueids":str1};
    }else{
        dic =@{@"order_id":[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"id"]],@"driver_fraction":starScore,@"note":_inputTV.text,@"driverid":[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_custid"]],@"ordertype":@"0",@"evalute_type":@"1",@"selevalueids":str1};
    }
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
        
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"提交评价%@",str);
        
        if ([str containsString:@"true"]) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                [SMAlert hide:NO];
                jxt_showToastTitle(@"提交评价成功", 1);
                _PLbutton.hidden = YES;
            });
        }else{
            jxt_showToastTitle(@"提交评价失败", 1);
            
        }
        
    }];
}
- (void)textViewDidChange:(UITextView *)textView

{
    
    if (textView.text.length == 0 )
        
    {
        
        _placeHolderLabel.text = @"请输入您的宝贵意见!";
        
    }
    
    else
        
    {
        
        _placeHolderLabel.text = @"";
        
    }
    
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
