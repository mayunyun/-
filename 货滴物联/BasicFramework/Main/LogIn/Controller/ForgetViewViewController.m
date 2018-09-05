//
//  ForgetViewViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/1/29.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ForgetViewViewController.h"

@interface ForgetViewViewController ()<UITextFieldDelegate>
{
    UITextField *_userField;
    UITextField *_pwdField;    
}

@end

@implementation ForgetViewViewController

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
    userimgView.image = [UIImage imageNamed:@"mima"];
    [userView addSubview:userimgView];
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(userimgView.width+40*MYWIDTH, 10*MYWIDTH, 1, userView.height-20*MYWIDTH)];
    xian.backgroundColor = UIColorFromRGBValueValue(0xCCCCCC);
    [userView addSubview:xian];
    _userField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, userView.width , userView.height)];
    _userField.backgroundColor = [UIColor clearColor];
    _userField.placeholder = @" 请设置新密码";
    _userField.secureTextEntry = YES;
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
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, pwdView.width , pwdView.height)];//- 50
    _pwdField.backgroundColor = [UIColor clearColor];
    _pwdField.placeholder = @"请再次确认密码";
    _pwdField.secureTextEntry = YES;
    _pwdField.textColor = [UIColor blackColor];
    _pwdField.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _pwdField.textAlignment = NSTextAlignmentCenter;
    _pwdField.delegate = self;
    [pwdView addSubview:_pwdField];
    [self placeholderColor:_pwdField str:_pwdField.placeholder color:[UIColor blackColor]];
    
    
    
    UIButton *nextBut = [[UIButton alloc]initWithFrame:CGRectMake(userView.left, pwdView.bottom+(self.view.bottom-pwdView.bottom-userView.height)/2-20*MYWIDTH, userView.width, userView.height)];
    [nextBut setBackgroundColor:MYColor];
    [nextBut setTitle:@"完成" forState:UIControlStateNormal];
    nextBut.titleLabel.font = [UIFont systemFontOfSize:16*MYWIDTH];
    [nextBut addTarget:self action:@selector(nextButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
}
- (void)nextButClick{
    if ([Command isPassword:_userField.text]) {
        if ([_pwdField.text isEqualToString:_userField.text]&&!IsEmptyValue(_pwdField.text)) {
            [self registRequest];
            
        }else{
            jxt_showToastTitle(@"两次输入的密码不一致", 1);
        }
    }else{
        jxt_showAlertOneButton(@"密码格式不正确", @"由数字、字母、下划线组成的6—15位密码", @"确定", ^(NSInteger buttonIndex) {
            
        });
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
- (void)registRequest{
    /*
     /mbtwz/register?action=upPassword"+callback1
     参数：phone password 放在data中
     */
    NSString* urlstr = @"/mbtwz/register?action=upPassword";
    _pwdField.text = [Command convertNull:_pwdField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\",\"password\":\"%@\"}",_phoneStr,_pwdField.text]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"密码修改成功", 1);
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",_pwdField.text] forKey:PASSWORD];
            
            NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
        }else{
            jxt_showToastTitle(@"密码修改失败", 1);
        }
    }];
    
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
