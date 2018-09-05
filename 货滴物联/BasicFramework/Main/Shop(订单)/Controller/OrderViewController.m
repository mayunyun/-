//
//  OrderViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/2/28.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "OrderViewController.h"
#import "TCHXiaoJModel.h"
#import "TCHBanJModel.h"
#import "TCHKuaiYModel.h"

#import "TongChXiaoCell.h"
#import "TongChBanCell.h"
#import "KuaiYunTableViewCell.h"

#import "WuliuOrderDetail.h"
#import "WuliuOrderDetail1.h"
#import "TongChBanOrderDetail.h"
#import "TongChBanOrderDetail1.h"

#import "TongChKuaiYOrderDetail1.h"
#import "TongChKuaiYOrderDetail.h"

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation OrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadwithData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"订单搜索结果";
    _dataArr = [[NSMutableArray alloc]init];
    [self tableview];
}
- (void)loadwithData{
    [_dataArr removeAllObjects];

    NSString *url = @"/mbtwz/logisticssendwz?action=searchOrderByParam";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:self.params FinishedLogin:^(id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"搜索订单%@",array);
        if (array.count) {
            for (NSDictionary*dic in array) {
                if ([self.typeStr isEqualToString:@"0"]) {
                    TCHXiaoJModel *model=[[TCHXiaoJModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    //追加数据
                    [_dataArr addObject:model];
                }else if ([self.typeStr isEqualToString:@"1"]){
                    TCHBanJModel *model=[[TCHBanJModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    //追加数据
                    [_dataArr addObject:model];
                }else if ([self.typeStr isEqualToString:@"2"]){
                    TCHKuaiYModel *model=[[TCHKuaiYModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    //追加数据
                    [_dataArr addObject:model];
                }
            }
            
        }else{
            jxt_showAlertTitle(@"暂无搜索结果");
        }
        [_tableview reloadData];

    }];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_typeStr isEqualToString:@"2"]) {
        return 205*MYWIDTH;
    }
    return 240*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_typeStr isEqualToString:@"0"]) {
        Class ZuLinCarClass = [TongChXiaoCell class];
        TongChXiaoCell *cell = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =[UIColor clearColor];
        if (_dataArr.count) {
            NSLog(@"%@",_dataArr);
            TCHXiaoJModel *model = _dataArr[indexPath.row];
            [cell setwithDataModel:model];
        }
        return cell;
    }else if ([_typeStr isEqualToString:@"1"]){
        Class ZuLinCarClass = [TongChBanCell class];
        TongChBanCell *cell = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =[UIColor clearColor];
        if (_dataArr.count) {
            NSLog(@"%@",_dataArr);
            TCHBanJModel *model = _dataArr[indexPath.row];
            [cell setwithDataModel:model];
        }
        return cell;
    }
    Class ZuLinCarClass = [KuaiYunTableViewCell class];
    KuaiYunTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    if (_dataArr.count) {
        NSLog(@"%@",_dataArr);
        TCHKuaiYModel *model = _dataArr[indexPath.row];
        [cell setwithDataModel:model];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_typeStr isEqualToString:@"0"]) {
        TCHXiaoJModel *model = _dataArr[indexPath.row];
        if ([model.paytype intValue]>4) {
            WuliuOrderDetail1 *detail = [[WuliuOrderDetail1 alloc]init];
            detail.model = model;
            detail.hidesBottomBarWhenPushed = YES;;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            WuliuOrderDetail *detail = [[WuliuOrderDetail alloc]init];
            detail.orderStr = model.orderno;
            detail.custid = model.driver_custid;
            detail.hidesBottomBarWhenPushed = YES;;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }else if ([_typeStr isEqualToString:@"1"]){
        TCHBanJModel *model = _dataArr[indexPath.row];
        if ([model.paytype intValue]>4) {
            TCHBanJModel *model = _dataArr[indexPath.row];
            TongChBanOrderDetail1 *detail = [[TongChBanOrderDetail1 alloc]init];
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            TCHBanJModel *model = _dataArr[indexPath.row];
            TongChBanOrderDetail *detail = [[TongChBanOrderDetail alloc]init];
            detail.orderStr = model.owner_orderno;
            detail.custid = model.driver_custid;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
        
    }else{
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
    }
    
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, 1)];
        if (statusbarHeight>20) {
            line.frame = CGRectMake(0, 88, UIScreenW, 1);
        }
        line.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self.view addSubview:line];
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, line.bottom, UIScreenW, UIScreenH-65)];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

        [self.view addSubview:_tableview];
        [_tableview registerClass:[KuaiYunTableViewCell class] forCellReuseIdentifier:NSStringFromClass([KuaiYunTableViewCell class])];
        [_tableview registerClass:[TongChBanCell class] forCellReuseIdentifier:NSStringFromClass([TongChBanCell class])];
        [_tableview registerClass:[TongChXiaoCell class] forCellReuseIdentifier:NSStringFromClass([TongChXiaoCell class])];

    }
    return _tableview;
    
}
- (void)loadNewData{
    [self loadwithData];
    
    [_tableview.mj_header endRefreshing];
    
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
