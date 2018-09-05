//
//  QQandWXViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "QQandWXViewController.h"

@interface QQandWXViewController ()
{
    UITextField* _qqField;
    UITextField* _wxField;
    
}
@end

@implementation QQandWXViewController
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
    self.navigationItem.title = @"绑定QQ/微信";
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
    
    UIImageView* qqimgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, headimgView.bottom +35*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    qqimgView.contentMode = UIViewContentModeScaleAspectFit;
    qqimgView.image = [UIImage imageNamed:@"绑定QQ"];
    [bgview addSubview:qqimgView];
    
    _qqField = [[UITextField alloc]initWithFrame:CGRectMake(qqimgView.right+20*MYWIDTH, headimgView.bottom + 25*MYWIDTH, kScreenWidth - qqimgView.right - 60*MYWIDTH, 40*MYWIDTH)];
    _qqField.font = [UIFont systemFontOfSize:14*MYWIDTH];
//    _qqField.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
//    _qqField.layer.borderWidth = 1.0f;//设置边框
    _qqField.textAlignment = NSTextAlignmentCenter;
    _qqField.placeholder = @"请输入您的QQ账号";
    [Command placeholderColor:_qqField str:_qqField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    [bgview addSubview:_qqField];
    
    UIView *bgview2 = [[UIView alloc]initWithFrame:CGRectMake(20*MYWIDTH, _qqField.bottom + 15*MYWIDTH, kScreenWidth-40*MYWIDTH, 40*MYWIDTH)];
    bgview2.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:bgview2];
    
    UIImageView* wximgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, _qqField.bottom +25*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    wximgView.contentMode = UIViewContentModeScaleAspectFit;
    wximgView.image = [UIImage imageNamed:@"绑定微信"];
    [bgview addSubview:wximgView];
    
    _wxField = [[UITextField alloc]initWithFrame:CGRectMake(qqimgView.right+20*MYWIDTH, _qqField.bottom + 15*MYWIDTH, kScreenWidth - qqimgView.right - 60*MYWIDTH, 40*MYWIDTH)];
//    _wxField.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
//    _wxField.layer.borderWidth = 1.0f;//设置边框
    _wxField.font = _qqField.font;
    _wxField.textAlignment = NSTextAlignmentCenter;
    _wxField.placeholder = @"请输入您的微信账号";
    [Command placeholderColor:_wxField str:_wxField.placeholder color:UIColorFromRGBValueValue(0x666666)];
    [bgview addSubview:_wxField];
    
    UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake(0, kScreenHeight-50*MYWIDTH, kScreenWidth, 50*MYWIDTH);;;
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:18*MYWIDTH];
    okBtn.backgroundColor =  UIColorFromRGB(0xff4b52);
    [self.view addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void)okBtnClick:(UIButton*)sender{
    if (IsEmptyValue(_qqField.text)&&IsEmptyValue(_wxField.text)) {
        jxt_showToastTitle(@"qq和微信不能同时为空", 1);
    }else{
        [self dataRequest];
    }
}

- (void)dataRequest{
    /*
    /mbtwz/wxcustomer?action=addQqWechat
     参数：qq   wechat     放在data中
     */
    NSString* urlstr = @"/mbtwz/wxcustomer?action=addQqWechat";
    _qqField.text = [Command convertNull:_qqField.text];
    _wxField.text = [Command convertNull:_wxField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"qq\":\"%@\",\"wechat\":\"%@\"}",_qqField.text,_wxField.text]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"绑定邮箱和球球>>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"绑定成功", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"绑定失败", 1);
        }
        
    }];
}

@end
