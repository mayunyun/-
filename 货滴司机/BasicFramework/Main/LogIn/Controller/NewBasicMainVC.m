//
//  NewBasicMainVC.m
//  BasicFramework
//
//  Created by LONG on 2018/7/13.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "NewBasicMainVC.h"
#import "YZXTimeButton.h"
#import "UserModel.h"
#import "BasicMainTBVC.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#define SendTime 60

@interface NewBasicMainVC ()<UITextFieldDelegate>
{
    UITextField *_userField;
    UITextField *_phoneField;
    UITextField *_yzmField;
    UITextField *_pwdField;
    BOOL _isregist;
    YZXTimeButton* _ecodeBtn;
    NSString* _smscode;
    
}

@end

@implementation NewBasicMainVC

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
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-60*MYWIDTH, 100*MYWIDTH, 120*MYWIDTH, 51.7*MYWIDTH)];
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
    _userField.placeholder = @" 请填写昵称";
    _userField.keyboardType = UIKeyboardTypeDefault;
    _userField.textAlignment =  NSTextAlignmentCenter;
    _userField.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _userField.textColor = [UIColor blackColor];
    _userField.delegate = self;
    [userView addSubview:_userField];
    [self placeholderColor:_userField str:_userField.placeholder color:[UIColor blackColor]];
    
    UIImageView* userView1 = [[UIImageView alloc]initWithFrame:CGRectMake(50*MYWIDTH, userView.bottom+15*MYWIDTH, kScreenWidth-100*MYWIDTH, 50*MYWIDTH)];
    userView1.userInteractionEnabled = YES;
    userView1.image = [UIImage imageNamed:@"发现_边框"];
    [self.view addSubview:userView1];
    UIImageView* userimgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 17.5*MYWIDTH, userView.height - 36.5*MYWIDTH, userView.height - 35*MYWIDTH)];
    userimgView1.image = [UIImage imageNamed:@"电话(1)"];
    [userView1 addSubview:userimgView1];
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(userimgView1.width+40*MYWIDTH, 10*MYWIDTH, 1, userView1.height-20*MYWIDTH)];
    xian1.backgroundColor = UIColorFromRGBValueValue(0xCCCCCC);
    [userView1 addSubview:xian1];
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, userView1.width , userView1.height)];
    _phoneField.backgroundColor = [UIColor clearColor];
    _phoneField.placeholder = @" 请填写手机号";
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneField.textAlignment =  NSTextAlignmentCenter;
    _phoneField.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _phoneField.textColor = [UIColor blackColor];
    _phoneField.delegate = self;
    [userView1 addSubview:_phoneField];
    [self placeholderColor:_phoneField str:_phoneField.placeholder color:[UIColor blackColor]];
    
    UIImageView* pwdView = [[UIImageView alloc]initWithFrame:CGRectMake(userView.left, userView1.bottom+15*MYWIDTH, userView.width-80*MYWIDTH, userView.height)];
    pwdView.userInteractionEnabled = YES;
    pwdView.image = [UIImage imageNamed:@"发现_边框"];
    [self.view addSubview:pwdView];
    UIImageView* pwdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 17.5*MYWIDTH, userView.height - 36.5*MYWIDTH, userView.height - 35*MYWIDTH)];
    pwdimgView.image = [UIImage imageNamed:@"发送验证码"];
    [pwdView addSubview:pwdimgView];
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(userimgView.width+40*MYWIDTH, 10*MYWIDTH, 1, userView.height-20*MYWIDTH)];
    xian2.backgroundColor = UIColorFromRGBValueValue(0xCCCCCC);
    [pwdView addSubview:xian2];
    _yzmField = [[UITextField alloc]initWithFrame:CGRectMake(xian2.right, 0, pwdView.width-xian2.right, pwdView.height)];//- 50
    _yzmField.backgroundColor = [UIColor clearColor];
    _yzmField.placeholder = @" 请输入验证码";
    _yzmField.keyboardType = UIKeyboardTypeNumberPad;
    _yzmField.textColor = [UIColor blackColor];
    _yzmField.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _yzmField.textAlignment = NSTextAlignmentCenter;
    _yzmField.delegate = self;
    [pwdView addSubview:_yzmField];
    [self placeholderColor:_yzmField str:_yzmField.placeholder color:[UIColor blackColor]];
    
    _ecodeBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(pwdView.right+8*MYWIDTH, pwdView.top, 78*MYWIDTH, userView.height)];
    [_ecodeBtn setBackgroundColor:MYColor];
    [_ecodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    _ecodeBtn.titleLabel.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [_ecodeBtn addTarget:self action:@selector(phoneButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ecodeBtn];
    
    UIImageView* userView2 = [[UIImageView alloc]initWithFrame:CGRectMake(50*MYWIDTH, pwdView.bottom + 15*MYWIDTH, kScreenWidth-100*MYWIDTH, 50*MYWIDTH)];
    userView2.userInteractionEnabled = YES;
    userView2.image = [UIImage imageNamed:@"发现_边框"];
    [self.view addSubview:userView2];
    UIImageView* userimgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 17.5*MYWIDTH, userView.height - 36.5*MYWIDTH, userView.height - 35*MYWIDTH)];
    userimgView2.image = [UIImage imageNamed:@"mima"];
    [userView2 addSubview:userimgView2];
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(userimgView2.width+40*MYWIDTH, 10*MYWIDTH, 1, userView2.height-20*MYWIDTH)];
    xian3.backgroundColor = UIColorFromRGBValueValue(0xCCCCCC);
    [userView2 addSubview:xian3];
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, userView.width , userView.height)];
    _pwdField.backgroundColor = [UIColor clearColor];
    _pwdField.placeholder = @" 请填写密码";
    _pwdField.secureTextEntry = YES;
    _pwdField.keyboardType = UIKeyboardTypeDefault;
    _pwdField.textAlignment =  NSTextAlignmentCenter;
    _pwdField.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _pwdField.textColor = [UIColor blackColor];
    _pwdField.delegate = self;
    [userView2 addSubview:_pwdField];
    [self placeholderColor:_pwdField str:_pwdField.placeholder color:[UIColor blackColor]];
    
    UIButton *nextBut = [[UIButton alloc]initWithFrame:CGRectMake(userView.left, userView2.bottom+(self.view.bottom-userView2.bottom-userView.height)/2-20*MYWIDTH, userView.width, userView.height)];
    [nextBut setBackgroundColor:MYColor];
    [nextBut setTitle:@"注册并登录" forState:UIControlStateNormal];
    nextBut.titleLabel.font = [UIFont systemFontOfSize:16*MYWIDTH];
    [nextBut addTarget:self action:@selector(nextButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
}
- (void)phoneButClick{
    [_phoneField resignFirstResponder];
    if ([Command isMobileNumber:_phoneField.text]) {
        [self isExitsPhoneRequest1];
    }else{
        jxt_showToastTitle(@"手机格式不正确", 1);
    }
}
- (void)isExitsPhoneRequest1{
    /*
     /mbtwz/register?action=isExitsPhone   "+callback1
     phone  放在data中
     */
    _phoneField.text = [Command convertNull:_phoneField.text];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_phoneField.text forKey:@"phone"];
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
    if (!IsEmptyValue(_userField.text)) {
        if ([Command isPassword:_pwdField.text]) {
            [self registRequest];
        }else{
            jxt_showAlertOneButton(@"密码格式不正确", @"由数字、字母、下划线组成的6—15位密码", @"确定", ^(NSInteger buttonIndex) {
                
            });
        }
    }else{
        jxt_showToastTitle(@"昵称不能为空", 1);
    }
    
    
}
- (void)registRequest{
    if ([_yzmField.text isEqualToString:_smscode]&&!IsEmptyValue(_yzmField.text)) {
        /*
         /mbtwz/register?action=addCoustomer
         参数  custname,custphone,password   放在data中
         */
        NSString* urlstr = @"/mbtwz/register?action=addCoustomer";
        _phoneField.text = [Command convertNull:_phoneField.text];
        _userField.text = [Command convertNull:_userField.text];
        _pwdField.text = [Command convertNull:_pwdField.text];
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"custphone\":\"%@\",\"custname\":\"%@\",\"password\":\"%@\"}",_phoneField.text,_userField.text,_pwdField.text]};
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
            NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@">>>%@",str);
            if ([str rangeOfString:@"true"].location!=NSNotFound) {
                [self logining];
                
            }else{
                jxt_showToastTitle(@"注册失败", 1);
            }
        }];
    }else{
        jxt_showToastTitle(@"验证码输入不正确", 1);
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
-(void)logining{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_phoneField.text forKey:@"account"];
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
            jxt_showToastTitle(@"自动登录失败", 1);
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
