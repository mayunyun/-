//
//  ShunFengDetailsViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/8/22.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ShunFengDetailsViewController.h"
#import "ShunFengDetailswCell.h"
#import "FreeRideDetailModel.h"
#import "HomeKuaiYunVC.h"
@interface ShunFengDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)FreeRideDetailModel* model;
@end

@implementation ShunFengDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"货滴顺风车详情";
    [self tableview];
    [self loadData];
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, _tableview.bottom, UIScreenW, 45*MYWIDTH)];
    [but setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    [but setTitle:@"选择用车" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:but];
    [but addTarget:self action:@selector(nowClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, statusbarHeight+44, UIScreenW, UIScreenH-45-statusbarHeight-44)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableview.scrollEnabled =NO;

        [self.view addSubview:_tableview];
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 20*MYWIDTH)];
        _tableview.tableHeaderView = headview;
        
        UIView *foodview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 100*MYWIDTH)];
        _tableview.tableFooterView = foodview;
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/2-80*MYWIDTH, 30*MYWIDTH, 160*MYWIDTH, 40*MYWIDTH)];
        [but setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
        but.layer.cornerRadius = 20*MYWIDTH;
        [but setTitle:@"打电话" forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [foodview addSubview:but];
        [but addTarget:self action:@selector(phoneClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        return 60*MYWIDTH;
    }
    return 40*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * stringCell = @"ShunFengDetailswCell";
    ShunFengDetailswCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray* imageArray = @[@"司机姓名",@"起点",@"终点",@"途径",@"总车长",@"总车长",@"出发时间",@"行程发布时间"];
    NSArray* titleArray = @[@"司机姓名",@"起点",@"终点",@"途径",@"总车长",@"可用车长",@"出发时间",@"订单发布时间"];
    NSString* name = [NSString stringWithFormat:@"%@",_model.contactname];
    NSString* start = [NSString stringWithFormat:@"%@%@%@",_model.sprovince,_model.scity,_model.scounty];
    NSString* end = [NSString stringWithFormat:@"%@%@%@",_model.eprovince,_model.ecity,_model.ecounty];
    NSString* middle = [NSString stringWithFormat:@"%@",_model.waytocitysshow];
    NSString* total = [NSString stringWithFormat:@"%@",_model.totalvehicle];
    NSString* available = [NSString stringWithFormat:@"%@",_model.availablevehicle];
    NSString* starttime = [NSString stringWithFormat:@"%@",_model.deptime];
    NSString* creattime = [NSString stringWithFormat:@"%@",_model.cretime];
    NSArray* detailArray = @[name,start,end,middle,total,available,starttime,creattime];
    [cell setDataImage:imageArray[indexPath.row] Title:titleArray[indexPath.row] Detail:detailArray[indexPath.row]];
    return cell;
}
- (void)loadData{
    NSString *URLStr = @"/mbtwz/freeride?action=selectFreeRideDet";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",self.idStr]};
    NSLog(@"参数==%@",params);
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"zulin%@",diction);
        if ([[diction objectForKey:@"response"] count]) {
            for (NSDictionary *dic in [diction objectForKey:@"response"]) {
                NSDictionary* freerideDet = dic[@"freerideDet"];
                //建立模型
                _model=[[FreeRideDetailModel alloc]init];
                [_model setValuesForKeysWithDictionary:freerideDet];
            }
        }
        
        [self.tableview reloadData];
        
        
        
    }];
}

- (void)phoneClick:(UIButton*)sender{
    if (!IsEmptyValue(_model.contactphone)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_model.contactphone]]];
    }
}
- (void)nowClick:(UIButton*)sender{
    jxt_showAlertTwoButton(@"提示", @"确认使用该顺风车吗", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        if ([[Command convertNull:_orderid] isEqualToString:@""]) {
            //检测是否在此顺风车下发布过订单
            NSString *URLStr = @"/mbtwz/freeride?action=checkJoinFreeRideOne";
            
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"frid\":\"%@\"}",self.idStr]};
            NSLog(@"参数==%@",params);
            
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
                NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"zulin%@",diction);
                if ([diction[@"flag"] integerValue] == 200) {
                    [self pushupviewController];
                }else{
                    
                    jxt_showAlertTwoButton(@"您在此顺风车下已发布过订单", @"是否继续发布订单", @"取消", ^(NSInteger buttonIndex) {
                        
                    }, @"继续", ^(NSInteger buttonIndex) {
                        [self pushupviewController];
                    });
                }
                
            }];
            
        }else{
            NSString *URLStr = @"/mbtwz/freeride?action=joinFreeRideOne";
            
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderid\":\"%@\",\"frid\":\"%@\"}",self.orderid,self.idStr]};
            NSLog(@"参数==%@",params);
            
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
                NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"zulin%@",diction);
                if ([diction[@"flag"] integerValue] == 200) {
                    jxt_showAlertOneButton(@"提示", [NSString stringWithFormat:@"%@",diction[@"msg"]], @"确定", ^(NSInteger buttonIndex) {
                        
                    });
                }else{
                    jxt_showAlertOneButton(@"提示", [NSString stringWithFormat:@"%@",diction[@"msg"]], @"确定", ^(NSInteger buttonIndex) {
                        
                    });
                }
                
            }];
        }
    });
}
- (void)pushupviewController{
    [Command isloginRequest:^(bool str) {
        if (str) {
            HomeKuaiYunVC *kuaiyun = [[HomeKuaiYunVC alloc]init];
            kuaiyun.hidesBottomBarWhenPushed = YES;
            kuaiyun.type = @"1";
            kuaiyun.idStr = self.idStr;
            kuaiyun.sprovince = [NSString stringWithFormat:@"%@",_model.sprovince];
            kuaiyun.scity = [NSString stringWithFormat:@"%@",_model.scity];
            kuaiyun.scounty = [NSString stringWithFormat:@"%@",_model.scounty];
            kuaiyun.eprovince = [NSString stringWithFormat:@"%@",_model.eprovince];
            kuaiyun.ecity = [NSString stringWithFormat:@"%@",_model.ecity];
            kuaiyun.ecounty = [NSString stringWithFormat:@"%@",_model.ecounty];

            kuaiyun.Qlocation = CLLocationCoordinate2DMake([_model.slatitude floatValue], [_model.slongitude floatValue]);
            kuaiyun.Zlocation = CLLocationCoordinate2DMake([_model.elatitude floatValue], [_model.elongitude floatValue]);
            [self.navigationController pushViewController:kuaiyun animated:YES];
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
@end
