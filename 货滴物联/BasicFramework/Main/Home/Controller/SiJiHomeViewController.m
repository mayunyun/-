//
//  SiJiHomeViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/6/15.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "SiJiHomeViewController.h"
#import "MyPurseTableViewCell.h"
#import "XiaZaiViewController.h"
#import "NewXWViewController.h"
#import "wentiViewController.h"
#import "CarHomeViewController.h"
#import "HuodongViewController.h"
#import "CircleViewController.h"
#import "QuestionViewController.h"
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
        //_tableview.scrollEnabled =NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 170*MYWIDTH)];
        bgimage.image = [UIImage imageNamed:@"货主之家Banner"];
        
        _tableview.tableHeaderView = bgimage;
        
        UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 100)];
        _tableview.tableFooterView = foot;
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
    self.navigationItem.title = @"货主之家";
    [self tableview];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [MyPurseTableViewCell class];
    MyPurseTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *data = @[@"用户指南",@"新闻中心",@"常见问题",@"最新活动",@"二手车市场"];
    NSArray *image = @[@"用户指南",@"新闻中心",@"常见问题",@"最新活动",@"二手车"];

    [cell setdata:data[indexPath.row] image:image[indexPath.row] push:nil];
    cell.otherView.text = @"";
    
    return cell;
}   

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        XiaZaiViewController *MyYuE = [[XiaZaiViewController alloc]init];
        MyYuE.push = @"1";
        [self.navigationController pushViewController:MyYuE animated:YES];
        
    }else if (indexPath.row == 1){
        NewXWViewController *regiVc = [[NewXWViewController alloc]init];
        [self.navigationController pushViewController:regiVc animated:YES];
        
    }else if (indexPath.row == 2){
        wentiViewController *aboutwx = [[wentiViewController alloc]init];
        [self.navigationController pushViewController:aboutwx animated:YES];
    }
//    else if(indexPath.row == 3){
//        CarHomeViewController *CarHomeV = [[CarHomeViewController alloc]init];
//        CarHomeV.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:CarHomeV animated:YES];
//    }
    else if (indexPath.row == 3){
        HuodongViewController *HuodongVC = [[HuodongViewController alloc]init];
        HuodongVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:HuodongVC animated:YES];
    }else if (indexPath.row == 4){
        ErSCshopViewController *HuodongVC = [[ErSCshopViewController alloc]init];
        HuodongVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:HuodongVC animated:YES];
    }
    
    
    NSLog(@"%ld",indexPath.row);
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
