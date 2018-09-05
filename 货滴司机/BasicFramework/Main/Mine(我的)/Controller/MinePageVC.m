//
//  MinePageVC.m
//  BasicFramework
//
//  Created by 钱龙 on 2018/1/24.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "MinePageVC.h"
#import "LoginVC.h"
#import "SetViewController.h"
#import "MyPurseViewController.h"
#import "MingXiViewController.h"
#import "ShopingClassViewController.h"
#import "HomeSuYunVC.h"
#import "HomeKuaiYunVC.h"
#import "EditInfoPageVC.h"
#import "MeTableViewCell.h"
#import "WuLiuSJRZViewController.h"
#import "WuLiuSjrzIngViewController.h"
#import "WZEnquiriesViewController.h"
#import "WQLStarView.h"
#import "DriverRemarkVC.h"
#import "MinePageVCTableViewCell.h"
#import "MyYeEViewController.h"
#import "YouHuiJuanViewController.h"
#import "ETCRechargeViewController.h"
#import "ErSCshopViewController.h"
#import "HuodongViewController.h"
#import "AboutMeViewController.h"
#import "SaveCenterViewController.h"
#import "XiaZaiViewController.h"
#import "AnswerViewController.h"
#import "wentiViewController.h"
#import "AppDelegate.h"
#import "QiandaoViewController.h"
#import "NewShopingClassViewController.h"

@interface MinePageVC ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_headimage;
    UIImageView *_headview;
    UILabel * _titlelabel;
    NSMutableArray * _dataArr;
    UIImageView *_renzhview;
    UILabel * _renzhlabel;
    
    UIView *_bgView;
    NSString *_versionUrl;
    UIImageView * levImage;
}
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)WQLStarView * xingxingView;
@property (nonatomic,strong)UIView * starV;
@end

@implementation MinePageVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [self ajaxCallbak];

}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBasehuoyunTK:) name:@"huoyunTK" object:nil];
    _dataArr = [[NSMutableArray alloc]init];
    [self initSubViewUI];
    [self tableview];
}
-(void)editInfoClicked{
    
    EditInfoPageVC * vc = [[EditInfoPageVC alloc]init];
    if (!IsEmptyValue(_dataArr)) {
        MeModel* model = [[MeModel alloc]init];
        [model setValuesForKeysWithDictionary:_dataArr[0]];
        vc.model = model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(60*MYWIDTH, _headimage.bottom, kScreenWidth-60*MYWIDTH, UIScreenH-_headimage.bottom-49)];
        _tableview.scrollEnabled =NO;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEFEFEF);
        
        [self.view addSubview:_tableview];
        
        [_tableview registerNib:[UINib nibWithNibName:@"MinePageVCTableViewCell" bundle:nil] forCellReuseIdentifier:@"MinePageVCTableViewCell"];
    }
    return _tableview;
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*MYWIDTH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 10*MYWIDTH)];
    head.backgroundColor = [UIColor clearColor];
    return head;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        return 4;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 70*MYWIDTH;
    }else if (indexPath.section==1){
        return 90*MYWIDTH;
    }
    return 65*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MinePageVCTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MinePageVCTableViewCell"];
    if (!cell) {
        cell=[[MinePageVCTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MinePageVCTableViewCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * arr1 = @[@[@"余额"],@[@"订单"],@[@"司机认证",@"联系客服",@"安全中心",@"用户指南"]];
    NSArray * arr2 = @[@[@"优惠券"],@[@"账单"],@[@"二手车市场",@"关于我们",@"应用下载",@"常见问题"]];
    NSArray * arr3 = @[@[@"ETC充值"],@[@"商城"],@[@"行业资讯",@"版本更新",@"意见与建议",@"退出登录"]];
    cell.lab1.text = arr1[indexPath.section][indexPath.row];
    cell.lab2.text = arr2[indexPath.section][indexPath.row];
    cell.lab3.text = arr3[indexPath.section][indexPath.row];
    NSArray * imagearr1 = @[@[@"余额1"],@[@"订单1"],@[@"实名认证1",@"联系客服1",@"安全中心1",@"用户指南1"]];
    NSArray * imagearr2 = @[@[@"优惠卷1"],@[@"账单1"],@[@"二手车市场1",@"关于我们1",@"应用下载1",@"常见问题1"]];
    NSArray * imagearr3 = @[@[@"发票与报销1"],@[@"商城1"],@[@"最新活动1",@"版本更新1",@"意见与建议1",@"退出登录1"]];
    cell.image1.image = [UIImage imageNamed:imagearr1[indexPath.section][indexPath.row]];
    cell.image2.image = [UIImage imageNamed:imagearr2[indexPath.section][indexPath.row]];
    cell.image3.image = [UIImage imageNamed:imagearr3[indexPath.section][indexPath.row]];
    cell.but1.tag = 110+indexPath.row;
    cell.but2.tag = 210+indexPath.row;
    cell.but3.tag = 310+indexPath.row;
    if (indexPath.section==0) {
        [cell.but1 addTarget:self action:@selector(yueClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.but2 addTarget:self action:@selector(youhuiClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.but3 addTarget:self action:@selector(fapiaoClick) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.section==1){
        [cell.but1 addTarget:self action:@selector(dingdanClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.but2 addTarget:self action:@selector(zhangdanClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.but3 addTarget:self action:@selector(shangchengClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.but1 addTarget:self action:@selector(but1Click:) forControlEvents:UIControlEventTouchUpInside];
        [cell.but2 addTarget:self action:@selector(but2Click:) forControlEvents:UIControlEventTouchUpInside];
        [cell.but3 addTarget:self action:@selector(but3Click:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",indexPath.row);
}
- (void)yueClick{
    [Command isloginRequest:^(bool str) {
        if (str) {
            MyYeEViewController *MyYuE = [[MyYeEViewController alloc]init];
            MyYuE.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:MyYuE animated:YES];
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
- (void)youhuiClick{
    [Command isloginRequest:^(bool str) {
        if (str) {
            YouHuiJuanViewController *YouHuiJuan = [[YouHuiJuanViewController alloc]init];
            YouHuiJuan.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:YouHuiJuan animated:YES];
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
- (void)fapiaoClick{
    [Command isloginRequest:^(bool str) {
        if (str) {
            ETCRechargeViewController *MyYuE = [[ETCRechargeViewController alloc]init];
            MyYuE.push = @"1";
            MyYuE.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:MyYuE animated:YES];
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
- (void)dingdanClick{
    [Command isloginRequest:^(bool str) {
        if (str) {
            self.tabBarController.selectedIndex = 1;
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
- (void)zhangdanClick{
    [Command isloginRequest:^(bool str) {
        if (str) {
            MingXiViewController *regiVc = [[MingXiViewController alloc]init];
            regiVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:regiVc animated:YES];
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
- (void)shangchengClick{
    [Command isloginRequest:^(bool str) {
        if (str) {
            NewShopingClassViewController *regiVc = [[NewShopingClassViewController alloc]init];
            regiVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:regiVc animated:YES];
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
- (void)but1Click:(UIButton *)but{
    [Command isloginRequest:^(bool str) {
        if (str) {
            switch (but.tag) {
                case 110:{
                    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/drivercertification?action=checkDriverSPStatus" Parameters:nil FinishedLogin:^(id responseObject) {
                        
                        NSString* str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        NSLog(@"%@",str);
                        if (str.length<10) {
                            WuLiuSJRZViewController*ZHVC = [[WuLiuSJRZViewController alloc]init];
                            ZHVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:ZHVC animated:YES];
                        }else if ([str rangeOfString:@"司机已被停用"].location!=NSNotFound){
                            NSString * string = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                            jxt_showAlertOneButton(@"提示", string, @"取消", ^(NSInteger buttonIndex) {
                                
                            });
                        }else{
                            NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                            
                            WuLiuSjrzIngViewController*ZHVC = [[WuLiuSjrzIngViewController alloc]init];
                            ZHVC.status = [[Arr[0] objectForKey:@"driver_info_status"] intValue];
                            ZHVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:ZHVC animated:YES];
                            
                        }
                        NSLog(@">>%@",str);
                        
                    }];
                    
                    
                    break;
                }
                case 111:{
                    [self phoneClick];
                    break;
                }
                case 112:{
                    SaveCenterViewController *saveVC = [[SaveCenterViewController alloc]init];
                    saveVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:saveVC animated:YES];
                    break;
                }
                case 113:{
                    ETCRechargeViewController *MyYuE = [[ETCRechargeViewController alloc]init];
                    MyYuE.push = @"3";
                    MyYuE.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:MyYuE animated:YES];
                    break;
                }
                default:
                    break;
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
}
- (void)but2Click:(UIButton *)but{
    [Command isloginRequest:^(bool str) {
        if (str) {
            switch (but.tag) {
                case 210:{
                    ErSCshopViewController *HuodongVC = [[ErSCshopViewController alloc]init];
                    HuodongVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:HuodongVC animated:YES];
                    break;
                }
                case 211:{
                    AboutMeViewController *about = [[AboutMeViewController alloc]init];
                    about.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:about animated:YES];
                    break;
                }
                case 212:{
                    XiaZaiViewController *xiazai = [[XiaZaiViewController alloc]init];
                    xiazai.hidesBottomBarWhenPushed = YES;
                    [self presentViewController:xiazai animated:YES completion:nil];
                    break;
                }
                case 213:{
                    wentiViewController *aboutwx = [[wentiViewController alloc]init];
                    aboutwx.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:aboutwx animated:YES];
                    break;
                }
                default:
                    break;
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
}
- (void)but3Click:(UIButton *)but{
    [Command isloginRequest:^(bool str) {
        if (str) {
            switch (but.tag) {
                case 310:{
                    HuodongViewController *HuodongVC = [[HuodongViewController alloc]init];
                    HuodongVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:HuodongVC animated:YES];
                    break;
                }
                case 311:{
                    [self versionRequest];
                    break;
                }
                case 312:{
                    AnswerViewController* vc = [[AnswerViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 313:{
                    [self tuichuClick];
                    break;
                }
                default:
                    break;
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
}
- (void)initSubViewUI{
    _headimage = [[UIView alloc]initWithFrame:CGRectMake(0, statusbarHeight, UIScreenW, 120*MYWIDTH)];
    _headimage.backgroundColor = UIColorFromRGB(0xff0202);
    [self.view addSubview:_headimage];
    _headimage.userInteractionEnabled = YES;
    
    _headview = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 18*MYWIDTH, 70*MYWIDTH, 70*MYWIDTH)];
    _headview.image = [UIImage imageNamed:@"默认头像"];
    _headview.layer.masksToBounds = YES;
    _headview.layer.cornerRadius = _headview.width/2;
    _headview.userInteractionEnabled = YES;
    [_headimage addSubview:_headview];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editInfoClicked)];
    [_headview addGestureRecognizer:tap];
    
    _titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(_headview.right +10*MYWIDTH, _headview.top+15*MYWIDTH, 150*MYWIDTH, 25*MYWIDTH)];
    _titlelabel.backgroundColor = [UIColor clearColor];
    _titlelabel.textColor = [UIColor whiteColor];
    _titlelabel.text = @"货滴用户";
    _titlelabel.textAlignment = NSTextAlignmentLeft;
    _titlelabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    [_headimage addSubview:_titlelabel];
    
    UIView *renview = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _headview.bottom-10*MYWIDTH, _headview.width, 22*MYWIDTH)];
    renview.backgroundColor = [UIColor blackColor];
    renview.layer.cornerRadius = 6;
    [_headimage addSubview:renview];
    
    _renzhview = [[UIImageView alloc]initWithFrame:CGRectMake(2.5*MYWIDTH, 3.5*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH)];
    _renzhview.image = [UIImage imageNamed:@"未认证"];
    [renview addSubview:_renzhview];
    
    _renzhlabel = [[UILabel alloc]initWithFrame:CGRectMake(_renzhview.right, 0, renview.width-_renzhview.right, 22*MYWIDTH)];
    _renzhlabel.backgroundColor = [UIColor clearColor];
    _renzhlabel.textColor = [UIColor whiteColor];
    _renzhlabel.text = @"未认证";
    _renzhlabel.textAlignment = NSTextAlignmentCenter;
    _renzhlabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13*MYWIDTH];
    [renview addSubview:_renzhlabel];
    
    //星星评价等级
    _starV = [[UIView alloc]initWithFrame:CGRectMake(_headview.right +10*MYWIDTH, _titlelabel.bottom+1*MYWIDTH, 200*MYWIDTH, 20*MYWIDTH)];
    _starV.backgroundColor = [UIColor clearColor];
    [_headimage addSubview:_starV];
    
    levImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3*MYWIDTH, 13.5*MYWIDTH, 17.5*MYWIDTH)];
    //    levImage.backgroundColor = [UIColor redColor];
    levImage.image = [UIImage imageNamed:@"lv0"];
    [_starV addSubview:levImage];
    _xingxingView = [[WQLStarView alloc]initWithFrame:CGRectMake(levImage.right+7*MYWIDTH,1*MYWIDTH, 80*MYWIDTH,20*MYWIDTH) withTotalStar:5 withTotalPoint:5 starSpace:2*MYWIDTH];
    _xingxingView.starAliment = StarAlimentDefault;
    _xingxingView.commentPoint = 0;
    [_starV addSubview:_xingxingView];
    UITapGestureRecognizer * startap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starScore)];
    [_starV addGestureRecognizer:startap];
    
    UIImageView * rArrow = [[UIImageView alloc]initWithFrame:CGRectMake(_xingxingView.right+5*MYWIDTH, 7*MYWIDTH, 8*MYWIDTH, 12*MYWIDTH)];
    rArrow.image = [UIImage imageNamed:@"youjiantou_1"];
    [_starV addSubview:rArrow];
    
    UIButton *qiandao = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-70*MYWIDTH, 18*MYWIDTH, 70*MYWIDTH, 70*MYWIDTH)];
    qiandao.backgroundColor = [UIColor clearColor];
    [qiandao addTarget:self action:@selector(qiandaoClick) forControlEvents:UIControlEventTouchUpInside];
    [_headimage addSubview:qiandao];
    
    UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20*MYWIDTH, 70*MYWIDTH,20*MYWIDTH)];
    label0.text = @"签到";
    label0.textAlignment = NSTextAlignmentCenter;
    label0.textColor = [UIColor yellowColor];
    label0.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [qiandao addSubview:label0];
    
    UIImageView *image0 = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, label0.bottom+5*MYWIDTH, 40*MYWIDTH, 5*MYWIDTH)];
    image0.image = [UIImage imageNamed:@"五星黄色"];
    [qiandao addSubview:image0];
    
    UIView *shuview = [[UIView alloc]initWithFrame:CGRectMake(0, _headimage.bottom, 60*MYWIDTH, UIScreenH-_headimage.bottom)];
    shuview.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:shuview];
    
    UIButton *qianbao = [[UIButton alloc]initWithFrame:CGRectMake(0, 10*MYWIDTH, 60*MYWIDTH, 70*MYWIDTH)];
    qianbao.backgroundColor = UIColorFromRGB(0xff4d4d);
    [shuview addSubview:qianbao];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 5*MYWIDTH, 17*MYWIDTH, 17*MYWIDTH)];
    image1.image = [UIImage imageNamed:@"钱包1"];
    [qianbao addSubview:image1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, image1.bottom, 20*MYWIDTH,qianbao.height-5*MYWIDTH-image1.bottom)];
    label1.text = @"钱\n包";
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:13*MYWIDTH];
    label1.numberOfLines = [label1.text length];
    [qianbao addSubview:label1];
    
    UIButton *wuliu = [[UIButton alloc]initWithFrame:CGRectMake(0, qianbao.bottom+10*MYWIDTH, 60*MYWIDTH, 90*MYWIDTH)];
    wuliu.backgroundColor = UIColorFromRGB(0x4D9DFF);
    [shuview addSubview:wuliu];
    
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(18.5*MYWIDTH, 5*MYWIDTH, 20*MYWIDTH, 16*MYWIDTH)];
    image2.image = [UIImage imageNamed:@"物流1"];
    [wuliu addSubview:image2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, image2.bottom, 20*MYWIDTH,wuliu.height-image2.bottom)];
    label2.text = @"我\n的\n物\n流";
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:13*MYWIDTH];
    label2.numberOfLines = [label2.text length];
    [wuliu addSubview:label2];
    
    UIButton *gongju = [[UIButton alloc]initWithFrame:CGRectMake(0, wuliu.bottom+10*MYWIDTH, 60*MYWIDTH, 260*MYWIDTH)];
    gongju.backgroundColor = UIColorFromRGB(0xC161FF);
    [shuview addSubview:gongju];
    
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(18.5*MYWIDTH, 55*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    image3.image = [UIImage imageNamed:@"工具1"];
    [gongju addSubview:image3];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH,gongju.height)];
    label3.text = @"货\n滴\n工\n具";
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:14*MYWIDTH];
    label3.numberOfLines = [label3.text length];
    [gongju addSubview:label3];
}
-(void)qiandaoClick{
    QiandaoViewController *ScoresView = [[QiandaoViewController alloc]init];
    ScoresView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ScoresView animated:YES];
}
- (void)phoneClick{
    NSString *phone = [NSString stringWithFormat:@"拨打客服电话：%@",@"0531-88807916"];
    jxt_showAlertTwoButton(@"提示", phone, @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"0531-88807916"]]];
    });
    
}

- (void)ajaxCallbak{
    [Command isloginRequest:^(bool str) {
        if (str) {
            [self loadNew];
            [self searchDriverScore];
        }else{
            _headview.image = [UIImage imageNamed:@"默认头像"];
            _titlelabel.text = @"货滴用户";
            _renzhview.image = [UIImage imageNamed:@"未认证"];
            _renzhlabel.text = @"未认证";
            _renzhlabel.textColor = [UIColor whiteColor];
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            });
        }
    }];
}
#pragma 在这里面请求数据
- (void)loadNew
{
    NSString *URLStr = @"/mbtwz/personal?action=getPersonalInfo";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的信息%@",arr);
        [_dataArr removeAllObjects];
        [_dataArr addObjectsFromArray:arr];
        //建立模型
        if (arr.count) {
            MeModel *model=[[MeModel alloc]init];
            [model setValuesForKeysWithDictionary:arr[0]];
            //追加数据
            
            NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,model.folder,model.autoname];
            NSLog(@"%@",image);
            [_headview sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            _titlelabel.text = [NSString stringWithFormat:@"%@",model.custname];
            
        }
        
    }];
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/drivercertification?action=checkDriverSPStatus" Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSString* str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        if (str.length<10) {
            
        }else if ([str rangeOfString:@"司机已被停用"].location!=NSNotFound){
            
        }else{
            _renzhview.image = [UIImage imageNamed:@"已认证"];
            _renzhlabel.text = @"已认证";
            _renzhlabel.textColor = [UIColor yellowColor];
            
        }
        NSLog(@">>%@",str);
        
    }];
    
    
}
- (void)getLoadDataBasehuoyunTK:(NSNotification *)notice{
    
    if (![[[Command getCurrentVC] class] isEqual:[MinePageVC class]]) {
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
- (void)starScore{
    DriverRemarkVC * vc = [[DriverRemarkVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)searchDriverScore{
    NSString *url = @"/mbtwz/find?action=selectDriverEvaluationTotal";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSString * result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"司机评价星分%@",result);
        if ([result isEqualToString:@"\"1\""]){
            _xingxingView.commentPoint = 1;
            levImage.image = [UIImage imageNamed:@"lv1"];
        }else if ([result isEqualToString:@"\"2\""]){
            _xingxingView.commentPoint = 2;
            levImage.image = [UIImage imageNamed:@"lv2"];
        }else if ([result isEqualToString:@"\"3\""]){
            _xingxingView.commentPoint = 3;
            levImage.image = [UIImage imageNamed:@"lv3"];
        }else if ([result isEqualToString:@"\"4\""]){
            _xingxingView.commentPoint = 4;
            levImage.image = [UIImage imageNamed:@"lv4"];
        }else if ([result isEqualToString:@"\"5\""]) {
            _xingxingView.commentPoint = 5;
            levImage.image = [UIImage imageNamed:@"lv5"];
        }else{
            _xingxingView.commentPoint = 0;
            levImage.image = [UIImage imageNamed:@"lv0"];
        }
        
    }];
}
//退出登录
- (void)tuichuClick{
    
    [JXTAlertView showAlertViewWithTitle:@"确认退出登录" message:nil cancelButtonTitle:@"取消"otherButtonTitle:@"确定" cancelButtonBlock:nil otherButtonBlock:^(NSInteger buttonIndex) {
        NSString *URLStr = @"/mbtwz/mallLogin?action=exiteMallLogin";
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"我的登录%@",array);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:USERID];
            [userDefaults removeObjectForKey:USENAME];
            [userDefaults removeObjectForKey:USERPHONE];
            [userDefaults removeObjectForKey:PASSWORD];
            [userDefaults synchronize];
            
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *lona = [[UINavigationController alloc]initWithRootViewController:[[LoginVC alloc]init]];
            del.window.rootViewController = lona;
        }];
    }];
    
}
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"huoyunTK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];
    
}
#pragma mark -－－－－－－－－－－－－－－ 版本更新－－－－－－－－－－－－－－－－－－－－－－－－－－－
//版本更新
- (void)versionRequest{
    /*lxpub/app/version?
     
     action=getVersionInfo
     project=lx
     联祥           applelianxiang
     。。。
     */
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app名字%@",appName);
    NSString *urlStr = [NSString stringWithFormat:@"%@:8004/lxpub/app/version?action=getVersionInfo&project=applehuodisiji",Ver_Address];
    NSDictionary *parameters = @{@"action":@"getVersionInfo",@"project":[NSString stringWithFormat:@"%@",@"applehuodisiji"]};
    [NetWorkManagerTwo requestDataWithURL:urlStr
                              requestType:POST
                               parameters:parameters
                           uploadProgress:nil
                                  success:^(id responseObject,id data)
     {
         NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"版本信息:%@",dic);
         NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
         CFShow((__bridge CFTypeRef)(infoDic));
         NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
         NSLog(@"当前版本号%@",appVersion);
         NSString *version = dic[@"app_version"];
         NSString *nessary = dic[@"app_necessary"];
         _versionUrl = dic[@"app_url"];
         if ([version isEqualToString:appVersion]) {
             //当前版本
             [self setbanbenUIViewed];
         }else if(![version isEqualToString:appVersion]){
             if ([nessary isEqualToString:@"0"]) {
                 //不强制更新
             }else if([nessary isEqualToString:@"1"]){
                 //强制更新
             }
             [self setbanbenUIViewing];
         }
         
     } failure:^(NSError *error) {
         
     }];
    
}


- (void)upButClick:(UIButton*)sender{
    NSString *str = [NSString stringWithFormat:@"%@%@",@"itms-services://?action=download-manifest&url=",_versionUrl];
    NSURL *url = [NSURL URLWithString:str];
    
    [[UIApplication sharedApplication]openURL:url];
    
}
- (void)setbanbenUIViewing{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bgView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/7*2)];
    topview.backgroundColor = [UIColor blackColor];
    topview.alpha = 0.5;
    [_bgView addSubview:topview];
    
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, topview.bottom, kScreenWidth/2 - 125*MYWIDTH, 320*MYWIDTH)];
    leftview.backgroundColor = [UIColor blackColor];
    leftview.alpha = 0.5;
    [_bgView addSubview:leftview];
    
    UIView *rightview = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 + 125*MYWIDTH, topview.bottom, kScreenWidth/2 - 125*MYWIDTH, 320*MYWIDTH)];
    rightview.backgroundColor = [UIColor blackColor];
    rightview.alpha = 0.5;
    [_bgView addSubview:rightview];
    
    UIView *bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight/7*2+320*MYWIDTH, kScreenWidth, kScreenHeight/7*5 - 320*MYWIDTH)];
    bottomview.backgroundColor = [UIColor blackColor];
    bottomview.alpha = 0.5;
    [_bgView addSubview:bottomview];
    
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"版本更新_1"]];
    bgImage.userInteractionEnabled = YES;
    bgImage.frame = CGRectMake(leftview.right-12*MYWIDTH, topview.bottom-12*MYWIDTH, 250*MYWIDTH+24*MYWIDTH, 320*MYWIDTH+24*MYWIDTH);
    [_bgView addSubview:bgImage];
    
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(bgImage.right-30*MYWIDTH, bgImage.top-10*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    [backBut setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(backBanBenClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:backBut];
    
    UIImageView *huojianImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"火箭"]];
    huojianImage.frame = CGRectMake(kScreenWidth/2 - 45*MYWIDTH, bgImage.top - 45*MYWIDTH, 90*MYWIDTH, 150*MYWIDTH);
    [_bgView addSubview:huojianImage];
    
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, bgImage.height/5*2, bgImage.width-60*MYWIDTH, 20)];
    textLab.text = @"新版本优化:";
    textLab.textColor = [UIColor blackColor];
    textLab.font = [UIFont systemFontOfSize:15];
    [bgImage addSubview:textLab];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, textLab.bottom+10, bgImage.width-60*MYWIDTH, 60)];
    titleLab.text = @"1.优化部分机型闪退BUG\n\n2.更换部分图标";
    titleLab.numberOfLines = 0;
    titleLab.textColor = UIColorFromRGBValueValue(0x666666);
    titleLab.font = [UIFont systemFontOfSize:13];
    [bgImage addSubview:titleLab];
    
    UIButton *upBut = [[UIButton alloc]initWithFrame:CGRectMake(30*MYWIDTH, bgImage.height/7*5, bgImage.width-60*MYWIDTH, 40*MYWIDTH)];
    [upBut setBackgroundColor:MYColor forState:UIControlStateNormal];
    upBut.layer.cornerRadius = 5;
    [upBut setTitle:@"立即更新" forState:UIControlStateNormal];
    [upBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgImage addSubview:upBut];
    [upBut addTarget:self action:@selector(upButClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backBanBenClick{
    [_bgView removeFromSuperview];
}
- (void)setbanbenUIViewed{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bgView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/7*2)];
    topview.backgroundColor = [UIColor blackColor];
    topview.alpha = 0.5;
    [_bgView addSubview:topview];
    
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, topview.bottom, kScreenWidth/2 - 125*MYWIDTH, 320*MYWIDTH)];
    leftview.backgroundColor = [UIColor blackColor];
    leftview.alpha = 0.5;
    [_bgView addSubview:leftview];
    
    UIView *rightview = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 + 125*MYWIDTH, topview.bottom, kScreenWidth/2 - 125*MYWIDTH, 320*MYWIDTH)];
    rightview.backgroundColor = [UIColor blackColor];
    rightview.alpha = 0.5;
    [_bgView addSubview:rightview];
    
    UIView *bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight/7*2+320*MYWIDTH, kScreenWidth, kScreenHeight/7*5 - 320*MYWIDTH)];
    bottomview.backgroundColor = [UIColor blackColor];
    bottomview.alpha = 0.5;
    [_bgView addSubview:bottomview];
    
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"版本更新"]];
    bgImage.userInteractionEnabled = YES;
    bgImage.frame = CGRectMake(leftview.right-12*MYWIDTH, topview.bottom-12*MYWIDTH, 250*MYWIDTH+24*MYWIDTH, 320*MYWIDTH+24*MYWIDTH);
    [_bgView addSubview:bgImage];
    
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(bgImage.right-30*MYWIDTH, bgImage.top-10*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    [backBut setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(backBanBenClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:backBut];
    
    UIImageView *huojianImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"火箭"]];
    huojianImage.frame = CGRectMake(kScreenWidth/2 - 45*MYWIDTH, bgImage.top - 45*MYWIDTH, 90*MYWIDTH, 150*MYWIDTH);
    [_bgView addSubview:huojianImage];
    
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, bgImage.height/2, bgImage.width-60*MYWIDTH, 20)];
    textLab.text = @"当前已是最新版本";
    textLab.textColor = [UIColor blackColor];
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = [UIFont systemFontOfSize:17];
    [bgImage addSubview:textLab];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSLog(@"当前版本号%@",appVersion);
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, textLab.bottom+30, bgImage.width-60*MYWIDTH, 60)];
    titleLab.text = [NSString stringWithFormat:@"当前版本号:%@\n\n更新时间:2018/08/24",appVersion];
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = UIColorFromRGBValueValue(0x666666);
    titleLab.font = [UIFont systemFontOfSize:13];
    [bgImage addSubview:titleLab];
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
