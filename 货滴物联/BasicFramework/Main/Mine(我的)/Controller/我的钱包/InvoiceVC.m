//
//  InvoiceVC.m
//  BasicFramework
//
//  Created by 钱龙 on 2018/2/27.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "InvoiceVC.h"
#import "InvoiceCell.h"
#import "InvoiceHistoryVC.h"
#import "ShoppingCartViewController.h"
@interface InvoiceVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray *section_one;
@property(nonatomic,strong)NSArray *section_two;
@end

@implementation InvoiceVC
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self.view addSubview:_tableview];
    }
    return _tableview;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开具发票";
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    // Do any additional setup after loading the view.
    _section_one = @[@"同城小件",@"同城搬家",@"货滴快运",@"开票历史"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableview];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * stringCell = @"InvoiceCell";
    InvoiceCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
    }
        cell.label.text = _section_one[indexPath.row];
        if (indexPath.row == 3) {
            cell.line.hidden = YES;
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row == 0) {
            //同城小件
            ShoppingCartViewController * VC = [[ShoppingCartViewController alloc]init];
            VC.ordertype = @"0";
            [self.navigationController pushViewController:VC animated:YES];
        }else if (indexPath.row == 1){
            //同城搬家
            ShoppingCartViewController * VC = [[ShoppingCartViewController alloc]init];
            VC.ordertype = @"1";
            [self.navigationController pushViewController:VC animated:YES];
        }else if (indexPath.row == 2){
            //货滴快运
            ShoppingCartViewController * VC = [[ShoppingCartViewController alloc]init];
            VC.ordertype = @"2";
            [self.navigationController pushViewController:VC animated:YES];
        }else if (indexPath.row == 3){
            //开票历史
            InvoiceHistoryVC * vc = [[InvoiceHistoryVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
}
@end
