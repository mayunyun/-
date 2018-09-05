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
#import "TongChBanOrderDetail.h"
#import "TongChKuaiYOrderDetail.h"

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"订单搜索结果";
    [self tableview];
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
        WuliuOrderDetail *detail = [[WuliuOrderDetail alloc]init];
        detail.orderno = model.orderno;
        detail.custid = model.owner_custid;
        [self.navigationController pushViewController:detail animated:YES];
    }else if ([_typeStr isEqualToString:@"1"]){
        TCHBanJModel *model = _dataArr[indexPath.row];
        TongChBanOrderDetail *detail = [[TongChBanOrderDetail alloc]init];
        detail.orderno = model.owner_orderno;
        detail.custid = model.owner_custid;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        TCHKuaiYModel *model = _dataArr[indexPath.row];
        TongChKuaiYOrderDetail *detail = [[TongChKuaiYOrderDetail alloc]init];
        detail.orderno = model.orderno;
        detail.custid = model.owner_custid;
        [self.navigationController pushViewController:detail animated:YES];
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
        
        [self.view addSubview:_tableview];
        if ([_typeStr isEqualToString:@"0"]) {
            [_tableview registerClass:[TongChXiaoCell class] forCellReuseIdentifier:NSStringFromClass([TongChXiaoCell class])];
        }else if ([_typeStr isEqualToString:@"1"]){
            [_tableview registerClass:[TongChBanCell class] forCellReuseIdentifier:NSStringFromClass([TongChBanCell class])];
        }else{
            [_tableview registerClass:[KuaiYunTableViewCell class] forCellReuseIdentifier:NSStringFromClass([KuaiYunTableViewCell class])];

        }
    }
    return _tableview;
    
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
