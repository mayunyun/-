//
//  MYYFaHuoViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYFaHuoViewController.h"
#import "MYYMyOrderModel.h"
#import "MyOrterTableViewCell.h"
#import "OrderDaterViewController.h"
@interface MYYFaHuoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;


@end

@implementation MYYFaHuoViewController{
    NSMutableArray *_prolistArr;
    NSInteger _page;
    
}

- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-104)];
        _tableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        //下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            if (!IsEmptyValue(_dataArr)) {
                [_dataArr removeAllObjects];
            }
            [self dataRequest];
            [_tableView.mj_header endRefreshing];
            
        }];
        //
        _tableView.mj_header.automaticallyChangeAlpha = YES;
        //
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _page ++;
            [self dataRequest];
            [_tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    _prolistArr = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    _page=1;
    [self dataRequest];
    [self TableView];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataArr.count) {
        MYYMyOrderModel *model = _dataArr[indexPath.row];
        NSInteger count = 0;
        if (!IsEmptyValue(_prolistArr)) {
            for (NSArray* arr in _prolistArr) {
                if (!IsEmptyValue(arr)) {
                    MYYMyOrderClassModer* classModel = arr[0];
                    if ([[NSString stringWithFormat:@"%@",model.id] integerValue] == [[NSString stringWithFormat:@"%@",classModel.orderid] integerValue]) {
                        count = arr.count;
                        
                    }
                }
            }
        }
        return 95 + count*90;
    }
    return 190;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * stringCell = @"MyOrterTableViewCell";
    MyOrterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count) {
        MYYMyOrderModel *model = _dataArr[indexPath.row];
        
        
        if (!IsEmptyValue(_prolistArr)) {
            for (NSArray* arr in _prolistArr) {
                if (!IsEmptyValue(arr)) {
                    MYYMyOrderClassModer* classModel = arr[0];
                    NSLog(@"%@,,,,%@",model.id,classModel.orderid);
                    if ([[NSString stringWithFormat:@"%@",model.id] integerValue] == [[NSString stringWithFormat:@"%@",classModel.orderid] integerValue]) {
                        cell.prolistArr = arr;
                        
                    }
                }
            }
        }
        [cell configModel:model];
        
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MYYMyOrderModel *model = _dataArr[indexPath.row];
    OrderDaterViewController *ordervc = [[OrderDaterViewController alloc]init];
    ordervc.idstr = model.id;
    [self.navigationController pushViewController:ordervc animated:YES];
}

- (void)dataRequest{
    if (_dataArr==nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }else{
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
    }
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"orderstatus\":\"%@\"}",@"1"],@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8"};
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/scshop?action=getOrderList" Parameters:params loading:NO FinishedLogin:^(id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [dict objectForKey:@"rows"];
        NSLog(@"%@",array);
        if (!IsEmptyValue(array)) {
            for (NSDictionary*dic in array) {
                MYYMyOrderModel *model=[[MYYMyOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_dataArr addObject:model];
                [self dataOrder:model.id];
            }
        }
        [_tableView reloadData];
        
    }];
}
- (void)dataOrder:(NSString *)strid{
    
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"orderid\":\"%@\"}",strid]};
    NSLog(@"%@",params);
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/scshop?action=getOrderProList" Parameters:params loading:NO FinishedLogin:^(id responseObject) {
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            for (NSDictionary*dic in array) {
                MYYMyOrderClassModer *model=[[MYYMyOrderClassModer alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [arr addObject:model];
            }
            [_prolistArr addObject:arr];
            NSLog(@"dingdan%@",array);
            
        }
        [_tableView reloadData];
        
        
    }];
}

@end
