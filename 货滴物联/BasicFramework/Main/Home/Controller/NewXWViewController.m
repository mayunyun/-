//
//  NewXWViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/9/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NewXWViewController.h"
#import "MainTableViewCell.h"
#import "NewAllViewController.h"

@interface NewXWViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation NewXWViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, UIScreenH-64)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88);
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 25)];
        header.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        UIView *headerbgview =[[UIView alloc]init];
        headerbgview.backgroundColor = [UIColor whiteColor];
        [header addSubview:headerbgview];
        headerbgview.frame = CGRectMake(10, 15, UIScreenW-20, 10);
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:headerbgview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = headerbgview.bounds;
        maskLayer1.path = maskPath1.CGPath;
        headerbgview.layer.mask = maskLayer1;
        _tableview.tableHeaderView = header;
        
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 25)];
        food.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        UIView *foodbgview =[[UIView alloc]init];
        foodbgview.backgroundColor = [UIColor whiteColor];
        [food addSubview:foodbgview];
        foodbgview.frame = CGRectMake(10, 0, UIScreenW-20, 10);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:foodbgview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = foodbgview.bounds;
        maskLayer.path = maskPath.CGPath;
        foodbgview.layer.mask = maskLayer;
        _tableview.tableFooterView = food;
        
        [_tableview registerClass:[MainTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MainTableViewCell class])];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{
    
    [self loadNew];
    [_tableview.mj_header endRefreshing];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"最新动态";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    _dataArr = [[NSMutableArray alloc]init];
    [self tableview];
    [self loadNew];
}

#pragma 刷新(在这里面发送请求，刷新数据)
- (void)loadNew
{
    
    [self.dataArr removeAllObjects];
    
    //最新动态
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"appstatus\":\"%@\"}",@"0"]};

    NSString *XWURLStr = @"/mbtwz/index?action=getNews";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:params FinishedLogin:^(id responseObject) {
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"最新动态%@",responseObject[0]);
        if (Arr.count) {
            
            //建立模型
            for (NSDictionary*dic in Arr ) {
                XWMainModel *model=[[XWMainModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [self.dataArr addObject:model];
            }
            
            [self.tableview reloadData];
                
            
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
        XWMainModel*model = self.dataArr[indexPath.row];
        cell.data = model;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewAllViewController *newAll = [[NewAllViewController alloc]init];
    newAll.hidesBottomBarWhenPushed = YES;
    newAll.model = self.dataArr[indexPath.row];
    newAll.type = 1;
    [self.navigationController pushViewController:newAll animated:YES];
}

@end
