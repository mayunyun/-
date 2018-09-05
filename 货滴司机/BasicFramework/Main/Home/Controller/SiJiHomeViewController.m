//
//  SiJiHomeViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/6/15.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "SiJiHomeViewController.h"
#import "MyPurseTableViewCell.h"
#import "ETCRechargeViewController.h"
#import "WZEnquiriesViewController.h"
#import "wentiViewController.h"
#import "ErSCshopViewController.h"

@interface SiJiHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_headtitle;
    UIImageView *_headview;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation SiJiHomeViewController
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88);
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
       // _tableview.scrollEnabled =NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 170*MYWIDTH)];
        bgimage.image = [UIImage imageNamed:@"司机之家bannar"];
        
        _tableview.tableHeaderView = bgimage;
        
        [_tableview registerClass:[MyPurseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyPurseTableViewCell class])];
        
    }
    return _tableview;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"司机之家";
    [self tableview];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [MyPurseTableViewCell class];
    MyPurseTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *data = @[@"用户指南",@"违章查询",@"货运车辆超限超载服务手册",@"常见问题",@"二手车市场"];
    NSArray *image = @[@"用户指南",@"机动车违章查询",@"帮助手册",@"常见问题",@"二手车"];
    [cell setdata:data[indexPath.row] image:image[indexPath.row] push:@"0"];
   cell.otherView.text = @"";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ETCRechargeViewController *MyYuE = [[ETCRechargeViewController alloc]init];
        MyYuE.push = @"3";
        [self.navigationController pushViewController:MyYuE animated:YES];
        
    }else if (indexPath.row == 1){
        WZEnquiriesViewController *regiVc = [[WZEnquiriesViewController alloc]init];
        [self.navigationController pushViewController:regiVc animated:YES];
        
    }else if (indexPath.row == 2){
        
        ETCRechargeViewController *MyYuE = [[ETCRechargeViewController alloc]init];
        MyYuE.push = @"2";
        [self.navigationController pushViewController:MyYuE animated:YES];
    }else if (indexPath.row == 3){
        wentiViewController *aboutwx = [[wentiViewController alloc]init];
        [self.navigationController pushViewController:aboutwx animated:YES];
    }else{
        ErSCshopViewController *regiVc = [[ErSCshopViewController alloc]init];
        regiVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:regiVc animated:YES];
    }
    
    
    
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
