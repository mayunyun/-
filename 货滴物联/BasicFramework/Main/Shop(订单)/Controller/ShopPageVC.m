//
//  ShopPageVC.m
//  BasicFramework
//
//  Created by 钱龙 on 2018/1/24.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ShopPageVC.h"
#import "JohnTopTitleView.h"
#import "TongChBanViewController.h"
#import "TongChXiaoViewController.h"
#import "KuaiYunTableViewCell.h"
#import "HomeSuYunVC.h"
#import "HomeKuaiYunVC.h"
#import "TCHKuaiYModel.h"
#import "TongChKuaiYOrderDetail.h"
#import "TongChKuaiYOrderDetail1.h"
#import "OrderSousuoViewController.h"
#import "WuLiuFHViewController.h"
@interface ShopPageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *leftBut;
    UIButton *rightBut;
    UIView *bgview;
    NSInteger _page;

}
@property (nonatomic,strong) JohnTopTitleView *titleView;
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation ShopPageVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    [self ajaxCallbak];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController)];
    [self.navigationItem.rightBarButtonItem setTintColor:MYColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBasehuoyunTK:) name:@"huoyunTK" object:nil];
    _page=1;
    _dataArr = [[NSMutableArray alloc]init];
    [self createUI];
    [self tableview];
    [_titleView setIndexPageBlock:^(NSInteger index) {
        
    }];
}
- (void)createUI{
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200*MYWIDTH, 40*MYWIDTH)];
    self.navigationItem.titleView = bgview;
    
    leftBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 5*MYWIDTH, 90*MYWIDTH, 35*MYWIDTH)];
    [leftBut setTitle:@"同城/搬家" forState:UIControlStateNormal];
    [leftBut setBackgroundColor:MYColor];
    [leftBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBut.layer.borderColor = MYColor.CGColor;//设置边框颜色
    leftBut.layer.borderWidth = 1.0f;//设置边框
    leftBut.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
    [leftBut addTarget:self action:@selector(leftButClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:leftBut];
    
    rightBut = [[UIButton alloc]initWithFrame:CGRectMake(110*MYWIDTH, 5*MYWIDTH, 90*MYWIDTH, 35*MYWIDTH)];
    [rightBut setTitle:@"省际/城际" forState:UIControlStateNormal];
    [rightBut setBackgroundColor:[UIColor whiteColor]];
    [rightBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBut.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
    rightBut.layer.borderWidth = 1.0f;//设置边框
    rightBut.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
    [rightBut addTarget:self action:@selector(rightButClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:rightBut];
    
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"同城小件单",@"同城搬家单", nil];
    self.titleView.title = titleArray;
    //    self.titleView.titleSegment.selectedSegmentIndex = 0;
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    [self.view addSubview:self.titleView];
    if ([_push isEqualToString:@"1"]) {
        self.navigationItem.titleView = nil;
        [self rightButClick:rightBut];
        self.navigationItem.title = @"快运单订单";
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)leftButClick:(UIButton *)but{
    [rightBut setBackgroundColor:[UIColor whiteColor]];
    [rightBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBut.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;
    
    [but setBackgroundColor:MYColor];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but.layer.borderColor = MYColor.CGColor;
    
    self.titleView.hidden = NO;
    self.tableview.hidden = YES;
    bgview.hidden = YES;
}
- (void)rightButClick:(UIButton *)but{
    [leftBut setBackgroundColor:[UIColor whiteColor]];
    [leftBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBut.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;
    
    [but setBackgroundColor:MYColor];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but.layer.borderColor = MYColor.CGColor;
    
    self.titleView.hidden = YES;
    self.tableview.hidden = NO;
    bgview.hidden = NO;
}
- (NSArray <UIViewController *>*)setChildVC{
    TongChXiaoViewController * vc1 = [[TongChXiaoViewController alloc]init];
    //    [vc1 setHidenSegmentBlock:^(NSInteger index) {
    //
    //    }];
    TongChBanViewController *vc2 = [[TongChBanViewController alloc]init];
    NSArray *childVC = [NSArray arrayWithObjects:vc1,vc2, nil];
    return childVC;
}
#pragma mark - getter
- (JohnTopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        if (statusbarHeight>20) {
            _titleView.frame = CGRectMake(0, 88, UIScreenW, UIScreenH-88);
        }
    }
    return _titleView;
}

- (void)loadNewSearchSuyunorder
{
    if (_page==1) {
        [_dataArr removeAllObjects];
    }
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=searchKuaiyunOrder";
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8"};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [dict objectForKey:@"rows"];
        NSLog(@"%@",array);
        if (!IsEmptyValue(array)) {
            for (NSDictionary*dic in array) {
                TCHKuaiYModel *model=[[TCHKuaiYModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_dataArr addObject:model];
            }
        }
        [_tableview reloadData];
        
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 205*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class ZuLinCarClass = [KuaiYunTableViewCell class];
    KuaiYunTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    if (_dataArr.count) {
        TCHKuaiYModel *model = _dataArr[indexPath.row];
        [cell setwithDataModel:model];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Command isloginRequest:^(bool str) {
        if (str) {
            TCHKuaiYModel *model = _dataArr[indexPath.row];
            if ([[NSString stringWithFormat:@"%@",model.driver_orderstatus] isEqualToString:@"-2"]) {
                TongChKuaiYOrderDetail1 *detail = [[TongChKuaiYOrderDetail1 alloc]init];
                detail.model = model;
                detail.hidesBottomBarWhenPushed = YES;;
                [self.navigationController pushViewController:detail animated:YES];
            }else{
                TongChKuaiYOrderDetail *detail = [[TongChKuaiYOrderDetail alloc]init];
                detail.orderStr = model.orderno;
                detail.custid = model.driver_custid;
                detail.hidesBottomBarWhenPushed = YES;;
                [self.navigationController pushViewController:detail animated:YES];
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
- (UITableView *)tableview{
    if (_tableview == nil) {
        
        bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, 20*MYWIDTH)];
        if (statusbarHeight>20) {
            bgview.frame = CGRectMake(0, 88, UIScreenW, 20*MYWIDTH);
        }
        bgview.backgroundColor = [UIColor whiteColor];
        bgview.hidden = YES;
        [self.view addSubview:bgview];
        
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 19*MYWIDTH, UIScreenW, 1*MYWIDTH)];
        xian.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [bgview addSubview:xian];
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, bgview.bottom, self.view.frame.size.width, self.view.frame.size.height-64-44-20*MYWIDTH)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, bgview.bottom, UIScreenW, UIScreenH-88-44-20*MYWIDTH);

        }
        if ([_push isEqualToString:@"1"]) {
            bgview.hidden = YES;
            _tableview.frame = CGRectMake(0, 65, UIScreenW, UIScreenH-65);
            if (statusbarHeight>20) {
                _tableview.frame = CGRectMake(0, 89, UIScreenW, UIScreenH-89);
                
            }
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        [_tableview registerClass:[KuaiYunTableViewCell class] forCellReuseIdentifier:NSStringFromClass([KuaiYunTableViewCell class])];

        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addnewData)];
        _tableview.hidden = YES;
    }
    return _tableview;
    
}
- (void)loadNewData{
    _page=1;
    [self loadNewSearchSuyunorder];
    
    [_tableview.mj_header endRefreshing];
    
}
- (void)addnewData{
    _page ++;
    [self loadNewSearchSuyunorder];
    [_tableview.mj_footer endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getLoadDataBasehuoyunTK:(NSNotification *)notice{
    
    if (![[[Command getCurrentVC] class] isEqual:[ShopPageVC class]]) {
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
- (void)ajaxCallbak{
    [Command isloginRequest:^(bool str) {
        if (str) {
            [self loadNewSearchSuyunorder];
            
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
- (void)rightToLastViewController{
    OrderSousuoViewController *sousuo = [[OrderSousuoViewController alloc]init];
    sousuo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sousuo animated:YES];
}
- (void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
