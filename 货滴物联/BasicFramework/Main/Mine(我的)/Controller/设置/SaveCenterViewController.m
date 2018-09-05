//
//  SaveCenterViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SaveCenterViewController.h"
#import "ReplacePwdViewController.h"
#import "ReplacePayPswVC.h"
#import "BindEmailViewController.h"
#import "QQandWXViewController.h"
@interface SaveCenterViewController ()
{
    NSArray* _titleArr;
}
@end

@implementation SaveCenterViewController
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
    self.navigationItem.title = @"安全中心";
    _titleArr = @[@"修改登录密码",@"绑定邮箱",@"绑定QQ/微信",@"修改支付密码"];//,@"设置密保"
    [self creatUI];
}

- (void)creatUI{
    CGFloat w = 65*MYWIDTH;
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, UIScreenH)];
    if (statusbarHeight>20) {
        bgview.frame = CGRectMake(0, 88, kScreenWidth, UIScreenH);
    }
    bgview.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [self.view addSubview:bgview];
    
    UIImageView* headimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180*MYWIDTH)];
    headimgView.image = [UIImage imageNamed:@"安全中心banner"];
    [bgview addSubview:headimgView];
    
    NSArray *imagearr = @[@"修改密码",@"绑定邮箱33",@"绑定QQ微信",@"修改支付密码"];
    for (int i = 0; i < _titleArr.count; i++) {
        UIButton* btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(0,headimgView.bottom+i*w+20*MYWIDTH, kScreenWidth, w-15*MYWIDTH);
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 100+i;
        [bgview addSubview:btn];
        [btn addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView* imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(12*MYWIDTH, (btn.height - 20*MYWIDTH)/2, 20*MYWIDTH, 20*MYWIDTH)];
        imgView1.image = [UIImage imageNamed:imagearr[i]];
        [btn addSubview:imgView1];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(imgView1.right+10*MYWIDTH, 0, btn.width/2, 50*MYWIDTH)];
        label.text = _titleArr[i];
        label.font = [UIFont systemFontOfSize:14*MYWIDTH];
        label.backgroundColor = [UIColor clearColor];
        [btn addSubview:label];

        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.width - 25*MYWIDTH, (btn.height - 20*MYWIDTH)/2, 15*MYWIDTH, 20*MYWIDTH)];
        imgView.image = [UIImage imageNamed:@"rightArrow"];
        [btn addSubview:imgView];

    }
    
}

- (void)cellClick:(UIButton*)sender{
    if (sender.tag == 100) {

        //修改密码
        ReplacePwdViewController* vc = [[ReplacePwdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 101){
        //绑定邮箱
        BindEmailViewController* vc = [[BindEmailViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if (sender.tag == 102){
        //绑定球球、微信
        QQandWXViewController* vc = [[QQandWXViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 103){
        //修改支付密码
        ReplacePayPswVC* vc = [[ReplacePayPswVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}

@end
