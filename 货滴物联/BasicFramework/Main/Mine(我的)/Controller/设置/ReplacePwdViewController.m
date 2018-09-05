//
//  ReplacePwdViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ReplacePwdViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
@interface ReplacePwdViewController ()<UITextFieldDelegate>
{

    YZXTimeButton* _ecodeBtn;
    UIButton* _okBtn;
    UITextField* _phoneField;   //手机号
    UITextField* _ecodeField;   //验证码
    UITextField* _pwdField;     //密码
    UITextField* _againpwdField;//确认密码
    NSString* _smscode;
    BOOL _isregist;
}
@end

@implementation ReplacePwdViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改登录密码";
    [self creatUI];
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



- (void)creatUI{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, UIScreenH)];
    if (statusbarHeight>20) {
        bgview.frame = CGRectMake(0, 88, kScreenWidth, UIScreenH);
    }
    bgview.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [self.view addSubview:bgview];
    
    UIImageView* headimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180*MYWIDTH)];
    headimgView.image = [UIImage imageNamed:@"安全中心banner"];
    [bgview addSubview:headimgView];
    
    UIView *bgview1 = [[UIView alloc]initWithFrame:CGRectMake(20*MYWIDTH, headimgView.bottom + 25*MYWIDTH, kScreenWidth-40*MYWIDTH, 40*MYWIDTH)];
    bgview1.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:bgview1];
    
    UIImageView* phoneimgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, headimgView.bottom + 35*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    phoneimgView.image = [UIImage imageNamed:@"手机号"];
    [bgview addSubview:phoneimgView];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(phoneimgView.right+20*MYWIDTH, headimgView.bottom + 25*MYWIDTH, kScreenWidth - 2*phoneimgView.left - phoneimgView.width - 20*MYWIDTH, 40*MYWIDTH)];
    if ([user objectForKey:USERPHONE]) {
        _phoneField.text = [user objectForKey:USERPHONE];
    }
    [_phoneField setBackground:[UIImage imageNamed:@"nameView"]];
    _phoneField.placeholder = @"请输入您的手机号 ";
    _phoneField.delegate = self;
    _phoneField.textColor = [UIColor blackColor];
    //_phoneField.textAlignment = NSTextAlignmentRight;
    _phoneField.font = [UIFont systemFontOfSize:12*MYWIDTH];
//    _phoneField.layer.masksToBounds = YES;
//    _phoneField.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
//    _phoneField.layer.borderWidth = 1.0f;//设置边框
    [bgview addSubview:_phoneField];
    [Command placeholderColor:_phoneField str:_phoneField.placeholder color:UIColorFromRGBValueValue(0x666666)];

    UIView *bgview2 = [[UIView alloc]initWithFrame:CGRectMake(20*MYWIDTH, _phoneField.bottom + 15*MYWIDTH, kScreenWidth-40*MYWIDTH - 80*MYWIDTH, 40*MYWIDTH)];
    bgview2.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:bgview2];
    
    UIImageView* ecodeimgView = [[UIImageView alloc]initWithFrame:CGRectMake(phoneimgView.left, _phoneField.bottom+25*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    ecodeimgView.image = [UIImage imageNamed:@"验证码"];
    [bgview addSubview:ecodeimgView];
    _ecodeField = [[UITextField alloc]initWithFrame:CGRectMake(ecodeimgView.right+20*MYWIDTH, _phoneField.bottom+15*MYWIDTH, kScreenWidth - ecodeimgView.left*2 - ecodeimgView.width - 20*MYWIDTH - 80*MYWIDTH, _phoneField.height)];
    [_ecodeField setBackground:[UIImage imageNamed:@"nameView"]];
    _ecodeField.placeholder = @"请输入验证码";
    //_ecodeField.textAlignment = NSTextAlignmentCenter;
    _ecodeField.font = _phoneField.font;
//    _ecodeField.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
//    _ecodeField.layer.borderWidth = 1.0f;//设置边框
    [bgview addSubview:_ecodeField];
    [Command placeholderColor:_ecodeField str:_ecodeField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    _ecodeBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(_ecodeField.right, _ecodeField.top, 80*MYWIDTH, _ecodeField.height)];
    [_ecodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_ecodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_ecodeBtn setBackgroundColor:UIColorFromRGB(0xff4b52)];
    _ecodeBtn.titleLabel.font = [UIFont systemFontOfSize:12*MYWIDTH];
    _ecodeBtn.layer.masksToBounds = YES;
    _ecodeBtn.layer.cornerRadius = 0;
    [bgview addSubview:_ecodeBtn];
    [_ecodeBtn addTarget:self action:@selector(ecodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *bgview3 = [[UIView alloc]initWithFrame:CGRectMake(20*MYWIDTH, _ecodeField.bottom + 15*MYWIDTH, kScreenWidth-40*MYWIDTH, 40*MYWIDTH)];
    bgview3.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:bgview3];
    
    UIImageView* pwdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(phoneimgView.left, _ecodeField.bottom+25*MYWIDTH, phoneimgView.width, phoneimgView.height )];
    pwdimgView.image = [UIImage imageNamed:@"密码"];
    [bgview addSubview:pwdimgView];
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(_phoneField.left, _ecodeField.bottom+15*MYWIDTH, _phoneField.width, _phoneField.height)];
    [_pwdField setBackground:[UIImage imageNamed:@"nameView"]];
    _pwdField.placeholder = @"请设置新密码 ";
    _pwdField.secureTextEntry = YES;
    //_pwdField.textAlignment = NSTextAlignmentRight;
    _pwdField.font = _ecodeField.font;
//    _pwdField.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
//    _pwdField.layer.borderWidth = 1.0f;//设置边框
    [bgview addSubview:_pwdField];
    [Command placeholderColor:_pwdField str:_pwdField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    UIView *bgview4 = [[UIView alloc]initWithFrame:CGRectMake(20*MYWIDTH, _pwdField.bottom + 15*MYWIDTH, kScreenWidth-40*MYWIDTH, 40*MYWIDTH)];
    bgview4.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:bgview4];
    
    UIImageView* againimgView = [[UIImageView alloc]initWithFrame:CGRectMake(pwdimgView.left, _pwdField.bottom+25*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    againimgView.image= [UIImage imageNamed:@"密码"];
    [bgview addSubview:againimgView];
    _againpwdField = [[UITextField alloc]initWithFrame:CGRectMake(againimgView.right+20*MYWIDTH, _pwdField.bottom+15*MYWIDTH, _pwdField.width, _pwdField.height)];
    [_againpwdField setBackground:[UIImage imageNamed:@"nameView"]];
    //_againpwdField.textAlignment = NSTextAlignmentRight;
    _againpwdField.placeholder = @"请再次确认新密码 ";
    _againpwdField.secureTextEntry = YES;
    _againpwdField.font = _pwdField.font;
//    _againpwdField.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
//    _againpwdField.layer.borderWidth = 1.0f;//设置边框
    [bgview addSubview:_againpwdField];
    [Command placeholderColor:_againpwdField str:_againpwdField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    _okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _okBtn.frame = CGRectMake(0, kScreenHeight-50*MYWIDTH, kScreenWidth, 50*MYWIDTH);
    [_okBtn setBackgroundColor:UIColorFromRGB(0xff4b52)];
    [_okBtn setTitle:@"完  成" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _okBtn.titleLabel.font = [UIFont systemFontOfSize:18*MYWIDTH];
    [self.view addSubview:_okBtn];
    [_okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)ecodeBtnClick:(UIButton*)seder{
    [_phoneField resignFirstResponder];
    if ([Command isMobileNumber:_phoneField.text]) {
        NSString* phone = [[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE];
        if ([_phoneField.text isEqualToString:phone]) {
            [self isExitsPhoneRequest];
        }else{
            jxt_showToastTitle(@"此手机号不是当前登录用户", 1);
        }
    }else{
        jxt_showToastTitle(@"手机号格式不正确", 1);
    }
    

}

- (void)okBtnClick:(UIButton*)sender{
    if ([_ecodeField.text isEqualToString:_smscode]&&!IsEmptyValue(_ecodeField.text)) {
        if ([Command isPassword:_pwdField.text]) {
            if ([_pwdField.text isEqualToString:_againpwdField.text]&&!IsEmptyValue(_pwdField.text)) {
                [self registRequest];
                
            }else{
                jxt_showToastTitle(@"两次输入的密码不一致", 1);
            }
        }else{
            jxt_showAlertOneButton(@"密码格式不正确", @"由数字、字母、下划线组成的6—15位密码", @"确定", ^(NSInteger buttonIndex) {
                
            });
        }

    }else{
        jxt_showToastTitle(@"验证码输入不正确", 1);
    }
}

- (void)isExitsPhoneRequest{
    /*
     /mbtwz/register?action=isExitsPhone   "+callback1
     phone  放在data中
     */
    _phoneField.text = [Command convertNull:_phoneField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/register?action=isExitsPhone" Parameters:params FinishedLogin:^(id responseObject) {
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
    _phoneField.text = [Command convertNull:_phoneField.text];
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"验证码发送失败", 1);
        }else{
            str = [Command replaceAllOthers:str];
            _smscode = [NSString stringWithFormat:@"%@",str];
        }
        
    }];
    
    
}



- (void)registRequest{
    /*
     /mbtwz/register?action=upPassword"+callback1
     参数：phone password 放在data中
     */
    NSString* urlstr = @"/mbtwz/register?action=upPassword";
    _phoneField.text = [Command convertNull:_phoneField.text];
    _pwdField.text = [Command convertNull:_pwdField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\",\"password\":\"%@\"}",_phoneField.text,_pwdField.text]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"密码修改成功", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"密码修改失败", 1);
        }
        
    }];
    
    
}


@end
