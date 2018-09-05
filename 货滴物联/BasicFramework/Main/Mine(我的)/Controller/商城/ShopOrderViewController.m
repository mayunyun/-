//
//  ShopOrderViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShopOrderViewController.h"
#import "ShopAddrModel.h"
#import "ShopOrderTableViewCell.h"
#import "MYYMyOrderClassModer.h"
#import "AddressModel.h"
#import "AddressManageViewController.h"
#import "Paydetail.h"
#import "MYYMyOrderViewController.h"
#import "YouHuiJuanViewController.h"
@interface ShopOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_orderId;//订单号
    NSString *_YuENumer;//余额
    NSString *_jifen;//我的积分数

}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic ,strong)AddressModel *addressmodel;
@property(nonatomic,strong)YouHuiModel *youhuimodel;
@end

@implementation ShopOrderViewController

{
    
    UILabel        *_monlab;
    NSMutableArray* _dataArray;//订单商品
    
}
- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-45-NavBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight  = 1.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ShopOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopOrderTableViewCell"];
        [self.view addSubview:_tableView];
        
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 30)];
        food.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableView.tableFooterView = food;
    }
    return _tableView;
}

- (void)viewDidLoad {
    _addressmodel = [[AddressModel alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    
    [self TableView];
    [self fooderUIView];
    [self dataRequest];
    [self getCustAddr];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseAliPayTrue:) name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseWXPayTrue:) name:WXPayTrue object:nil];
    
}
- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayTrue object:nil];
}
- (void)fooderUIView{
    
    //
    UIView *viewal = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenH-45-NavBarHeight, UIScreenW, 45)];
    if (statusbarHeight>20) {
        viewal.frame = CGRectMake(0, UIScreenH-45-NavBarHeight-34, UIScreenW, 45);
    }
    viewal.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewal];
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 1)];
    xian.backgroundColor = UIColorFromRGB(0xefefef);
    [viewal addSubview:xian];
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 60, 20)];
    labe.text = @"总计:";
    labe.textColor = UIColorFromRGB(0x666666);
    [viewal addSubview:labe];
    
    _monlab = [[UILabel alloc]initWithFrame:CGRectMake(60, 12, 200, 20)];
    _monlab.textColor = UIColorFromRGB(0xE41D24);
    _monlab.text = [NSString stringWithFormat:@"￥%@ / 0积分",@"0.00"];

    [viewal addSubview:_monlab];
    
    UIButton *monBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW - 100, 0, 100, 45)];
    [monBut setTitle:@"去支付"forState:UIControlStateNormal];
    if ([_type intValue]==2) {
        [monBut setTitle:@"积分支付"forState:UIControlStateNormal];
    }
    monBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [monBut setBackgroundColor:MYColor];
    [monBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [monBut addTarget:self action:@selector(butwhihGo:) forControlEvents:UIControlEventTouchUpInside];
    [viewal addSubview:monBut];
    
}
//地址
- (UIView *)addressView{
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 80)];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(45, 15, 100, 20)];
    name.text = [NSString stringWithFormat:@"收货人：%@",@""];
    if (!IsEmptyValue(_addressmodel.shcustname)) {
        name.text = [NSString stringWithFormat:@"%@",_addressmodel.shcustname];
    }
    name.font = [UIFont systemFontOfSize:14];
    name.textColor = UIColorFromRGB(0x333333);
    CGSize maximumLabelSize = CGSizeMake(100, 20);
    CGSize expectSize = [name sizeThatFits:maximumLabelSize];
    name.frame = CGRectMake(40, 16, expectSize.width, expectSize.height);
    [view addSubview:name];
    
    UILabel *phonelab = [[UILabel alloc]initWithFrame:CGRectMake(name.size.width+55, 15, 100, 20)];
    phonelab.text = [NSString stringWithFormat:@"%@",@""];
    if (!IsEmptyValue(_addressmodel.shphone)) {
        phonelab.text = [NSString stringWithFormat:@"%@",_addressmodel.shphone];
    }
    phonelab.font = [UIFont systemFontOfSize:14];
    phonelab.textColor = UIColorFromRGB(0x333333);
    [view addSubview:phonelab];
    
    UILabel *addressLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 35, UIScreenW-80, 40)];
    addressLab.text = @"收货地址:";
    if (!IsEmptyValue(_addressmodel.address)) {
        addressLab.text = [NSString stringWithFormat:@"收货地址:   %@",_addressmodel.address];
    }
    addressLab.font = [UIFont systemFontOfSize:12];
    addressLab.numberOfLines = 0;
    addressLab.textColor = UIColorFromRGB(0x666666);
    [view addSubview:addressLab];
    
    UIImageView *xian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 78, UIScreenW, 2)];
    xian.image = [UIImage imageNamed:@"组"];
    [view addSubview:xian];
    
    return view;
}

- (UIView *)xiaojiView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 50*MYWIDTH)];
    view.backgroundColor = [UIColor whiteColor];
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5*MYWIDTH, 80, 20*MYWIDTH)];
//    lab.text = @"运费";
//    lab.font = [UIFont systemFontOfSize:14];
//    lab.textColor = UIColorFromRGB(0x333333);
//    [view addSubview:lab];
//
//    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 25*MYWIDTH, 200, 20*MYWIDTH)];
//    lab1.text = @"物流由顺风物流配送";
//    lab1.font = [UIFont systemFontOfSize:12];
//    lab1.textColor = UIColorFromRGB(0x888888);
//    [view addSubview:lab1];
//
//    UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW-90, 10*MYWIDTH, 80, 30*MYWIDTH)];
//    pay.text = [NSString stringWithFormat:@"￥%d",0];
//    pay.font = [UIFont systemFontOfSize:14];
//    pay.textAlignment = NSTextAlignmentRight;
//    pay.textColor = UIColorFromRGB(0xFFB400);
//    [view addSubview:pay];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15*MYWIDTH, 200, 20*MYWIDTH)];
    lab2.text = @"在线支付 (支付宝、微信、余额支付)";
    if ([_type intValue]==2) {
        lab2.text = @"在线支付 (积分支付)";
    }
    lab2.font = [UIFont systemFontOfSize:12];
    lab2.textColor = UIColorFromRGB(0x888888);
    [view addSubview:lab2];
    return view;
}
#pragma mark 订单提交
- (void)butwhihGo:(UIButton *)but{
    if ([[Command convertNull:_addressmodel.shcustname] isEqualToString:@""]) {
        jxt_showAlertOneButton(@"提示", @"请完善收货信息,填写收货人", @"确定", ^(NSInteger buttonIndex) {
        });
        return;
    }
    if ([[Command convertNull:_addressmodel.shphone] isEqualToString:@""]) {
        jxt_showAlertOneButton(@"提示", @"请完善收货信息,填写联系方式", @"确定", ^(NSInteger buttonIndex) {
        });
        return;
    }
    if ([[Command convertNull:_addressmodel.address] isEqualToString:@""]) {
        jxt_showAlertOneButton(@"提示", @"请完善收货信息,填写收货地址", @"确定", ^(NSInteger buttonIndex) {
        });
        return;
    }
    if ([_type intValue]==1) {//麦商城
        //加载余额
        
        NSString *URLStr = @"/mbtwz/cdxt?action=loadCustomerBalance";
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
            NSString* str = [[NSString alloc]initWithData:responseObject encoding:kCFStringEncodingUTF8];
            if (str.length>2) {
                NSString *str1 = [str substringFromIndex:1];
                
                NSString *str2 = [str1 substringToIndex:str1.length-1];
                NSLog(@"余额>>>>%@",str2);
                if (str2.length>0) {
                    _YuENumer = str2;
                }else{
                    _YuENumer = @"0.00";
                }
            }else{
                _YuENumer = @"0.00";
            }
            
            [self setSMAlertWithView];
            
        }];
    }
    else{//积分商城
        //加载积分

        NSString *URLStr = @"/mbtwz/scshop?action=getCustScores";
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"积分>>>>%@",arr);
            if (arr.count) {
                _jifen = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"scores"]];
                [self setJiFenSMAlertWithView];
            }else{
                jxt_showToastTitle(@"请求剩余积分失败", 1);

            }
            
        }];
    }
    
}
//支付方式弹框
- (void)setSMAlertWithView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];

    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, UIScreenW-60*MYWIDTH, 320*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<3; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 80*MYWIDTH+80*MYWIDTH*i, bgview.width-60*MYWIDTH, 1)];
        xian.backgroundColor = UIColorFromRGB(MYLine);
        [bgview addSubview:xian];
    }
    NSArray *imageArr = @[@"单选_选中",@"单选_未选中",@"单选_未选中",@"单选_未选中"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45*MYWIDTH, 30*MYWIDTH+i*80*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr[i]];
        [bgview addSubview:imageview];
    }
    NSArray *imageArr1 = @[@"未标题-5.1",@"未标题-5.2",@"未标题-5.3",@"积分"];
    for (int i=0; i<imageArr1.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/3, 25*MYWIDTH+i*80*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr1[i]];
        [bgview addSubview:imageview];
    }
    NSArray *titleArr = @[@"支付宝支付",@"微信支付",@"余额支付",@"积分支付"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, 25*MYWIDTH+i*80*MYWIDTH, 200, 30*MYWIDTH)];
        lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        lab.textColor = UIColorFromRGB(0x333333);
        [bgview addSubview:lab];
    }
    UILabel *yueLab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, bgview.bottom-110*MYWIDTH, 200, 30*MYWIDTH)];
    yueLab.text = [NSString stringWithFormat:@"%.2f",[_YuENumer floatValue]];
    yueLab.font = [UIFont systemFontOfSize:12*MYWIDTH];
    yueLab.textColor = [UIColor redColor];
    [bgview addSubview:yueLab];
    
    for (int i=0; i<4; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, i*80*MYWIDTH, bgview.width, 80*MYWIDTH)];
        but.tag = 550+i;
        [but addTarget:self action:@selector(zhifuButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:but];
    }
    [SMAlert showCustomView:bgview];
}
- (void)zhifuButClicked:(UIButton *)button{
    [SMAlert hide:NO];
    NSArray *arr = [_monlab.text componentsSeparatedByString:@" / "];
    NSLog(@"%@",arr);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    if (button.tag == 550) {//支付宝
        jxt_showAlertTwoButton(@"提示", @"您确定使用支付宝支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
//            jxt_showAlertOneButton(@"提示", @"正在开发中",@"确定" , ^(NSInteger buttonIndex) {
//                
//            });
            if ([_youhuimodel.cheap_equal_money floatValue]==0) {
                [Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:[arr[0] substringFromIndex:1] orderId:[NSString stringWithFormat:@"%@-%@-0",_orderId,[user objectForKey:USERID]] notice:@"0"];
            }else{
                [Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:[arr[0] substringFromIndex:1] orderId:[NSString stringWithFormat:@"%@-%@-%@",_orderId,[user objectForKey:USERID],_youhuimodel.couponid] notice:@"0"];
            }
        });
        
        
    }else if (button.tag == 551){//微信支付
        jxt_showAlertTwoButton(@"提示", @"您确定使用微信支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
//            jxt_showAlertOneButton(@"提示", @"正在开发中",@"确定" , ^(NSInteger buttonIndex) {
//
//            });
            if ([_youhuimodel.cheap_equal_money floatValue]==0) {
                [Paydetail wxname:@"货滴充值" titile:@"货滴充值" price:[arr[0] substringFromIndex:1] orderId:[NSString stringWithFormat:@"%@-%@-0",_orderId,[user objectForKey:USERID]] notice:@"0"];
            }else{
                [Paydetail wxname:@"货滴充值" titile:@"货滴充值" price:[arr[0] substringFromIndex:1] orderId:[NSString stringWithFormat:@"%@-%@-%@",_orderId,[user objectForKey:USERID],_youhuimodel.couponid] notice:@"0"];
            }
        });
        
        
    }else if (button.tag == 552){//余额支付
        if ([[arr[0] substringFromIndex:1] floatValue]>[_YuENumer floatValue]) {
            jxt_showAlertOneButton(@"提示", @"余额不足，请进行充值再进行支付", @"确定", ^(NSInteger buttonIndex) {
            });
            return;
        }else{
            jxt_showAlertTwoButton(@"提示", @"您确定使用余额支付吗", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"确定", ^(NSInteger buttonIndex) {
                NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderno\":\"%@\",\"totalmoney\":\"%.2f\",\"conpouid\":\"%@\"}",_orderId,[[arr[0] substringFromIndex:1] floatValue]+[_youhuimodel.cheap_equal_money floatValue],[Command convertNull:_youhuimodel.couponid]]};
                
                NSLog(@"%@",params);
                [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/scshop?action=orderYuEZhiFu" Parameters:params FinishedLogin:^(id responseObject) {
                    NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSLog(@"余额支付状态%@",str);
                    if ([str rangeOfString:@"false"].location!=NSNotFound) {
                        jxt_showAlertOneButton(@"提示", @"余额支付失败", @"确定", ^(NSInteger buttonIndex) {
                        });
                    }
                    if ([str rangeOfString:@"true"].location!=NSNotFound) {
                        MYYMyOrderViewController *mingxi = [[MYYMyOrderViewController alloc]init];
                        mingxi.push = @"pay";
                        [self.navigationController pushViewController:mingxi animated:YES];
                    }
                    
                }];
            });
            
        }
    }else if (button.tag == 553){//积分支付
        
        NSString *URLStr = @"/mbtwz/scshop?action=getCustScores";
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"积分>>>>%@",arr);
            if (arr.count) {
                _jifen = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"scores"]];
                [self JiFenzhifuButClicked];
            }else{
                jxt_showToastTitle(@"请求剩余积分失败", 1);
                
            }
            
        }];
    }
    
    //更新订单地址
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"custaddress\":\"%@\",\"shphone\":\"%@\",\"shcustname\":\"%@\",\"uuid\":\"%@\"}",_addressmodel.provinceid,_addressmodel.cityid,_addressmodel.areaid,_addressmodel.address,_addressmodel.shphone,_addressmodel.shcustname,_uuid]};
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/address?action=updateorderaddress" Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"更新订单地址%@",str);
        
    }];
}
//积分支付弹框
- (void)setJiFenSMAlertWithView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];

    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, UIScreenW-60*MYWIDTH, 80*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45*MYWIDTH, 30*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    imageview.image = [UIImage imageNamed:@"单选_选中"];
    [bgview addSubview:imageview];
    
    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/3, 25*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    imageview1.image = [UIImage imageNamed:@"积分"];
    [bgview addSubview:imageview1];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, 25*MYWIDTH, 200, 30*MYWIDTH)];
    lab.text = @"积分支付";
    lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    lab.textColor = UIColorFromRGB(0x333333);
    [bgview addSubview:lab];
    
    UILabel *yueLab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, lab.bottom, 200, 30*MYWIDTH)];
    yueLab.text = [NSString stringWithFormat:@"%@",_jifen];
    yueLab.font = [UIFont systemFontOfSize:12*MYWIDTH];
    yueLab.textColor = [UIColor redColor];
    [bgview addSubview:yueLab];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bgview.width, 80*MYWIDTH)];
    [but addTarget:self action:@selector(JiFenzhifuButClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:but];
    [SMAlert showCustomView:bgview];
}
- (void)JiFenzhifuButClicked{
    [SMAlert hide:NO];
    NSArray *arr = [_monlab.text componentsSeparatedByString:@" / "];
    NSLog(@"%@",[arr[1] substringToIndex:2]);
    NSString *jifen = arr[1];
    if ([[jifen substringToIndex:jifen.length-2] floatValue]>[_jifen floatValue]) {
        jxt_showAlertOneButton(@"提示", @"积分不足", @"确定", ^(NSInteger buttonIndex) {
        });
        return;
    }else{
        jxt_showAlertTwoButton(@"提示", @"您确定使用积分支付吗", @"取消", ^(NSInteger buttonIndex) {
        }, @"确定", ^(NSInteger buttonIndex) {
            NSDictionary* data = @{@"data":[NSString stringWithFormat:@"{\"orderno\":\"%@\",\"totalmoney\":\"%@\"}",_orderId,[jifen substringToIndex:jifen.length-2]]};
            NSLog(@"%@",data);
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/scshop?action=orderScoresZhiFu" Parameters:data FinishedLogin:^(id responseObject) {
                NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"积分支付状态%@",str);
                if ([str rangeOfString:@"false"].location!=NSNotFound) {
                    jxt_showAlertOneButton(@"提示", @"积分支付失败", @"确定", ^(NSInteger buttonIndex) {
                    });
                }
                if ([str rangeOfString:@"true"].location!=NSNotFound) {
                    MYYMyOrderViewController *mingxi = [[MYYMyOrderViewController alloc]init];
                    mingxi.push = @"pay";
                    [self.navigationController pushViewController:mingxi animated:YES];
                }
                
            }];
        });
    }
    //更新订单地址
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"custaddress\":\"%@\",\"shphone\":\"%@\",\"shcustname\":\"%@\",\"uuid\":\"%@\"}",_addressmodel.provinceid,_addressmodel.cityid,_addressmodel.areaid,_addressmodel.address,_addressmodel.shphone,_addressmodel.shcustname,_uuid]};
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/address?action=updateorderaddress" Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"更新订单地址%@",str);
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_type intValue]==2) {
        return 3;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 2;
    }
    else if (section == 1) {
        return _dataArray.count+1;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15*MYWIDTH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40*MYWIDTH;
        }else{
            return 90*MYWIDTH;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 40*MYWIDTH;
        }else{
            return 140*MYWIDTH;
        }
    }
    return 50*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"dingwei.png"];
            cell.textLabel.text = @"收货地址";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightRed"]];
            image.frame = CGRectMake(UIScreenW - 30*MYWIDTH, 12.5*MYWIDTH, 10*MYWIDTH, 15*MYWIDTH);
            [cell.contentView addSubview:image];
            
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 39*MYWIDTH, UIScreenW, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
        }else{
            [cell.contentView addSubview:[self addressView]];
        }
    }else if (indexPath.section == 3){
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15*MYWIDTH, 100, 20*MYWIDTH)];
        lab1.text = @"是否使用优惠券";
        lab1.font = [UIFont systemFontOfSize:12];
        lab1.textColor = UIColorFromRGB(0x888888);
        [cell.contentView addSubview:lab1];
        
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightRed"]];
        imageview.frame = CGRectMake(UIScreenW-20, 17.5*MYWIDTH, 10*MYWIDTH, 15*MYWIDTH);
        [cell.contentView addSubview:imageview];

        UILabel * yhquanLab = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right, 17.5*MYWIDTH, UIScreenW-150, 15*MYWIDTH)];
        if ([_youhuimodel.cheap_equal_money floatValue]!=0) {
            yhquanLab.text = [NSString stringWithFormat:@"优惠金额:%.2f元",[_youhuimodel.cheap_equal_money floatValue]];
        }
        yhquanLab.textAlignment = NSTextAlignmentRight;
        yhquanLab.font = [UIFont systemFontOfSize:12];
        yhquanLab.textColor = UIColorFromRGB(0x888888);
        [cell.contentView addSubview:yhquanLab];
        
    }else if (indexPath.section == 2){
        cell.contentView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [cell.contentView addSubview:[self xiaojiView]];
    }else{
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"订单.png"];
            cell.textLabel.text = @"商品列表";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            
            UILabel *numer = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW-190, 0, 180, 40*MYWIDTH)];
            numer.text = [NSString stringWithFormat:@"共计%@件商品",@"0"];
            if (!IsEmptyValue(_dataArray)) {
                int count = 0;
                float money = 0.0;
                int moneyJF = 0;
                for (MYYMyOrderClassModer *model in _dataArray) {
                    count = count + [model.count intValue];
                    money = [model.totalmoney floatValue];
                    moneyJF = [model.totaljifen intValue];
                }
                _monlab.text = [NSString stringWithFormat:@"￥%.2f / %d积分",money,moneyJF];
                if ([_youhuimodel.cheap_equal_money floatValue]!=0) {
                    _monlab.text = [NSString stringWithFormat:@"￥%.2f / %d积分",money-[_youhuimodel.cheap_equal_money floatValue],moneyJF];
                }
                
                if ([_type intValue]==2) {
                    _monlab.text = [NSString stringWithFormat:@"%.2f积分",money];
                }
                numer.text = [NSString stringWithFormat:@"共计%d件商品",count];
            }
            numer.font = [UIFont systemFontOfSize:12];
            numer.textAlignment = NSTextAlignmentRight;
            numer.textColor = UIColorFromRGB(0x888888);
            [cell.contentView addSubview:numer];
            
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 39*MYWIDTH, UIScreenW, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
        }else{
            ShopOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopOrderTableViewCell" forIndexPath:indexPath];
            if (!IsEmptyValue(_dataArray)) {
                NSLog(@"%@",_dataArray);
                MYYMyOrderClassModer *model = _dataArray[indexPath.row-1];
                [cell.imgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,model.folder,model.autoname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
                cell.titleLab.text = [NSString stringWithFormat:@"%@",model.proname];
                cell.otherLab.text = [NSString stringWithFormat:@"%@",model.productdes];
                cell.color.text = [NSString stringWithFormat:@"%@",model.color];
                cell.typeLab.text = [NSString stringWithFormat:@"适合车型:%@",model.specification];
                cell.priceLab.text = [NSString stringWithFormat:@"￥%.2f / %@积分",[model.price floatValue],model.price_jf];
                if ([_type intValue]==2) {
                    cell.priceLab.text = [NSString stringWithFormat:@"%@积分",model.price];
                }
                cell.numerLab.text = [NSString stringWithFormat:@"x%@",model.count];
                cell.priceLab.textColor = MYColor;
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        AddressManageViewController *address = [[AddressManageViewController alloc]init];
        address.controller = @"1";
        [address setTransVaule:^(AddressModel * model) {

            _addressmodel.address = model.address;
            _addressmodel.shphone = model.shphone;
            _addressmodel.shcustname = model.shcustname;
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:address animated:YES];
    }else if (indexPath.section == 3){
        YouHuiJuanViewController *youhui = [[YouHuiJuanViewController alloc]init];
        youhui.push = @"1";
        [youhui setYouhuiVaule:^(YouHuiModel *model) {
            MYYMyOrderClassModer *ordermodel = _dataArray[0];
            if ([model.cheap_equal_money floatValue]<[ordermodel.totalmoney floatValue]) {
                _youhuimodel = model;
            }else{
                _youhuimodel = nil;
                jxt_showAlertOneButton(@"提示", @"优惠券金额不可大于等于商品金额", @"确定", ^(NSInteger buttonIndex) {
                    
                });
            }
            [_tableView reloadData];

        }];
        [self.navigationController pushViewController:youhui animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 10)];
    header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return header;
}

- (void)dataRequest{

    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"uuid\":\"%@\"}",_uuid]};
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/scshop?action=getProductOrder_0" Parameters:params FinishedLogin:^(id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",array);
        if (!IsEmptyValue(array)) {
            for (NSDictionary *dic in array) {
                MYYMyOrderClassModer *ClassModer=[[MYYMyOrderClassModer alloc]init];
                [ClassModer setValuesForKeysWithDictionary:dic];
                _orderId = [NSString stringWithFormat:@"%@",ClassModer.orderno];
                [_dataArray addObject:ClassModer];
            }
            [_tableView reloadData];
        }

    }];
}
- (void)getCustAddr{
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/address?action=searchDefaultAddress" Parameters:nil FinishedLogin:^(id responseObject) {

        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",array);
        if (!IsEmptyValue(array)) {
            [_addressmodel setValuesForKeysWithDictionary:array[0]];
        }else{
            _addressmodel = [[AddressModel alloc]init];
        }
        [_tableView reloadData];

    }];
}
- (void)getLoadDataBaseAliPayTrue:(NSNotification *)notice{
    NSLog(@"支付结果》》》》%@",notice.userInfo);
    /*
     {
     result = "{"alipay_trade_app_pay_response":{"code":"10000","msg":"Success","app_id":"2016020201135575","auth_app_id":"2016020201135575","charset":"utf-8","timestamp":"2017-09-11 12:07:04","total_amount":"0.01","trade_no":"2017091121001004730285476459","seller_id":"2088911120626880","out_trade_no":"a259a638a2494216bdad-62"},"sign":"avQ9kA4WQR8XqkDbFUPtNgNtSDV79dKGYo4xfxNClRdXolGr5zvDaRS+3zpECgGK9bQIP1/kkTb/T27S3F7JUxd65aMkMarWECIlu31KYqUBso1HQoIInEh+zU/UzWlQWDQgqlI7bXbAmiSnR5mpXWhiT4k0TrqXoa8UH3WZwLI=","sign_type":"RSA"}";
     resultStatus = "9000";
     memo = ""
     }
     
     {
     result = "";
     resultStatus = "6001";
     memo = "用户中途取消"
     }
     */
    if (notice.userInfo) {
        if ([[notice.userInfo objectForKey:@"resultStatus"] intValue] == 9000 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"充值成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            MYYMyOrderViewController *mingxi = [[MYYMyOrderViewController alloc]init];
            mingxi.push = @"pay";
            [self.navigationController pushViewController:mingxi animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:[notice.userInfo objectForKey:@"memo"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}
- (void)getLoadDataBaseWXPayTrue:(NSNotification *)notice{
    
    jxt_showAlertOneButton(@"支付结果", @"支付结果：成功！", @"确定", ^(NSInteger buttonIndex) {
        MYYMyOrderViewController *mingxi = [[MYYMyOrderViewController alloc]init];
        mingxi.push = @"pay";
        [self.navigationController pushViewController:mingxi animated:YES];
    });
    
}
@end
