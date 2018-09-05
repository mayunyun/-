//
//  RegisterVC.m
//  BasicFramework
//
//  Created by LONG on 2018/1/26.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()<UITextFieldDelegate>
{
    UITextField *_userField;
    UITextField *_pwdField;
    UITextField *_pwdField1;
    UITextField *_pwdField2;

}
@end

@implementation RegisterVC
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
    
    UIImageView* userView = [[UIImageView alloc]initWithFrame:CGRectMake(50*MYWIDTH, logoImage.bottom + 50*MYWIDTH, kScreenWidth-100*MYWIDTH, 50*MYWIDTH)];
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
    _userField.placeholder = @" 请填写您的用户名";
    _userField.keyboardType = UIKeyboardTypeDefault;
    _userField.textAlignment =  NSTextAlignmentCenter;
    _userField.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _userField.textColor = [UIColor blackColor];
    _userField.delegate = self;
    [userView addSubview:_userField];
    [self placeholderColor:_userField str:_userField.placeholder color:[UIColor blackColor]];
    
    
    UIImageView* pwdView = [[UIImageView alloc]initWithFrame:CGRectMake(userView.left, userView.bottom+20*MYWIDTH, userView.width, userView.height)];
    pwdView.userInteractionEnabled = YES;
    pwdView.image = [UIImage imageNamed:@"发现_边框"];
    [self.view addSubview:pwdView];
    UIImageView* pwdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 17.5*MYWIDTH, pwdView.height - 36.5*MYWIDTH, pwdView.height - 35*MYWIDTH)];
    pwdimgView.image = [UIImage imageNamed:@"mima"];
    [pwdView addSubview:pwdimgView];
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(userimgView.width+40*MYWIDTH, 10*MYWIDTH, 1, userView.height-20*MYWIDTH)];
    xian1.backgroundColor = UIColorFromRGBValueValue(0xCCCCCC);
    [pwdView addSubview:xian1];
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, pwdView.width , pwdView.height)];//- 50
    _pwdField.backgroundColor = [UIColor clearColor];
    _pwdField.placeholder = @"请填写密码";
    _pwdField.secureTextEntry = YES;
    _pwdField.textColor = [UIColor blackColor];
    _pwdField.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _pwdField.textAlignment = NSTextAlignmentCenter;
    _pwdField.delegate = self;
    [pwdView addSubview:_pwdField];
    [self placeholderColor:_pwdField str:_pwdField.placeholder color:[UIColor blackColor]];
    
    UILabel *other = [[UILabel alloc]initWithFrame:CGRectMake(userView.left, pwdView.bottom, userView.width, 20*MYWIDTH)];
    other.text = @"由数字、字母、下划线组成的6—15位密码";
    other.textColor = MYColor;
    other.font = [UIFont systemFontOfSize:10*MYWIDTH];
    other.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:other];
    
    UIImageView* pwdView1 = [[UIImageView alloc]initWithFrame:CGRectMake(userView.left, pwdView.bottom+25*MYWIDTH, userView.width, userView.height)];
    pwdView1.userInteractionEnabled = YES;
    pwdView1.image = [UIImage imageNamed:@"发现_边框"];
    [self.view addSubview:pwdView1];
    UIImageView* pwdimgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 17.5*MYWIDTH, pwdView.height - 36.5*MYWIDTH, pwdView.height - 35*MYWIDTH)];
    pwdimgView1.image = [UIImage imageNamed:@"mima"];
    [pwdView1 addSubview:pwdimgView1];
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(userimgView.width+40*MYWIDTH, 10*MYWIDTH, 1, userView.height-20*MYWIDTH)];
    xian2.backgroundColor = UIColorFromRGBValueValue(0xCCCCCC);
    [pwdView1 addSubview:xian2];
    _pwdField1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, pwdView1.width , pwdView1.height)];//- 50
    _pwdField1.backgroundColor = [UIColor clearColor];
    _pwdField1.placeholder = @"请确认密码";
    _pwdField1.secureTextEntry = YES;
    _pwdField1.textColor = [UIColor blackColor];
    _pwdField1.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _pwdField1.textAlignment = NSTextAlignmentCenter;
    _pwdField1.delegate = self;
    [pwdView1 addSubview:_pwdField1];
    [self placeholderColor:_pwdField1 str:_pwdField1.placeholder color:[UIColor blackColor]];
    
    UIImageView* pwdView2 = [[UIImageView alloc]initWithFrame:CGRectMake(userView.left, pwdView1.bottom+20*MYWIDTH, userView.width, userView.height)];
    pwdView2.userInteractionEnabled = YES;
    pwdView2.image = [UIImage imageNamed:@"发现_边框"];
    [self.view addSubview:pwdView2];
    UIImageView* pwdimgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 17.5*MYWIDTH, pwdView.height - 36.5*MYWIDTH, pwdView.height - 35*MYWIDTH)];
    pwdimgView2.image = [UIImage imageNamed:@"mima"];
    [pwdView2 addSubview:pwdimgView2];
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(userimgView.width+40*MYWIDTH, 10*MYWIDTH, 1, userView.height-20*MYWIDTH)];
    xian3.backgroundColor = UIColorFromRGBValueValue(0xCCCCCC);
    [pwdView2 addSubview:xian3];
    _pwdField2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, pwdView1.width , pwdView1.height)];//- 50
    _pwdField2.backgroundColor = [UIColor clearColor];
    _pwdField2.placeholder = @"请填写支付密码";
    _pwdField2.secureTextEntry = YES;
    _pwdField2.textColor = [UIColor blackColor];
    _pwdField2.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _pwdField2.textAlignment = NSTextAlignmentCenter;
    _pwdField2.delegate = self;
    [pwdView2 addSubview:_pwdField2];
    [self placeholderColor:_pwdField2 str:_pwdField2.placeholder color:[UIColor blackColor]];
    
    
    UIButton *nextBut = [[UIButton alloc]initWithFrame:CGRectMake(userView.left, pwdView2.bottom+(self.view.bottom-pwdView2.bottom-userView.height)/2-20*MYWIDTH, userView.width, userView.height)];
    [nextBut setBackgroundColor:MYColor];
    [nextBut setTitle:@"完成" forState:UIControlStateNormal];
    nextBut.titleLabel.font = [UIFont systemFontOfSize:16*MYWIDTH];
    [nextBut addTarget:self action:@selector(nextButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
    
}
- (void)nextButClick{
    if (IsEmptyValue(_userField.text)) {
        jxt_showToastTitle(@"用户名不能为空", 1);
        return;
    }
    if (![Command isPassword:_pwdField.text]) {
        jxt_showAlertOneButton(@"密码格式不正确", @"由数字、字母、下划线组成的6—15位密码", @"确定", ^(NSInteger buttonIndex) {
            
        });
        return;
    }
    if (![_pwdField.text isEqualToString:_pwdField1.text]) {
        jxt_showToastTitle(@"两次输入的密码不一致", 1);
        return;
    }
    if (IsEmptyValue(_pwdField2.text)) {
        jxt_showToastTitle(@"请填写支付密码", 1);
        return;
    }
    if (![Command isPassword:_pwdField2.text]) {
        jxt_showAlertOneButton(@"支付密码格式不正确", @"由数字、字母组成的6—15位密码", @"确定", ^(NSInteger buttonIndex) {
            
        });
        return;
    }
    
    [self registRequest];

}
- (void)registRequest{
    /*
     /mbtwz/register?action=addCoustomer
     参数  custname,custphone,password   放在data中
     */
    NSString* urlstr = @"/mbtwz/register?action=addCoustomer";
    _userField.text = [Command convertNull:_userField.text];
    _pwdField.text = [Command convertNull:_pwdField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"custphone\":\"%@\",\"custname\":\"%@\",\"password\":\"%@\",\"paypassword\":\"%@\"}",_phoneStr,_userField.text,_pwdField.text,_pwdField2.text]};
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"注册成功", 1);
            NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
        }else{
            jxt_showToastTitle(@"注册失败", 1);
        }
    }];
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
