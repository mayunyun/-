//
//  HomeKuaiYunVC.m
//  BasicFramework
//
//  Created by LONG on 2018/2/1.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "HomeKuaiYunVC.h"
#import "HomeKuaiYunMapVC.h"
#import "ShopPageVC.h"
#import "ChongYongViewController.h"
@interface HomeKuaiYunVC ()<UITextFieldDelegate,AMapSearchDelegate>
{
    UIButton *_yujiTimeBut;
    UIButton *_typeCarBut;
    UIButton *_goodsTypeBut;
    
    UITextField *_firstField;
    UITextField *_firstField1;
    UITextField *_secondField;
    UITextField *_threeField;

    UITextField *_nameField;
    UITextField *_phoneField;
    UITextField *_phoneField1;
    UITextField *_priceField;

    UITextField *_use_car_typeField;


    UIView *_alicteView;
    UIView *_goodsalicteView;
    UIButton *_goodsBut;
    UITextField *_goodsField;
    UIButton *_use_car_typeBut;
    NSArray *_carTypeArr;
    NSArray *_carLengthArr;
    NSArray *_carGoTypeArr;
    
    
    
    NSString *_PayUUid;

    // 黑色的背景
    UIButton * backBtn;
    // 整个弹出框
    UIView *applyInputView;
    // TextView的输入框
    UITextField * jkTextField;
    
    
    NSString *_QZmileage;//两点之间的距离
    UILabel *_titleLab250;
    
    NSString *_checkUserSign;
    
    UIImageView *_OK;
    NSString *_morenQ;
    NSString *_morenZ;
    
    NSMutableString *_carTypeStr;
    NSMutableString *_carlengthStr;
    NSString *_use_car_typeStr;
}
@property (nonatomic, strong) AMapSearchAPI *search;

@property(nonatomic,strong) UIScrollView *ScrollView;

@end

@implementation HomeKuaiYunVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkUserSign];
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=checkRelease" Parameters:nil FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
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
    
    UIButton *qiBut = [self.view viewWithTag:3368];
    UIButton *zhongBut = [self.view viewWithTag:3369];
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
    // Do any additional setup after loading the view.
    _morenQ = @"0";
    _morenZ = @"0";
    _use_car_typeStr = @"2";
    UIImageView * titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"货滴快运"]];
    titleImageView.frame = CGRectMake(0, 0, 100, 20);
    self.navigationItem.titleView = titleImageView;
    kWindow.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setWithUIview];
    [self loadNewsearchKuaiyunCartype];
    [self loadNewsearchVehicleLength];
    [self loadNewsearchKuaiyunCargotype];
    [self selectUserRelevantDef];
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}
//查询默认
- (void)selectUserRelevantDef
{
    
    NSString *url = @"/mbtwz/logisticssendwz?action=selectUserRelevantDef";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@">>%@",[dic objectForKey:@"response"][0]);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            NSArray *saddlistarr = [[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"saddlist"] ];
            NSArray *eaddlistarr = [[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"eaddlist"] ];
            NSArray *custinfoarr = [[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"custinfo"] ];
            UIButton *qiBut = [self.view viewWithTag:3368];
            UIButton *zhongBut = [self.view viewWithTag:3369];
            if (saddlistarr.count) {
                if ([[Command convertNull:_sprovince] isEqualToString:@""]) {
                    [qiBut setTitle:[saddlistarr[0] objectForKey:@"saddress"] forState:UIControlStateNormal];
                    _Qlocation = CLLocationCoordinate2DMake([[saddlistarr[0] objectForKey:@"slatitude"] floatValue], [[saddlistarr[0] objectForKey:@"slongitude"] floatValue]);
                    _sprovince = [NSString stringWithFormat:@"%@",[saddlistarr[0] objectForKey:@"sprovince"]];
                    _scity = [NSString stringWithFormat:@"%@",[saddlistarr[0] objectForKey:@"scity"]];
                    _scounty = [NSString stringWithFormat:@"%@",[saddlistarr[0] objectForKey:@"scounty"]];
                    if ([_checkUserSign isEqualToString:@"1"]) {
                        [self selectSignSetPrice];
                    }
                }
                
            }
            if (eaddlistarr.count) {
                if ([[Command convertNull:_eprovince] isEqualToString:@""]) {
                    [zhongBut setTitle:[eaddlistarr[0] objectForKey:@"eaddress"] forState:UIControlStateNormal];
                    _Zlocation = CLLocationCoordinate2DMake([[eaddlistarr[0] objectForKey:@"elatitude"] floatValue], [[eaddlistarr[0] objectForKey:@"elongitude"] floatValue]);
                    _eprovince = [NSString stringWithFormat:@"%@",[eaddlistarr[0] objectForKey:@"eprovince"]];
                    _ecity = [NSString stringWithFormat:@"%@",[eaddlistarr[0] objectForKey:@"ecity"]];
                    _ecounty = [NSString stringWithFormat:@"%@",[eaddlistarr[0] objectForKey:@"ecounty"]];
                    if ([_checkUserSign isEqualToString:@"1"]) {
                        [self selectSignSetPrice];
                    }
                }
                
            }
            if (custinfoarr.count) {
                _nameField.text = [NSString stringWithFormat:@"%@",[custinfoarr[0] objectForKey:@"name"]];
                _phoneField.text = [NSString stringWithFormat:@"%@",[custinfoarr[0] objectForKey:@"call"]];
            }
            
        }
        
    }];
    
    
    
}
- (void)loadNewsearchKuaiyunCartype
{
    //快运 车型选择 查询接口
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=searchKuaiyunCartype";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        _carTypeArr = [[NSArray alloc]init];
        _carTypeArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
    }];
}
- (void)loadNewsearchVehicleLength
{
    //快运 车长 查询接口
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=searchVehicleLength";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            _carLengthArr = [[NSArray alloc]initWithArray:[dic objectForKey:@"response"]];
        }
        
    }];
}
- (void)loadNewsearchKuaiyunCargotype
{
    //快运 货物类型 查询接口
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=searchKuaiyunCargotype";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        _carGoTypeArr = [[NSArray alloc]init];
        _carGoTypeArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
    }];
}
- (void)typeCarButClick{
    
    float w = (kScreenWidth-75*MYWIDTH)/4;
    
    _alicteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _alicteView.backgroundColor = [UIColor clearColor];
    [kWindow addSubview:_alicteView];
    
    UIView *baiBgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
    baiBgView.backgroundColor = [UIColor whiteColor];
    [_alicteView addSubview:baiBgView];
    
    UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 15*MYWIDTH, kScreenWidth, 25*MYWIDTH)];
    titleLab1.text = @"用车类型";
    titleLab1.textColor = [UIColor blackColor];
    titleLab1.textAlignment = NSTextAlignmentLeft;
    titleLab1.font = [UIFont boldSystemFontOfSize:15*MYWIDTH];
    [baiBgView addSubview:titleLab1];
    
    float dowe1 = 0;
    NSArray *arr1 = @[@"不限类型",@"整车",@"零担"];
    for (int i=0; i<arr1.count; i++) {
        UIButton *But = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH+i%4*(w+15*MYWIDTH), titleLab1.bottom + 5*MYWIDTH+i/4*40*MYWIDTH, w, 35*MYWIDTH)];
        [But setTitle:arr1[i] forState:UIControlStateNormal];
        [But setTitle:arr1[i] forState:UIControlStateSelected];
        [But setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [But setBackgroundColor:[UIColor whiteColor]];
        But.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        But.layer.cornerRadius = 3.0;
        But.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
        But.layer.borderWidth = 0.5f;//设置边框颜色
        But.tag = 3155+i;
        [But addTarget:self action:@selector(use_car_typeClick:) forControlEvents:UIControlEventTouchUpInside];
        [baiBgView addSubview:But];
        if (i==0) {
            [But setBackgroundColor:MYColor];
            But.layer.borderColor = MYColor.CGColor;
            [But setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            _use_car_typeBut = But;
        }
        if (i==arr1.count-1) {
            dowe1 = But.bottom;
        }
    }
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, dowe1+10*MYWIDTH, kScreenWidth, 5*MYWIDTH)];
    xian.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [baiBgView addSubview:xian];
    
    UILabel *titleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian.bottom+15*MYWIDTH, kScreenWidth, 25*MYWIDTH)];
    titleLab2.text = @"车长";
    titleLab2.textColor = [UIColor blackColor];
    titleLab2.textAlignment = NSTextAlignmentLeft;
    titleLab2.font = [UIFont boldSystemFontOfSize:15*MYWIDTH];
    [baiBgView addSubview:titleLab2];
    
    UILabel *titleLab21 = [[UILabel alloc]initWithFrame:CGRectMake(30, 3*MYWIDTH, kScreenWidth, 20*MYWIDTH)];
    titleLab21.text = @"(*可多选)(*必选)";
    titleLab21.textColor = UIColorFromRGB(0x666666);
    titleLab21.textAlignment = NSTextAlignmentLeft;
    titleLab21.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [titleLab2 addSubview:titleLab21];
    
    NSMutableArray *arr2 = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _carLengthArr) {
        [arr2 addObject:[dic objectForKey:@"lengthname"]];
    }
    float dowe2 = 0;
    for (int i=0; i<arr2.count; i++) {
        UIButton *But = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH+i%4*(w+15*MYWIDTH), titleLab2.bottom + 10*MYWIDTH+i/4*45*MYWIDTH, w, 35*MYWIDTH)];
        [But setTitle:[NSString stringWithFormat:@"%@",arr2[i]] forState:UIControlStateNormal];
        [But setTitle:[NSString stringWithFormat:@"%@",arr2[i]] forState:UIControlStateSelected];
        [But setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [But setBackgroundColor:[UIColor whiteColor]];
        But.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        But.layer.cornerRadius = 3.0;
        But.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
        But.layer.borderWidth = 0.5f;//设置边框颜色
        But.tag = 2155+i;
        [But addTarget:self action:@selector(ButClick:) forControlEvents:UIControlEventTouchUpInside];
        [baiBgView addSubview:But];
        
        if (i==arr2.count-1) {
            dowe2 = But.bottom;
        }
    }
    
    _use_car_typeField = [[UITextField alloc]initWithFrame:CGRectMake(15*MYWIDTH, dowe2+10*MYWIDTH, 200*MYWIDTH, 35*MYWIDTH)];
    _use_car_typeField.delegate = self;
    _use_car_typeField.placeholder = @"请输入其他车长";
    _use_car_typeField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _use_car_typeField.textAlignment = NSTextAlignmentLeft;
    _use_car_typeField.returnKeyType = UIReturnKeyDone;
    _use_car_typeField.textColor = UIColorFromRGBValueValue(0x000000);
    _use_car_typeField.layer.cornerRadius = 3.0;
    _use_car_typeField.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
    _use_car_typeField.layer.borderWidth = 0.5f;//设置边框颜色
    _use_car_typeField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    _use_car_typeField.leftViewMode = UITextFieldViewModeAlways;
    [baiBgView addSubview:_use_car_typeField];
    [Command placeholderColor:_use_car_typeField str:_use_car_typeField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, _use_car_typeField.bottom+10*MYWIDTH, kScreenWidth, 5*MYWIDTH)];
    xian1.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [baiBgView addSubview:xian1];
    
    UILabel *titleLab3 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1.bottom+15*MYWIDTH, kScreenWidth, 25*MYWIDTH)];
    titleLab3.text = @"选择车型";
    titleLab3.textColor = [UIColor blackColor];
    titleLab3.textAlignment = NSTextAlignmentLeft;
    titleLab3.font = [UIFont boldSystemFontOfSize:15*MYWIDTH];
    [baiBgView addSubview:titleLab3];
    
    UILabel *titleLab31 = [[UILabel alloc]initWithFrame:CGRectMake(60, 3*MYWIDTH, kScreenWidth, 20*MYWIDTH)];
    titleLab31.text = @"(*车型可多选)(*必选)";
    titleLab31.textColor = UIColorFromRGB(0x666666);
    titleLab31.textAlignment = NSTextAlignmentLeft;
    titleLab31.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [titleLab3 addSubview:titleLab31];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _carTypeArr) {
        [arr addObject:[dic objectForKey:@"cartypename"]];
    }
    
    
    float dowe = 0;
    for (int i=0; i<arr.count; i++) {
        UIButton *But = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH+i%4*(w+15*MYWIDTH), titleLab3.bottom + 10*MYWIDTH+i/4*45*MYWIDTH, w, 35*MYWIDTH)];
        [But setTitle:arr[i] forState:UIControlStateNormal];
        [But setTitle:arr[i] forState:UIControlStateSelected];
        [But setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [But setBackgroundColor:[UIColor whiteColor]];
        But.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        But.layer.cornerRadius = 3.0;
        But.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
        But.layer.borderWidth = 0.5f;//设置边框颜色
        But.tag = 1155+i;
        [But addTarget:self action:@selector(ButClick:) forControlEvents:UIControlEventTouchUpInside];
        [baiBgView addSubview:But];
        
        if (i==arr.count-1) {
            dowe = But.bottom;
        }
    }
    
    UIButton *cencleBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/2-107.5*MYWIDTH, dowe+20*MYWIDTH, 100*MYWIDTH, 35*MYWIDTH)];
    [cencleBut setTitle:@"取消" forState:UIControlStateNormal];
    [cencleBut setTitleColor:UIColorFromRGBValueValue(0x666666) forState:UIControlStateNormal];
    cencleBut.backgroundColor = UIColorFromRGB(0xCACACA);
    cencleBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [cencleBut addTarget:self action:@selector(cencelClick) forControlEvents:UIControlEventTouchUpInside];
    [baiBgView addSubview:cencleBut];
    
    UIButton *quedingBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/2+7.5*MYWIDTH, dowe+20*MYWIDTH, 100*MYWIDTH, 35*MYWIDTH)];
    [quedingBut setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quedingBut.backgroundColor = MYColor;
    quedingBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [quedingBut addTarget:self action:@selector(cartypeClick) forControlEvents:UIControlEventTouchUpInside];
    [baiBgView addSubview:quedingBut];
    
    baiBgView.frame = CGRectMake(0, kScreenHeight-cencleBut.bottom-20*MYWIDTH, kScreenWidth, cencleBut.bottom+20*MYWIDTH);

    UIButton *toumingBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-baiBgView.height)];
    [toumingBut addTarget:self action:@selector(cencelClick) forControlEvents:UIControlEventTouchUpInside];
    [toumingBut setBackgroundColor:[UIColor blackColor]];
    toumingBut.alpha = 0.5;
    [_alicteView addSubview:toumingBut];
}
- (void)use_car_typeClick:(UIButton *)but{
    
    NSArray *arr1 = @[@"整车",@"零担",@"不限类型"];
    for (int i=0; i<arr1.count; i++) {
        NSString *str = arr1[i];
        if ([but.titleLabel.text isEqualToString:str]) {
            _use_car_typeStr = [NSString stringWithFormat:@"%d",i];
        }
    }
    [_use_car_typeBut setBackgroundColor:[UIColor whiteColor]];
    _use_car_typeBut.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;
    [_use_car_typeBut setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [but setBackgroundColor:MYColor];
    but.layer.borderColor = MYColor.CGColor;
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _use_car_typeBut = but;
}
- (void)ButClick:(UIButton *)but{
    but.selected = !but.selected;
    if (but.selected) {
        [but setBackgroundColor:MYColor];
        but.layer.borderColor = MYColor.CGColor;
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }else{
        [but setBackgroundColor:[UIColor whiteColor]];
        but.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
}
- (void)cartypeClick{
    [_alicteView removeFromSuperview];

    _carTypeStr = [NSMutableString stringWithFormat:@"%@",@""];
    for (int i=0 ; i<_carTypeArr.count; i++) {
        UIButton *but = [_alicteView viewWithTag:1155+i];
        if (but.selected) {
            _carTypeStr = [NSMutableString stringWithFormat:@"%@,%@",_carTypeStr,[_carTypeArr[i] objectForKey:@"cartypename"]];
        }
    }
    if (_carTypeStr.length<1) {
        jxt_showToastTitle(@"请选择车型", 1);
        return;
    }
    [_carTypeStr deleteCharactersInRange:NSMakeRange(0, 1)];
    
    _carlengthStr = [NSMutableString stringWithFormat:@"%@",@""];
    for (int i=0 ; i<_carLengthArr.count; i++) {
        UIButton *but = [_alicteView viewWithTag:2155+i];
        if (but.selected) {
            _carlengthStr = [NSMutableString stringWithFormat:@"%@,%@",_carlengthStr,[_carLengthArr[i] objectForKey:@"lengthname"]];
        }
    }
    if (_carlengthStr.length<1) {
        jxt_showToastTitle(@"请选择车长", 1);
        return;
    }
    [_carlengthStr deleteCharactersInRange:NSMakeRange(0, 1)];
    if(![_use_car_typeField.text isEqualToString:@""]){
        _carlengthStr = [NSMutableString stringWithFormat:@"%@,%@",_carlengthStr,_use_car_typeField.text];
    }
    [_typeCarBut setTitle:[NSString stringWithFormat:@"%@,%@",_carlengthStr,_carTypeStr] forState:UIControlStateNormal];

}
- (void)cencelClick{
    [_alicteView removeFromSuperview];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
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
    
    UIView *bgview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10*MYWIDTH, kScreenWidth, 202*MYWIDTH)];
    bgview1.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgview1];
    
    //起点
    UIImageView * greenimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    greenimage.image = [UIImage imageNamed:@"起点"];
    [bgview1 addSubview:greenimage];
    
    UIImageView * youimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(bgview1.right-73*MYWIDTH, 17.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
    youimage1.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage1];
    
    UIButton *qidainBut = [[UIButton alloc]initWithFrame:CGRectMake(greenimage.right+10*MYWIDTH, 0, youimage1.left-greenimage.right-60*MYWIDTH, 50*MYWIDTH)];
    [qidainBut setTitleColor:UIColorFromRGBValueValue(0x000000) forState:UIControlStateNormal];
    [qidainBut setTitle:@"请选择起点" forState:UIControlStateNormal];
    qidainBut.titleLabel.lineBreakMode = 0;
    qidainBut.tag = 3368;
    if (![[Command convertNull:_sprovince] isEqualToString:@""]) {
        [qidainBut setTitle:[NSString stringWithFormat:@"%@%@%@",_sprovince,_scity,_scounty] forState:UIControlStateNormal];
    }
    qidainBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [qidainBut addTarget:self action:@selector(qidainButClick:) forControlEvents:UIControlEventTouchUpInside];
    qidainBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bgview1 addSubview:qidainBut];
    

    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, qidainBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian];
    
    UIButton *changQBut = [[UIButton alloc]initWithFrame:CGRectMake(youimage1.right+5*MYWIDTH, 0, 50*MYWIDTH, 50*MYWIDTH)];
    [changQBut setImage:[UIImage imageNamed:@"WechatIMG67"] forState:UIControlStateNormal];
    [changQBut addTarget:self action:@selector(qichangyongClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview1 addSubview:changQBut];
    //终点
    UIImageView * redimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    redimage.image = [UIImage imageNamed:@"终点"];
    [bgview1 addSubview:redimage];
    
    UIButton *zhongdainBut = [[UIButton alloc]initWithFrame:CGRectMake(qidainBut.left, xian.bottom, qidainBut.width, 50*MYWIDTH)];
    [zhongdainBut setTitleColor:UIColorFromRGBValueValue(0x000000 ) forState:UIControlStateNormal];
    [zhongdainBut setTitle:@"请选择终点" forState:UIControlStateNormal];
    zhongdainBut.titleLabel.lineBreakMode = 0;
    zhongdainBut.tag = 3369;
    if (![[Command convertNull:_eprovince] isEqualToString:@""]) {
        [zhongdainBut setTitle:[NSString stringWithFormat:@"%@%@%@",_eprovince,_ecity,_ecounty] forState:UIControlStateNormal];
    }
    zhongdainBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [zhongdainBut addTarget:self action:@selector(zhongdainButClick:) forControlEvents:UIControlEventTouchUpInside];
    zhongdainBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bgview1 addSubview:zhongdainBut];
    
//    UIView *xian256 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, zhongdainBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
//    xian256.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
//    [bgview1 addSubview:xian256];
//
//    UIButton *zhongchangyong = [[UIButton alloc]initWithFrame:CGRectMake(qidainBut.left, xian256.bottom, qidainBut.width, 50*MYWIDTH)];
//    [zhongchangyong addTarget:self action:@selector(zhongchangyongClick) forControlEvents:UIControlEventTouchUpInside];
//    [zhongchangyong setTitleColor:UIColorFromRGBValueValue(0x666666) forState:UIControlStateNormal];
//    [zhongchangyong setTitle:@"可选择常用送货终点" forState:UIControlStateNormal];
//    zhongchangyong.titleLabel.lineBreakMode = 0;
//    zhongchangyong.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
//    zhongchangyong.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [bgview1 addSubview:zhongchangyong];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, zhongdainBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian1.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian1];
    
    UIButton *changZBut = [[UIButton alloc]initWithFrame:CGRectMake(youimage1.right+5*MYWIDTH, xian.bottom, 50*MYWIDTH, 50*MYWIDTH)];
    [changZBut setImage:[UIImage imageNamed:@"WechatIMG67"] forState:UIControlStateNormal];
    [changZBut addTarget:self action:@selector(zhongchangyongClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview1 addSubview:changZBut];
    
    UIImageView * youimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(youimage1.left, xian.bottom + 17.5*MYWIDTH, youimage1.width, youimage1.height)];
    youimage2.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage2];
    
    //距离
    UIImageView * juliimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    juliimage.image = [UIImage imageNamed:@"取货时间"];
    [bgview1 addSubview:juliimage];
    
    UILabel *titleLab25 = [[UILabel alloc]initWithFrame:CGRectMake(juliimage.right+10*MYWIDTH, juliimage.top-1*MYWIDTH, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab25.text = @"起点与终点的距离";
    titleLab25.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab25.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview1 addSubview:titleLab25];
    
    _titleLab250 = [[UILabel alloc]initWithFrame:CGRectMake(120*MYWIDTH, xian1.bottom, bgview1.width-155*MYWIDTH, 50*MYWIDTH)];
    _titleLab250.text = [NSString stringWithFormat:@"%@Km",@"0"];
    _titleLab250.textColor = UIColorFromRGBValueValue(0x666666);
    _titleLab250.font = [UIFont systemFontOfSize:14*MYWIDTH];
    _titleLab250.textAlignment = NSTextAlignmentRight;
    [bgview1 addSubview:_titleLab250];
    
    UIView *xian1250 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _titleLab250.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian1250.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian1250];
    
    //预计时间
    UIImageView * yujiTimeimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1250.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    yujiTimeimage.image = [UIImage imageNamed:@"取货时间"];
    [bgview1 addSubview:yujiTimeimage];
    
    UILabel *titleLab3 = [[UILabel alloc]initWithFrame:CGRectMake(yujiTimeimage.right+10*MYWIDTH, yujiTimeimage.top-1*MYWIDTH, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab3.text = @"装车时间";
    titleLab3.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab3.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview1 addSubview:titleLab3];
    
    _yujiTimeBut = [[UIButton alloc]initWithFrame:CGRectMake(120*MYWIDTH, xian1250.bottom, bgview1.width-155*MYWIDTH, 50*MYWIDTH)];
    [_yujiTimeBut setTitle:@"请选择到达时间" forState:UIControlStateNormal];
    _yujiTimeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_yujiTimeBut setTitleColor:UIColorFromRGBValueValue(0x666666) forState:UIControlStateNormal];
    _yujiTimeBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_yujiTimeBut addTarget:self action:@selector(timeButClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview1 addSubview:_yujiTimeBut];
    
    UIImageView * youimage3 = [[UIImageView alloc]initWithFrame:CGRectMake(bgview1.right-23*MYWIDTH, xian1250.bottom + 17.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
    youimage3.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage3];
    
    //////////////////////////////////////////////////
    UIView *bgview2 = [[UIView alloc]initWithFrame:CGRectMake(0, bgview1.bottom + 10*MYWIDTH, kScreenWidth, 340*MYWIDTH)];
    bgview2.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgview2];
    
    //车型
    UIImageView * typeimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    typeimage.image = [UIImage imageNamed:@"小货车"];
    [bgview2 addSubview:typeimage];
    
    UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(typeimage.right+10*MYWIDTH, typeimage.top-1*MYWIDTH, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab1.text = @"车型";
    titleLab1.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab1];
    
    _typeCarBut = [[UIButton alloc]initWithFrame:CGRectMake(120*MYWIDTH, 0, bgview1.width-155*MYWIDTH, 50*MYWIDTH)];
    [_typeCarBut setTitle:@"请选择" forState:UIControlStateNormal];
    _typeCarBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_typeCarBut setTitleColor:UIColorFromRGBValueValue(0x000000) forState:UIControlStateNormal];
    _typeCarBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_typeCarBut addTarget:self action:@selector(typeCarButClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview2 addSubview:_typeCarBut];
    
    UIImageView * youimage4 = [[UIImageView alloc]initWithFrame:CGRectMake(_typeCarBut.right+10*MYWIDTH, 17.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
    youimage4.image = [UIImage imageNamed:@"youjiantou"];
    [bgview2 addSubview:youimage4];
    
    UIButton *_typeCarBut111 = [[UIButton alloc]initWithFrame:CGRectMake(_typeCarBut.right, 0, 50*MYWIDTH, 50*MYWIDTH)];
    [_typeCarBut111 addTarget:self action:@selector(typeCarButClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview2 addSubview:_typeCarBut111];
    
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _typeCarBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian2.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview2 addSubview:xian2];
    
    //货物类型
    UIImageView * typeimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian2.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    typeimage1.image = [UIImage imageNamed:@"货物-(1)"];
    [bgview2 addSubview:typeimage1];
    
    UILabel *titleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(typeimage1.right+10*MYWIDTH, typeimage1.top-1*MYWIDTH, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab2.text = @"货物类型";
    titleLab2.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab2.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab2];
    
    _goodsTypeBut = [[UIButton alloc]initWithFrame:CGRectMake(120*MYWIDTH, xian2.bottom, bgview1.width-155*MYWIDTH, 50*MYWIDTH)];
    [_goodsTypeBut setTitle:@"请选择" forState:UIControlStateNormal];
    _goodsTypeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_goodsTypeBut setTitleColor:UIColorFromRGBValueValue(0x000000) forState:UIControlStateNormal];
    _goodsTypeBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_goodsTypeBut addTarget:self action:@selector(goodsTypeButClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview2 addSubview:_goodsTypeBut];
    
    UIImageView * youimage5 = [[UIImageView alloc]initWithFrame:CGRectMake(_typeCarBut.right+10*MYWIDTH, xian2.bottom+17.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
    youimage5.image = [UIImage imageNamed:@"youjiantou"];
    [bgview2 addSubview:youimage5];
    
    UIButton *_goodsTypeBut111 = [[UIButton alloc]initWithFrame:CGRectMake(_goodsTypeBut.right, 0, 50*MYWIDTH, 50*MYWIDTH)];
    [_goodsTypeBut111 addTarget:self action:@selector(goodsTypeButClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview2 addSubview:_goodsTypeBut111];
    
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _goodsTypeBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian3.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview2 addSubview:xian3];
    
    //货物重量
    UIImageView * typeimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian3.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    typeimage2.image = [UIImage imageNamed:@"称重"];
    [bgview2 addSubview:typeimage2];
    
    UILabel *titleLab4 = [[UILabel alloc]initWithFrame:CGRectMake(typeimage2.right+10*MYWIDTH, typeimage2.top-1*MYWIDTH, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab4.text = @"货物重量/数量";
    titleLab4.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab4.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab4];
    
    
    UILabel *titleLab5 = [[UILabel alloc]initWithFrame:CGRectMake(typeimage2.right+20*MYWIDTH, titleLab4.bottom+20*MYWIDTH, 45*MYWIDTH, 20*MYWIDTH)];
    titleLab5.text = @"重量:";
    titleLab5.textAlignment = NSTextAlignmentLeft;
    titleLab5.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab5.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab5];
    
    _firstField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab5.right, titleLab5.top-5*MYWIDTH, 120*MYWIDTH, 30*MYWIDTH)];
    _firstField.delegate = self;
    _firstField.placeholder = @"点击输入";
    _firstField.keyboardType = UIKeyboardTypeNumberPad;
    _firstField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _firstField.textAlignment = NSTextAlignmentCenter;
    _firstField.textColor = UIColorFromRGBValueValue(0x000000);
    _firstField.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
    _firstField.layer.borderWidth = 1.0f;//设置边框颜色
    _firstField.returnKeyType = UIReturnKeyDone;
    [bgview2 addSubview:_firstField];
    [Command placeholderColor:_firstField str:_firstField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    UILabel *titleLab7 = [[UILabel alloc]initWithFrame:CGRectMake(_firstField.right, _firstField.top, 30*MYWIDTH, 30*MYWIDTH)];
    titleLab7.text = @"Kg";
    titleLab7.textAlignment = NSTextAlignmentCenter;
    titleLab7.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab7.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab7];
    
    _firstField1 = [[UITextField alloc]initWithFrame:CGRectMake(titleLab5.right, _firstField.bottom+10*MYWIDTH, 120*MYWIDTH, 30*MYWIDTH)];
    _firstField1.delegate = self;
    _firstField1.placeholder = @"点击输入";
    _firstField1.keyboardType = UIKeyboardTypeNumberPad;
    _firstField1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _firstField1.textAlignment = NSTextAlignmentCenter;
    _firstField1.textColor = UIColorFromRGBValueValue(0x000000);
    _firstField1.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
    _firstField1.layer.borderWidth = 1.0f;//设置边框颜色
    _firstField1.returnKeyType = UIReturnKeyDone;
    [bgview2 addSubview:_firstField1];
    [Command placeholderColor:_firstField1 str:_firstField1.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    UILabel *titleLab71 = [[UILabel alloc]initWithFrame:CGRectMake(_firstField1.right, _firstField1.top, 30*MYWIDTH, 30*MYWIDTH)];
    titleLab71.text = @"吨";
    titleLab71.textAlignment = NSTextAlignmentCenter;
    titleLab71.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab71.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab71];
    
    UILabel *titleLab511 = [[UILabel alloc]initWithFrame:CGRectMake(titleLab7.right, titleLab7.top+20*MYWIDTH, 105*MYWIDTH, 30*MYWIDTH)];
    titleLab511.text = @"(*至少填一项)";
    titleLab511.textAlignment = NSTextAlignmentLeft;
    titleLab511.textColor = UIColorFromRGBValueValue(0x999999);
    titleLab511.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [bgview2 addSubview:titleLab511];
    
    UILabel *titleLab512 = [[UILabel alloc]initWithFrame:CGRectMake(typeimage2.right+20*MYWIDTH, _firstField1.bottom+20*MYWIDTH, 45*MYWIDTH, 20*MYWIDTH)];
    titleLab512.text = @"数量:";
    titleLab512.textAlignment = NSTextAlignmentLeft;
    titleLab512.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab512.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab512];
    
    _secondField = [[UITextField alloc]initWithFrame:CGRectMake(_firstField.left, titleLab512.top-5*MYWIDTH, 120*MYWIDTH, 30*MYWIDTH)];
    _secondField.delegate = self;
    _secondField.placeholder = @"点击输入";
    _secondField.keyboardType = UIKeyboardTypeNumberPad;
    _secondField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _secondField.textAlignment = NSTextAlignmentCenter;
    _secondField.textColor = UIColorFromRGBValueValue(0x000000);
    _secondField.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
    _secondField.layer.borderWidth = 1.0f;//设置边框颜色
    _secondField.returnKeyType = UIReturnKeyDone;
    [bgview2 addSubview:_secondField];
    [Command placeholderColor:_secondField str:_secondField.placeholder color:UIColorFromRGBValueValue(0x666666)];
                                                                            
    UILabel *titleLab6 = [[UILabel alloc]initWithFrame:CGRectMake(titleLab7.left, _secondField.top, 30*MYWIDTH, 30*MYWIDTH)];
    titleLab6.text = @"件";
    titleLab6.textAlignment = NSTextAlignmentCenter;
    titleLab6.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab6.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab6];
    
    UILabel *titleLab611 = [[UILabel alloc]initWithFrame:CGRectMake(titleLab7.right, titleLab6.top, 85*MYWIDTH, 30*MYWIDTH)];
    titleLab611.text = @"(*选填)";
    titleLab611.textAlignment = NSTextAlignmentLeft;
    titleLab611.textColor = UIColorFromRGBValueValue(0x999999);
    titleLab611.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [bgview2 addSubview:titleLab611];
    
    
    UIView *xian4 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _secondField.bottom+15*MYWIDTH, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian4.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview2 addSubview:xian4];
    
    //备注
    UIImageView * beizhuimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian4.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    beizhuimage.image = [UIImage imageNamed:@"发货备注"];
    [bgview2 addSubview:beizhuimage];
    
    UILabel *titleLab8 = [[UILabel alloc]initWithFrame:CGRectMake(beizhuimage.right+10*MYWIDTH, beizhuimage.top-1*MYWIDTH, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab8.text = @"备注";
    titleLab8.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab8.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab8];
    
    _threeField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab8.right, xian4.bottom, bgview2.width-15*MYWIDTH-titleLab8.right, 50*MYWIDTH)];
    _threeField.delegate = self;
    _threeField.placeholder = @"点击输入";
    _threeField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _threeField.textAlignment = NSTextAlignmentRight;
    _threeField.textColor = UIColorFromRGBValueValue(0x666666);
    _threeField.returnKeyType = UIReturnKeyDone;
    [bgview2 addSubview:_threeField];
    [Command placeholderColor:_threeField str:_threeField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    
    //////////////////////////////////
    UIView *bgview3 = [[UIView alloc]initWithFrame:CGRectMake(0, bgview2.bottom + 10*MYWIDTH, kScreenWidth, 202*MYWIDTH)];
    bgview3.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgview3];
    
//    UIImageView * shouhuoimage123 = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
//    shouhuoimage123.image = [UIImage imageNamed:@"收货人"];
//    [bgview3 addSubview:shouhuoimage123];
//
//    UIButton *chongyongshouhuorenBut = [[UIButton alloc]initWithFrame:CGRectMake(greenimage.right+10*MYWIDTH, 0, youimage1.left-greenimage.right-10*MYWIDTH, 50*MYWIDTH)];
//    [chongyongshouhuorenBut setTitleColor:UIColorFromRGBValueValue(0x000000) forState:UIControlStateNormal];
//    [chongyongshouhuorenBut setTitle:@"选择常用收货人" forState:UIControlStateNormal];
//    chongyongshouhuorenBut.titleLabel.lineBreakMode = 0;
//    chongyongshouhuorenBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
//    [chongyongshouhuorenBut addTarget:self action:@selector(chongyongshouhuorenButClick) forControlEvents:UIControlEventTouchUpInside];
//    chongyongshouhuorenBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [bgview3 addSubview:chongyongshouhuorenBut];
//
//    UIImageView * youimage456 = [[UIImageView alloc]initWithFrame:CGRectMake(_typeCarBut.right+10*MYWIDTH, 17.5*MYWIDTH, 8*MYWIDTH, 15*MYWIDTH)];
//    youimage456.image = [UIImage imageNamed:@"youjiantou"];
//    [bgview3 addSubview:youimage456];
//
//    UIView *xian56 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, chongyongshouhuorenBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
//    xian56.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
//    [bgview3 addSubview:xian56];
    
    UIImageView * shouhuoimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH,  16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    shouhuoimage.image = [UIImage imageNamed:@"收货人"];
    [bgview3 addSubview:shouhuoimage];
    
    UILabel *titleLab9 = [[UILabel alloc]initWithFrame:CGRectMake(shouhuoimage.right+10*MYWIDTH, shouhuoimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab9.text = @"收货人姓名";
    titleLab9.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab9.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview3 addSubview:titleLab9];
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab9.right, 0, bgview3.width-15*MYWIDTH-titleLab9.right-50*MYWIDTH, 50*MYWIDTH)];
    _nameField.delegate = self;
    _nameField.placeholder = @"选填";
    _nameField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _nameField.textAlignment = NSTextAlignmentRight;
    _nameField.textColor = UIColorFromRGBValueValue(0x000000);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    if ([user objectForKey:USENAME]) {
//        _nameField.text = [user objectForKey:USENAME];
//    }
    [bgview3 addSubview:_nameField];
    [Command placeholderColor:_nameField str:_nameField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    UIButton *changBut = [[UIButton alloc]initWithFrame:CGRectMake(_nameField.right+5*MYWIDTH, 0, 50*MYWIDTH, 50*MYWIDTH)];
    [changBut setImage:[UIImage imageNamed:@"WechatIMG67"] forState:UIControlStateNormal];
    [changBut addTarget:self action:@selector(chongyongshouhuorenButClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview3 addSubview:changBut];
    
    UIView *xian5 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _nameField.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian5.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview3 addSubview:xian5];
    
    UIImageView * phoneimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian5.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    phoneimage.image = [UIImage imageNamed:@"联系电话"];
    [bgview3 addSubview:phoneimage];
    
    UILabel *titleLab10 = [[UILabel alloc]initWithFrame:CGRectMake(phoneimage.right+10*MYWIDTH, phoneimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab10.text = @"收货人联系电话";
    titleLab10.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab10.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview3 addSubview:titleLab10];
    
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab10.right, xian5.bottom, bgview3.width-15*MYWIDTH-titleLab9.right, 50*MYWIDTH)];
    _phoneField.delegate = self;
    _phoneField.placeholder = @"选填";
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _phoneField.textAlignment = NSTextAlignmentRight;
    _phoneField.textColor = UIColorFromRGBValueValue(0x000000);
//    if ([user objectForKey:USERPHONE]) {
//        _phoneField.text = [user objectForKey:USERPHONE];
//    }
    [bgview3 addSubview:_phoneField];
    [Command placeholderColor:_phoneField str:_phoneField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    //
    UIView *xian2567 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _phoneField.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian2567.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview3 addSubview:xian2567];
    
    UIImageView *duihao = [[UIImageView alloc]initWithFrame:CGRectMake(14*MYWIDTH, xian2567.bottom +17*MYWIDTH, 16*MYWIDTH, 16*MYWIDTH)];
    duihao.image = [UIImage imageNamed:@"shehzimoren"];
    [bgview3 addSubview:duihao];
    
    _OK = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian2567.bottom + 16*MYWIDTH, 20*MYWIDTH, 17*MYWIDTH)];
    _OK.image = [UIImage imageNamed:@"duihaohou"];
    _OK.hidden = YES;
    [bgview3 addSubview:_OK];
    
    UIButton *changyong = [[UIButton alloc]initWithFrame:CGRectMake(0, xian2567.bottom, bgview3.width, 50*MYWIDTH)];
    [changyong addTarget:self action:@selector(changyongClick) forControlEvents:UIControlEventTouchUpInside];
    [changyong setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [changyong setTitle:@"           保存为常用联系人" forState:UIControlStateNormal];
    changyong.titleLabel.lineBreakMode = 0;
    changyong.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    changyong.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bgview3 addSubview:changyong];

    //
    UIView *xian15 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, changyong.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian15.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview3 addSubview:xian15];
    
    UIImageView * phoneimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian15.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    phoneimage1.image = [UIImage imageNamed:@"联系电话"];
    [bgview3 addSubview:phoneimage1];
    
    UILabel *titleLab101 = [[UILabel alloc]initWithFrame:CGRectMake(phoneimage1.right+10*MYWIDTH, phoneimage1.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab101.text = @"发货人联系电话";
    titleLab101.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab101.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview3 addSubview:titleLab101];
    
    _phoneField1 = [[UITextField alloc]initWithFrame:CGRectMake(titleLab101.right, xian15.bottom, _phoneField.width, 50*MYWIDTH)];
    _phoneField1.delegate = self;
    _phoneField1.placeholder = @"填写发货人联系人电话";
    _phoneField1.keyboardType = UIKeyboardTypeNumberPad;
    _phoneField1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _phoneField1.textAlignment = NSTextAlignmentRight;
    _phoneField1.textColor = UIColorFromRGBValueValue(0x000000);
    if ([user objectForKey:USERPHONE]) {
        _phoneField1.text = [user objectForKey:USERPHONE];
    }
    [bgview3 addSubview:_phoneField1];
    [Command placeholderColor:_phoneField1 str:_phoneField1.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
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
    
    UILabel *titleLab11 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 100*MYWIDTH, baiNar.height)];
    titleLab11.text = @"设定金额";
    titleLab11.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab11.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [baiNar addSubview:titleLab11];
    
    UILabel *titleLab12 = [[UILabel alloc]initWithFrame:CGRectMake(baiNar.width-30*MYWIDTH, 0, 30*MYWIDTH, baiNar.height-3*MYWIDTH)];
    titleLab12.text = @"元";
    titleLab12.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab12.textAlignment = NSTextAlignmentCenter;
    titleLab12.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [baiNar addSubview:titleLab12];
    
    _priceField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab11.right, 0, titleLab12.left-titleLab11.right, baiNar.height)];
    _priceField.delegate = self;
    _priceField.placeholder = @"点击输入";
    _priceField.keyboardType = UIKeyboardTypeNumberPad;
    _priceField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _priceField.textAlignment = NSTextAlignmentRight;
    _priceField.textColor = MYColor;
    [baiNar addSubview:_priceField];
    [Command placeholderColor:_priceField str:_priceField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
}

- (void)qichangyongClick{
    UIButton *qiBut = [self.view viewWithTag:3368];
    ChongYongViewController *chang = [[ChongYongViewController alloc]init];
    chang.pushtype = @"2";
    [chang setMorenqiBlock:^(NSString *strQD, CLLocationCoordinate2D location, NSString *sprovince, NSString *scity, NSString *scounty) {
        [qiBut setTitle:strQD forState:UIControlStateNormal];
        _Qlocation = location;
        _sprovince = sprovince;
        _scity = scity;
        _scounty = scounty;
        if ([_checkUserSign isEqualToString:@"1"]) {
            [self selectSignSetPrice];
        }
    }];
    [self.navigationController pushViewController:chang animated:YES];
}
- (void)zhongchangyongClick{
    UIButton *zhongBut = [self.view viewWithTag:3369];
    ChongYongViewController *chang = [[ChongYongViewController alloc]init];
    chang.pushtype = @"3";
    [chang setMorenzhongBlock:^(NSString *strZD, CLLocationCoordinate2D location, NSString *eprovince, NSString *ecity, NSString *ecounty) {
        [zhongBut setTitle:strZD forState:UIControlStateNormal];
        _Zlocation = location;
        _eprovince = eprovince;
        _ecity = ecity;
        _ecounty = ecounty;
        if ([_checkUserSign isEqualToString:@"1"]) {
            [self selectSignSetPrice];
        }
    }];
    [self.navigationController pushViewController:chang animated:YES];
}
- (void)chongyongshouhuorenButClick{
    ChongYongViewController *chang = [[ChongYongViewController alloc]init];
    chang.pushtype = @"1";
    [chang setMorenshouhuorenBlock:^(NSString *name, NSString *phone) {
        _nameField.text = name;
        _phoneField.text = phone;
    }];
    [self.navigationController pushViewController:chang animated:YES];
}
- (void)changyongClick{//保存为常用联系人
    if (_OK.hidden) {
        
        if ([[Command convertNull:_nameField.text] isEqualToString:@""]) {
             jxt_showToastTitle(@"请填写收货人姓名", 1);
            return;
        }
        if ([[Command convertNull:_phoneField.text] isEqualToString:@""]) {
          jxt_showToastTitle(@"请填写收货人联系电话", 1);
            return;
        }
        _OK.hidden = NO;
    }else{
        _OK.hidden = YES;
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
        if ([self dateTimeDifferenceWithStartTime:dateTime endTime:timeStr]==0) {
            jxt_showAlertTitle(@"选择的时间需大于当前时间");
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
- (void)qidainButClick:(UIButton *)but{
    HomeKuaiYunMapVC *map = [[HomeKuaiYunMapVC alloc]init];
    map.type = @"0";
    map.location = _Qlocation;
    [map setQidianBlock:^(NSString *strQD,CLLocationCoordinate2D location,NSString* sprovince,NSString* scity,NSString* scounty,NSString*moreQ) {
        [but setTitle:strQD forState:UIControlStateNormal];
        _Qlocation = location;
        _sprovince = sprovince;
        _scity = scity;
        _scounty = scounty;
        _morenQ = moreQ;
        if ([_checkUserSign isEqualToString:@"1"]) {
            [self selectSignSetPrice];
        }
    }];
    [self.navigationController pushViewController:map animated:YES];
}
- (void)zhongdainButClick:(UIButton *)but{
    HomeKuaiYunMapVC *map = [[HomeKuaiYunMapVC alloc]init];
    map.type = @"1";
    map.location = _Zlocation;
    [map setZhongdianBlock:^(NSString *strZD,CLLocationCoordinate2D location,NSString* eprovince,NSString* ecity,NSString* ecounty,NSString*moreZ) {
        [but setTitle:strZD forState:UIControlStateNormal];
        _Zlocation = location;
        _eprovince = eprovince;
        _ecity = ecity;
        _ecounty = ecounty;
        _morenZ = moreZ;
        if ([_checkUserSign isEqualToString:@"1"]) {
            [self selectSignSetPrice];
        }

    }];
    [self.navigationController pushViewController:map animated:YES];
}
//货物类型弹框
- (void)goodsTypeButClick{
    _goodsalicteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _goodsalicteView.backgroundColor = [UIColor clearColor];
    [kWindow addSubview:_goodsalicteView];
    
    UIView *baiBgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
    baiBgView.backgroundColor = [UIColor whiteColor];
    [_goodsalicteView addSubview:baiBgView];
    
    UIButton *cencleBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60*MYWIDTH, 50*MYWIDTH)];
    [cencleBut setTitle:@"取消" forState:UIControlStateNormal];
    [cencleBut setTitleColor:UIColorFromRGBValueValue(0x666666) forState:UIControlStateNormal];
    cencleBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [cencleBut addTarget:self action:@selector(goodsCencelClick) forControlEvents:UIControlEventTouchUpInside];
    [baiBgView addSubview:cencleBut];
    
    UIButton *quedingBut = [[UIButton alloc]initWithFrame:CGRectMake(baiBgView.width-60*MYWIDTH, 0, 60*MYWIDTH, 50*MYWIDTH)];
    [quedingBut setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBut setTitleColor:MYColor forState:UIControlStateNormal];
    quedingBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [quedingBut addTarget:self action:@selector(CargoodsTypeClick) forControlEvents:UIControlEventTouchUpInside];
    [baiBgView addSubview:quedingBut];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50*MYWIDTH)];
    titleLab.text = @"货物类型";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    [baiBgView addSubview:titleLab];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 50*MYWIDTH, kScreenWidth, 1)];
    xian.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [baiBgView addSubview:xian];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _carGoTypeArr) {
        [arr addObject:[dic objectForKey:@"cargotypename"]];
    }
    
    float w = (kScreenWidth-75*MYWIDTH)/4;
    float dowe = 0;
    for (int i=0; i<arr.count; i++) {
        UIButton *But = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH+i%4*(w+15*MYWIDTH), xian.bottom + 30*MYWIDTH+i/4*75*MYWIDTH, w, 45*MYWIDTH)];
        [But setTitle:arr[i] forState:UIControlStateNormal];
        [But setTitle:arr[i] forState:UIControlStateSelected];
        [But setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [But setBackgroundColor:[UIColor whiteColor]];
        But.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        But.layer.cornerRadius = 3.0;
        But.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
        But.layer.borderWidth = 0.5f;//设置边框颜色
        But.tag = 1255+i;
        [But addTarget:self action:@selector(goodsButClick:) forControlEvents:UIControlEventTouchUpInside];
        [baiBgView addSubview:But];
        
        if (i==arr.count-1) {
            dowe = But.bottom;
        }
    }
    
    UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, dowe, 80*MYWIDTH, 70*MYWIDTH)];
    titleLab1.text = @"其他类型:";
    titleLab1.textColor = UIColorFromRGBValueValue(0x000000);
    titleLab1.textAlignment = NSTextAlignmentLeft;
    titleLab1.font = [UIFont systemFontOfSize:15*MYWIDTH];
    [baiBgView addSubview:titleLab1];
    
    _goodsField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab1.right, dowe+10*MYWIDTH, baiBgView.width-15*MYWIDTH-titleLab1.right, 50*MYWIDTH)];
    _goodsField.delegate = self;
    _goodsField.placeholder = @"最多输入四个字";
    _goodsField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _goodsField.textAlignment = NSTextAlignmentRight;
    _goodsField.returnKeyType = UIReturnKeyDone;
    _goodsField.textColor = UIColorFromRGBValueValue(0x000000);
    [baiBgView addSubview:_goodsField];
    [Command placeholderColor:_goodsField str:_goodsField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    baiBgView.frame = CGRectMake(0, kScreenHeight-titleLab1.bottom, kScreenWidth, titleLab1.bottom);
    
    UIButton *toumingBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-baiBgView.height)];
    [toumingBut addTarget:self action:@selector(goodsCencelClick) forControlEvents:UIControlEventTouchUpInside];
    [toumingBut setBackgroundColor:[UIColor blackColor]];
    toumingBut.alpha = 0.5;
    [_goodsalicteView addSubview:toumingBut];
}
- (void)CargoodsTypeClick{
    [_goodsalicteView removeFromSuperview];
    if(![_goodsField.text isEqualToString:@""]){
        if (_goodsField.text.length>4) {
            jxt_showAlertTitle(@"最多输入四个字");
            return;
        }
        [_goodsTypeBut setTitle:_goodsField.text forState:UIControlStateNormal];

    }else{
        [_goodsTypeBut setTitle:_goodsBut.titleLabel.text forState:UIControlStateNormal];
    }
    
}
- (void)goodsButClick:(UIButton *)but{
    
    _goodsField.text = @"";
    [_goodsBut setBackgroundColor:[UIColor whiteColor]];
    _goodsBut.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;
    [_goodsBut setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [but setBackgroundColor:MYColor];
    but.layer.borderColor = MYColor.CGColor;
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _goodsBut = but;
}
- (void)checkUserSign{
    NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=checkUserSign";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:nil FinishedLogin:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的信息%@  %@",dic,[dic objectForKey:@"msg"]);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            _checkUserSign = @"1";
        }
        
        
    }];
}
- (void)selectSignSetPrice{
    
    
    
    if ([[Command convertNull:_sprovince] isEqualToString:@""]||[[Command convertNull:_scity] isEqualToString:@""]||[[Command convertNull:_eprovince] isEqualToString:@""]||[[Command convertNull:_ecity] isEqualToString:@""]||[[Command convertNull:_ecounty] isEqualToString:@""]||[[Command convertNull:_secondField.text] isEqualToString:@""]||([[Command convertNull:_firstField.text] isEqualToString:@""]&&[[Command convertNull:_firstField1.text] isEqualToString:@""])) {
        _priceField.text = @"";
        return;
    }
    NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=selectSignSetPrice";
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:[NSString stringWithFormat:@"%@",_sprovince] forKey:@"provice_name"];
    [param setValue:[NSString stringWithFormat:@"%@",_scity] forKey:@"city_name"];
    [param setValue:[NSString stringWithFormat:@"%@",_eprovince] forKey:@"to_provice_name"];
    [param setValue:[NSString stringWithFormat:@"%@",_ecity] forKey:@"to_city_name"];
    [param setValue:[NSString stringWithFormat:@"%@",_ecounty] forKey:@"to_area_name"];
    [param setValue:[NSString stringWithFormat:@"%@",_secondField.text] forKey:@"volume"];
    [param setValue:[NSString stringWithFormat:@"%@",_firstField.text] forKey:@"weight"];
    [param setValue:[NSString stringWithFormat:@"%@",_firstField1.text] forKey:@"ton_weight"];

    NSLog(@"%@",param);

    NSDictionary* KCparams = @{@"params":[Command dictionaryToJson:param]};//

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:KCparams FinishedLogin:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            _priceField.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"response"][0] objectForKey:@"price"]];
        }
        
        
    }];

}
- (void)newButClick:(UIButton *)but{
    UIButton *qiBut = [self.view viewWithTag:3368];
    UIButton *zhongBut = [self.view viewWithTag:3369];
    if ([qiBut.titleLabel.text isEqualToString:@"请选择起点"]) {
        jxt_showToastTitle(@"请选择起点", 1);
        return;
    }
    if ([zhongBut.titleLabel.text isEqualToString:@"请选择终点"]){
        jxt_showToastTitle(@"请选择终点", 1);
        return;
    }
//    if ([qiBut.titleLabel.text isEqualToString:zhongBut.titleLabel.text]){
//        jxt_showToastTitle(@"起点和目的地选择不能一致", 1);
//        return;
//    }
    if ([_yujiTimeBut.titleLabel.text isEqualToString:@"请选择到达时间"]){
        jxt_showToastTitle(@"请选择到达时间", 1);
        return;
    }
    
    if ([_typeCarBut.titleLabel.text isEqualToString:@"请选择"]){
        jxt_showToastTitle(@"请选择车型", 1);
        return;
    }
    if ([_goodsTypeBut.titleLabel.text isEqualToString:@"请选择"]){
        jxt_showToastTitle(@"请选择货物类型", 1);
        return;
    }
    if ([[Command convertNull:_firstField.text] isEqualToString:@""]&&[[Command convertNull:_firstField1.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写货物重量", 1);
        return;
    }
//    if ([[Command convertNull:_secondField.text] isEqualToString:@""]) {
//        jxt_showToastTitle(@"请填写货物数量", 1);
//        return;
//    }
//    if ([[Command convertNull:_nameField.text] isEqualToString:@""]) {
//        jxt_showToastTitle(@"请填写收货人姓名", 1);
//        return;
//    }
//    if ([[Command convertNull:_phoneField.text] isEqualToString:@""]) {
//        jxt_showToastTitle(@"请填写收货人联系电话", 1);
//        return;
//    }
//    if (![Command isMobileNumber2:[Command convertNull:_phoneField.text]]) {
//        jxt_showToastTitle(@"请填写正确的收货人联系电话", 1);
//        return;
//    }
    if ([[Command convertNull:_phoneField1.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写发货人联系电话", 1);
        return;
    }
    if (![Command isMobileNumber2:[Command convertNull:_phoneField1.text]]) {
        jxt_showToastTitle(@"请填写正确的发货人联系电话", 1);
        return;
    }
//    if ([[Command convertNull:_priceField.text] isEqualToString:@""]) {
//        jxt_showToastTitle(@"请填写设定金额", 1);
//        return;
//    }
    NSString *relevant_type;
    if (_OK.hidden&&[_morenQ isEqualToString:@"0"]&&[_morenZ isEqualToString:@"0"]) {
        relevant_type = @"0";
    }else if (!_OK.hidden&&[_morenQ isEqualToString:@"0"]&&[_morenZ isEqualToString:@"0"]){
        relevant_type = @"1";
    }else if (_OK.hidden&&[_morenQ isEqualToString:@"1"]&&[_morenZ isEqualToString:@"0"]){
        relevant_type = @"2";
    }else if (_OK.hidden&&[_morenQ isEqualToString:@"0"]&&[_morenZ isEqualToString:@"1"]){
        relevant_type = @"3";
    }else if (!_OK.hidden&&[_morenQ isEqualToString:@"1"]&&[_morenZ isEqualToString:@"0"]){
        relevant_type = @"4";
    }else if (!_OK.hidden&&[_morenQ isEqualToString:@"0"]&&[_morenZ isEqualToString:@"1"]){
        relevant_type = @"5";
    }else if (_OK.hidden&&[_morenQ isEqualToString:@"1"]&&[_morenZ isEqualToString:@"1"]){
        relevant_type = @"6";
    }else if (!_OK.hidden&&[_morenQ isEqualToString:@"1"]&&[_morenZ isEqualToString:@"1"]){
        relevant_type = @"7";
    }
    jxt_showAlertTwoButton(@"提示", @"您确认发布订单吗？", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=addKuaiyunOrder_by_rele";
        if ([self.type isEqualToString:@"1"]) {
            XWURLStr = @"/mbtwz/freeride?action=addKuaiyunOrderByFreeRide";
        }
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setValue:relevant_type forKey:@"relevant_type"];
        [param setValue:@"huodi_kuaiyun" forKey:@"table"];
        [param setValue:[NSString stringWithFormat:@"%@",[Command convertNull:_nameField.text]] forKey:@"contactname"];
        [param setValue:[NSString stringWithFormat:@"%@",[Command convertNull:_phoneField.text]] forKey:@"contactphone"];
        [param setValue:[NSString stringWithFormat:@"%@",_phoneField1.text] forKey:@"consignorphone"];
        [param setValue:[NSString stringWithFormat:@"%@",qiBut.titleLabel.text] forKey:@"startaddress"];
        [param setValue:[NSString stringWithFormat:@"%f",_Qlocation.longitude] forKey:@"startlongitude"];
        [param setValue:[NSString stringWithFormat:@"%f",_Qlocation.latitude] forKey:@"startlatitude"];
        [param setValue:[NSString stringWithFormat:@"%@",zhongBut.titleLabel.text] forKey:@"endaddress"];
        [param setValue:[NSString stringWithFormat:@"%f",_Zlocation.longitude] forKey:@"endlongitude"];
        [param setValue:[NSString stringWithFormat:@"%f",_Zlocation.latitude] forKey:@"endlatitude"];
        [param setValue:[NSString stringWithFormat:@"%@",_yujiTimeBut.titleLabel.text] forKey:@"shipmenttime"];
        [param setValue:_use_car_typeStr forKey:@"use_car_type"];
        [param setValue:_carTypeStr forKey:@"cartypenames"];
        [param setValue:_carlengthStr forKey:@"lengthname"];

        [param setValue:[NSString stringWithFormat:@"%@",_goodsTypeBut.titleLabel.text] forKey:@"cargotypenames"];
        [param setValue:[NSString stringWithFormat:@"%@",_sprovince] forKey:@"sprovince"];
        [param setValue:[NSString stringWithFormat:@"%@",_scity] forKey:@"scity"];
        [param setValue:[NSString stringWithFormat:@"%@",_scounty] forKey:@"scounty"];
        [param setValue:[NSString stringWithFormat:@"%@",_eprovince] forKey:@"eprovince"];
        [param setValue:[NSString stringWithFormat:@"%@",_ecity] forKey:@"ecity"];
        [param setValue:[NSString stringWithFormat:@"%@",_ecounty] forKey:@"ecounty"];
        
        if ([self.type isEqualToString:@"1"]) {
            [param setValue:self.idStr forKey:@"selFreeRideId"];//顺风车ID
        }
        
        if ([[Command convertNull:_firstField.text] isEqualToString:@""]) {
            [param setValue:[NSString stringWithFormat:@"%@",@"0"] forKey:@"weight"];
            [param setValue:[NSString stringWithFormat:@"%@",_secondField.text] forKey:@"volume"];
        }else if([[Command convertNull:_secondField.text] isEqualToString:@""]){
            [param setValue:[NSString stringWithFormat:@"%@",_firstField.text] forKey:@"weight"];
            [param setValue:[NSString stringWithFormat:@"%@",@"0"] forKey:@"volume"];
        }else{
            [param setValue:[NSString stringWithFormat:@"%@",_firstField.text] forKey:@"weight"];
            [param setValue:[NSString stringWithFormat:@"%@",_secondField.text] forKey:@"volume"];
            
        }
        [param setValue:[NSString stringWithFormat:@"%@",_threeField.text] forKey:@"remarks"];
        if ([[Command convertNull:_priceField.text] isEqualToString:@""]) {
            [param setValue:@"0" forKey:@"settheprice"];
        }else{
            [param setValue:[NSString stringWithFormat:@"%@",_priceField.text] forKey:@"settheprice"];
        }
        if ([[Command convertNull:_firstField1.text] isEqualToString:@""]) {
            [param setValue:@"0" forKey:@"ton_weight"];
        }else{
            [param setValue:[NSString stringWithFormat:@"%@",_firstField1.text] forKey:@"ton_weight"];
        }
        [param setValue:[NSString stringWithFormat:@"%@",_QZmileage] forKey:@"total_mileage"];
        
        NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:param]};//
        
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:KCparams FinishedLogin:^(id responseObject) {
            
            
            NSString* str = [[NSString alloc]initWithData:responseObject encoding:kCFStringEncodingUTF8];
            
            if ([str rangeOfString:@"false"].location!=NSNotFound) {
                jxt_showAlertOneButton(@"提示", @"订单提交失败", @"确定", ^(NSInteger buttonIndex) {
                });
            }else{
//                [self setSMAlertWithView];
//                if (str.length>0) {
//                    NSString *str1 = [str substringFromIndex:1];
//                    _PayUUid = [str1 substringToIndex:str1.length-1];
//                }
                [self paySuccess];
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
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=deleteKuaiyunOrder" Parameters:params FinishedLogin:^(id responseObject) {
            NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"取消订单%@",str);
        }];
    }];
}
- (void)zhifuButClicked:(UIButton *)button{
    [SMAlert hide:NO];

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (button.tag == 550) {//支付宝
        jxt_showAlertTwoButton(@"提示", @"您确定使用支付宝支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            
            //[Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:_youhuiprice orderId:[NSString stringWithFormat:@"%@_%@",_PayUUid,[user objectForKey:USERID]] notice:@"2"];
            
            jxt_showAlertTitle(@"正在开发中");
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"uuid\":\"%@\"}",_PayUUid]};
            
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=deleteKuaiyunOrder" Parameters:params FinishedLogin:^(id responseObject) {
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
            
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=deleteKuaiyunOrder" Parameters:params FinishedLogin:^(id responseObject) {
                NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"取消订单%@",str);
            }];
        });
        
        
    }else if (button.tag == 552){//余额支付
        jxt_showAlertTwoButton(@"提示", @"您确定使用余额支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            //验证密码
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
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"ordertype\":\"2\",\"zhifuprice\":\"%@\",\"uuid\":\"%@\",\"paypassword\":\"%@\"}",_priceField.text,_PayUUid,jkTextField.text]};
        
        NSLog(@"%@",params);
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=shipperBalancePay" Parameters:params FinishedLogin:^(id responseObject) {
            NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            
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



- (void)goodsCencelClick{
    [_goodsalicteView removeFromSuperview];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_firstField||textField==_firstField1||textField==_secondField) {
        if ([_checkUserSign isEqualToString:@"1"]) {
            [self selectSignSetPrice];
        }
        
    }
    return [textField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==_firstField||textField==_firstField1||textField==_secondField) {
        
        return YES;
    }
    
    return YES;
}
//以下两个代理方法可以防止键盘遮挡textview
-(void)textFieldDidBeginEditing:(UITextField *)textField{

    
    [UIView animateWithDuration:0.5f animations:^{
        if (textField==_firstField||textField==_firstField1||textField==_secondField) {
            kWindow.frame = CGRectMake(0, -UIScreenH/5, UIScreenW, UIScreenH);
        }else if (textField==_threeField){
            kWindow.frame = CGRectMake(0, -UIScreenH/4, UIScreenW, UIScreenH);
        }else if (textField==_nameField){
            kWindow.frame = CGRectMake(0, -UIScreenH/3, UIScreenW, UIScreenH);
        }else if (textField==_phoneField){
            kWindow.frame = CGRectMake(0, -UIScreenH/3-10*MYWIDTH, UIScreenW, UIScreenH);
        }else if (textField==_phoneField1){
            kWindow.frame = CGRectMake(0, -UIScreenH/3-20*MYWIDTH, UIScreenW, UIScreenH);
        }else if (textField==_priceField){
            kWindow.frame = CGRectMake(0, -UIScreenH/3-30*MYWIDTH, UIScreenW, UIScreenH);
        }else if (textField==_goodsField){
            [_goodsBut setBackgroundColor:[UIColor whiteColor]];
            _goodsBut.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;
            [_goodsBut setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            
            kWindow.frame = CGRectMake(0, -UIScreenH/3-70*MYWIDTH, UIScreenW, UIScreenH);
        }else if (textField==_use_car_typeField){
        
            kWindow.frame = CGRectMake(0, -70*MYWIDTH, UIScreenW, UIScreenH);
        }

    }];
    
}
//完成编辑的时候下移回来（只要把offset重新设为0就行了）
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==_firstField||textField==_firstField1||textField==_secondField) {
        if ([_checkUserSign isEqualToString:@"1"]) {
            [self selectSignSetPrice];
        }
    }
    if (textField==_nameField||textField==_phoneField) {
        if ([textField.text isEqualToString:@""]) {
            _OK.hidden = YES;
        }
    }
    [UIView animateWithDuration:0.3f animations:^{
        kWindow.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);

    }];

}
- (void)paySuccess{
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 230*MYWIDTH, 200*MYWIDTH)];
    imageview.userInteractionEnabled = YES;
    imageview.image = [UIImage imageNamed:@"订单提交成功"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.height/2, imageview.width, 30*MYWIDTH)];
    lab.text = @"订单发布成功";
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
    ShopPageVC *tongch = [[ShopPageVC alloc]init];
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
