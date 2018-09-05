//
//  MyPurseViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyPurseViewController.h"
#import "MyPurseTableViewCell.h"
#import "InvoiceVC.h"
#import "MyYeEViewController.h"
#import "YouHuiJuanViewController.h"
#import "ScoresViewController.h"
#import "ZhouJieViewController.h"
#import "MeModel.h"
#import "QiandaoViewController.h"

@interface MyPurseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_headtitle;
    UIImageView *_headview;
    NSString *_qianyue;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation MyPurseViewController
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled =NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200*MYWIDTH)];
        bgimage.image = [UIImage imageNamed:@"钱包背景"];
    
        UIImageView *headviewBG = [[UIImageView alloc]initWithFrame:CGRectMake(bgimage.width/2-55*MYWIDTH, bgimage.height/2-75*MYWIDTH, 110*MYWIDTH, 110*MYWIDTH)];
        headviewBG.image = [UIImage imageNamed:@"默认头像BG"];
        headviewBG.layer.masksToBounds = YES;
        headviewBG.layer.cornerRadius = headviewBG.width/2;
        [bgimage addSubview:headviewBG];
        
        _headview = [[UIImageView alloc]initWithFrame:CGRectMake(12*MYWIDTH, 12*MYWIDTH, 86*MYWIDTH, 86*MYWIDTH)];
        _headview.image = [UIImage imageNamed:@"默认头像"];
        _headview.layer.masksToBounds = YES;
        _headview.layer.cornerRadius = _headview.width/2;
        [headviewBG addSubview:_headview];
        
        _headtitle  = [[UILabel alloc]initWithFrame:CGRectMake(0, headviewBG.bottom+10*MYWIDTH, kScreenWidth, 20)];
        _headtitle.text = @"货滴用户";
        _headtitle.textAlignment = NSTextAlignmentCenter;
        _headtitle.textColor = UIColorFromRGB(0x333333);
        _headtitle.font = [UIFont systemFontOfSize:16];
        [bgimage addSubview:_headtitle];
        
        _tableview.tableHeaderView = bgimage;
        
        [_tableview registerClass:[MyPurseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyPurseTableViewCell class])];
        
    }
    return _tableview;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    [self loadNew];
}
- (void)viewDidLoad {

    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    _qianyue = @"0";
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的钱包";
    [self tableview];

}
#pragma 在这里面请求数据
- (void)loadNew
{
    [_dataArr removeAllObjects];
    
    NSString *XWURLStr = @"/mbtwz/personal?action=getPersonalInfo";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:nil FinishedLogin:^(id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的信息%@",array);
        //建立模型
        if (!(responseObject == nil)) {
            MeModel *model=[[MeModel alloc]init];
            [model setValuesForKeysWithDictionary:array[0]];
            //追加数据
            [_dataArr addObject:model];
            [self settitledata];
        }
        [_tableview reloadData];
        
    }];
    
    NSString *XWURLStr2 = @"/mbtwz/logisticssendwz?action=checkUserSign";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr2 Parameters:nil FinishedLogin:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的信息%@  %@",dic,[dic objectForKey:@"msg"]);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            _qianyue = @"1";
        }else{
            _qianyue = @"0";
        }
        [_tableview reloadData];
        
    }];
}
- (void)settitledata{
    MeModel *model = _dataArr[0];
    if ([[NSString stringWithFormat:@"%@",model.custname] isEqualToString:@"(null)"]) {
        _headtitle.text = @"货滴用户";
    }else{
        _headtitle.text = model.custname;
    }
    
    if (![[NSString stringWithFormat:@"%@",model.autoname] isEqualToString:@"(null)"]) {
        NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,model.folder,model.autoname];
        NSLog(@"%@",image);
        [_headview sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_qianyue isEqualToString:@"1"]) {
        return 5;
    }
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [MyPurseTableViewCell class];
    MyPurseTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *data = @[@"余额",@"优惠券",@"积分",@"发票与报销",@"签约用户结算"];
    
    [cell setdata:data[indexPath.row] image:data[indexPath.row] push:nil];
    if (indexPath.row == 0) {
        cell.otherView.text = @"0元";
    }else if (indexPath.row == 1){
        cell.otherView.text = @"0张";
    }else if (indexPath.row == 2){
        cell.otherView.text = @"0积分";
    }
    if (_dataArr.count>0) {
        MeModel *model = _dataArr[0];
        if (indexPath.row == 0) {
            if ([[NSString stringWithFormat:@"%@",model.balance] isEqualToString:@"(null)"]) {
                cell.otherView.text = @"0元";
            }else{
                cell.otherView.text = [NSString stringWithFormat:@"%.2f元",[model.balance floatValue]];
            }
        }else if (indexPath.row == 1){
            if ([[NSString stringWithFormat:@"%@",model.tickets] isEqualToString:@"(null)"]) {
                cell.otherView.text = @"0张";
            }else{
                cell.otherView.text = [NSString stringWithFormat:@"%@张",model.count];
            }
        }else if (indexPath.row == 2){
            if ([[NSString stringWithFormat:@"%@",model.scores] isEqualToString:@"(null)"]) {
                cell.otherView.text = @"0积分";
            }else{
                cell.otherView.text = [NSString stringWithFormat:@"%.2f积分",[model.scores floatValue]];
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MyYeEViewController *MyYuE = [[MyYeEViewController alloc]init];
        [self.navigationController pushViewController:MyYuE animated:YES];
    }else if (indexPath.row == 1){
        YouHuiJuanViewController *YouHuiJuan = [[YouHuiJuanViewController alloc]init];
        if (_dataArr.count>0) {
           // YouHuiJuan.model = _dataArr[0];
        }
        [self.navigationController pushViewController:YouHuiJuan animated:YES];
    }else if (indexPath.row == 2){
        QiandaoViewController *ScoresView = [[QiandaoViewController alloc]init];
        
//        setVc.hidesBottomBarWhenPushed = YES;
//        ScoresViewController *ScoresView = [[ScoresViewController alloc]init];
//        if (_dataArr.count>0) {
//            ScoresView.model = _dataArr[0];
//        }
        [self.navigationController pushViewController:ScoresView animated:YES];
    }else if (indexPath.row == 3){
        InvoiceVC *vc = [[InvoiceVC alloc]init];
//        if (_dataArr.count>0) {
//            vc.model = _dataArr[0];
//        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ZhouJieViewController *zhoujie = [[ZhouJieViewController alloc]init];
        [self.navigationController pushViewController:zhoujie animated:YES];
        
    }
    
    
    NSLog(@"%ld",indexPath.row);
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
