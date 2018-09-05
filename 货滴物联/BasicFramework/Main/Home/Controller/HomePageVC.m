//
//  HomePageVC.m
//  BasicFramework
//
//  Created by Rainy on 16/10/26.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "HomePageVC.h"
#import "HomeSuYunVC.h"
#import "HomeKuaiYunVC.h"
#import "MYYTypeDetailsCollectionView.h"
#import "XWMainModel.h"
#import "NewAllViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ProvinceViewController.h"
#import "NewXWViewController.h"
#import "CoreViewController.h"
#import "NetWorkManagerTwo.h"
#import "WuLiuFHViewController.h"
#import "xiaoxiViewController.h"
@interface HomePageVC ()<SDCycleScrollViewDelegate,UICollectionViewDelegate>
{
    UIScrollView* detailsscrollView;
    UIButton * _locationBut;
    NSString *_versionUrl;

}
@property(nonatomic,strong)UIScrollView *scrollview;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic, strong) NSMutableArray * imagesArr;
@property (nonatomic,strong)MYYTypeDetailsCollectionView* detailsCollectionView;
@property(nonatomic,strong)AMapLocationManager *locationManager;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

@end

@implementation HomePageVC

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭

    UIImageView * titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hd_logo"]];
    titleImageView.frame = CGRectMake(0, 0, 100, 20);
    self.navigationItem.titleView = titleImageView;
    _dataArr = [[NSMutableArray alloc]init];
    _imagesArr = [NSMutableArray new];
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-44)];
    if (statusbarHeight>20) {
        self.scrollview.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88-44);
    }
    self.scrollview.backgroundColor = kClearColor;

    [self.view addSubview: self.scrollview];
    self.view.backgroundColor = WhiteColor;
    [self initSubViewUI];
    [self loadNew];
    [self requestDataForBanner];
    
    [self navbarBGView];
    [self amapLocationSharedServices];
    
    [self versionRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataCity:) name:@"city" object:nil];
    //通知中心注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBasehuoyunTK:) name:@"huoyunTK" object:nil];
    

}
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status==ReachableViaWiFi||status==ReachableViaWWAN) {
        [self amapLocationSharedServices];
        [self loadNew];
        [self requestDataForBanner];
 
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"huoyunTK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];

}
- (void)navbarBGView{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"saoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(leftToLastViewController)];
    [self.navigationItem.leftBarButtonItem setTintColor:MYColor];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"济南市" forKey:CITY];
    
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
 
    
    xiaoxiViewController *proVC = [[xiaoxiViewController alloc]init];
    proVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:proVC animated:YES completion:nil];
//    CoreViewController *proVC = [[CoreViewController alloc]init];
//    proVC.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:proVC animated:YES completion:nil];

}
- (void)rightToLastViewController{
    ProvinceViewController *proVC = [[ProvinceViewController alloc]init];
    proVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:proVC animated:YES];
}
#pragma 刷新(在这里面发送请求，刷新数据)
- (void)loadNew
{
    
    [self.dataArr removeAllObjects];
    
    //最新动态
    NSString *XWURLStr = @"/mbtwz/index?action=getNews";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"appstatus\":\"%@\"}",@"0"]};

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:params FinishedLogin:^(id responseObject) {
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        // NSSLog(@"最新动态%@",Arr[0]);
        if (Arr) {
            
            //建立模型
            for (NSDictionary*dic in Arr ) {
                XWMainModel *model=[[XWMainModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_dataArr addObject:model];
            }
            NSLog(@">>%@ %zd",Arr,(_dataArr.count/2+_dataArr.count%2));
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (int j=0; j<_dataArr.count; j++) {
                [array addObject:_dataArr[j]];
                j++;
            }
            for (int i=1; i<_dataArr.count; i++) {
                [array addObject:_dataArr[i]];
                i++;
            }
            NSLog(@">>%@ %zd",array,(_dataArr.count/2+_dataArr.count%2));
            _detailsCollectionView.dataArr = array;
            [_detailsCollectionView reloadData];
            _detailsCollectionView.frame = CGRectMake(0, 0, (_dataArr.count/2+_dataArr.count%2)*self.scrollview.width, 180*MYWIDTH);
            detailsscrollView.contentSize = CGSizeMake((_dataArr.count/2+_dataArr.count%2)*self.scrollview.width, 180*MYWIDTH);
        }
    }];
    
    
}
-(void)initSubViewUI{
    // 网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10*MYWIDTH, 0, self.scrollview.width-20*MYWIDTH, 190*MYWIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.currentPageDotColor = MYColor; // 自定义分页控件小圆标颜色
    self.cycleScrollView.pageDotColor = [UIColor whiteColor];
    [self.scrollview addSubview:self.cycleScrollView];
    //发货类型
    UILabel * fahuoType = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, self.cycleScrollView.bottom+10*MYWIDTH, self.scrollview.width-20*MYWIDTH, 20*MYWIDTH)];
    fahuoType.text = @"发货类型";
    fahuoType.font = FifteenFontSize;
    fahuoType.textAlignment = NSTextAlignmentLeft;
    [self.scrollview addSubview:fahuoType];
    //左按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10*MYWIDTH, fahuoType.bottom+5*MYWIDTH, self.scrollview.width/2-20*MYWIDTH, 100*MYWIDTH);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"sy"] forState:UIControlStateNormal];
    leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:leftBtn];
    //右按钮
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(leftBtn.right+20*MYWIDTH, fahuoType.bottom+5*MYWIDTH, leftBtn.width, 100*MYWIDTH);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"ky"] forState:UIControlStateNormal];
    rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:rightBtn];
    //最新动态
    UILabel * dongtai = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, leftBtn.bottom+10*MYWIDTH, self.scrollview.width-30, 20*MYWIDTH)];
    dongtai.text = @"最新动态";
    dongtai.font = FifteenFontSize;
    dongtai.textAlignment = NSTextAlignmentLeft;
    [self.scrollview addSubview:dongtai];
    //更多资讯 ...
    UIImageView *imageBtn = [[UIImageView alloc]initWithFrame:CGRectMake(self.scrollview.right-40*MYWIDTH, dongtai.center.y-2*MYWIDTH, 15*MYWIDTH, 4*MYWIDTH)];
    imageBtn.image = [UIImage imageNamed:@"more"];
    [self.scrollview addSubview:imageBtn];

    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(self.scrollview.right-50*MYWIDTH, dongtai.center.y-10*MYWIDTH, 50*MYWIDTH, 20*MYWIDTH);
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:moreBtn];
    //上横线
    UILabel * uline = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, dongtai.bottom+5*MYWIDTH, self.scrollview.width-20*MYWIDTH, 1)];
    uline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.scrollview addSubview:uline];
    //collection
    detailsscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, uline.bottom+5*MYWIDTH, kScreenWidth, 180*MYWIDTH)];
    detailsscrollView.delegate = self;
    detailsscrollView.backgroundColor = [UIColor clearColor];
    detailsscrollView.pagingEnabled = YES ;
    detailsscrollView.showsVerticalScrollIndicator = NO;
    detailsscrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollview addSubview:detailsscrollView];
    
    _detailsCollectionView = [[MYYTypeDetailsCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.scrollview.width, 180*MYWIDTH)];
    _detailsCollectionView.delegate = self;
    _detailsCollectionView.bounces = NO;
    _detailsCollectionView.scrollsToTop = NO;
    _detailsCollectionView.scrollEnabled = NO;
    _detailsCollectionView.userInteractionEnabled = YES;
    [detailsscrollView addSubview:_detailsCollectionView];
    _detailsCollectionView.backgroundColor = [UIColor whiteColor];

    //下横线
    UILabel * bline = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, detailsscrollView.bottom+5*MYWIDTH, self.scrollview.width-20*MYWIDTH, 1)];
    bline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.scrollview addSubview:bline];
    self.scrollview.contentSize = CGSizeMake(kScreenWidth, bline.bottom+20*MYWIDTH);
}
- (void)moreBtnClick{
    NewXWViewController *newxw = [[NewXWViewController alloc]init];
    newxw.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newxw animated:YES];
}
- (void)leftBtnClick{
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
    
}
- (void)rightBtnClick{
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
    
}
- (void)getLoadDataBasehuoyunTK:(NSNotification *)notice{
    
    if (![[[Command getCurrentVC] class] isEqual:[HomePageVC class]]) {
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

-(void)requestDataForBanner{
    
    //NSDictionary * dic = @{@"params":@"1"};
    NSMutableArray *_imagesURLStrings = [[NSMutableArray alloc]init];
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"appstatus\":\"%@\"}",@"0"]};

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
#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[MYYTypeDetailsCollectionView class]]) {
        return CGSizeMake(kScreenWidth, 90*MYWIDTH);
    }
    else{
        return CGSizeMake(0, 0);
    }
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[MYYTypeDetailsCollectionView class]]) {
        NewAllViewController *newAll = [[NewAllViewController alloc]init];
        newAll.hidesBottomBarWhenPushed = YES;
        newAll.model = self.dataArr[indexPath.row];
        newAll.type = 1;
        [self.navigationController pushViewController:newAll animated:YES];
    }
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
    if (cycleScrollView == self.cycleScrollView) {
        NSLog(@"---点击了专题第%ld张图片", (long)index);
        HuoDongModel * model = self.imagesArr[index];
        
        NewAllViewController *newAll = [[NewAllViewController alloc]init];
        newAll.hidesBottomBarWhenPushed = YES;
        newAll.huomodel = model;
        newAll.type = 2;
        [self.navigationController pushViewController:newAll animated:YES];
    }
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
    NSString *urlStr = [NSString stringWithFormat:@"%@:8004/lxpub/app/version?action=getVersionInfo&project=applehuodiwuliu",Ver_Address];
    NSDictionary *parameters = @{@"action":@"getVersionInfo",@"project":[NSString stringWithFormat:@"%@",@"applehuodiwuliu"]};
    
    [NetWorkManagerTwo requestDataWithURL:urlStr
                              requestType:POST
                               parameters:parameters
                                  loading:NO
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
@end
