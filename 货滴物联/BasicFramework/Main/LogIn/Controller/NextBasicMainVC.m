//
//  NextBasicMainVC.m
//  BasicFramework
//
//  Created by LONG on 2018/1/29.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "NextBasicMainVC.h"
#import "RegisterVC.h"
#import "ForgetViewViewController.h"
#import "YZXTimeButton.h"

#define SendTime 60
@interface NextBasicMainVC ()<UITextFieldDelegate>
{
    UITextField *_userField;
    UITextField *_pwdField;
    BOOL _isregist;
    YZXTimeButton* _ecodeBtn;
    NSString* _smscode;

}

@end

@implementation NextBasicMainVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViewUI];
    
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
- (void)initSubViewUI{
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-80*MYWIDTH, 100*MYWIDTH, 160*MYWIDTH, 69.2*MYWIDTH)];
    logoImage.image = [UIImage imageNamed:@"huodiLogo"];
    [self.view addSubview:logoImage];
    
    UIImageView* userView = [[UIImageView alloc]initWithFrame:CGRectMake(50*MYWIDTH, logoImage.bottom + 60*MYWIDTH, kScreenWidth-100*MYWIDTH, 50*MYWIDTH)];
    userView.userInteractionEnabled = YES;
    userView.image = [UIImage imageNamed:@"发现_边框"];
    [self.view addSubview:userView];
    UIImageView* userimgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 17.5*MYWIDTH, userView.height - 36.5*MYWIDTH, userView.height - 35*MYWIDTH)];
    userimgView.image = [UIImage imageNamed:@"yonghuming"];
    [userView addSubview:userimgView];
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(userimgView.width+40*MYWIDTH, 10*MYWIDTH, 1, userView.height-20*MYWIDTH)];
    xian.backgroundColor = UIColorFromRGBValueValue(0xCCCCCC);
    [userView addSubview:xian];
    _userField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, userView.width , userView.height)];
    _userField.backgroundColor = [UIColor clearColor];
    _userField.placeholder = @" 请填写您的手机号";
    _userField.keyboardType = UIKeyboardTypeDefault;
    _userField.textAlignment =  NSTextAlignmentCenter;
    _userField.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _userField.textColor = [UIColor blackColor];
    _userField.delegate = self;
    [userView addSubview:_userField];
    [self placeholderColor:_userField str:_userField.placeholder color:[UIColor blackColor]];
    
    
    UIImageView* pwdView = [[UIImageView alloc]initWithFrame:CGRectMake(userView.left, userView.bottom+25*MYWIDTH, userView.width, userView.height)];
    pwdView.userInteractionEnabled = YES;
    pwdView.image = [UIImage imageNamed:@"发现_边框"];
    [self.view addSubview:pwdView];
    UIImageView* pwdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 17.5*MYWIDTH, pwdView.height - 36.5*MYWIDTH, pwdView.height - 35*MYWIDTH)];
    pwdimgView.image = [UIImage imageNamed:@"mima"];
    [pwdView addSubview:pwdimgView];
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(userimgView.width+40*MYWIDTH, 10*MYWIDTH, 1, userView.height-20*MYWIDTH)];
    xian1.backgroundColor = UIColorFromRGBValueValue(0xCCCCCC);
    [pwdView addSubview:xian1];
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(xian1.right, 0, pwdView.width-80*MYWIDTH-xian1.right, pwdView.height)];//- 50
    _pwdField.backgroundColor = [UIColor clearColor];
    _pwdField.placeholder = @" 请输入验证码";
    _pwdField.secureTextEntry = YES;
    _pwdField.textColor = [UIColor blackColor];
    _pwdField.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _pwdField.textAlignment = NSTextAlignmentCenter;
    _pwdField.delegate = self;
    [pwdView addSubview:_pwdField];
    [self placeholderColor:_pwdField str:_pwdField.placeholder color:[UIColor blackColor]];
    
    _ecodeBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(_pwdField.right, 0, 80*MYWIDTH, userView.height)];
    [_ecodeBtn setBackgroundColor:MYColor];
    [_ecodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    _ecodeBtn.titleLabel.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [_ecodeBtn addTarget:self action:@selector(phoneButClick) forControlEvents:UIControlEventTouchUpInside];
    [pwdView addSubview:_ecodeBtn];
    
    UIButton *nextBut = [[UIButton alloc]initWithFrame:CGRectMake(userView.left, pwdView.bottom+(self.view.bottom-pwdView.bottom-userView.height)/2-20*MYWIDTH, userView.width, userView.height)];
    [nextBut setBackgroundColor:MYColor];
    [nextBut setTitle:@"下一步" forState:UIControlStateNormal];
    nextBut.titleLabel.font = [UIFont systemFontOfSize:16*MYWIDTH];
    [nextBut addTarget:self action:@selector(nextButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
}
- (void)phoneButClick{
    [_userField resignFirstResponder];
    if ([Command isMobileNumber:_userField.text]) {
        if ([self.push isEqualToString:@"1"]) {
            [self isExitsPhoneRequest1];
        }else{
            [self isExitsPhoneRequest2];
        }
    }else{
        jxt_showToastTitle(@"手机格式不正确", 1);
    }
}
- (void)isExitsPhoneRequest1{
    /*
     /mbtwz/register?action=isExitsPhone   "+callback1
     phone  放在data中
     */
    _userField.text = [Command convertNull:_userField.text];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_userField.text forKey:@"phone"];
    NSDictionary * parameter = @{@"data":[Command dictionaryToJson:dic]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/register?action=isExitsPhone" Parameters:parameter FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"内容~~~~~~%@",str);
        //true,注册了；false,未注册
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            _isregist = YES;
            if (_isregist) {
                _ecodeBtn.recoderTime = @"yes";
                [_ecodeBtn setKaishi:SendTime];
                [self receiveEcodeRequestF];
            }
        }else{
            _isregist = NO;
            jxt_showToastTitle(@"该手机号已经注册", 1);
        }
    }];
}
- (void)isExitsPhoneRequest2{
    /*
     /mbtwz/register?action=isExitsPhone   "+callback1
     phone  放在data中
     */
    _userField.text = [Command convertNull:_userField.text];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_userField.text forKey:@"phone"];
    NSDictionary * parameter = @{@"data":[Command dictionaryToJson:dic]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/register?action=isExitsPhone" Parameters:parameter FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        //true,注册了；false,未注册
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            _isregist = YES;
            if (_isregist) {
                _ecodeBtn.recoderTime = @"yes";
                [_ecodeBtn setKaishi:SendTime];
                [self receiveEcodeRequestF];
            }
        }else{
            _isregist = NO;
            jxt_showToastTitle(@"该手机号未注册", 1);
        }
    }];
}
- (void)receiveEcodeRequestF{
    
    /*
     /mbtwz/register?action=getSMSCode"+callback1
     参数：phone  放在params中
     */
    NSString* urlstr = @"/mbtwz/register?action=getSMSCode";
    _userField.text = [Command convertNull:_userField.text];
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_userField.text]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSLog(@"内容~~~~~~%@",str);
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"验证码发送失败", 1);
        }else{
            str = [Command replaceAllOthers:str];
            _smscode = [NSString stringWithFormat:@"%@",str];
        }
    }];

}

- (void)nextButClick{
    
    if ([_pwdField.text isEqualToString:_smscode]&&!IsEmptyValue(_pwdField.text)) {
        if ([self.push isEqualToString:@"1"]) {
            RegisterVC *Register = [[RegisterVC alloc]init];
            Register.smscode = _smscode;
            Register.phoneStr = _userField.text;
            [self.navigationController pushViewController:Register animated:YES];
        }else{
            ForgetViewViewController *ForgetView = [[ForgetViewViewController alloc]init];
            ForgetView.smscode = _smscode;
            ForgetView.phoneStr = _userField.text;
            [self.navigationController pushViewController:ForgetView animated:YES];
        }
    }else{
        jxt_showToastTitle(@"验证码输入不正确", 1);
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
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
