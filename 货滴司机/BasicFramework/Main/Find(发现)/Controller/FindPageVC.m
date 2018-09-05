//
//  FindPageVC.m
//  BasicFramework
//
//  Created by 钱龙 on 2018/1/24.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "FindPageVC.h"
#import "FindPageCell.h"
#import "HuodongViewController.h"
#import "CarHomeViewController.h"
#import "DiscoverController.h"
#import "CircleViewController.h"
#import "QuestionViewController.h"
#import "LoginVC.h"
#import "HomeSuYunVC.h"
#import "HomeKuaiYunVC.h"
@interface FindPageVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray * chinaArr;
@property (nonatomic,strong)NSArray * englishArr;
@end

@implementation FindPageVC
{
    UIBarButtonItem *leftBarItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    // Do any additional setup after loading the view.
    _chinaArr = @[@"司机圈子",@"司机回答",@"电车之家",@"最新活动"];
    _englishArr = @[@"Community",@"Q & A",@"Autocar",@"Activity"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBasehuoyunTK:) name:@"huoyunTK" object:nil];

    [self tableview];
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return 84*MYWIDTH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * stringCell = @"FindPageCell";
    FindPageCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftName.text = _chinaArr[indexPath.row];
    cell.rightName.text = _englishArr[indexPath.row];
    cell.bgimgV.userInteractionEnabled = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld行",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Command isloginRequest:^(bool str) {
        if (str) {
            if (indexPath.row == 0){
                CircleViewController * cvc = [[CircleViewController alloc]init];
                cvc.htmlUrl = [NSString stringWithFormat:@"%@/hdsywz/weixin/page/faxianapp/quanzi/quanzi.html",_Environment_Domain];
                cvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cvc animated:YES];
                
            }else if (indexPath.row == 1){
                QuestionViewController * qvc = [[QuestionViewController alloc]init];
                qvc.htmlUrl = [NSString stringWithFormat:@"%@/hdsywz/weixin/page/faxianapp/quanzi/question.html",_Environment_Domain];
                qvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:qvc animated:YES];
            }
            
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            });
        }
    }];
    
    
    if(indexPath.row == 2){
        CarHomeViewController *CarHomeV = [[CarHomeViewController alloc]init];
        CarHomeV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CarHomeV animated:YES];
    }else if (indexPath.row == 3){
        HuodongViewController *HuodongVC = [[HuodongViewController alloc]init];
        HuodongVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:HuodongVC animated:YES];
    }
}
#pragma mark --懒加载
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        //这一行是解决滑不到底的问题
        self.tableview.contentInset = UIEdgeInsetsMake(0, 0, NavBarHeight, 0);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 224*MYWIDTH)];
        headView.backgroundColor = WhiteColor;

        UIImageView * headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 207*MYWIDTH)];
        headImageV.image = [UIImage imageNamed:@"发现_头视图"];
        [headView addSubview:headImageV];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.tableHeaderView = headView;
        _tableview.scrollEnabled = NO;
        [self.view addSubview:_tableview];
    }
    return _tableview;
    
}
- (void)getLoadDataBasehuoyunTK:(NSNotification *)notice{
    
    if (![[[Command getCurrentVC] class] isEqual:[FindPageVC class]]) {
        return;
        
    }
    [Command isloginRequest:^(bool str) {
        if (str) {
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/drivercertification?action=checkDriverSPStatus" Parameters:nil FinishedLogin:^(id responseObject) {
                
                NSString* str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"%@",str);
                if (str.length<10) {
                    jxt_showAlertTitleMessage(@"您还没通过司机认证", @"请到 我的-司机认证 提交相应信息");
                }else if ([str rangeOfString:@"司机已被停用"].location!=NSNotFound){
                    NSString * string = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    jxt_showAlertOneButton(@"提示", string, @"取消", ^(NSInteger buttonIndex) {
                        
                    });
                }else{
                    NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    if ([[Arr[0] objectForKey:@"driver_info_status"] intValue]==1){//审核通过
                        if ([[notice.userInfo objectForKey:@"FH"] isEqualToString:@"SY"]) {
                            HomeSuYunVC *suyun = [[HomeSuYunVC alloc]init];
                            suyun.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:suyun animated:YES];
                        }else{
                            HomeKuaiYunVC *kuaiyun = [[HomeKuaiYunVC alloc]init];
                            kuaiyun.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:kuaiyun animated:YES];
                        }
                    }else{//审核拒绝
                        jxt_showAlertTitleMessage(@"您还没通过司机认证", @"请到 我的-司机认证 提交相应信息");
                    }
                    
                }
                NSLog(@">>%@",str);
                
            }];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
    }];
}
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"huoyunTK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];
    
}
@end
