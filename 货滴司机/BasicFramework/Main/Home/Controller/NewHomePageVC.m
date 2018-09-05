//
//  HomePageVC.m
//  BasicFramework
//
//  Created by Rainy on 16/10/26.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "NewHomePageVC.h"
#import "HomeSuYunVC.h"
#import "HomeKuaiYunVC.h"
#import "MYYTypeDetailsCollectionView.h"
#import "XWMainModel.h"
#import "NewAllViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ProvinceViewController.h"
#import "CoreViewController.h"
#import "NetWorkManagerTwo.h"
#import "SiJiHomeViewController.h"
#import "mainCollectionViewCell.h"
#import "NewShopingClassViewController.h"
#import "MyPurseViewController.h"
#import "XiaZaiViewController.h"
#import "xiaoxiViewController.h"
#import "BadgeButton.h"
#import "FreeRideTripListVC.h"
@interface NewHomePageVC ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton * _locationBut;
    NSString *_versionUrl;
    
}
@property (nonatomic ,strong)UICollectionView *IconsCollectionView;
@property (nonatomic, strong) NSMutableArray * imagesArr;
@property(nonatomic,strong)AMapLocationManager *locationManager;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)BadgeButton *btn;

@end


@implementation NewHomePageVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [Command isloginRequest:^(bool str) {
        if (str) {
            [self xiaoxidataRequest];
        }
    }];
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
    UIImageView * titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hd_logo"]];
    titleImageView.frame = CGRectMake(0, 0, 100, 20);
    self.navigationItem.titleView = titleImageView;
    _imagesArr = [NSMutableArray new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self IconsCollectionView];
    [self requestDataForBanner];
    
    [self navbarBGView];
    [self amapLocationSharedServices];
    
    [self versionRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataCity:) name:@"city" object:nil];
    //通知中心注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBasehuoyunTK:) name:@"huoyunTK" object:nil];
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"kaiqidingwei" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    
}
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status==ReachableViaWiFi||status==ReachableViaWWAN) {
        [self amapLocationSharedServices];
        [self requestDataForBanner];
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"kaiqidingwei" object:nil userInfo:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"huoyunTK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kaiqidingwei" object:nil];
    
    
}
- (UICollectionView *)IconsCollectionView{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 10;//行间距
    flowLayout.minimumLineSpacing = 10;//列间距
    if (_IconsCollectionView == nil) {
        _IconsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, UIScreenH-40-64) collectionViewLayout:flowLayout];
        //隐藏滑块
        _IconsCollectionView.showsVerticalScrollIndicator = NO;
        _IconsCollectionView.showsHorizontalScrollIndicator = NO;
        
        _IconsCollectionView.backgroundColor = UIColorFromRGB(0xEFEFEF);
        _IconsCollectionView.dataSource = self;
        _IconsCollectionView.delegate = self;
        //注册单元格
        [_IconsCollectionView registerNib:[UINib nibWithNibName:@"mainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"mainCollectionViewCell"];
        [_IconsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];  //  一定要设置
        
        [self.view addSubview:_IconsCollectionView];
    }
    return _IconsCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
//调整Item的位置 使Item不紧挨着屏幕
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //在原有基础上进行调整 上 左 下 右
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(UIScreenW/2-20, (UIScreenW/2-20)*20/32);
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"mainCollectionViewCell";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"mainCollectionViewCell" bundle: [NSBundle mainBundle]];
    [_IconsCollectionView registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    mainCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    
    NSArray *imageArr = @[@"zixun-2",@"kuaiyun",@"shangcheng",@"xiazai",@"zixun",@"qianbao",@"suyun",@"qianbao-1"];
    NSArray *nameArr = @[@"货滴顺风车",@"省际/城际",@"同城/搬家",@"应用下载",@"司机之家",@"我的钱包",@"货滴商城",@"货滴保险"];
    [cell setdataimage:imageArr[indexPath.row] title:nameArr[indexPath.row]];
    return cell;
}


//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    // 网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenW, 170*MYWIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.currentPageDotColor = MYColor; // 自定义分页控件小圆标颜色
    self.cycleScrollView.pageDotColor = [UIColor whiteColor];
    [headerView addSubview:self.cycleScrollView];
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(UIScreenW, 180*MYWIDTH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        FreeRideTripListVC *etcVC = [[FreeRideTripListVC alloc]init];
        etcVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:etcVC animated:YES];
    }
    else if (indexPath.row==1) {
        [Command isloginRequest:^(bool str) {
            if (str) {
                HomeKuaiYunVC *kuaiyun = [[HomeKuaiYunVC alloc]init];
                kuaiyun.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:kuaiyun animated:YES];
                
            }else{
                jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                    
                }, @"前往", ^(NSInteger buttonIndex) {
                    LoginVC* vc = [[LoginVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }
        }];
    }else if (indexPath.row==2){
        [Command isloginRequest:^(bool str) {
            if (str) {
                HomeSuYunVC *suyun = [[HomeSuYunVC alloc]init];
                suyun.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:suyun animated:YES];
            }else{
                jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                    
                }, @"前往", ^(NSInteger buttonIndex) {
                    LoginVC* vc = [[LoginVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }
        }];
    }else if (indexPath.row==3){
        XiaZaiViewController *xiazai = [[XiaZaiViewController alloc]init];
        xiazai.hidesBottomBarWhenPushed = YES;
        [self presentViewController:xiazai animated:YES completion:nil];
        
        
    }else if (indexPath.row==4){
        SiJiHomeViewController *etcVC = [[SiJiHomeViewController alloc]init];
        etcVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:etcVC animated:YES];
    }else if (indexPath.row==5){
        [Command isloginRequest:^(bool str) {
            if (str) {
                MyPurseViewController *regiVc = [[MyPurseViewController alloc]init];
                regiVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:regiVc animated:YES];
            }else{
                jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                    
                }, @"前往", ^(NSInteger buttonIndex) {
                    LoginVC* vc = [[LoginVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }
        }];
        
        
    }else if (indexPath.row==6){
        NewShopingClassViewController *regiVc = [[NewShopingClassViewController alloc]init];
        regiVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:regiVc animated:YES];
        
    }
    else if (indexPath.row==7){
        
        
    }
}


- (void)navbarBGView{
    
    _btn = [[BadgeButton alloc] init];
    [_btn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
    [_btn setTitleColor:MYColor forState:UIControlStateNormal];
    //_btn.badgeValue = 1;//红点的值  _btn.isRedBall = YES;此bool值的设置只显示红点
    [_btn addTarget:self action:@selector(leftToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:_btn];
    self.navigationItem.leftBarButtonItem = right;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"消息"] style:UIBarButtonItemStylePlain target:self action:@selector(leftToLastViewController)];
//    [self.navigationItem.leftBarButtonItem setTintColor:MYColor];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"济南市" forKey:CITY];
    [[NSUserDefaults standardUserDefaults]setObject:@"山东省" forKey:PROVINCE];

    UIImage *image = [UIImage imageNamed:@"形状-12"];
    _locationBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBut addTarget:self action:@selector(rightToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [_locationBut setFrame:CGRectMake(0, 0, 120, 40)];
    [_locationBut setTitle:@"济南市" forState:UIControlStateNormal];
    _locationBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [_locationBut setImage:image forState:UIControlStateNormal];
    [_locationBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _locationBut.frame = CGRectMake(0, 0, size1.width+25, size1.height);
    [_locationBut setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
    [_locationBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataCity:) name:@"city" object:nil];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];
    
}
- (void)leftToLastViewController{
    
    [Command isloginRequest:^(bool str) {
        if (str) {
            xiaoxiViewController *proVC = [[xiaoxiViewController alloc]init];
            proVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:proVC animated:YES];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
    }];
    
//    CoreViewController *proVC = [[CoreViewController alloc]init];
//    proVC.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:proVC animated:YES completion:nil];
    
}
- (void)rightToLastViewController{
    ProvinceViewController *proVC = [[ProvinceViewController alloc]init];
    proVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:proVC animated:YES];
}

- (void)getLoadDataBasehuoyunTK:(NSNotification *)notice{
    
    if (![[[Command getCurrentVC] class] isEqual:[NewHomePageVC class]]) {
        return;
    }
    [Command isloginRequest:^(bool str) {
        if (str) {
            if ([[notice.userInfo objectForKey:@"FH"] isEqualToString:@"SY"]) {
                HomeSuYunVC *suyun = [[HomeSuYunVC alloc]init];
                suyun.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:suyun animated:YES];
            }else{
                HomeKuaiYunVC *kuaiyun = [[HomeKuaiYunVC alloc]init];
                kuaiyun.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:kuaiyun animated:YES];
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

-(void)requestDataForBanner{
    
    //NSDictionary * dic = @{@"params":@"1"};
    NSMutableArray *_imagesURLStrings = [[NSMutableArray alloc]init];
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"appstatus\":\"%@\"}",@"1"]};
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/PcIndex?action=getTrends" Parameters:params FinishedLogin:^(id responseObject) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //NSLog(@"%@",responseObject);
        for (NSDictionary * dic in array) {
            HuoDongModel *model=[[HuoDongModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [_imagesArr addObject:model];
            NSString *image = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,[dic objectForKey:@"folder"],[dic objectForKey:@"autoname"]];
            
            //追加数据
            [_imagesURLStrings addObject:image];
        }
        self.cycleScrollView.imageURLStringsGroup = _imagesURLStrings;
        
    }];
}


- (void)amapLocationSharedServices{
    
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
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode.city);
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",regeocode.city] forKey:CITY];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",regeocode.province] forKey:PROVINCE];

            [_locationBut setTitle:regeocode.city forState:UIControlStateNormal];
            CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
            // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
            CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
            _locationBut.frame = CGRectMake(0, 0, size1.width+25, size1.height);
            [_locationBut setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
            [_locationBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];
            
        }
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];
    
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    if (cycleScrollView == self.cycleScrollView) {
//        NSLog(@"---点击了专题第%ld张图片", (long)index);
//        HuoDongModel * model = self.imagesArr[index];
//        
//        NewAllViewController *newAll = [[NewAllViewController alloc]init];
//        newAll.hidesBottomBarWhenPushed = YES;
//        newAll.huomodel = model;
//        newAll.type = 2;
//        [self.navigationController pushViewController:newAll animated:YES];
//    }
}
#pragma mark -－－－－－－－－－－－－－－ 版本更新－－－－－－－－－－－－－－－－－－－－－－－－－－
//版本更新
- (void)versionRequest{
    /*lxpub/app/version?
     
     action=getVersionInfo
     project=lx
     联祥           applelianxiang
     。。。
     */
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app名字%@",appName);
    NSString *urlStr = [NSString stringWithFormat:@"%@:8004/lxpub/app/version?action=getVersionInfo&project=applehuodisiji",Ver_Address];
    NSDictionary *parameters = @{@"action":@"getVersionInfo",@"project":[NSString stringWithFormat:@"%@",@"applehuodisiji"]};
    
    [NetWorkManagerTwo requestDataWithURL:urlStr
                              requestType:POST
                               parameters:parameters
                           uploadProgress:nil
                                  success:^(id responseObject,id data)
     {
         NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"版本信息:%@",dic);
         NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
         CFShow((__bridge CFTypeRef)(infoDic));
         NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
         NSLog(@"当前版本号%@",appVersion);
         NSString *version = dic[@"app_version"];
         NSString *nessary = dic[@"app_necessary"];
         _versionUrl = dic[@"app_url"];
         if ([version isEqualToString:appVersion]) {
             //当前版本
         }else if(![version isEqualToString:appVersion]){
             if ([nessary isEqualToString:@"0"]) {
                 //不强制更新
                 [self showAlert];
             }else if([nessary isEqualToString:@"1"]){
                 //强制更新
                 [self showAlert1];
             }
         }
         
     } failure:^(NSError *error) {
         
     }];
    
}
//选择更新
- (void)showAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:@"发现新版本，是否马上更新？"
                                                   delegate:self
                                          cancelButtonTitle:@"以后再说"
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10001;
    [alert show];
    
}
//强制更新
- (void)showAlert1{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:@"发现新版本，是否马上更新？"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10002;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (alertView.tag==10001) {
        
        if (buttonIndex==1) {
            NSString *str = [NSString stringWithFormat:@"%@%@",@"itms-services://?action=download-manifest&url=",_versionUrl];
            NSURL *url = [NSURL URLWithString:str];
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }else if (alertView.tag == 10002){
        
        if (buttonIndex == 0) {
            
            NSString *str = [NSString stringWithFormat:@"%@%@",@"itms-services://?action=download-manifest&url=",_versionUrl];
            NSURL *url = [NSURL URLWithString:str];
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
    
}
//查询接口
- (void)xiaoxidataRequest{
    /*
     collect?action=searchCollection
     */
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:@"1" forKey:@"type"];
    
    NSDictionary* params = @{@"params":[Command dictionaryToJson:param]};
    
    NSString *url = @"/mbtwz/sendusermsg?action=searchUserMsgNoRead";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:params FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"flag"] intValue] == 200) {
            NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:dic[@"response"][0]];
            _btn.badgeValue = [[dict objectForKey:@"noread"] intValue];//红点的值
        }
        
        
    }];
    
    
}
@end
