//
//  HomeSuYunVC.m
//  BasicFramework
//
//  Created by LONG on 2018/1/30.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "HomeSuYunVC.h"
#import "HomeMapViewC.h"
#import "HomeAddNeedVC.h"
#import "WLAddNeedModel.h"
#import "HomePriceBZVC.h"
#import "WuLiuFHViewController.h"
#import "ProvinceViewController.h"
#import "TongChXiaoViewController.h"
#define TitleBlackCOLOR [UIColor colorWithRed:(51)/255.0 green:(51)/255.0 blue:(51)/255.0 alpha:1]

@interface HomeSuYunVC ()<UIScrollViewDelegate,UITextFieldDelegate,AMapSearchDelegate>
{
    UIButton *_timeBut;
    UIButton *_heftBut;
    UIButton *_yujiTimeBut;
    UITextField *_firstField;
    UITextField *_secondField;
    UITextField *_secondField1;
    UITextField *_threeField;
    UIButton *_needBut;
    UITextField *_fourField;
    UILabel *_youhuiNumer;
    UILabel *_qidianLab;
    UILabel *_zhongdianLab;

    NSMutableArray *_needArr;
    UIButton * _locationBut;
    NSString *_youhuiprice;
    NSString *_zongprice;
    NSArray *_weightArr;
    CLLocationCoordinate2D _Qlocation;//起点
    CLLocationCoordinate2D _Zlocation;//终点
    NSString *_PayUUid;
    
    NSString *_QprovinceId;
    NSString *_QcityId;
    NSString *_QareaId;
    
    NSString *_ZprovinceId;
    NSString *_ZcityId;
    NSString *_ZareaId;
    
    // 黑色的背景
    UIButton * backBtn;
    // 整个弹出框
    UIView *applyInputView;
    // TextView的输入框
    UITextField * jkTextField;
    
    NSString *_QZmileage;//两点之间的距离
    UILabel *_titleLab250;
}
@property(nonatomic,strong) UIScrollView *ScrollView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation HomeSuYunVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=checkRelease" Parameters:nil FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"余额支付状态%@",str);
        if([str rangeOfString:@"true"].location!=NSNotFound) {
            //是签约用户，可以发布订单，可以选择周结
        }else if ([str rangeOfString:@"nosign"].location!=NSNotFound){
            //非签约用户，可以发布订单，不能选择周结
        }else if ([str rangeOfString:@"false"].location!=NSNotFound){
            //是签约用户，不能发布订单，上一个周期存在未周结完的单子
            jxt_showAlertOneButton(@"提示", @"上一个周期存在未周结完的单子", @"返回", ^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            jxt_showToastTitle(@"登录状态失效，请重新登录", 1);
        }
        
    }];
    
    UIButton *qiBut = [self.view viewWithTag:3388];
    UIButton *zhongBut = [self.view viewWithTag:3389];
    
    if ((![qiBut.titleLabel.text isEqualToString:@"请选择起点"])&&(![zhongBut.titleLabel.text isEqualToString:@"请选择终点"])) {
        NSLog(@"起点：%f，%f  终点：%f，%f",_Qlocation.latitude,_Qlocation.longitude,_Zlocation.latitude,_Zlocation.longitude);
        AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
        
        navi.requireExtension = YES;
        navi.strategy = 0;
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:_Qlocation.latitude
                                               longitude:_Qlocation.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:_Zlocation.latitude
                                                    longitude:_Zlocation.longitude];
        [self.search AMapDrivingRouteSearch:navi];
        
    }
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
        _QZmileage = [NSString stringWithFormat:@"%.2f",distance/1000];
        _titleLab250.text = [NSString stringWithFormat:@"%@Km",_QZmileage];
        
    }else{
        jxt_showToastTitle(@"路线计算错误，请重新选点", 1);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huodisuyun"]];
    titleImageView.frame = CGRectMake(0, 0, 50, 20);
    self.navigationItem.titleView = titleImageView;
    
    _Qlocation = CLLocationCoordinate2DMake(0, 0);
    _Zlocation = CLLocationCoordinate2DMake(0, 0);
    
    UIButton *informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [informationCardBtn addTarget:self action:@selector(rightToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [informationCardBtn setImage:[UIImage imageNamed:@"banjiaBar"] forState:UIControlStateNormal];
    
    [informationCardBtn sizeToFit];
    UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:informationCardBtn];
    
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 22;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    UIImage *image = [UIImage imageNamed:@"形状-12"];
    _locationBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBut addTarget:self action:@selector(rightToLastViewControllerTwo) forControlEvents:UIControlEventTouchUpInside];
    [_locationBut setFrame:CGRectMake(0, 0, 120, 40)];
    [_locationBut setTitle:[user objectForKey:CITY] forState:UIControlStateNormal];
    _locationBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [_locationBut setImage:image forState:UIControlStateNormal];
    [_locationBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _locationBut.frame = CGRectMake(0, 0, size1.width+25, size1.height);
    [_locationBut setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
    [_locationBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];
    
    self.navigationItem.rightBarButtonItems  = @[informationCardItem,fixedSpaceBarButtonItem,settingBtnItem];
    
    [self.navigationItem.rightBarButtonItem setTintColor:MYColor];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataCity:) name:@"city" object:nil];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _needArr = [[NSMutableArray alloc]init];
    [self loadNewData];
    [self setWithUIview];
    [self loadNewSearchWeightOfGoods];
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
}
- (void)loadNewSearchWeightOfGoods
{
    
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=searchWeightOfGoods";
    NSDictionary* paramsname = @{@"params":[NSString stringWithFormat:@"{\"type\":\"%@\"}",@"0"]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:paramsname FinishedLogin:^(id responseObject) {
        _weightArr = [[NSArray alloc]init];
        _weightArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
    }];
    /*
     {
     "during_time" = 10;
     id = 49;
     timename = "0-20\U516c\U65a4";
     type = 0;
     },
     {
     "during_time" = 20;
     id = 50;
     timename = "20-30\U516c\U65a4";
     type = 0;
     },
     {
     "during_time" = 40;
     id = 51;
     timename = "30-50\U516c\U65a4";
     type = 0;
     }
     */
}
- (void)loadNewData{
    //
    NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=searchCarServices";
    NSDictionary* paramsname = @{@"params":[NSString stringWithFormat:@"{\"type\":\"%@\"}",@"0"]};

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:paramsname FinishedLogin:^(id responseObject) {
        
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSLog(@">>%@",Arr);
        if (Arr.count) {
            //建立模型
            for (NSDictionary*dic in Arr ) {
                WLAddNeedModel *model=[[WLAddNeedModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                if ([[NSString stringWithFormat:@"%@",model.service_price] isEqualToString:@"0"]) {
                    model.need=@"1";
                    [_needArr addObject:model];
                }else{
                    model.need=@"0";
                }
            }
        }
        
    }];
}
- (void)setWithUIview{
    
    self.ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight-NavBarHeight-115*MYWIDTH)];
    self.ScrollView.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.showsVerticalScrollIndicator = NO;
    self.ScrollView.contentSize = CGSizeMake(0, kScreenHeight);
    self.ScrollView.bounces = NO;
    self.ScrollView.delegate = self;
    [self.view addSubview:self.ScrollView];
    
    UIView *bgview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10*MYWIDTH, kScreenWidth, 318*MYWIDTH)];
    bgview1.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgview1];
    //取货时间
    UIImageView * timeimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    timeimage.image = [UIImage imageNamed:@"取货时间"];
    [bgview1 addSubview:timeimage];
    
    UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, timeimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab1.text = @"取货时间";
    titleLab1.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview1 addSubview:titleLab1];
    
    //当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    _timeBut = [[UIButton alloc]initWithFrame:CGRectMake(120*MYWIDTH, 0, bgview1.width-155*MYWIDTH, 50*MYWIDTH)];
    [_timeBut setTitle:dateTime forState:UIControlStateNormal];
    _timeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_timeBut setTitleColor:UIColorFromRGBValueValue(0x000000) forState:UIControlStateNormal];
    _timeBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_timeBut addTarget:self action:@selector(timeButClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview1 addSubview:_timeBut];
    
    UIImageView * youimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(_timeBut.right+10*MYWIDTH, 17.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
    youimage1.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage1];
    
    //起点
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 50*MYWIDTH, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian];
    
    UIImageView * greenimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian.bottom + 22*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    greenimage.image = [UIImage imageNamed:@"起点"];
    [bgview1 addSubview:greenimage];
    
    _qidianLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab1.left, xian.bottom+5*MYWIDTH, _timeBut.right-titleLab1.left, 15*MYWIDTH)];
    _qidianLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    _qidianLab.textColor = UIColorFromRGB(0x555555);
    [bgview1 addSubview:_qidianLab];
    
    UIButton *qidainBut = [[UIButton alloc]initWithFrame:CGRectMake(titleLab1.left, _qidianLab.bottom-13*MYWIDTH, _timeBut.right-titleLab1.left, 50*MYWIDTH)];
    [qidainBut setTitleColor:UIColorFromRGBValueValue(0x555555) forState:UIControlStateNormal];
    [qidainBut setTitle:@"请选择起点" forState:UIControlStateNormal];
    qidainBut.titleLabel.lineBreakMode = 0;
    qidainBut.tag = 3388;
    qidainBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [qidainBut addTarget:self action:@selector(qidainButClick:) forControlEvents:UIControlEventTouchUpInside];
    qidainBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bgview1 addSubview:qidainBut];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, qidainBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian1.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian1];
    
    UIImageView * youimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(_timeBut.right+10*MYWIDTH, xian.bottom + 24.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
    youimage2.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage2];
    //终点
    UIImageView * redimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1.bottom + 22*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    redimage.image = [UIImage imageNamed:@"终点"];
    [bgview1 addSubview:redimage];
    
    _zhongdianLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab1.left, xian1.bottom+5*MYWIDTH, _timeBut.right-titleLab1.left, 15*MYWIDTH)];
    _zhongdianLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    _zhongdianLab.textColor = UIColorFromRGB(0x555555);
    [bgview1 addSubview:_zhongdianLab];
    
    UIButton *zhongdainBut = [[UIButton alloc]initWithFrame:CGRectMake(qidainBut.left, _zhongdianLab.bottom-13*MYWIDTH, qidainBut.width, 50*MYWIDTH)];
    [zhongdainBut setTitleColor:UIColorFromRGBValueValue(0x555555) forState:UIControlStateNormal];
    [zhongdainBut setTitle:@"请选择终点" forState:UIControlStateNormal];
    zhongdainBut.titleLabel.lineBreakMode = 0;
    zhongdainBut.tag = 3399;
    zhongdainBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [zhongdainBut addTarget:self action:@selector(zhongdainButClick:) forControlEvents:UIControlEventTouchUpInside];
    zhongdainBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bgview1 addSubview:zhongdainBut];
    
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, zhongdainBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian2.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian2];
    
    UIImageView * youimage3 = [[UIImageView alloc]initWithFrame:CGRectMake(_timeBut.right+10*MYWIDTH, xian1.bottom + 24.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
    youimage3.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage3];
    
    //距离
    UIImageView * juliimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian2.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    juliimage.image = [UIImage imageNamed:@"取货时间"];
    [bgview1 addSubview:juliimage];
    
    UILabel *titleLab25 = [[UILabel alloc]initWithFrame:CGRectMake(juliimage.right+10*MYWIDTH, juliimage.top-1*MYWIDTH, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab25.text = @"起点与终点的距离";
    titleLab25.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab25.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview1 addSubview:titleLab25];
    
    _titleLab250 = [[UILabel alloc]initWithFrame:CGRectMake(120*MYWIDTH, xian2.bottom, bgview1.width-155*MYWIDTH, 50*MYWIDTH)];
    _titleLab250.text = [NSString stringWithFormat:@"%@Km",@"0"];
    _titleLab250.textColor = UIColorFromRGBValueValue(0x666666);
    _titleLab250.font = [UIFont systemFontOfSize:14*MYWIDTH];
    _titleLab250.textAlignment = NSTextAlignmentRight;
    [bgview1 addSubview:_titleLab250];
    
    UIView *xian1250 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _titleLab250.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian1250.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian1250];
    
    //重量
    UIImageView * heftimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1250.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    heftimage.image = [UIImage imageNamed:@"货物重量"];
    [bgview1 addSubview:heftimage];
    
    UILabel *titleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, heftimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab2.text = @"货物重量";
    titleLab2.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab2.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview1 addSubview:titleLab2];
    
    _heftBut = [[UIButton alloc]initWithFrame:CGRectMake(120*MYWIDTH, xian1250.bottom, _timeBut.width, 50*MYWIDTH)];
    [_heftBut setTitle:@"请选择重量" forState:UIControlStateNormal];
    _heftBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_heftBut setTitleColor:UIColorFromRGBValueValue(0x666666) forState:UIControlStateNormal];
    _heftBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_heftBut addTarget:self action:@selector(heftButClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview1 addSubview:_heftBut];
    
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1250.bottom + 50*MYWIDTH, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian3.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian3];
    
    UIImageView * youimage4 = [[UIImageView alloc]initWithFrame:CGRectMake(_timeBut.right+10*MYWIDTH, xian1250.bottom + 17.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
    youimage4.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage4];
    //预计时间
    UIImageView * yujiTimeimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian3.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    yujiTimeimage.image = [UIImage imageNamed:@"预计时间"];
    [bgview1 addSubview:yujiTimeimage];
    
    UILabel *titleLab3 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, yujiTimeimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab3.text = @"预计到达时间";
    titleLab3.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab3.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview1 addSubview:titleLab3];
    
    _yujiTimeBut = [[UIButton alloc]initWithFrame:CGRectMake(120*MYWIDTH, xian3.bottom, _timeBut.width, 50*MYWIDTH)];
    [_yujiTimeBut setTitle:@"请选择到达时间" forState:UIControlStateNormal];
    _yujiTimeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_yujiTimeBut setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    _yujiTimeBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_yujiTimeBut addTarget:self action:@selector(YujitimeButClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview1 addSubview:_yujiTimeBut];
    
    UIImageView * youimage5 = [[UIImageView alloc]initWithFrame:CGRectMake(_timeBut.right+10*MYWIDTH, xian3.bottom + 17.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
    youimage5.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage5];
    ////////////////////////////////
    UIView *bgview2 = [[UIView alloc]initWithFrame:CGRectMake(0, bgview1.bottom + 10*MYWIDTH, kScreenWidth, 192*MYWIDTH)];
    bgview2.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgview2];
    
    UIImageView * shouhuoimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    shouhuoimage.image = [UIImage imageNamed:@"收货人"];
    [bgview2 addSubview:shouhuoimage];
    
    UILabel *titleLab4 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, shouhuoimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab4.text = @"收货人姓名";
    titleLab4.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab4.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab4];
    
    
    _firstField = [[UITextField alloc]initWithFrame:CGRectMake(qidainBut.left, 0, qidainBut.width, 50*MYWIDTH)];
    _firstField.delegate = self;
    _firstField.placeholder = @"必填";
    _firstField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _firstField.textAlignment = NSTextAlignmentRight;
    _firstField.textColor = UIColorFromRGBValueValue(0x000000);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:USENAME]) {
        _firstField.text = [user objectForKey:USENAME];
    }
    [bgview2 addSubview:_firstField];
    [Command placeholderColor:_firstField str:_firstField.placeholder color:MYColor];
    
    UIView *xian4 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _firstField.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian4.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview2 addSubview:xian4];
    
    UIImageView * phoneimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian4.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    phoneimage.image = [UIImage imageNamed:@"联系电话"];
    [bgview2 addSubview:phoneimage];
    
    UILabel *titleLab5 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, phoneimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab5.text = @"收货人联系电话";
    titleLab5.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab5.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab5];
    
    _secondField = [[UITextField alloc]initWithFrame:CGRectMake(qidainBut.left, xian4.bottom, qidainBut.width, 50*MYWIDTH)];
    _secondField.delegate = self;
    _secondField.placeholder = @"必填";
    _secondField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _secondField.keyboardType = UIKeyboardTypeNumberPad;
    _secondField.textAlignment = NSTextAlignmentRight;
    _secondField.textColor = UIColorFromRGBValueValue(0x000000);
    if ([user objectForKey:USERPHONE]) {
        _secondField.text = [user objectForKey:USERPHONE];
    }
    [bgview2 addSubview:_secondField];
    [Command placeholderColor:_secondField str:_secondField.placeholder color:MYColor];
    //
    UIView *xian14 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _secondField.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian14.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview2 addSubview:xian14];
    
    UIImageView * phoneimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian14.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    phoneimage1.image = [UIImage imageNamed:@"联系电话"];
    [bgview2 addSubview:phoneimage1];
    
    UILabel *titleLab15 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, phoneimage1.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab15.text = @"发货人联系电话";
    titleLab15.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab15.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab15];
    
    _secondField1 = [[UITextField alloc]initWithFrame:CGRectMake(qidainBut.left, xian14.bottom, qidainBut.width, 50*MYWIDTH)];
    _secondField1.delegate = self;
    _secondField1.placeholder = @"必填";
    _secondField1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _secondField1.keyboardType = UIKeyboardTypeNumberPad;
    _secondField1.textAlignment = NSTextAlignmentRight;
    _secondField1.textColor = UIColorFromRGBValueValue(0x000000);
    if ([user objectForKey:USERPHONE]) {
        _secondField1.text = [user objectForKey:USERPHONE];
    }
    [bgview2 addSubview:_secondField1];
    [Command placeholderColor:_secondField1 str:_secondField1.placeholder color:MYColor];
    //
    
    UIView *xian5 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _secondField1.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian5.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview2 addSubview:xian5];
    
    UIImageView * loucengimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian5.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    loucengimage.image = [UIImage imageNamed:@"楼层"];
    [bgview2 addSubview:loucengimage];
    
    UILabel *titleLab6 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, loucengimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab6.text = @"楼层及门牌号";
    titleLab6.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab6.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab6];
    
    _threeField = [[UITextField alloc]initWithFrame:CGRectMake(qidainBut.left, xian5.bottom, qidainBut.width, 50*MYWIDTH)];
    _threeField.delegate = self;
    _threeField.placeholder = @"选填";
    _threeField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _threeField.textAlignment = NSTextAlignmentRight;
    _threeField.textColor = UIColorFromRGBValueValue(0x000000);
    [bgview2 addSubview:_threeField];
    [Command placeholderColor:_threeField str:_threeField.placeholder color:MYColor];
    
    ////////////////////////////////
    UIView *bgview3 = [[UIView alloc]initWithFrame:CGRectMake(0, bgview2.bottom + 10*MYWIDTH, kScreenWidth, 101*MYWIDTH)];
    bgview3.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgview3];
    
    UIImageView * xuqiuimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    xuqiuimage.image = [UIImage imageNamed:@"额外需求"];
    [bgview3 addSubview:xuqiuimage];
    
    UILabel *titleLab7 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, xuqiuimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab7.text = @"额外需求";
    titleLab7.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab7.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview3 addSubview:titleLab7];
    
    _needBut = [[UIButton alloc]initWithFrame:CGRectMake(120*MYWIDTH, 0, bgview1.width-155*MYWIDTH, 50*MYWIDTH)];
    [_needBut setTitle:@"是否需要搬运、回单等服务" forState:UIControlStateNormal];
    _needBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_needBut setTitleColor:MYColor forState:UIControlStateNormal];
    _needBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_needBut addTarget:self action:@selector(needButClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview3 addSubview:_needBut];
    
    UIImageView * youimage6 = [[UIImageView alloc]initWithFrame:CGRectMake(_timeBut.right+10*MYWIDTH, 17.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
    youimage6.image = [UIImage imageNamed:@"youjiantou"];
    [bgview3 addSubview:youimage6];

    UIView *xian6 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 50*MYWIDTH, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian6.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview3 addSubview:xian6];
    
    UIImageView * beizhuimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian6.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    beizhuimage.image = [UIImage imageNamed:@"发货备注"];
    [bgview3 addSubview:beizhuimage];
    
    UILabel *titleLab8 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, beizhuimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab8.text = @"发货备注";
    titleLab8.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab8.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview3 addSubview:titleLab8];
    
    _fourField = [[UITextField alloc]initWithFrame:CGRectMake(qidainBut.left, xian6.bottom, qidainBut.width, 50*MYWIDTH)];
    _fourField.delegate = self;
    _fourField.placeholder = @"填写备注";
    _fourField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _fourField.textAlignment = NSTextAlignmentRight;
    _fourField.textColor = UIColorFromRGBValueValue(0x666666);
    [bgview3 addSubview:_fourField];
    [Command placeholderColor:_fourField str:_fourField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    self.ScrollView.contentSize = CGSizeMake(0, bgview3.bottom+10*MYWIDTH);

    ////////////////////////////////////
    UIView *bgupView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bottom-115*MYWIDTH, kScreenWidth, 115*MYWIDTH)];
    bgupView.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [self.view addSubview:bgupView];
    
    UIButton *newBut = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bottom-55*MYWIDTH, kScreenWidth, 55*MYWIDTH)];
    newBut.backgroundColor = MYColor;
    [newBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBut setTitle:@"现在用车" forState:UIControlStateNormal];
    newBut.titleLabel.font = [UIFont systemFontOfSize:20*MYWIDTH];
    [newBut addTarget:self action:@selector(newButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBut];
    
    UIImageView *baiNar = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, newBut.top-55*MYWIDTH, kScreenWidth-30*MYWIDTH, 50*MYWIDTH)];
    baiNar.image = [UIImage imageNamed:@"优惠价BG"];
    baiNar.userInteractionEnabled = YES;
    [self.view addSubview:baiNar];
    
    _youhuiNumer = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, baiNar.width, baiNar.height)];
    _youhuiNumer.textColor = MYColor;
    _youhuiNumer.font = [UIFont systemFontOfSize:18*MYWIDTH];
    _youhuiNumer.text = @"优惠价 ￥0";
    _youhuiNumer.textAlignment = NSTextAlignmentCenter;
    _youhuiprice = @"0";
    [self changeTextfont:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];
    [baiNar addSubview:_youhuiNumer];
    
    UIButton *mingxiBut = [[UIButton alloc]initWithFrame:CGRectMake(baiNar.width-90*MYWIDTH, baiNar.height/2-10*MYWIDTH, 80*MYWIDTH, 20*MYWIDTH)];
    mingxiBut.backgroundColor = [UIColor whiteColor];
    [mingxiBut setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [mingxiBut setTitle:@"收费标准" forState:UIControlStateNormal];
    mingxiBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [mingxiBut addTarget:self action:@selector(mingxiButClick) forControlEvents:UIControlEventTouchUpInside];
    mingxiBut.layer.cornerRadius = mingxiBut.height*0.5;
    mingxiBut.layer.borderColor = UIColorFromRGB(0x666666).CGColor;//设置边框颜色
    mingxiBut.layer.borderWidth = 1.0f;//设置边框颜色
    [baiNar addSubview:mingxiBut];
}
- (void)mingxiButClick{
    HomePriceBZVC *priceBZ = [[HomePriceBZVC alloc]init];
    priceBZ.bzPrice = _weightArr;
    [self.navigationController pushViewController:priceBZ animated:YES];
}
- (void)needButClick{
    HomeAddNeedVC *addneed = [[HomeAddNeedVC alloc]init];
    if (_needArr.count) {
        addneed.needArr = _needArr;
    }
    [addneed setNeedBlock:^(NSMutableArray *Arr) {
        _needArr = Arr;
        float zpice = 0;
        NSString *need = @"";
        for (WLAddNeedModel *model in Arr) {
            zpice = zpice +[_zongprice floatValue]*[model.service_price floatValue];
            if ([need isEqualToString:@""]) {
                need = [NSString stringWithFormat:@"%@",model.service_name];
            }else{
                need = [NSString stringWithFormat:@"%@、%@",need,model.service_name];
            }
        }
        
        _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[_zongprice floatValue]+zpice];
        [self changeTextfont:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];
        
        _youhuiprice = [NSString stringWithFormat:@"%.2f",[_zongprice floatValue]+zpice];
        [_needBut setTitle:need forState:UIControlStateNormal];
        
    }];
    [self presentViewController:addneed animated:YES completion:nil];
}
- (void)qidainButClick:(UIButton *)but{
    HomeMapViewC *map = [[HomeMapViewC alloc]init];
    map.type = @"0";
    map.location = _Qlocation;
    map.provinceId = _QprovinceId;
    map.cityId = _QcityId;
    map.areaId = _QareaId;
    map.otherCityID = _ZcityId;
    map._provinceStr = [_qidianLab.text componentsSeparatedByString:@" "][0];
    map._cityStr = [_qidianLab.text componentsSeparatedByString:@" "][1];
    map._areaStr = [_qidianLab.text componentsSeparatedByString:@" "][2];

    [map setQidianBlock:^(NSString *strQD,CLLocationCoordinate2D location,NSString *addessStr,NSString *_provinceId,NSString *_cityId,NSString *_areaId) {
        [but setTitle:strQD forState:UIControlStateNormal];
        _QprovinceId = _provinceId;
        _QcityId = _cityId;
        _QareaId = _areaId;
        _Qlocation = location;
        _qidianLab.text = addessStr;
        but.frame = CGRectMake(_qidianLab.left, _qidianLab.bottom-5*MYWIDTH, _qidianLab.width, 50*MYWIDTH);
    }];
    [self.navigationController pushViewController:map animated:YES];
}
- (void)zhongdainButClick:(UIButton *)but{
    HomeMapViewC *map = [[HomeMapViewC alloc]init];
    map.type = @"1";
    map.location = _Zlocation;
    map.provinceId = _ZprovinceId;
    map.cityId = _ZcityId;
    map.areaId = _ZareaId;
    map.otherCityID = _QcityId;
    map._provinceStr = [_zhongdianLab.text componentsSeparatedByString:@" "][0];
    map._cityStr = [_zhongdianLab.text componentsSeparatedByString:@" "][1];
    map._areaStr = [_zhongdianLab.text componentsSeparatedByString:@" "][2];
    [map setZhongdianBlock:^(NSString *strZD,CLLocationCoordinate2D location,NSString *addessStr,NSString *_provinceId,NSString *_cityId,NSString *_areaId) {
        [but setTitle:strZD forState:UIControlStateNormal];
        _ZprovinceId = _provinceId;
        _ZcityId = _cityId;
        _ZareaId = _areaId;
        _Zlocation = location;
        _zhongdianLab.text = addessStr;
        but.frame = CGRectMake(_zhongdianLab.left, _zhongdianLab.bottom-5*MYWIDTH, _zhongdianLab.width, 50*MYWIDTH);

    }];
    [self.navigationController pushViewController:map animated:YES];
}
//改变某字符串
- (void)changeTextfont:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(location, length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14*MYWIDTH] range:NSMakeRange(location, length)];
        
        //赋值
        label.attributedText = str1;
    }
}
- (void)timeButClick:(UIButton *)but{
    __weak typeof(self) weakSelf = self;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSMutableArray *year = [[NSMutableArray alloc]init];
    [year addObject:[NSString stringWithFormat:@"%@",[formatter stringFromDate:startDate]]];

    for (int i=0; i<29; i++) {
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
        
        [year addObject:[NSString stringWithFormat:@"%@",[formatter stringFromDate:endDate]]];
        startDate = [formatter dateFromString:[formatter stringFromDate:endDate]];
    }
    NSLog(@"%@",year);
    
    NSMutableArray *day = [[NSMutableArray alloc]init];
    NSString *dayStr;
    for (int i=0; i<24; i++) {
        dayStr = [NSString stringWithFormat:@"%d点",i];
        [day addObject:dayStr];
    }
    
    NSMutableArray *hour = [[NSMutableArray alloc]init];
    NSString *hourStr;
    for (int i=0; i<6; i++) {
        hourStr = [NSString stringWithFormat:@"%d0分",i];
        [hour addObject:hourStr];
    }
    
    //    // 自定义多列字符串
    NSArray *dataSources = @[year,day,hour];
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSources defaultSelValue:weakSelf isAutoSelect:NO resultBlock:^(id selectValue) {

        NSString *hourstr = selectValue[1];
        hourstr = [hourstr substringToIndex:hourstr.length-1];
        if ([hourstr intValue]<10) {
            hourstr = [NSString stringWithFormat:@"0%@",hourstr];
        }else{
            hourstr = [NSString stringWithFormat:@"%@",hourstr];
        }
        
        NSString *minstr = selectValue[2];
        minstr = [minstr substringToIndex:minstr.length-1];
        
        NSString *timeStr = [NSString stringWithFormat:@"%@ %@:%@",selectValue[0],hourstr,minstr];
        
        //当前时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        
        if ([_yujiTimeBut.titleLabel.text isEqualToString:@"请选择到达时间"]){
            if ([self dateTimeDifferenceWithStartTime:dateTime endTime:timeStr]==0) {
                jxt_showAlertTitle(@"选择的时间需大于当前时间");
            }else{
                [but setTitle:timeStr forState:UIControlStateNormal];
            }
        }else{
            if ([self dateTimeDifferenceWithStartTime:dateTime endTime:timeStr]==0) {
                jxt_showAlertTitle(@"选择的时间需大于当前时间");
            }else if ([self dateTimeDifferenceWithStartTime:timeStr endTime:_yujiTimeBut.titleLabel.text]==0){
                jxt_showAlertTitle(@"取货时间需小于预计到达时间");
            }else{
                [but setTitle:timeStr forState:UIControlStateNormal];
            }
        }
    }];
}
- (void)YujitimeButClick:(UIButton *)but{
    __weak typeof(self) weakSelf = self;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSMutableArray *year = [[NSMutableArray alloc]init];
    [year addObject:[NSString stringWithFormat:@"%@",[formatter stringFromDate:startDate]]];
    
    for (int i=0; i<29; i++) {
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
        
        [year addObject:[NSString stringWithFormat:@"%@",[formatter stringFromDate:endDate]]];
        startDate = [formatter dateFromString:[formatter stringFromDate:endDate]];
    }
    NSLog(@"%@",year);
    
    NSMutableArray *day = [[NSMutableArray alloc]init];
    NSString *dayStr;
    for (int i=0; i<24; i++) {
        dayStr = [NSString stringWithFormat:@"%d点",i];
        [day addObject:dayStr];
    }
    
    NSMutableArray *hour = [[NSMutableArray alloc]init];
    NSString *hourStr;
    for (int i=0; i<6; i++) {
        hourStr = [NSString stringWithFormat:@"%d0分",i];
        [hour addObject:hourStr];
    }
    
    //    // 自定义多列字符串
    NSArray *dataSources = @[year,day,hour];
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSources defaultSelValue:weakSelf isAutoSelect:NO resultBlock:^(id selectValue) {
        
        NSString *hourstr = selectValue[1];
        hourstr = [hourstr substringToIndex:hourstr.length-1];
        if ([hourstr intValue]<10) {
            hourstr = [NSString stringWithFormat:@"0%@",hourstr];
        }else{
            hourstr = [NSString stringWithFormat:@"%@",hourstr];
        }
        
        NSString *minstr = selectValue[2];
        minstr = [minstr substringToIndex:minstr.length-1];
        
        NSString *timeStr = [NSString stringWithFormat:@"%@ %@:%@",selectValue[0],hourstr,minstr];
        
        //当前时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        if ([self dateTimeDifferenceWithStartTime:dateTime endTime:timeStr]==0) {
            jxt_showAlertTitle(@"选择的时间需大于当前时间");
        }else if ([self dateTimeDifferenceWithStartTime:_timeBut.titleLabel.text endTime:timeStr]==0){
            jxt_showAlertTitle(@"预计到达时间需大于取货时间");
        }else{
            [but setTitle:timeStr forState:UIControlStateNormal];
        }
    }];
}
/**
 * 开始到结束的时间差
 */
- (float)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    if (value<0) {
        value = 0;
    }
    return value / 3600;
}
- (void)heftButClick:(UIButton *)but{
    //    // 自定义多列字符串
    NSMutableArray *dataSources = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _weightArr) {
        [dataSources addObject:[dic objectForKey:@"timename"]];
    }
    __weak typeof(self) weakSelf = self;
    
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSources defaultSelValue:weakSelf isAutoSelect:NO resultBlock:^(id selectValue) {
        
        NSString *timeStr = [NSString stringWithFormat:@"%@",selectValue];
        [but setTitle:timeStr forState:UIControlStateNormal];
        
        for (NSDictionary *dic in _weightArr) {
            if ([[dic objectForKey:@"timename"] isEqualToString:selectValue]) {
                _zongprice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"during_time"]];
            }
        }
        float zpice = 0;
        for (WLAddNeedModel *model in _needArr) {
            zpice = zpice +[_zongprice floatValue]*[model.service_price floatValue];
        }
        
        _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[_zongprice floatValue]+zpice];
        [self changeTextfont:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];
        
        _youhuiprice = [NSString stringWithFormat:@"%.2f",[_zongprice floatValue]+zpice];
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
- (void)rightToLastViewController{
    WuLiuFHViewController *wuliu = [[WuLiuFHViewController alloc]init];
    [self.navigationController pushViewController:wuliu animated:YES];
}
- (void)rightToLastViewControllerTwo{
    ProvinceViewController *proVC = [[ProvinceViewController alloc]init];
    [self.navigationController pushViewController:proVC animated:YES];
}
- (void)newButClick:(UIButton *)but{
    [Command isloginRequest:^(bool str) {
        if (str) {
            [self upWithorder];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
    }];
}
//提交订单
- (void)upWithorder{
    UIButton *qiBut = [self.view viewWithTag:3388];
    UIButton *zhongBut = [self.view viewWithTag:3399];
    if ([qiBut.titleLabel.text isEqualToString:@"请选择起点"]) {
        jxt_showToastTitle(@"请选择起点", 1);
        return;
    }
    if ([zhongBut.titleLabel.text isEqualToString:@"请选择终点"]){
        jxt_showToastTitle(@"请选择起点", 1);
        return;
    }
    if ([qiBut.titleLabel.text isEqualToString:zhongBut.titleLabel.text]){
        jxt_showToastTitle(@"起点和目的地选择不能一致", 1);
        return;
    }
    if ([_heftBut.titleLabel.text isEqualToString:@"请选择重量"]){
        jxt_showToastTitle(@"请选择重量", 1);
        return;
    }
    if ([_yujiTimeBut.titleLabel.text isEqualToString:@"请选择到达时间"]){
        jxt_showToastTitle(@"请选择到达时间", 1);
        return;
    }
    if ([[Command convertNull:_firstField.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写收货人姓名", 1);
        return;
    }
    if ([[Command convertNull:_secondField.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写收货人联系电话", 1);
        return;
    }
    if ([[Command convertNull:_secondField1.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写发货人联系电话", 1);
        return;
    }
    if (![Command isMobileNumber2:[Command convertNull:_secondField.text]]) {
        jxt_showToastTitle(@"请填写正确的收货人联系电话", 1);
        return;
    }
    if (![Command isMobileNumber2:[Command convertNull:_secondField1.text]]) {
        jxt_showToastTitle(@"请填写正确的发货人联系电话", 1);
        return;
    }
    //    if ([[Command convertNull:_threeField.text] isEqualToString:@""]) {
    //        jxt_showToastTitle(@"请填写联系地址", 1);
    //        return;
    //    }
    jxt_showAlertTwoButton(@"提示", @"您确认发布订单吗？", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        
        NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=addSuyunOrder";
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setValue:@"huodi_suyun" forKey:@"table"];
        [param setValue:[NSString stringWithFormat:@"%@",_firstField.text] forKey:@"consigneename"];
        [param setValue:[NSString stringWithFormat:@"%@",_secondField.text] forKey:@"consigneephone"];
        [param setValue:[NSString stringWithFormat:@"%@",_secondField1.text] forKey:@"consignorphone"];
        [param setValue:[NSString stringWithFormat:@"%@",_threeField.text] forKey:@"floorhousenumber"];
        [param setValue:[NSString stringWithFormat:@"%@",_fourField.text] forKey:@"remarks"];
        [param setValue:[NSString stringWithFormat:@"%@",_timeBut.titleLabel.text] forKey:@"pickuptime"];
        [param setValue:[NSString stringWithFormat:@"%@",_youhuiprice] forKey:@"ordertotalprice"];
        [param setValue:[NSString stringWithFormat:@"%@",_heftBut.titleLabel.text] forKey:@"weightofgoods"];
        [param setValue:[NSString stringWithFormat:@"%@",qiBut.titleLabel.text] forKey:@"startaddress"];
        [param setValue:[NSString stringWithFormat:@"%f",_Qlocation.longitude] forKey:@"startlongitude"];
        [param setValue:[NSString stringWithFormat:@"%f",_Qlocation.latitude] forKey:@"startlatitude"];
        [param setValue:[NSString stringWithFormat:@"%@",zhongBut.titleLabel.text] forKey:@"endaddress"];
        [param setValue:[NSString stringWithFormat:@"%f",_Zlocation.longitude] forKey:@"endlongitude"];
        [param setValue:[NSString stringWithFormat:@"%f",_Zlocation.latitude] forKey:@"endlatitude"];
        [param setValue:[NSString stringWithFormat:@"%@",_yujiTimeBut.titleLabel.text] forKey:@"expectedarrivaltime"];
        [param setValue:[NSString stringWithFormat:@"%@",_QprovinceId] forKey:@"sprovinceid"];
        [param setValue:[NSString stringWithFormat:@"%@",_QcityId] forKey:@"scityid"];
        [param setValue:[NSString stringWithFormat:@"%@",_QareaId] forKey:@"scountyid"];
        [param setValue:[NSString stringWithFormat:@"%@",[_qidianLab.text stringByReplacingOccurrencesOfString:@" " withString:@","]] forKey:@"sprocitcou"];
        [param setValue:[NSString stringWithFormat:@"%@",_ZprovinceId] forKey:@"eprovinceid"];
        [param setValue:[NSString stringWithFormat:@"%@",_ZcityId] forKey:@"ecityid"];
        [param setValue:[NSString stringWithFormat:@"%@",_ZareaId] forKey:@"ecountyid"];
        [param setValue:[NSString stringWithFormat:@"%@",[_zhongdianLab.text stringByReplacingOccurrencesOfString:@" " withString:@","]] forKey:@"eprocitcou"];
        [param setValue:[NSString stringWithFormat:@"%@",_QZmileage] forKey:@"total_mileage"];
        
        NSMutableArray *proList = [[NSMutableArray alloc]init];
        if (_needArr.count) {
            for (WLAddNeedModel *model in _needArr) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setValue:@"huodi_suyun_details" forKey:@"table"];
                [dict setValue:[NSString stringWithFormat:@"%@",model.id] forKey:@"owner_service_id"];
                [dict setValue:[NSString stringWithFormat:@"%.2f",            [_zongprice floatValue]*[model.service_price floatValue]
                                ] forKey:@"owner_service_price"];
                [proList addObject:dict];
            }
        }
        [param setValue:proList forKey:@"huodi_suyun_detailsList"];
        
        NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:param]};//
        
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:KCparams FinishedLogin:^(id responseObject) {
            
            
            NSString* str = [[NSString alloc]initWithData:responseObject encoding:kCFStringEncodingUTF8];
            
            if ([str rangeOfString:@"soverstep"].location!=NSNotFound) {
                jxt_showAlertOneButton(@"提示", @"出发地超出配送范围", @"确定", ^(NSInteger buttonIndex) {
                });
            }else if ([str rangeOfString:@"eoverstep"].location!=NSNotFound){
                jxt_showAlertOneButton(@"提示", @"目的地超出配送范围", @"确定", ^(NSInteger buttonIndex) {
                });
            }
            else if ([str rangeOfString:@"false"].location!=NSNotFound){
                jxt_showAlertOneButton(@"提示", @"订单提交失败", @"确定", ^(NSInteger buttonIndex) {
                });
            }
            else{
                [self paySuccess];
                //            [self setSMAlertWithView];
                //            NSString *str1 = [str substringFromIndex:1];
                //
                //            _PayUUid = [str1 substringToIndex:str1.length-1];
            }
            NSLog(@">>%@",str);
            
            
        }];
    });
    
}
//支付方式弹框
- (void)setSMAlertWithView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, kScreenWidth-60*MYWIDTH, 240*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<2; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 80*MYWIDTH+80*MYWIDTH*i, bgview.width-60*MYWIDTH, 1)];
        xian.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
        [bgview addSubview:xian];
    }
    NSArray *imageArr = @[@"单选_选中",@"单选_未选中",@"单选_未选中"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45*MYWIDTH, 30*MYWIDTH+i*80*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr[i]];
        [bgview addSubview:imageview];
    }
    NSArray *imageArr1 = @[@"未标题-5.1",@"未标题-5.2",@"未标题-5.3"];
    for (int i=0; i<imageArr1.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/3, 25*MYWIDTH+i*80*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr1[i]];
        [bgview addSubview:imageview];
    }
    NSArray *titleArr = @[@"支付宝支付",@"微信支付",@"余额支付"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, 25*MYWIDTH+i*80*MYWIDTH, 200, 30*MYWIDTH)];
        lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        lab.textColor = UIColorFromRGBValueValue(0x333333);
        [bgview addSubview:lab];
    }
    for (int i=0; i<3; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, i*80*MYWIDTH, bgview.width, 80*MYWIDTH)];
        but.tag = 550+i;
        [but addTarget:self action:@selector(zhifuButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:but];
    }
    [SMAlert showCustomView:bgview];
    [SMAlert hideCompletion:^{
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"uuid\":\"%@\"}",_PayUUid]};
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=deleteSuyunOrder" Parameters:params FinishedLogin:^(id responseObject) {
            NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"取消订单%@",str);
        }];
    }];
}
- (void)zhifuButClicked:(UIButton *)button{
    [SMAlert hide:NO];
    
    if (button.tag == 550) {//支付宝
        jxt_showAlertTwoButton(@"提示", @"您确定使用支付宝支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            
            //[Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:_youhuiprice orderId:[NSString stringWithFormat:@"%@_%@",_PayUUid,[user objectForKey:USERID]] notice:@"2"];
            
            jxt_showAlertTitle(@"正在开发中");
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"uuid\":\"%@\"}",_PayUUid]};
            
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=deleteSuyunOrder" Parameters:params FinishedLogin:^(id responseObject) {
                NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"取消订单%@",str);
            }];
        });
        
        
    }else if (button.tag == 551){//微信支付
        jxt_showAlertTwoButton(@"提示", @"您确定使用微信支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            //[Paydetail wxname:@"货滴充值" titile:@"货滴充值" price:_youhuiprice orderId:[NSString stringWithFormat:@"%@_%@",_PayUUid,[user objectForKey:USERID]] notice:@"2"];
            jxt_showAlertTitle(@"正在开发中");
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"uuid\":\"%@\"}",_PayUUid]};
            
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=deleteSuyunOrder" Parameters:params FinishedLogin:^(id responseObject) {
                NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"取消订单%@",str);
            }];

        });
        
        
    }else if (button.tag == 552){//余额支付
        jxt_showAlertTwoButton(@"提示", @"您确定使用余额支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            //验证密码是否正确
            NSString *passwordURLStr = @"/mbtwz/logisticssendwz?action=checkZhiFuPassword";
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:passwordURLStr Parameters:nil FinishedLogin:^(id responseObject) {
                
                NSString* str = [[NSString alloc]initWithData:responseObject encoding:kCFStringEncodingUTF8];
                if ([str rangeOfString:@"false"].location!=NSNotFound) {
                    jxt_showAlertTwoButton(@"温馨提示", @"请到：个人中心-设置-安全中心-设置支付密码中进行设置", @"确定", ^(NSInteger buttonIndex) {
                        ReplacePayPswVC* vc = [[ReplacePayPswVC alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }, @"取消", ^(NSInteger buttonIndex) {
                        
                    });
                }else{
                    [self createUI];
                    [self pushApplyCase];
                }
            }];
        });
    }
    
}
#pragma mark UI的设置
-(void)createUI{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0, UIScreenW,UIScreenH);
    backBtn.backgroundColor = [UIColor cyanColor];
    backBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    backBtn.alpha = 0.2;
    [window addSubview:backBtn];
    
    
    applyInputView = [[UIView alloc]initWithFrame:CGRectMake(25*MYWIDTH, (UIScreenH-175*MYWIDTH)/2, UIScreenW-50*MYWIDTH, 175*MYWIDTH)];
    applyInputView.alpha = 0;
    applyInputView.backgroundColor = [UIColor whiteColor];
    applyInputView.layer.cornerRadius = 10.f;
    applyInputView.clipsToBounds = NO;
    [window addSubview:applyInputView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, 10*MYWIDTH, UIScreenW-40, 18*MYWIDTH)];
    title.text = @"余额支付";
    title.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    [applyInputView addSubview:title];
    
    UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(0, title.bottom+10*MYWIDTH, applyInputView.width, 1)];
    lines.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [applyInputView addSubview:lines];
    UILabel * tfLabel = [[UILabel alloc]initWithFrame:CGRectMake(24*MYWIDTH, lines.bottom+15*MYWIDTH, applyInputView.width-48*MYWIDTH, 42*MYWIDTH)];
    tfLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tfLabel.userInteractionEnabled = YES;
    [applyInputView addSubview:tfLabel];
    jkTextField = [[UITextField alloc]initWithFrame:CGRectMake(10*MYWIDTH, 8*MYWIDTH, tfLabel.width-20*MYWIDTH,30*MYWIDTH)];
    jkTextField.delegate = self;
    jkTextField.textColor = [UIColor blackColor];
    jkTextField.placeholder = @"输入支付密码";
    jkTextField.secureTextEntry = YES;
    jkTextField.textAlignment = NSTextAlignmentCenter;
    jkTextField.font = [UIFont systemFontOfSize:14.0f*MYWIDTH];
    [tfLabel addSubview:jkTextField];
    [Command placeholderColor:jkTextField str:jkTextField.placeholder color:UIColorFromRGBValueValue(0x333333)];

    CGFloat btnWidth = (applyInputView.width-60*MYWIDTH)/2;
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(20*MYWIDTH, tfLabel.bottom+25*MYWIDTH, btnWidth, 35*MYWIDTH)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    [sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundColor:MYColor];
    sureButton.layer.cornerRadius = 6.f;
    sureButton.clipsToBounds = YES;
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyInputView addSubview:sureButton];
    
    UIButton *canleButton = [[UIButton alloc]initWithFrame:CGRectMake(sureButton.right+20*MYWIDTH, tfLabel.bottom+25*MYWIDTH, btnWidth, 35*MYWIDTH)];
    [canleButton setTitle:@"取消" forState:UIControlStateNormal];
    [canleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [canleButton setBackgroundColor:UIColorFromRGB(0xCDCDCD)];
    canleButton.titleLabel.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    canleButton.layer.cornerRadius = 6.f;
    canleButton.clipsToBounds = YES;
    [canleButton addTarget:self action:@selector(canle) forControlEvents:UIControlEventTouchUpInside];
    [applyInputView addSubview:canleButton];
}
#pragma mark 取消
-(void)canle{
    [applyInputView removeFromSuperview];
    [backBtn removeFromSuperview];
}

#pragma mark 确定
-(void)sure{
    [jkTextField resignFirstResponder];
    
    if ([jkTextField.text isEqualToString:@""]) {
        jxt_showToastTitle(@"密码不能为空", 1);
    }else{
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"ordertype\":\"1\",\"zhifuprice\":\"%@\",\"uuid\":\"%@\",\"paypassword\":\"%@\"}",_youhuiprice,_PayUUid,jkTextField.text]};
        
        NSLog(@"%@",params);
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=shipperBalancePay" Parameters:params FinishedLogin:^(id responseObject) {
            NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"余额支付状态%@",str);
            if([str rangeOfString:@"true"].location!=NSNotFound) {
                [SMAlert hide:NO];
                [backBtn removeFromSuperview];
                [applyInputView removeFromSuperview];
                [self paySuccess];
            }else{
                NSString *str1 = [str substringFromIndex:1];
                
                NSString *str2 = [str1 substringToIndex:str1.length-1];
                jxt_showAlertOneButton(@"提示", str2, @"确定", ^(NSInteger buttonIndex) {
                });
            }
            
        }];
        
    }
}

#pragma mark 弹出申请框
-(void)pushApplyCase{
    
    [UIView animateWithDuration:0.36f animations:^{
        
        backBtn.alpha = 0.48;
        applyInputView.alpha = 1;
        
    }completion:^(BOOL finished) {
        
    }];
}

- (void)getLoadDataCity:(NSNotification *)notifiation{
    NSLog(@"%@",notifiation.userInfo);
    [_locationBut setTitle:[NSString stringWithFormat:@"%@",notifiation.userInfo] forState:UIControlStateNormal];
    CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _locationBut.frame = CGRectMake(0, 0, size1.width+25, size1.height);
    [_locationBut setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
    [_locationBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    
}
- (void)paySuccess{
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 230*MYWIDTH, 200*MYWIDTH)];
    imageview.userInteractionEnabled = YES;
    imageview.image = [UIImage imageNamed:@"订单提交成功"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.height/2, imageview.width, 30*MYWIDTH)];
    lab.text = @"订单提交成功";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = UIColorFromRGB(0x333333);
    [imageview addSubview:lab];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, lab.bottom+5*MYWIDTH, imageview.width, 30*MYWIDTH)];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"点击查看订单"];
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
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
- (void)fahuodanButClicked:(UIButton *)but{
    [SMAlert hide:NO];
    TongChXiaoViewController *tongch = [[TongChXiaoViewController alloc]init];
    tongch.push = @"1";
    [self.navigationController pushViewController:tongch animated:YES];
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
