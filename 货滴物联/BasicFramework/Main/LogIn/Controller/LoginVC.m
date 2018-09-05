//
//  LoginVC.m
//  BasicFramework
//
//  Created by Rainy on 2016/11/8.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "LoginVC.h"
#import "UserModel.h"
#import "RequestTool.h"
#import "NextBasicMainVC.h"
#import "BasicMainTBVC.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "NewBasicMainVC.h"
@interface LoginVC ()<UITextFieldDelegate>
{
    UITextField *_userField;
    UITextField *_pwdField;
}

@end

@implementation LoginVC

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
    _userField.placeholder = @" 请输入用户名/手机号";
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
    _pwdField.placeholder = @"请输入密码";
    _pwdField.secureTextEntry = YES;
    _pwdField.textColor = [UIColor blackColor];
    _pwdField.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _pwdField.textAlignment = NSTextAlignmentCenter;
    _pwdField.delegate = self;
    [pwdView addSubview:_pwdField];
    [self placeholderColor:_pwdField str:_pwdField.placeholder color:[UIColor blackColor]];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(pwdView.right-60*MYWIDTH, pwdView.bottom, 60*MYWIDTH, 30*MYWIDTH)];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"忘记密码?"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:MYColor range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:MYColor range:(NSRange){0,[tncString length]}];
    [but setAttributedTitle:tncString forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [but addTarget:self action:@selector(fahuodanButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    
    UIButton *nextBut = [[UIButton alloc]initWithFrame:CGRectMake(userView.left, pwdView.bottom+(self.view.bottom-pwdView.bottom-userView.height*2-20*MYWIDTH)/2-20*MYWIDTH, userView.width, userView.height)];
    [nextBut setBackgroundColor:MYColor];
    [nextBut setTitle:@"登录" forState:UIControlStateNormal];
    [nextBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBut.titleLabel.font = [UIFont systemFontOfSize:16*MYWIDTH];
    [nextBut addTarget:self action:@selector(nextButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
    
    UIButton *registerBut = [[UIButton alloc]initWithFrame:CGRectMake(userView.left, nextBut.bottom+20*MYWIDTH, userView.width, userView.height)];
    [registerBut setBackgroundColor:[UIColor whiteColor]];
    [registerBut.layer setMasksToBounds:YES];
    //[registerBut.layer setCornerRadius:3.0]; //设置矩圆角半径
    [registerBut.layer setBorderWidth:1.0];   //边框宽度
    [registerBut.layer setBorderColor:MYColor.CGColor];//边框颜色
    [registerBut setTitle:@"会员注册" forState:UIControlStateNormal];
    [registerBut setTitleColor:MYColor forState:UIControlStateNormal];
    registerBut.titleLabel.font = [UIFont systemFontOfSize:16*MYWIDTH];
    [registerBut addTarget:self action:@selector(registerButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBut];
}
- (void)fahuodanButClicked:(UIButton *)but{
    NextBasicMainVC *NextBasicMain = [[NextBasicMainVC alloc]init];
    NextBasicMain.push = @"2";
    [self.navigationController pushViewController:NextBasicMain animated:YES];
}
- (void)nextButClick{
    if (!IsEmptyValue(_userField.text)) {
        if (!IsEmptyValue(_pwdField.text)) {
            [self logining];
        }else{
            jxt_showToastTitle(@"密码未填写", 1);
        }
    }else{
        jxt_showToastTitle(@"用户名未填写", 1);
    }
}
- (void)registerButClick{
    NewBasicMainVC *NextBasicMain = [[NewBasicMainVC alloc]init];
    [self.navigationController pushViewController:NextBasicMain animated:YES];
}
-(void)logining{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_userField.text forKey:@"phone"];
    NSDictionary * parameter = @{@"data":[Command dictionaryToJson:dic]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/register?action=isExitsPhone" Parameters:parameter FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"内容~~~~~~%@",str);
        //true,注册了；false,未注册
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"该手机号未注册", 1);
        }else{
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:_userField.text forKey:@"account"];
            [dic setValue:_pwdField.text forKey:@"password"];
            NSDictionary * parameter = @{@"data":[Command dictionaryToJson:dic]};
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:_Login_URL Parameters:parameter FinishedLogin:^(id responseObject) {
                NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"登录返回的内容~~~~~~%@",array);
                if (array.count) {
                    UserModel* model = [[UserModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[0]];
                    if ([[NSString stringWithFormat:@"%@",model.isvalid] integerValue] == 1) {
                        //账户启用
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model.Id] forKey:USERID];
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model.custname] forKey:USENAME];
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model.custphone] forKey:USERPHONE];
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model.password] forKey:PASSWORD];
                        
                        [self joinJPush:[NSString stringWithFormat:@"%@",model.Id]];
                        //[self.navigationController popViewControllerAnimated:YES];
                        BasicMainTBVC *LCTabVC = [[BasicMainTBVC alloc]init];
                        
                        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        del.window.rootViewController = LCTabVC;
                        
                    }else{
                        jxt_showToastTitle(@"该账户已停用", 1);
                    }
                }else{
                    jxt_showToastTitle(@"账户或密码不正确", 1);
                }
            }];
        }
    }];
    
}
#pragma mark 用户+标签、别名
-(void)joinJPush:(NSString *)tag{
    //    NSLog(@"%@",tag);
    
    [JPUSHService setAlias:tag completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:arc4random()%100];
//        NSSet * set = [[NSSet alloc] initWithObjects:@"abc",@"one", nil];
//
//        [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//
//        } seq:0];
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
