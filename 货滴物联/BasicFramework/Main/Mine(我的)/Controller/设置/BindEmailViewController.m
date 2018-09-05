//
//  BindEmailViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/8/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BindEmailViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
@interface BindEmailViewController ()
{
    UITextField* _emailField;
    UITextField* _ecodeField;
    YZXTimeButton* _ecodeBtn;
    NSString* _smscode;
}

@end

@implementation BindEmailViewController
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
    self.navigationItem.title = @"绑定邮箱";
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
- (void)backpop:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    UIImageView* emailimgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, headimgView.bottom +35*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    emailimgView.contentMode = UIViewContentModeScaleAspectFit;
    emailimgView.image = [UIImage imageNamed:@"绑定邮箱"];
    [bgview addSubview:emailimgView];
    
    _emailField = [[UITextField alloc]initWithFrame:CGRectMake(emailimgView.right+20*MYWIDTH, headimgView.bottom + 25*MYWIDTH, kScreenWidth - emailimgView.right - 60*MYWIDTH, 40*MYWIDTH)];
    //[_emailField setBackground:[UIImage imageNamed:@"nameView"]];
    _emailField.placeholder = @"请输入您的邮箱地址";
    //_emailField.textAlignment = NSTextAlignmentCenter;
    _emailField.font = [UIFont systemFontOfSize:12*MYWIDTH];
//    _emailField.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
//    _emailField.layer.borderWidth = 1.0f;//设置边框
    [bgview addSubview:_emailField];
    [Command placeholderColor:_emailField str:_emailField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    
    UIView *bgview2 = [[UIView alloc]initWithFrame:CGRectMake(20*MYWIDTH, _emailField.bottom + 15*MYWIDTH, kScreenWidth-40*MYWIDTH, 40*MYWIDTH)];
    bgview2.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:bgview2];
    
    UIImageView* ecodeimgView = [[UIImageView alloc]initWithFrame:CGRectMake(emailimgView.left, _emailField.bottom + 25*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    ecodeimgView.contentMode = UIViewContentModeScaleAspectFit;
    ecodeimgView.image = [UIImage imageNamed:@"验证码"];
    [bgview addSubview:ecodeimgView];
    _ecodeField = [[UITextField alloc]initWithFrame:CGRectMake(ecodeimgView.right+20*MYWIDTH, _emailField.bottom+15*MYWIDTH, kScreenWidth - ecodeimgView.left*2 - ecodeimgView.width - 20*MYWIDTH - 80*MYWIDTH, 40*MYWIDTH)];
    _ecodeField.placeholder = @"填写验证码";
    //_ecodeField.textAlignment = NSTextAlignmentCenter;
    //[_ecodeField setBackground:[UIImage imageNamed:@"nameView"]];
//    _ecodeField.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
//    _ecodeField.layer.borderWidth = 1.0f;//设置边框
    _ecodeField.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [bgview addSubview:_ecodeField];
    [Command placeholderColor:_ecodeField str:_ecodeField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    _ecodeBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(_ecodeField.right, _ecodeField.top, 80*MYWIDTH, 40*MYWIDTH)];
    [_ecodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_ecodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _ecodeBtn.titleLabel.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _ecodeBtn.backgroundColor = UIColorFromRGB(0xff4b52);
    _ecodeBtn.layer.cornerRadius = 0;
    [bgview addSubview:_ecodeBtn];
    [_ecodeBtn addTarget:self action:@selector(ecodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake(0, kScreenHeight-50*MYWIDTH, kScreenWidth, 50*MYWIDTH);
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setBackgroundColor: UIColorFromRGB(0xff4b52)];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:18*MYWIDTH];
    [self.view addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)ecodeBtnClick:(YZXTimeButton*)sender{
    if (!IsEmptyValue(_emailField.text)&&[Command isValidateEmail:_emailField.text]) {
        sender.recoderTime = @"yes";
        [sender setKaishi:SendTime];
        [self receiveEcodeRequestF];
    }else{
        jxt_showToastTitle(@"邮箱不合法", 1);
    }

}
- (void)okBtnClick:(UIButton*)sender{
    if ([_ecodeField.text isEqualToString:_smscode]&&!IsEmptyValue(_ecodeField.text)) {
        [self dataRequest];
    }else{
        jxt_showToastTitle(@"验证码填写不正确", 1);
    }

}

- (void)receiveEcodeRequestF{
    /*
     /mbtwz/wxcustomer?action=sendEmailNum    获取验证码
     email  邮箱   data传
     */
    NSString* urlstr = @"/mbtwz/register?action=getSMSCodeEmail";
    _emailField.text = [Command convertNull:_emailField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"email\":\"%@\"}",_emailField.text]};
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



- (void)dataRequest{
    /*
     /mbtwz/wxcustomer?action=addEmailNum    点击完成
     email  邮箱
     */
    NSString* urlstr = @"/mbtwz/wxcustomer?action=addEmailNum";
    _emailField.text = [Command convertNull:_emailField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"email\":\"%@\"}",_emailField.text]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"已成功绑定邮箱", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"绑定邮箱失败", 1);
        }
        

    }];

}


@end
