//
//  HuodongViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HuodongViewController.h"
#import "MainTableViewCell.h"
#import "NewAllViewController.h"
#import "HDSousuoViewController.h"

@interface HuodongViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _page;
    
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation HuodongViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight-NavBarHeight)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88);
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
//        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
//        header.backgroundColor = UIColorFromRGB(0xEEEEEE);
//
//        UIView *headerbgview =[[UIView alloc]init];
//        headerbgview.backgroundColor = [UIColor whiteColor];
//        [header addSubview:headerbgview];
//        headerbgview.frame = CGRectMake(10, 15, kScreenWidth-20, 10);
//        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:headerbgview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
//        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
//        maskLayer1.frame = headerbgview.bounds;
//        maskLayer1.path = maskPath1.CGPath;
//        headerbgview.layer.mask = maskLayer1;
//        _tableview.tableHeaderView = header;
//
//        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
//        food.backgroundColor = UIColorFromRGB(0xEEEEEE);
//
//        UIView *foodbgview =[[UIView alloc]init];
//        foodbgview.backgroundColor = [UIColor whiteColor];
//        [food addSubview:foodbgview];
//        foodbgview.frame = CGRectMake(10, 0, kScreenWidth-20, 10);
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:foodbgview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = foodbgview.bounds;
//        maskLayer.path = maskPath.CGPath;
//        foodbgview.layer.mask = maskLayer;
//        _tableview.tableFooterView = food;
        
        [_tableview registerClass:[MainTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MainTableViewCell class])];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addUpData)];

        
    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{
    [self.dataArr removeAllObjects];
    _page = 1;
    [self loadNew];
    [_tableview.mj_header endRefreshing];
    
}
- (void)addUpData{
    _page++;
    [self loadNew];
    [_tableview.mj_footer endRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    self.navigationItem.title = @"行业资讯";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索_1"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController:)];
//    [self.navigationItem.rightBarButtonItem setTintColor:NavBarItemColor];
    _page = 1;

    _dataArr = [[NSMutableArray alloc]init];
    [self tableview];
    [self loadNew];
}

#pragma 刷新(在这里面发送请求，刷新数据)
- (void)loadNew
{
    //最新动态
    NSString *XWURLStr = @"/mbtwz/find?action=getActiveList";
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8",@"params":[NSString stringWithFormat:@"{\"appstatus\":\"%@\"}",@"0"]};
    NSLog(@"%@",params);
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:params FinishedLogin:^(id responseObject) {
        if (responseObject) {
            NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            //建立模型
            for (NSDictionary*dic in [resultDic objectForKey:@"rows"]) {
                HuoDongModel *model=[[HuoDongModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count>0) {
                //                [self.tableview dismissNoView];
                [self.tableview reloadData];
                
            }else{
                //                [self.tableview showNoView:nil image:nil certer:CGPointZero];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75*MYWIDTH+30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Class MainClass = [MainTableViewCell class];
    MainTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.xianview.hidden = YES;
    }else{
        cell.xianview.hidden = NO;
    }
    if (_dataArr.count) {
        HuoDongModel*model = self.dataArr[indexPath.row];
        cell.model = model;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewAllViewController *newAll = [[NewAllViewController alloc]init];
    newAll.hidesBottomBarWhenPushed = YES;
    newAll.huomodel = self.dataArr[indexPath.row];
    newAll.type = 2;
    [self.navigationController pushViewController:newAll animated:YES];
}
- (void)rightToLastViewController:(UIButton *)button{
    HDSousuoViewController *sousuo = [[HDSousuoViewController alloc]init];
    [self.navigationController pushViewController:sousuo animated:YES];
}
@end
