//
//  AnswerViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AnswerViewController.h"

@interface AnswerViewController ()
{
    UITextView* _qusTextView;
}
@end

@implementation AnswerViewController
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
    self.navigationItem.title = @"意见和建议";
    [self creatUI];
}
- (void)creatUI{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, UIScreenH)];
    if (statusbarHeight>20) {
        bgview.frame = CGRectMake(0, 88, kScreenWidth, UIScreenH);
    }
    bgview.backgroundColor = UIColorFromRGB(0xff4b52);
    [self.view addSubview:bgview];
    
    _qusTextView = [[UITextView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 35*MYWIDTH, kScreenWidth-40*MYWIDTH, kScreenWidth-100*MYWIDTH)];
    _qusTextView.font = [UIFont systemFontOfSize:13*MYWIDTH];
//    _qusTextView.layer.borderWidth = 1;
//    _qusTextView.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;
    _qusTextView.backgroundColor = [UIColor whiteColor];
    _qusTextView.layer.cornerRadius = 10;
    [bgview addSubview:_qusTextView];
    
    UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake(0, kScreenHeight-50*MYWIDTH, kScreenWidth, 50*MYWIDTH);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:UIColorFromRGB(0xff4b52) forState:UIControlStateNormal];
    [okBtn setBackgroundColor:[UIColor whiteColor]];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:18*MYWIDTH];
    [self.view addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)okBtnClick:(UIButton*)sender{
    if (!IsEmptyValue(_qusTextView.text)) {
        [self dataRequest];
    }else{
        jxt_showToastTitle(@"提交问题为空哦", 1);
    }

}

- (void)dataRequest{
    /*
     /mbtwz/wxcustomer?action=addAdvice
     参数：content  custphone   放在data中
     */
    NSString* phone= [[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE];
    NSString* urlstr = @"/mbtwz/wxcustomer?action=addAdvice";
    _qusTextView.text = [Command convertNull:_qusTextView.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"content\":\"%@\",\"custphone\":\"%@\"}",_qusTextView.text,phone]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"意见提交>>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"意见提交失败", 1);
        }
    }];
}


@end
