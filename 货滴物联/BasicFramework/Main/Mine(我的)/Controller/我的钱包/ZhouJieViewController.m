//
//  ZhouJieViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/5/17.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ZhouJieViewController.h"
#import "zhoujieTableViewCell.h"
#import "ShoopingCartBottomView.h"
#import "ZhoujieModel.h"
#import "CommitInvoicePageVC.h"
#import "TongChKuaiYOrderDetail.h"
#import "WuliuOrderDetail.h"
#import "TongChBanOrderDetail.h"
#import "Paydetail.h"

@interface ZhouJieViewController ()
<UITableViewDataSource,UITableViewDelegate,ShoopingCartBottomViewDelegate,zhoujieTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;//所有商铺数组
@property (nonatomic, strong) NSMutableArray *selectedShop;//选中的商品数组
@property (nonatomic, strong) ShoopingCartBottomView *bottomView;

@end

@implementation ZhouJieViewController

{
    NSString *allPriceStr;
    
    // 黑色的背景
    UIButton * backBtn;
    // 整个弹出框
    UIView *applyInputView;
    // TextView的输入框
    UITextField * jkTextField;
    NSString *_newUUid;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"签约用户结算";
    [self setUpUI];
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseAliPayTrue:) name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseWXPayTrue:) name:WXPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseWXPayTrueZJ:) name:@"ZJWXPayTrue" object:nil];

}
- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZJWXPayTrue" object:nil];

}
- (void)setUpUI
{
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomView];
}
//网络请求数据
- (void)initData {
    NSString* urlstr = @"/mbtwz/logisticssendwz?action=selectSignOrders";
    [NetWorkManagerTwo requestDataWithURL:[NSString stringWithFormat:@"%@%@",_Environment_Domain,urlstr] requestType:GET parameters:nil loading:YES uploadProgress:^(float progress) {
        
    } success:^(id responseObject, id data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        [_dataSource removeAllObjects];
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            for (NSDictionary* dics in [dic objectForKey:@"response"]) {
                ZhoujieModel *model=[[ZhoujieModel alloc]init];
                [model setValuesForKeysWithDictionary:dics];
                //追加数据
                [_dataSource addObject:model];
            }
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - delegate
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellID = @"zhoujieTableViewCell";
    zhoujieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[zhoujieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.lineLabel.hidden = YES;
    }
    cell.backgroundColor = UIColorFromRGB(0xEEEEEE);
    //刷新cell
    cell.indexPath = indexPath;
    ZhoujieModel *inModel = self.dataSource[indexPath.row];
    [cell setqianyueInfo:inModel];
    
    //计算并刷新价格、刷新结算按钮状态
    [self caculatePrice:inModel];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
//设置自定义的sectionFooter,去除sectionFooter
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZhoujieModel *inModel = self.dataSource[indexPath.row];
    if ([inModel.type intValue]==0) {
        TongChBanOrderDetail *detail = [[TongChBanOrderDetail alloc]init];
        detail.orderStr = inModel.orderno;
        detail.push = @"1";
        detail.custid = inModel.driver_custid;
        [self.navigationController pushViewController:detail animated:YES];
    }else if ([inModel.type intValue]==1){
        WuliuOrderDetail *detail = [[WuliuOrderDetail alloc]init];
        detail.orderStr = inModel.orderno;
        detail.push = @"1";
        detail.custid = inModel.driver_custid;
        [self.navigationController pushViewController:detail animated:YES];
    }else if ([inModel.type intValue]==2){
        TongChKuaiYOrderDetail *detail = [[TongChKuaiYOrderDetail alloc]init];
        detail.orderStr = inModel.orderno;
        detail.push = @"1";
        detail.custid = inModel.driver_custid;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
#pragma mark - ShoopingCartBottomViewDelegate
//全选
- (void)allGoodsIsSelected:(BOOL)selccted withButton:(UIButton *)btn {
    //修改数据源数据，刷新列表
    for (ZhoujieModel *goodsModel in self.dataSource) {
        goodsModel.isSelected = selccted;
    }
    [self.tableView reloadData];
}
//结算
- (void)paySelectedGoods:(UIButton *)btn {
    NSLog(@"结算，选中的有：\n ");
    [self setSMAlertWithView];
}

#pragma mark - ShoppingCartCellDelegate
- (void)cell:(zhoujieTableViewCell *)cell selected:(BOOL)isSelected indexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"section:%ld row:%ld isSelected:%d",indexPath.section,indexPath.row,isSelected);
    //更新选中cell的section下的数据
    ZhoujieModel *inModel = self.dataSource[indexPath.row];
    inModel.isSelected = isSelected;
    //判断整个section是不是全被选中
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL sectionSelected = YES;
        for (ZhoujieModel *inModel in self.dataSource) {
            if (!inModel.isSelected) {
                sectionSelected = NO;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bottomView setIsClick:sectionSelected];
        });
    });
    //    NSLog(@"all section selected:%d",sectionSelected);
    [self.tableView reloadData];
}
#pragma mark - 自定义
- (void)caculatePrice:(ZhoujieModel *)goodsModel{
    @synchronized (self.selectedShop)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (goodsModel.isSelected) {
                if (![self.selectedShop containsObject:goodsModel]) {
                    [self.selectedShop addObject:goodsModel];
                }
            }
            else {
                if ([self.selectedShop containsObject:goodsModel]) {
                    [self.selectedShop removeObject:goodsModel];
                }
            }
            
            NSDecimalNumber *allPriceDecimal = [NSDecimalNumber zero];
            for (ZhoujieModel *goods in self.selectedShop) {
                NSString *price = [NSString stringWithFormat:@"%@",goods.money];
                NSDecimalNumber *decimalPrice = [NSDecimalNumber decimalNumberWithString:price];
                allPriceDecimal = [allPriceDecimal decimalNumberByAdding:decimalPrice];
            }
            allPriceStr = [allPriceDecimal stringValue];
            NSLog(@"总价：%@",allPriceStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([allPriceStr floatValue]>0) {
                    [self.bottomView setPayEnable:YES];
                    self.bottomView.allPriceLabel.text = [NSString stringWithFormat:@"共%@元",[allPriceDecimal stringValue]];
                } else {
                    [self.bottomView setPayEnable:NO];
                    self.bottomView.allPriceLabel.text = [NSString stringWithFormat:@"共%@元",@"0"];
                }
            });
        });
    }
}

#pragma mark - set/get
- (ShoopingCartBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ShoopingCartBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-NavBarHeight-kIPhoneXBottomHeight, kScreenWidth, NavBarHeight)];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight-NavBarHeight-kIPhoneXBottomHeight-NavBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (NSMutableArray *)selectedShop {
    if (!_selectedShop) {
        _selectedShop = [[NSMutableArray alloc] init];
    }
    return _selectedShop;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSLog(@"dealloc");
}

//支付方式弹框
- (void)setSMAlertWithView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, kScreenWidth-60*MYWIDTH, 240*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<3; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 80*MYWIDTH+80*MYWIDTH*i, bgview.width-60*MYWIDTH, 1)];
        xian.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
        [bgview addSubview:xian];
    }
    NSArray *imageArr = @[@"单选_选中",@"单选_未选中",@"单选_未选中"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45*MYWIDTH, 30*MYWIDTH+i*80*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr[i]];
        [bgview addSubview:imageview];
    }
    NSArray *imageArr1 = @[@"未标题-5.1",@"未标题-5.2",@"未标题-5.3"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/3, 25*MYWIDTH+i*80*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr1[i]];
        [bgview addSubview:imageview];
    }
    NSArray *titleArr = @[@"支付宝支付",@"微信支付",@"余额支付"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, 25*MYWIDTH+i*80*MYWIDTH, 200, 30*MYWIDTH)];
        lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        lab.textColor = UIColorFromRGBValueValue(0x333333);
        [bgview addSubview:lab];
    }
    for (int i=0; i<4; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, i*80*MYWIDTH, bgview.width, 80*MYWIDTH)];
        but.tag = 550+i;
        [but addTarget:self action:@selector(zhifuButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:but];
    }
    [SMAlert showCustomView:bgview];
    [SMAlert hideCompletion:^{
        
    }];
}
- (void)zhifuButClicked:(UIButton *)button{
    [SMAlert hide:NO];
    
    
    if (button.tag == 550) {//支付宝
        jxt_showAlertTwoButton(@"提示", @"您确定使用支付宝支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            
            NSString *uuidS;
            int i=0;
            for (ZhoujieModel *inModel in self.dataSource) {
                if (inModel.isSelected) {
                    uuidS = [NSString stringWithFormat:@"%@,%@-%@",uuidS,inModel.type,inModel.uuid];
                    i++;
                }
            }
            _newUUid = [uuidS substringFromIndex:7];
            
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"selectsize\":\"%d\",\"typeuuids\":\"%@\"}",i,_newUUid]};
            
            NSLog(@"%@",params);
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=payBefGetUuid" Parameters:params FinishedLogin:^(id responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if([[dic objectForKey:@"flag"] intValue]==200) {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

                    [Paydetail zhiFuBaoname:@"周结支付" titile:@"周结支付" price:allPriceStr orderId:[NSString stringWithFormat:@"%@_%@",[[dic objectForKey:@"response"][0] objectForKey:@"newuuid"],[user objectForKey:USERID]] notice:@"2"];
                }
                
            }];
            
            
            
            //jxt_showAlertTitle(@"正在开发中");
            
        });
        
        
    }else if (button.tag == 551){//微信支付
        jxt_showAlertTwoButton(@"提示", @"您确定使用微信支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            
            NSString *uuidS;
            int i=0;
            for (ZhoujieModel *inModel in self.dataSource) {
                if (inModel.isSelected) {
                    uuidS = [NSString stringWithFormat:@"%@,%@-%@",uuidS,inModel.type,inModel.uuid];
                    i++;
                }
            }
            _newUUid = [uuidS substringFromIndex:7];
            
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"selectsize\":\"%d\",\"typeuuids\":\"%@\"}",i,_newUUid]};
            
            NSLog(@"%@",params);
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=payBefGetUuid" Parameters:params FinishedLogin:^(id responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if([[dic objectForKey:@"flag"] intValue]==200) {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

                    [Paydetail wxname:@"周结支付" titile:@"周结支付" price:allPriceStr orderId:[NSString stringWithFormat:@"%@_%@",[[dic objectForKey:@"response"][0] objectForKey:@"newuuid"],[user objectForKey:USERID]] notice:@"2"];
                }
                
            }];
            
            
            //jxt_showAlertTitle(@"正在开发中");
            
        });
        
        
    }else if (button.tag == 552){//余额支付
        jxt_showAlertTwoButton(@"提示", @"您确定使用余额支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            //验证密码
            NSString *passwordURLStr = @"/mbtwz/logisticssendwz?action=checkZhiFuPassword";
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:passwordURLStr Parameters:nil FinishedLogin:^(id responseObject) {
                
                NSString* str = [[NSString alloc]initWithData:responseObject encoding:kCFStringEncodingUTF8];
                if ([str rangeOfString:@"false"].location!=NSNotFound) {
                    jxt_showAlertTwoButton(@"温馨提示", @"请到：个人中心-设置-安全中心-设置支付密码中进行设置", @"确定", ^(NSInteger buttonIndex) {
                        ReplacePayPswVC* vc = [[ReplacePayPswVC alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }, @"取消", ^(NSInteger buttonIndex) {
                        
                    });
                }else{
                    [self createUI];
                    [self pushApplyCase];
                }
            }];
        });
    }
    
}
#pragma mark UI的设置
-(void)createUI{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0, UIScreenW,UIScreenH);
    backBtn.backgroundColor = [UIColor cyanColor];
    backBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    backBtn.alpha = 0.2;
    [window addSubview:backBtn];
    
    
    applyInputView = [[UIView alloc]initWithFrame:CGRectMake(25*MYWIDTH, (UIScreenH-175*MYWIDTH)/2, UIScreenW-50*MYWIDTH, 175*MYWIDTH)];
    applyInputView.alpha = 0;
    applyInputView.backgroundColor = [UIColor whiteColor];
    applyInputView.layer.cornerRadius = 10.f;
    applyInputView.clipsToBounds = NO;
    [window addSubview:applyInputView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, 10*MYWIDTH, UIScreenW-40, 18*MYWIDTH)];
    title.text = @"余额支付";
    title.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    [applyInputView addSubview:title];
    
    UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(0, title.bottom+10*MYWIDTH, applyInputView.width, 1)];
    lines.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [applyInputView addSubview:lines];
    UILabel * tfLabel = [[UILabel alloc]initWithFrame:CGRectMake(24*MYWIDTH, lines.bottom+15*MYWIDTH, applyInputView.width-48*MYWIDTH, 42*MYWIDTH)];
    tfLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tfLabel.userInteractionEnabled = YES;
    [applyInputView addSubview:tfLabel];
    jkTextField = [[UITextField alloc]initWithFrame:CGRectMake(10*MYWIDTH, 8*MYWIDTH, tfLabel.width-20*MYWIDTH,30*MYWIDTH)];
    jkTextField.delegate = self;
    jkTextField.textColor = [UIColor blackColor];
    jkTextField.placeholder = @"输入支付密码";
    jkTextField.secureTextEntry = YES;
    jkTextField.textAlignment = NSTextAlignmentCenter;
    jkTextField.font = [UIFont systemFontOfSize:14.0f*MYWIDTH];
    [tfLabel addSubview:jkTextField];
    [Command placeholderColor:jkTextField str:jkTextField.placeholder color:UIColorFromRGBValueValue(0x333333)];
    
    CGFloat btnWidth = (applyInputView.width-60*MYWIDTH)/2;
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(20*MYWIDTH, tfLabel.bottom+25*MYWIDTH, btnWidth, 35*MYWIDTH)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    [sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundColor:MYColor];
    sureButton.layer.cornerRadius = 6.f;
    sureButton.clipsToBounds = YES;
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyInputView addSubview:sureButton];
    
    UIButton *canleButton = [[UIButton alloc]initWithFrame:CGRectMake(sureButton.right+20*MYWIDTH, tfLabel.bottom+25*MYWIDTH, btnWidth, 35*MYWIDTH)];
    [canleButton setTitle:@"取消" forState:UIControlStateNormal];
    [canleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [canleButton setBackgroundColor:UIColorFromRGB(0xCDCDCD)];
    canleButton.titleLabel.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    canleButton.layer.cornerRadius = 6.f;
    canleButton.clipsToBounds = YES;
    [canleButton addTarget:self action:@selector(canle) forControlEvents:UIControlEventTouchUpInside];
    [applyInputView addSubview:canleButton];
}
#pragma mark 取消
-(void)canle{
    [applyInputView removeFromSuperview];
    [backBtn removeFromSuperview];
}

#pragma mark 确定
-(void)sure{
    [jkTextField resignFirstResponder];
    
    if ([jkTextField.text isEqualToString:@""]) {
        jxt_showToastTitle(@"密码不能为空", 1);
    }else{
        NSString *orderS;
        for (ZhoujieModel *inModel in self.dataSource) {
            if (inModel.isSelected) {
                orderS = [NSString stringWithFormat:@"%@,%@",orderS,inModel.orderno];
            }
        }
        orderS = [orderS substringFromIndex:7];

        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"ordernos\":\"%@\",\"paypassword\":\"%@\"}",orderS,jkTextField.text]};
        
        NSLog(@"%@",params);
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=selectSignOrdersToPay" Parameters:params FinishedLogin:^(id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"余额支付状态%@",dic);
            if([[dic objectForKey:@"flag"] intValue]==200) {
                [SMAlert hide:NO];
                [backBtn removeFromSuperview];
                [applyInputView removeFromSuperview];
                [self paySuccess];
            }else{
                
                //NSString *str2 = [str1 substringToIndex:str1.length-1];
                jxt_showAlertOneButton(@"提示", [dic objectForKey:@"msg"], @"确定", ^(NSInteger buttonIndex) {
                });
            }
            
        }];
        
    }
}

- (void)paySuccess{
    self.bottomView.allPriceLabel.text = [NSString stringWithFormat:@"共%@元",@"0"];
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 230*MYWIDTH, 200*MYWIDTH)];
    imageview.userInteractionEnabled = YES;
    imageview.image = [UIImage imageNamed:@"订单提交成功"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.height/2, imageview.width, 30*MYWIDTH)];
    lab.text = @"支付成功";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = UIColorFromRGB(0x333333);
    [imageview addSubview:lab];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, lab.bottom+10*MYWIDTH, imageview.width, 30*MYWIDTH)];
    [but setTitle:@"确定" forState:UIControlStateNormal];
    [but setTitleColor:MYColor forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:18];
    [but addTarget:self action:@selector(fahuodanButClicked) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:but];
    
    [SMAlert showCustomView:imageview];
    [SMAlert hideCompletion:^{
        
        [self initData];
        
    }];
}
-(void)fahuodanButClicked{
    [SMAlert hide:NO];
    [self initData];
}
#pragma mark 弹出申请框
-(void)pushApplyCase{
    
    [UIView animateWithDuration:0.36f animations:^{
        
        backBtn.alpha = 0.48;
        applyInputView.alpha = 1;
        
    }completion:^(BOOL finished) {
        
    }];
}
- (void)getLoadDataBaseAliPayTrue:(NSNotification *)notice{
    NSLog(@"支付结果》》》》%@",notice.userInfo);
    [SMAlert hide:NO];
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
            
            [self paySuccess];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:[notice.userInfo objectForKey:@"memo"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}
- (void)getLoadDataBaseWXPayTrue:(NSNotification *)notice{
    [SMAlert hide:NO];
    [self paySuccess];
}
- (void)getLoadDataBaseWXPayTrueZJ:(NSNotification *)notice{
    [SMAlert hide:NO];
    
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"uuid\":\"%@\"}",_newUUid]};
    
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=alWxSignPayCancelcallback" Parameters:params FinishedLogin:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",[dic objectForKey:@"msg"]);
        if([[dic objectForKey:@"flag"] intValue]==200) {
            
        }else{
            
            
            
        }
        
    }];
}
@end
