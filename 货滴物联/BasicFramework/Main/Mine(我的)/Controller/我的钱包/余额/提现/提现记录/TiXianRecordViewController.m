//
//  TiXianRecordViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TiXianRecordViewController.h"
#import "TiXianRecordCell.h"
#import "TiXianJLModel.h"
@interface TiXianRecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation TiXianRecordViewController

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight)];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tableview.tableHeaderView = head;
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tableview.tableFooterView = food;
        [_tableview registerNib:[UINib nibWithNibName:@"TiXianRecordCell" bundle:nil] forCellReuseIdentifier:@"TiXianRecordCell"];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
    }
    
    return _tableview;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"提现记录";
    _dataArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    [self tableview];
    [self loadNew];
}
//下拉刷新
- (void)loadNewData{
    
    [self loadNew];
    [_tableview.mj_header endRefreshing];
    
}
#pragma 在这里面请求数据
- (void)loadNew
{
    [_dataArr removeAllObjects];
    //最新动态
    NSString *URLStr = @"/mbtwz/wallet?action=getCashSearchRecord";

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"我的提现记录%@",Arr);
        //建立模型
        for (NSDictionary*dic in Arr ) {
            TiXianJLModel *model=[[TiXianJLModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [self.dataArr addObject:model];
        }
        [self.tableview reloadData];
        
    }];
    
   //15069019010
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArr.count == 0) {
        return 0;
    }
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TiXianJLModel *model;
    if (_dataArr.count>0) {
        model = _dataArr[indexPath.row];
    }
    TiXianRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TiXianRecordCell"];
    if (!cell) {
        cell=[[TiXianRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TiXianRecordCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    [cell setData:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld",indexPath.row);
}
- (void)backToLastViewController:(UIButton *)button{
    
    if (self.pushNum == 1) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
