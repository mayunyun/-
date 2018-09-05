//
//  HomeKuaiHuoYuanYunVC.m
//  BasicFramework
//
//  Created by LONG on 2018/2/1.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "HomeKuaiHuoYuanYunVC.h"
#import "ZHKuaiYModel.h"
#import "ZHKuaiYTableViewCell2.h"
#import "DWTagView.h"
#import "HomeSuYunVC.h"
#import "HomeKuaiYunVC.h"
#import "WuLiuFHViewController.h"

@interface HomeKuaiHuoYuanYunVC ()<UITableViewDelegate,UITableViewDataSource,DWTagViewDelegate, DWTagViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation HomeKuaiHuoYuanYunVC
{
    NSInteger _page;
    UIButton *_oneBut;
    UIButton *_twoBut;
    UIButton *_threeBut;
    UIView *_bgView;
    NSMutableArray *_arr;
    DWTagView *_typeview;
    NSString*_type1;
    NSString*_type2;
    NSString *_sprovince;
    NSString *_scity;
    NSString *_scounty;
    NSString *_eprovince;
    NSString *_ecity;
    NSString *_ecounty;
    NSString *_cartypenames;
    
    NSArray *_carTypeArr;
    UIView *_alicteView;
    
    UITextField * _use_car_typeField;
    UIButton *_use_car_typeBut;
    NSString *_use_car_typeStr;
    NSArray *_carLengthArr;
    NSString *_carlengthnames;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [self loadNewData];
    
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    // Do any additional setup after loading the view.
    UIImageView * titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"货滴快运"]];
    titleImageView.frame = CGRectMake(0, 0, 100, 20);
    self.navigationItem.titleView = titleImageView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBasehuoyunTK:) name:@"huoyunTK" object:nil];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _sprovince = [user objectForKey:PROVINCE];
    _scity =  @"";
    _scounty = @"";
    _eprovince = @"";
    _ecity = @"";
    _ecounty = @"";
    _cartypenames = @"";
    _type1 = @"1";
    _type2 = @"1";
    _use_car_typeStr = @"2";
    _carlengthnames = @"";
    _arr = [[NSMutableArray alloc]init];
    _dataArr = [[NSMutableArray alloc]init];
    [self loadNewsearchVehicleLength];
    [self loadNewsearchKuaiyunCartype];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, statusbarHeight+44, UIScreenW, 35)];
//    if (statusbarHeight>20) {
//        header.frame = CGRectMake(0, 88, UIScreenW, 35);
//    }
    header.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.view addSubview:header];
    _oneBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, UIScreenW/3-0.5, 34)];
    [_oneBut addTarget:self action:@selector(oneClick) forControlEvents:UIControlEventTouchUpInside];
    [_oneBut setTitle:[user objectForKey:PROVINCE] forState:UIControlStateNormal];
    [_oneBut setImage:[UIImage imageNamed:@"ssx_jt"] forState:UIControlStateNormal];
    [self setmodelBut:_oneBut];
    [_oneBut setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _oneBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [header addSubview:_oneBut];
    _twoBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/3+0.5, 0.5, UIScreenW/3-1, 34)];
    [_twoBut addTarget:self action:@selector(twoClick) forControlEvents:UIControlEventTouchUpInside];
    [_twoBut setTitle:@"目的地" forState:UIControlStateNormal];
    [_twoBut setImage:[UIImage imageNamed:@"ssx_jt"] forState:UIControlStateNormal];
    [self setmodelBut:_twoBut];
    [_twoBut setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _twoBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [header addSubview:_twoBut];
    _threeBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/3*2+0.5, 0.5, UIScreenW/3-0.5, 34)];
    [_threeBut addTarget:self action:@selector(threeClick) forControlEvents:UIControlEventTouchUpInside];
    [_threeBut setTitle:@"车型" forState:UIControlStateNormal];
    [_threeBut setImage:[UIImage imageNamed:@"ssx_jt"] forState:UIControlStateNormal];
    [self setmodelBut:_threeBut];
    [_threeBut setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_threeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _threeBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [header addSubview:_threeBut];
    [self tableview];
}
- (void)setmodelBut:(UIButton *)modelButton{
    // 交换button中title和image的位置
    CGFloat labelWidth = modelButton.titleLabel.intrinsicContentSize.width; //注意不能直接使用titleLabel.frame.size.width,原因为有时候获取到0值
    CGFloat imageWidth = modelButton.imageView.frame.size.width;
    CGFloat space = 4.f; //定义两个元素交换后的间距
    modelButton.titleEdgeInsets = UIEdgeInsetsMake(0, - imageWidth - space,0,imageWidth + space);
    modelButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space, 0,  -labelWidth - space);
    
}
- (void)oneClick{
    if ([_type2 isEqualToString:@"1"]&&_bgView) {
        if ([_type1 isEqualToString:@"2"]) {
            _scity = @"";
            _scounty = @"";
            [self loadNewData];
        }else if([_type1 isEqualToString:@"3"]){
            _scounty = @"";
            [self loadNewData];
        }
        [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bgView removeFromSuperview];
        _bgView = nil;
        return;
    }
    [_oneBut setTitleColor:MYColor forState:UIControlStateNormal];
    [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_threeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bgView removeFromSuperview];
    [_alicteView removeFromSuperview];
    _bgView = nil;
    _alicteView = nil;
    _type1 = @"1";
    _type2 = @"1";
    NSString *URLStr = @"/mbtwz/address?action=loadProvince";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        _arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"城市地址%@",_arr);
        NSDictionary *dic = @{@"areaname":@"全国"};
        [_arr insertObject:dic atIndex:0];
        if (_arr.count) {
            [self creatUI];
            
        }
        
    }];
}
- (void)twoClick{
    if ([_type2 isEqualToString:@"2"]&&_bgView) {
        if ([_type1 isEqualToString:@"2"]) {
            _ecity = @"";
            _ecounty = @"";
            [self loadNewData];
        }else if([_type1 isEqualToString:@"3"]){
            _ecounty = @"";
            [self loadNewData];
        }
        [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bgView removeFromSuperview];
        _bgView = nil;
        return;
    }
    [_twoBut setTitleColor:MYColor forState:UIControlStateNormal];
    [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_threeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bgView removeFromSuperview];
    [_alicteView removeFromSuperview];
    _bgView = nil;
    _alicteView = nil;
    _type1 = @"1";
    _type2 = @"2";
    NSString *URLStr = @"/mbtwz/address?action=loadProvince";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        _arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"城市地址%@",_arr);
        NSDictionary *dic = @{@"areaname":@"全国"};
        [_arr insertObject:dic atIndex:0];
        if (_arr.count) {
            [self creatUI];
            
        }
        
    }];
}
- (void)threeClick{
    if ([_type2 isEqualToString:@"3"]&&_alicteView) {
        [self cencelClick];
        return;
    }
    [_threeBut setTitleColor:MYColor forState:UIControlStateNormal];
    [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bgView removeFromSuperview];
    [_alicteView removeFromSuperview];
    _bgView = nil;
    _alicteView = nil;
    _type2 = @"3";
    [self typeCarButClick];
}
- (void)typeCarButClick{
    
    _alicteView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+statusbarHeight+44, UIScreenW, UIScreenH-35-statusbarHeight-44-49)];

    _alicteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_alicteView];
    
    UIScrollView *baiBgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _alicteView.height)];
    baiBgView.backgroundColor = [UIColor whiteColor];
    baiBgView.showsVerticalScrollIndicator = NO;
    baiBgView.showsHorizontalScrollIndicator = NO;
    baiBgView.bounces = NO;
    [_alicteView addSubview:baiBgView];
    
    UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 15*MYWIDTH, kScreenWidth, 25*MYWIDTH)];
    titleLab1.text = @"用车类型";
    titleLab1.textColor = [UIColor blackColor];
    titleLab1.textAlignment = NSTextAlignmentLeft;
    titleLab1.font = [UIFont boldSystemFontOfSize:15*MYWIDTH];
    [baiBgView addSubview:titleLab1];
    
    float w = (kScreenWidth-75*MYWIDTH)/4;
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
    
    UILabel *titleLab21 = [[UILabel alloc]initWithFrame:CGRectMake(40*MYWIDTH, 3*MYWIDTH, kScreenWidth, 20*MYWIDTH)];
    titleLab21.text = @"(*可多选)";
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
    
    UILabel *titleLab31 = [[UILabel alloc]initWithFrame:CGRectMake(70*MYWIDTH, 3*MYWIDTH, kScreenWidth, 20*MYWIDTH)];
    titleLab31.text = @"(*车型可多选)";
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
    
    baiBgView.contentSize = CGSizeMake(kScreenWidth, cencleBut.bottom+20*MYWIDTH);
    
}
- (void)cencelClick{
    [_threeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_alicteView removeFromSuperview];
    _alicteView = nil;
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
    NSArray *arr1 = @[@"整车",@"零担",@"不限类型"];
    
    NSMutableString *_carTypeStr;
    for (int i=0 ; i<_carTypeArr.count; i++) {
        UIButton *but = [_alicteView viewWithTag:1155+i];
        if (but.selected) {
            _carTypeStr = [NSMutableString stringWithFormat:@"%@,%@",_carTypeStr,[_carTypeArr[i] objectForKey:@"cartypename"]];
        }
    }
    [_carTypeStr deleteCharactersInRange:NSMakeRange(0, 7)];
    
    NSMutableString *_carlengthStr;
    for (int i=0 ; i<_carLengthArr.count; i++) {
        UIButton *but = [_alicteView viewWithTag:2155+i];
        if (but.selected) {
            _carlengthStr = [NSMutableString stringWithFormat:@"%@,%@",_carlengthStr,[_carLengthArr[i] objectForKey:@"lengthname"]];
        }
    }
    [_carlengthStr deleteCharactersInRange:NSMakeRange(0, 7)];

    if (_carTypeStr.length>0) {
        _cartypenames = _carTypeStr;
         if (_carlengthStr.length>0) {
             _carlengthnames = _carlengthStr;
             if ([_use_car_typeStr isEqualToString:@"2"]) {
                 [_threeBut setTitle:[NSString stringWithFormat:@"%@,%@",_carlengthStr,_carTypeStr] forState:UIControlStateNormal];
             }else{
                 int i = [_use_car_typeStr intValue];
                 [_threeBut setTitle:[NSString stringWithFormat:@"%@,%@,%@",arr1[i],_carlengthStr,_carTypeStr] forState:UIControlStateNormal];
             }
         }else{
             _carlengthnames = @"";
             if ([_use_car_typeStr isEqualToString:@"2"]) {
                 [_threeBut setTitle:[NSString stringWithFormat:@"%@",_carTypeStr] forState:UIControlStateNormal];
             }else{
                 int i = [_use_car_typeStr intValue];
                 [_threeBut setTitle:[NSString stringWithFormat:@"%@,%@",arr1[i],_carTypeStr] forState:UIControlStateNormal];
             }
         }
    }else{
        _cartypenames = @"";
        if (_carlengthStr.length>0) {
            _carlengthnames = _carlengthStr;
            if ([_use_car_typeStr isEqualToString:@"2"]) {
                [_threeBut setTitle:[NSString stringWithFormat:@"%@",_carlengthStr] forState:UIControlStateNormal];
            }else{
                int i = [_use_car_typeStr intValue];
                [_threeBut setTitle:[NSString stringWithFormat:@"%@,%@",arr1[i],_carlengthStr] forState:UIControlStateNormal];
            }
        }else{
            _carlengthnames = @"";
            if ([_use_car_typeStr isEqualToString:@"2"]) {
                [_threeBut setTitle:@"车型" forState:UIControlStateNormal];
            }else{
                int i = [_use_car_typeStr intValue];
                [_threeBut setTitle:[NSString stringWithFormat:@"%@",arr1[i]] forState:UIControlStateNormal];
            }
        }
    }
    [_threeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setmodelBut:_threeBut];
    [self loadNewData];
    [_alicteView removeFromSuperview];
    _alicteView = nil;
}
- (void)creatUI{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+statusbarHeight+44, UIScreenW, UIScreenH)];
//    if (statusbarHeight>20) {
//        _bgView.frame = CGRectMake(0, 88+35, UIScreenW, UIScreenH);
//    }
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _typeview = [[DWTagView alloc] init];
    _typeview.frame = CGRectMake(0, 1, UIScreenW, _bgView.height-2);
    _typeview.themeColor = [UIColor whiteColor];
    _typeview.backgroundColor = [UIColor whiteColor];
    _typeview.tagCornerRadius = 0;
    _typeview.dataSource = self;
    _typeview.delegate = self;
    _typeview.numer = 5;
    [_bgView addSubview:_typeview];
}
- (NSInteger)DWnumOfItemstagView:(DWTagView *)tagView  {
    
    if (_typeview == tagView){
        return _arr.count;
    }
    return 0;
}

- (NSString *)DWtagView:(DWTagView *)tagView titleForItemAtIndex:(NSInteger)index {
    if (_typeview == tagView){
        return [_arr[index] objectForKey:@"areaname"];
    }
    return nil;
}
- (void)DWtagView:(DWTagView *)tagView heightUpdated:(CGFloat)height{
    NSLog(@">>>>>>>???>>>>>%.2f",height);
    if (_typeview == tagView){
        
    }
}

- (void)DWtagView:(DWTagView *)tagView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@">>>>>>>???>>>>>%zd",index);
    
    if ([_type1 isEqualToString:@"1"]) {
        _type1 = @"2";
        if ([_type2 isEqualToString:@"1"]) {
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全国"]) {
                _sprovince = @"";
                _scity = @"";
                _scounty = @"";
                [_oneBut setTitle:@"全国" forState:UIControlStateNormal];
                [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self loadNewData];
                [_bgView removeFromSuperview];
                _bgView = nil;
            }else{
                _sprovince = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_oneBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [self setmodelBut:_oneBut];
        }else if ([_type2 isEqualToString:@"2"]){
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全国"]) {
                _eprovince = @"";
                _ecity = @"";
                _ecounty = @"";
                [_twoBut setTitle:@"全国" forState:UIControlStateNormal];
                [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self loadNewData];
                [_bgView removeFromSuperview];
                _bgView = nil;
            }else{
                _eprovince = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_twoBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [self setmodelBut:_twoBut];
        }
        
        NSString *URLStr = @"/mbtwz/address?action=loadCity";
        NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"provinceid\":\"%@\"}",[_arr[index] objectForKey:@"areaid"]]};
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
            _arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"城市地址%@",_arr);
            NSDictionary *dic = @{@"areaname":@"全省"};
            [_arr insertObject:dic atIndex:0];
            if (_arr.count) {
                [_typeview reloadData];
            }
            
        }];
    }else if ([_type1 isEqualToString:@"2"]){
        _type1 = @"3";
        if ([_type2 isEqualToString:@"1"]) {
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全省"]) {
                _scity = @"";
                _scounty = @"";
                [_oneBut setTitle:_sprovince forState:UIControlStateNormal];
                [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self loadNewData];
                [_bgView removeFromSuperview];
                _bgView = nil;
            }else{
                _scity = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_oneBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [self setmodelBut:_oneBut];
        }else if ([_type2 isEqualToString:@"2"]){
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全省"]) {
                _ecity = @"";
                _ecounty = @"";
                [_twoBut setTitle:_eprovince forState:UIControlStateNormal];
                [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self loadNewData];
                [_bgView removeFromSuperview];
                _bgView = nil;
            }else{
                _ecity = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_twoBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [self setmodelBut:_twoBut];
        }
        
        NSString *URLStr = @"/mbtwz/address?action=loadCountry";
        NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"cityid\":\"%@\"}",[_arr[index] objectForKey:@"areaid"]]};
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
            _arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"城市地址%@",_arr);
            NSDictionary *dic = @{@"areaname":@"全市"};
            [_arr insertObject:dic atIndex:0];
            if (_arr.count) {
                [_typeview reloadData];
            }
            
        }];
    }else if ([_type1 isEqualToString:@"3"]){
        if ([_type2 isEqualToString:@"1"]) {
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全市"]) {
                _scounty = @"";
                [_oneBut setTitle:_scity forState:UIControlStateNormal];
            }else{
                _scounty = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_oneBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setmodelBut:_oneBut];
        }else if ([_type2 isEqualToString:@"2"]){
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全市"]) {
                _ecounty = @"";
                [_twoBut setTitle:_ecity forState:UIControlStateNormal];
            }else{
                _ecounty = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_twoBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setmodelBut:_twoBut];
        }
        [self loadNewData];
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    
}

//下拉刷新
- (void)loadNewData{
    [self.dataArr removeAllObjects];
    _page = 1;
    [self loadData];
    [_tableview.mj_header endRefreshing];
    
}
- (void)addUpData{
    _page++;
    [self loadData];
    [_tableview.mj_footer endRefreshing];
}
#pragma 在这里面请求数据
- (void)loadData
{
    if ([_use_car_typeStr isEqualToString:@"2"]) {
        _use_car_typeStr = @"";
    }
    //
    NSString *URLStr = @"/mbtwz/find?action=selectKuaiyunOrderListByParam";
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8",@"params":[NSString stringWithFormat:@"{\"sprovince\":\"%@\",\"scity\":\"%@\",\"scounty\":\"%@\",\"eprovince\":\"%@\",\"ecity\":\"%@\",\"ecounty\":\"%@\",\"cartypenames\":\"%@\",\"lengthnames\":\"%@\",\"use_car_type\":\"%@\"}",_sprovince,_scity,_scounty,_eprovince,_ecity,_ecounty,_cartypenames,_carlengthnames,_use_car_typeStr]};
    NSLog(@"参数==%@",params);
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"zulin%@",diction);
        if ([[diction objectForKey:@"rows"] count]) {
            for (NSDictionary *dic in [diction objectForKey:@"rows"]) {
                //建立模型
                ZHKuaiYModel *model=[[ZHKuaiYModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [self.dataArr addObject:model];
            }
        }
        
        [self.tableview reloadData];
        
        
        
    }];
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 35+statusbarHeight+44, UIScreenW, UIScreenH-35-statusbarHeight-44)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        //        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 40*MYWIDTH)];
        //        _tableview.tableFooterView = food;
        [_tableview registerClass:[ZHKuaiYTableViewCell2 class] forCellReuseIdentifier:NSStringFromClass([ZHKuaiYTableViewCell2 class])];
        
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 243*MYWIDTH;
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addUpData)];
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class ZuLinCarClass = [ZHKuaiYTableViewCell2 class];
    ZHKuaiYTableViewCell2 *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    cell.controller = self;
    if (_dataArr.count) {
        NSLog(@"%@",_dataArr);
        ZHKuaiYModel *model = _dataArr[indexPath.row];
        [cell setwithDataModel:model];
    }
    
    return cell;
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
- (void)getLoadDataBasehuoyunTK:(NSNotification *)notice{
    
    if (![[[Command getCurrentVC] class] isEqual:[HomeKuaiHuoYuanYunVC class]]) {
        return;
    }
    [Command isloginRequest:^(bool str) {
        if (str) {
            if ([[notice.userInfo objectForKey:@"FH"] isEqualToString:@"SY"]) {
                HomeSuYunVC *suyun = [[HomeSuYunVC alloc]init];
                suyun.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:suyun animated:YES];
            }else if([[notice.userInfo objectForKey:@"FH"] isEqualToString:@"KY"]){
                HomeKuaiYunVC *kuaiyun = [[HomeKuaiYunVC alloc]init];
                kuaiyun.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:kuaiyun animated:YES];
            }else{
                WuLiuFHViewController *wuliu = [[WuLiuFHViewController alloc]init];
                wuliu.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wuliu animated:YES];
            }
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
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"huoyunTK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];
    
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
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
