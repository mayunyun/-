//
//  ChongZhiViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/9/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChongZhiViewController.h"
#import "Paydetail.h"
#import "MingXiViewController.h"
#define Heihht 20*MYWIDTH
@interface ChongZhiViewController ()<UITextFieldDelegate>
{
    UITextField *_textField;
    NSArray *_arr;
    UIButton *_zhifuBut;
}
@property (nonatomic,strong)NSString* payMoney;//钱数
@property (nonatomic,strong)NSString* orderId;//单号
@end

@implementation ChongZhiViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _zhifuBut.enabled = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"账户充值";
    [self setChongzhiUIView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseAliPayTrue:) name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseWXPayTrue:) name:WXPayTrue object:nil];

    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
}
- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayTrue object:nil];
}
- (void)setChongzhiUIView{
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, 8*MYWIDTH)];
    
    bgview.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [self.view addSubview:bgview];
    
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, bgview.bottom+20*MYWIDTH, 60, 0*MYWIDTH)];
    textLab.text = @"充值金额";
    textLab.textColor = MYColor;
    textLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textLab];
    
    CGFloat Butbottom = 0.0;
    _arr = @[@"30元",@"50元",@"100元",@"200元",@"300元",@"500元"];
    for (int i=0; i<_arr.count; i++) {
        int x = i%3;//行
        int y = i/3;//列
        CGFloat w = UIScreenW/3-20*MYWIDTH;//宽
        CGFloat h = w/2;//高
        UIButton *numerbtn = [[UIButton alloc]init];
        [numerbtn setFrame:CGRectMake(15*MYWIDTH*(x+1)+w*x,textLab.bottom + Heihht*(y+1)+h*y, w, h)];
        numerbtn.tag = i+130;
        [numerbtn setBackgroundImage:[UIImage imageNamed:@"灰框"] forState:UIControlStateNormal];
        [numerbtn setBackgroundImage:[UIImage imageNamed:@"亮框"] forState:UIControlStateSelected];
        [numerbtn setTitle:_arr[i] forState:UIControlStateNormal];
        numerbtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [numerbtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [numerbtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [numerbtn addTarget:self action:@selector(numerbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:numerbtn];
        if (i == 0) {
            _payMoney = _arr[i];
            numerbtn.selected = YES;
            [numerbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }
        Butbottom = numerbtn.bottom;
    }
    
    UILabel *textLab1 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, Butbottom+Heihht*1.5, 60, 20*MYWIDTH)];
    textLab1.text = @"其他金额";
    textLab1.textColor = UIColorFromRGB(0x333333);
    textLab1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textLab1];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(30*MYWIDTH+textLab1.right, textLab1.top-12.5*MYWIDTH, 150*MYWIDTH, 45*MYWIDTH)];
    _textField.backgroundColor = UIColorFromRGB(0xEEEEEE);
//    _textField.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;//边框颜色
//    _textField.layer.borderWidth = 1;//边框宽度
    _textField.layer.cornerRadius = 5.0;
//    _textField.placeholder = @"如1000";
    _textField.delegate = self;
    _textField.textAlignment =  NSTextAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:13];
    _textField.textColor = [UIColor blackColor];
    _textField.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:_textField];
    
    UILabel *yuanLab = [[UILabel alloc]initWithFrame:CGRectMake(_textField.right+10, textLab1.top, 30, 20*MYWIDTH)];
    yuanLab.text = @"元";
    yuanLab.textColor = UIColorFromRGB(0x333333);
    yuanLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:yuanLab];
    
    //
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, _textField.bottom+Heihht*1.5, UIScreenW, 8*MYWIDTH)];
    xian.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [self.view addSubview:xian];
    
    UILabel *textLab2 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian.bottom+Heihht*1.2, 60, 20*MYWIDTH)];
    textLab2.text = @"充值方式";
    textLab2.textColor = MYColor;
    textLab2.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textLab2];
    
    UIImageView *zhiImage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, textLab2.bottom+Heihht, 30*MYWIDTH, 30*MYWIDTH)];
    zhiImage.image = [UIImage imageNamed:@"未标题-5.1"];
    [self.view addSubview:zhiImage];
    
    UILabel *textLab3 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+zhiImage.right, zhiImage.top, 80, 30*MYWIDTH)];
    textLab3.text = @"支付宝支付";
    textLab3.textColor = UIColorFromRGB(0x333333);
    textLab3.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textLab3];
    
    UIButton *chooseBut = [[UIButton alloc]init];
    [chooseBut setFrame:CGRectMake(UIScreenW-50*MYWIDTH,zhiImage.top, 30*MYWIDTH, 30*MYWIDTH)];
    ;
    chooseBut.tag = 210;
    chooseBut.selected = YES;
    [chooseBut setImage:[UIImage imageNamed:@"单选_未选中"] forState:UIControlStateNormal];
    [chooseBut setImage:[UIImage imageNamed:@"单选_选中"] forState:UIControlStateSelected];
    [chooseBut addTarget:self action:@selector(chooseButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBut];
    
    UIImageView *weiImage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, zhiImage.bottom+Heihht+3*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    weiImage.image = [UIImage imageNamed:@"未标题-5.2"];
    [self.view addSubview:weiImage];
    
    UILabel *textLab4 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+weiImage.right, weiImage.top, 80, 30*MYWIDTH)];
    textLab4.text = @"微信支付";
    textLab4.textColor = UIColorFromRGB(0x333333);
    textLab4.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textLab4];
    
    UIButton *chooseBut1 = [[UIButton alloc]init];
    [chooseBut1 setFrame:CGRectMake(UIScreenW-50*MYWIDTH,weiImage.top, 30*MYWIDTH, 30*MYWIDTH)];
    ;
    chooseBut1.tag = 211;
    [chooseBut1 setImage:[UIImage imageNamed:@"单选_未选中"] forState:UIControlStateNormal];
    [chooseBut1 setImage:[UIImage imageNamed:@"单选_选中"] forState:UIControlStateSelected];
    [chooseBut1 addTarget:self action:@selector(chooseButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBut1];
    
    _zhifuBut = [[UIButton alloc]init];
    [_zhifuBut setFrame:CGRectMake(0,kScreenHeight-60*MYWIDTH, UIScreenW, 60*MYWIDTH)];
    ;
    [_zhifuBut setBackgroundColor:MYColor];
    [_zhifuBut setTitle:@"确认支付" forState:UIControlStateNormal];
    [_zhifuBut addTarget:self action:@selector(zhifuButClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zhifuBut];
}
//选择支付金额
-(void)numerbtnClicked:(UIButton *)but{
    for (int i=0; i<6; i++) {
        UIButton *button = [self.view viewWithTag:i+130];
        button.selected = NO;
        _textField.text = nil;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
    _payMoney = _arr[but.tag-130];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    but.selected = YES;
}
//选择支付方式
- (void)chooseButClicked:(UIButton *)but{
    UIButton *zbutton = [self.view viewWithTag:210];
    UIButton *wbutton = [self.view viewWithTag:211];
    zbutton.selected = NO;
    wbutton.selected = NO;
    but.selected = YES;

}
//确认支付
- (void)zhifuButClicked{
    if ([_payMoney floatValue]<=0) {
        jxt_showToastTitle(@"请选择充值金额", 1);
    }else{
        _zhifuBut.enabled = NO;
        [self loadNew];
    }
}
#pragma 在这里面获取单号
- (void)loadNew
{

    NSString *URL = @"/weixinzhifu?action=getChongzhiDanHao";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URL Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSString *str0 = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"订单号：%@",str0);
        NSString *str1 = [str0 substringFromIndex:1];
        
        NSString *str2 = [str1 substringToIndex:str1.length-1];
        
        _orderId = str2;
        
        UIButton *zbutton = [self.view viewWithTag:210];
        UIButton *wbutton = [self.view viewWithTag:211];
        
        NSLog(@"钱数%@,订单号%@",_payMoney,_orderId);
        _zhifuBut.enabled = YES;
        if (zbutton.selected == YES) {
            [Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:_payMoney orderId:_orderId notice:@"1"];
        }else if (wbutton.selected == YES){////@"0.01"
            [Paydetail wxname:@"货滴充值" titile:@"货滴充值" price:_payMoney orderId:_orderId notice:@"1"];
        }
        NSLog(@">>>%@   %@",str0,str2);
        
    }];
}
- (void)getLoadDataBaseAliPayTrue:(NSNotification *)notice{
    NSLog(@"祝福结果》》》》%@",notice.userInfo);
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
            MingXiViewController *mingxi = [[MingXiViewController alloc]init];
            mingxi.controller = @"pay";
            [self.navigationController pushViewController:mingxi animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:[notice.userInfo objectForKey:@"memo"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}
- (void)getLoadDataBaseWXPayTrue:(NSNotification *)notice{
    
    jxt_showAlertOneButton(@"支付结果", @"支付结果：成功！", @"确定", ^(NSInteger buttonIndex) {
        MingXiViewController *mingxi = [[MingXiViewController alloc]init];
        mingxi.controller = @"pay";
        [self.navigationController pushViewController:mingxi animated:YES];
    });
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"已经停止编辑");
    for (int i=0; i<6; i++) {
        UIButton *button = [self.view viewWithTag:i+130];
        button.selected = NO;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
    _payMoney = textField.text;

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
