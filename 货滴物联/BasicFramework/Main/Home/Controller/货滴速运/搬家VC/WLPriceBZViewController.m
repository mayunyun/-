//
//  WLPriceBZViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WLPriceBZViewController.h"
#import "ProvinceViewController.h"
#import "WuLiuFHModel.h"
#import "WLAddNeedModel.h"
@interface WLPriceBZViewController ()<UIScrollViewDelegate>
{
    UIButton * _locationBut;

}
@property(nonatomic,strong) UIScrollView *ImageScrollView;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation WLPriceBZViewController
{
    UILabel *_zaizhongNumer;
    UILabel *_chicunNumer;
    UILabel *_tijiNumer;
    UILabel *_priceLab1;
    UILabel *_priceOtherLab1;
    UILabel *_priceLab2;
    UILabel *_titleLab4;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    titleLab.text = @"收费标准";
    titleLab.textColor = UIColorFromRGBValueValue(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLab;
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    UIImage *image = [UIImage imageNamed:@"形状-12"];
    _locationBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBut addTarget:self action:@selector(leftToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [_locationBut setFrame:CGRectMake(0, 0, 120, 40)];
    [_locationBut setTitle:[user objectForKey:CITY] forState:UIControlStateNormal];
    _locationBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [_locationBut setImage:image forState:UIControlStateNormal];
    [_locationBut setTitleColor:UIColorFromRGBValueValue(0x555555) forState:UIControlStateNormal];
    CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _locationBut.frame = CGRectMake(0, 0, size1.width+25, size1.height);
    [_locationBut setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
    [_locationBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataCity:) name:@"cityone" object:nil];
    self.dataArr = [[NSMutableArray alloc]init];

    [self loadNew];
}
#pragma 刷新(在这里面发送请求，刷新数据)
- (void)loadNew
{
    
    [self.dataArr removeAllObjects];
    //
    NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=searchCarType";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"cityname\":\"%@\"}",_locationBut.titleLabel.text]};
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:params FinishedLogin:^(id responseObject) {
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@">>%@",Arr);
        if (Arr.count) {
            
            //建立模型
            for (NSDictionary*dic in Arr ) {
                WuLiuFHModel *model=[[WuLiuFHModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [self.dataArr addObject:model];
            }
            [self setWithUIview];
            
        }else{
            _zaizhongNumer.text = [NSString stringWithFormat:@"%@",@"0"];
            _chicunNumer.text = [NSString stringWithFormat:@"%@",@"0"];
            _tijiNumer.text = [NSString stringWithFormat:@"%@",@"0"];
            _priceLab1.text = [NSString stringWithFormat:@"%@元",@"0"];
            _priceOtherLab1.text = [NSString stringWithFormat:@"%@公里\n起步价",@"0"];
            _priceLab2.text = [NSString stringWithFormat:@"%@元",@"0"];
            
        }
        
    }];
}

- (void)setWithUIview{

    self.ImageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, 130*MYWIDTH)];
    self.ImageScrollView.backgroundColor = [UIColor whiteColor];
    self.ImageScrollView.showsHorizontalScrollIndicator = NO;
    self.ImageScrollView.showsVerticalScrollIndicator = NO;
    self.ImageScrollView.pagingEnabled = YES;
    self.ImageScrollView.contentSize = CGSizeMake(kScreenWidth*self.dataArr.count, 0);
    self.ImageScrollView.bounces = NO;
    self.ImageScrollView.delegate = self;
    [self.view addSubview:self.ImageScrollView];
    
    for (int i = 0; i<self.dataArr.count; i++) {
        WuLiuFHModel *model = self.dataArr[i];

        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, 20*MYWIDTH)];
        titleLab.text = [NSString stringWithFormat:@"%@",model.car_type];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = UIColorFromRGBValueValue(0x555555);
        titleLab.font = [UIFont systemFontOfSize:13];
        [self.ImageScrollView addSubview:titleLab];
        
        UIImageView * carimage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-120*MYWIDTH+kScreenWidth*i, 20*MYWIDTH, 240*MYWIDTH, 100*MYWIDTH)];
        NSString *imageStr = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,model.folder,model.autoname];
        [carimage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
        [self.ImageScrollView addSubview:carimage];
        
    }
    UIButton *zuoBut = [[UIButton alloc]initWithFrame:CGRectMake(20*MYWIDTH, self.ImageScrollView.top + 50*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    [zuoBut setImage:[UIImage imageNamed:@"zuojiantou_2"] forState:UIControlStateNormal];
    zuoBut.tag = 1103;
    //zuoBut.hidden = YES;
    [zuoBut addTarget:self action:@selector(zuoButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zuoBut];
    
    UIButton *youBut = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 50*MYWIDTH, self.ImageScrollView.top + 50*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    [youBut setImage:[UIImage imageNamed:@"youjiantou_2"] forState:UIControlStateNormal];
    youBut.tag = 1104;
    [youBut addTarget:self action:@selector(youButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:youBut];
    //
    UIView *bgview1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.ImageScrollView.bottom, kScreenWidth, 180*MYWIDTH)];
    bgview1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview1];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/3-20*MYWIDTH, 0, 1, 60*MYWIDTH)];
    xian1.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian1];
    
    UILabel *zaizhong = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1.top, xian1.left-15*MYWIDTH, 20*MYWIDTH)];
    zaizhong.text = @"载重";
    zaizhong.textAlignment = NSTextAlignmentCenter;
    zaizhong.textColor = UIColorFromRGBValueValue(0x888888);
    zaizhong.font = [UIFont systemFontOfSize:12];
    [bgview1 addSubview:zaizhong];
    
    WuLiuFHModel *model = self.dataArr[0];

    _zaizhongNumer = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, zaizhong.bottom+10*MYWIDTH, xian1.left-15*MYWIDTH, 30*MYWIDTH)];
    _zaizhongNumer.text = [NSString stringWithFormat:@"%@",model.car_load];
    _zaizhongNumer.textAlignment = NSTextAlignmentCenter;
    _zaizhongNumer.textColor = UIColorFromRGBValueValue(0x333333);
    _zaizhongNumer.font = [UIFont systemFontOfSize:16];
    [bgview1 addSubview:_zaizhongNumer];
    
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth*2/3+20*MYWIDTH, 0, 1, 60*MYWIDTH)];
    xian2.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian2];
    
    UILabel *chicun = [[UILabel alloc]initWithFrame:CGRectMake(xian1.right, xian1.top, xian2.left-xian1.right, 20*MYWIDTH)];
    chicun.text = @"长*宽*高";
    chicun.textAlignment = NSTextAlignmentCenter;
    chicun.textColor = UIColorFromRGBValueValue(0x888888);
    chicun.font = [UIFont systemFontOfSize:12];
    [bgview1 addSubview:chicun];
    
    _chicunNumer = [[UILabel alloc]initWithFrame:CGRectMake(xian1.right, _zaizhongNumer.top, xian2.left-xian1.right, _zaizhongNumer.height)];
    _chicunNumer.text = [NSString stringWithFormat:@"%@",model.car_size];
    _chicunNumer.textAlignment = NSTextAlignmentCenter;
    _chicunNumer.textColor = UIColorFromRGBValueValue(0x333333);
    _chicunNumer.font = [UIFont systemFontOfSize:16];
    [bgview1 addSubview:_chicunNumer];
    
    UILabel *tiji = [[UILabel alloc]initWithFrame:CGRectMake(xian2.right, xian1.top, kScreenWidth-15*MYWIDTH-xian2.right, 20*MYWIDTH)];
    tiji.text = @"载货体积";
    tiji.textAlignment = NSTextAlignmentCenter;
    tiji.textColor = UIColorFromRGBValueValue(0x888888);
    tiji.font = [UIFont systemFontOfSize:12];
    [bgview1 addSubview:tiji];
    
    _tijiNumer = [[UILabel alloc]initWithFrame:CGRectMake(xian2.right, _zaizhongNumer.top, kScreenWidth-15*MYWIDTH - xian2.right, _zaizhongNumer.height)];
    _tijiNumer.text = [NSString stringWithFormat:@"%@",model.car_volume];
    _tijiNumer.textAlignment = NSTextAlignmentCenter;
    _tijiNumer.textColor = UIColorFromRGBValueValue(0x333333);
    _tijiNumer.font = [UIFont systemFontOfSize:16];
    [bgview1 addSubview:_tijiNumer];
    
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1.bottom + 15*MYWIDTH, kScreenWidth-30*MYWIDTH, 1)];
    xian3.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [bgview1 addSubview:xian3];
    
    UIView * zouimage = [[UIView alloc]initWithFrame:CGRectMake(xian1.left-45*MYWIDTH, xian3.bottom+20*MYWIDTH, 90*MYWIDTH, 90*MYWIDTH)];
    zouimage.backgroundColor = MYColor;
    zouimage.layer.cornerRadius = 45*MYWIDTH;
    [bgview1 addSubview:zouimage];
    
    UILabel *addLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-15*MYWIDTH, xian3.bottom+50*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    addLab.text = @"+";
    addLab.textAlignment = NSTextAlignmentCenter;
    addLab.textColor = UIColorFromRGBValueValue(0x333333);
    addLab.font = [UIFont systemFontOfSize:25];
    [bgview1 addSubview:addLab];
    
    UIView * youimage = [[UIView alloc]initWithFrame:CGRectMake(xian2.left-45*MYWIDTH, xian3.bottom+20*MYWIDTH, 90*MYWIDTH, 90*MYWIDTH)];
    youimage.backgroundColor = MYColor;
    youimage.layer.cornerRadius = 45*MYWIDTH;
    [bgview1 addSubview:youimage];
    
    _priceLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*MYWIDTH, zouimage.width, 25*MYWIDTH)];
    _priceLab1.text = [NSString stringWithFormat:@"%@元",model.starting_price];
    _priceLab1.textAlignment = NSTextAlignmentCenter;
    _priceLab1.textColor = [UIColor whiteColor];
    _priceLab1.font = [UIFont systemFontOfSize:18];
    [zouimage addSubview:_priceLab1];
    
    _priceOtherLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _priceLab1.bottom, zouimage.width, 40*MYWIDTH)];
    _priceOtherLab1.text = [NSString stringWithFormat:@"%@公里\n起步价",model.starting_mileage];
    _priceOtherLab1.numberOfLines = 2;
    _priceOtherLab1.textAlignment = NSTextAlignmentCenter;
    _priceOtherLab1.textColor = [UIColor whiteColor];
    _priceOtherLab1.font = [UIFont systemFontOfSize:12];
    [zouimage addSubview:_priceOtherLab1];
    
    _priceLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*MYWIDTH, zouimage.width, 25*MYWIDTH)];
    _priceLab2.text = [NSString stringWithFormat:@"%@元",model.mileage_price];
    _priceLab2.textAlignment = NSTextAlignmentCenter;
    _priceLab2.textColor = [UIColor whiteColor];
    _priceLab2.font = [UIFont systemFontOfSize:18];
    [youimage addSubview:_priceLab2];
    
    UILabel *priceOtherLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _priceLab2.bottom, zouimage.width, 40*MYWIDTH)];
    priceOtherLab2.text = @"每公里\n超里程";
    priceOtherLab2.numberOfLines = 2;
    priceOtherLab2.textAlignment = NSTextAlignmentCenter;
    priceOtherLab2.textColor = [UIColor whiteColor];
    priceOtherLab2.font = [UIFont systemFontOfSize:12];
    [youimage addSubview:priceOtherLab2];
    
    UIView *bgview2 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, bgview1.bottom+25*MYWIDTH, kScreenWidth-30*MYWIDTH, 80*MYWIDTH)];
    bgview2.backgroundColor = [UIColor whiteColor];
    bgview2.layer.cornerRadius = 5;
    bgview2.layer.borderColor = UIColorFromRGBValueValue(0xEEEEEE).CGColor;//设置边框颜色
    bgview2.layer.borderWidth = 1.0f;//设置边框颜色
    [self.view addSubview:bgview2];
    
    UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgview2.width, 30*MYWIDTH)];
    titleLab1.text = @"  费用说明";
    titleLab1.textColor = UIColorFromRGBValueValue(0x888888);
    titleLab1.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    titleLab1.font = [UIFont systemFontOfSize:14];
    [bgview2 addSubview:titleLab1];
    
    UILabel *titleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, titleLab1.bottom, bgview2.width-20*MYWIDTH, bgview2.height-30*MYWIDTH)];
    titleLab2.text = @"高速及停车场等费用，根据实际产生的金额由客户支付";
    titleLab2.numberOfLines = 0;
    titleLab2.textColor = UIColorFromRGBValueValue(0x888888);
    titleLab2.font = [UIFont systemFontOfSize:12];
    [bgview2 addSubview:titleLab2];
    
    UIView *bgview3 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, bgview2.bottom+18*MYWIDTH, kScreenWidth-30*MYWIDTH, 140*MYWIDTH)];
    bgview3.backgroundColor = [UIColor whiteColor];
    bgview3.layer.cornerRadius = 5;
    bgview3.layer.borderColor = UIColorFromRGBValueValue(0xEEEEEE).CGColor;//设置边框颜色
    bgview3.layer.borderWidth = 1.0f;//设置边框颜色
    [self.view addSubview:bgview3];
    
    UILabel *titleLab3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgview3.width, 30*MYWIDTH)];
    titleLab3.text = @"  额外需求";
    titleLab3.textColor = UIColorFromRGBValueValue(0x888888);
    titleLab3.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    titleLab3.font = [UIFont systemFontOfSize:14];
    [bgview3 addSubview:titleLab3];
    
    _titleLab4 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, titleLab3.bottom, bgview3.width-20*MYWIDTH, bgview3.height-30*MYWIDTH)];
    _titleLab4.text = @"无";
    _titleLab4.numberOfLines = 0;
    _titleLab4.textColor = UIColorFromRGBValueValue(0x888888);
    _titleLab4.font = [UIFont systemFontOfSize:12];
    [bgview3 addSubview:_titleLab4];
    
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=searchCarServices";
    NSDictionary* paramsname = @{@"params":[NSString stringWithFormat:@"{\"type\":\"%@\"}",@"1"]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:paramsname FinishedLogin:^(id responseObject) {
        
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@">>%@",Arr);
        if (Arr.count) {
            //建立模型
            NSString *str = @"";
            for (NSDictionary*dic in Arr ) {
                WLAddNeedModel *model=[[WLAddNeedModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                if ([[NSString stringWithFormat:@"%@",model.service_price] isEqualToString:@"0"]) {
                    str = [NSString stringWithFormat:@"%@%@:免费\n",str,model.service_name];
                }else{
                    str = [NSString stringWithFormat:@"%@%@:附加%.f%%路费\n",str,model.service_name,[model.service_price floatValue]*100];
                }
            }
            _titleLab4.text = str;
        }
        
    }];
}
- (void)zuoButClick:(UIButton *)but{
    NSInteger integer = self.ImageScrollView.contentOffset.x / kScreenWidth;
    NSLog(@"%zd",integer);
    if (integer>0) {
        [self.ImageScrollView setContentOffset:CGPointMake((integer-1) * kScreenWidth, 0) animated:YES];
    }
}
- (void)youButClick:(UIButton *)but{
    NSInteger integer = self.ImageScrollView.contentOffset.x / kScreenWidth;
    NSLog(@"%zd",integer);
    if (integer<self.dataArr.count-1) {
        [self.ImageScrollView setContentOffset:CGPointMake((integer+1) * kScreenWidth, 0) animated:YES];
    }
}
//开始拖拽视图

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
    
    
    if(scrollView==self.ImageScrollView)
    {
        
        NSInteger integer = self.ImageScrollView.contentOffset.x / kScreenWidth;
        WuLiuFHModel *model;
        if (self.dataArr.count) {
            model= self.dataArr[integer];
        }
        _zaizhongNumer.text = [NSString stringWithFormat:@"%@",model.car_load];
        _chicunNumer.text = [NSString stringWithFormat:@"%@",model.car_size];
        _tijiNumer.text = [NSString stringWithFormat:@"%@",model.car_volume];
        _priceLab1.text = [NSString stringWithFormat:@"%@元",model.starting_price];
        _priceOtherLab1.text = [NSString stringWithFormat:@"%@公里\n起步价",model.starting_mileage];
        _priceLab2.text = [NSString stringWithFormat:@"%@元",model.mileage_price];

//        UIButton *zuoBut = [self.view viewWithTag:1103];
//        UIButton *youBut = [self.view viewWithTag:1104];
//
//        if (integer==0) {
//            zuoBut.hidden = YES;
//        }else if (integer==self.dataArr.count-1){
//            youBut.hidden = YES;
//        }else{
//            zuoBut.hidden = NO;
//            youBut.hidden = NO;
//        }
        
    }
}
- (void)leftToLastViewController{
    ProvinceViewController *provc = [[ProvinceViewController alloc]init];
    provc.oneStr = @"1";
    [self.navigationController pushViewController:provc animated:YES];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];
    [self loadNew];

}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];
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
