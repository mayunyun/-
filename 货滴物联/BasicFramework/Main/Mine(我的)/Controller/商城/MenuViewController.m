//
//  MenuViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MenuViewController.h"
#import "MYYMyOrderViewController.h"
#import "AddressManageViewController.h"
#import "NewShopingClassViewController.h"
#import "FeiLeiShopViewController.h"
#import "ShopCarViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text =@"个人中心";
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftNavBarClick)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xFFFFFF)];
    
    [self creatUI];
}
- (void)leftNavBarClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)creatUI{
    
    UIView *bgview4 = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, UIScreenH)];
    if (statusbarHeight>20) {
        bgview4.frame = CGRectMake(0, 88, kScreenWidth, UIScreenH);
    }
    bgview4.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [self.view addSubview:bgview4];
    
    NSArray *titleArr = @[@"我的订单",@"地址管理"];

    CGFloat w = 50*GMYWIDTH;

    for (int i = 0; i < titleArr.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 25*MYWIDTH + i*(w+15*MYWIDTH), UIScreenW, w);
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.tag = 100+i;
//        btn.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
//        btn.layer.borderWidth = 1.0f;//设置边框
        [bgview4 addSubview:btn];
        [btn addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView* imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake( 15*GMYWIDTH, (w - 20*GMYWIDTH)/2, 20*GMYWIDTH, 20*GMYWIDTH)];
        imgView1.image = [UIImage imageNamed:titleArr[i]];
        [btn addSubview:imgView1];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(40*GMYWIDTH, 0, btn.width/2, w)];
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:14*GMYWIDTH];
        label.backgroundColor = [UIColor clearColor];
        [btn addSubview:label];
        
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.width - 20*GMYWIDTH, (w - 15*GMYWIDTH)/2, 10*GMYWIDTH, 15*GMYWIDTH)];
        imgView.image = [UIImage imageNamed:@"rightRed"];
        [btn addSubview:imgView];
        
    }
    
    
    NSArray *butArr = @[@"导航-首页",@"fenleihei",@"gouwuhei",@"wodehong"];
    NSArray *butArr1 = @[@"首页",@"分类",@"购物车",@"我的"];
    
    for (int i=0; i<4; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/4*i, UIScreenH-44*MYWIDTH, UIScreenW/4, 44*MYWIDTH)];
        [but setImage:[UIImage imageNamed:butArr[i]] forState:UIControlStateNormal];
        [but setTitle:butArr1[i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:11];
        but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [but setTitleEdgeInsets:UIEdgeInsetsMake(but.imageView.frame.size.height+10 ,-but.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [but setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,but.titleLabel.bounds.size.height, -but.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
        but.tag = i;
        [but addTarget:self action:@selector(tabbarBut:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
    }
}
- (void)tabbarBut:(UIButton*)but{
    switch (but.tag) {
        case 0:
        {
            NewShopingClassViewController *NewShoping = [[NewShopingClassViewController alloc]init];
            [self.navigationController pushViewController:NewShoping animated:YES];
            break;
        }
        case 1:
        {
            FeiLeiShopViewController *fenlei = [[FeiLeiShopViewController alloc]init];
            [self.navigationController pushViewController:fenlei animated:YES];
            break;
        }
        case 2:
        {
            ShopCarViewController *ShopCar = [[ShopCarViewController alloc]init];
            [self.navigationController pushViewController:ShopCar animated:YES];
            break;
        }
        
            
        default:
            break;
    }
}

- (void)cellClick:(UIButton*)sender{
    [Command isloginRequest:^(bool str) {
        if (str) {
            if (sender.tag == 100) {
                //我的订单
                MYYMyOrderViewController *order = [[MYYMyOrderViewController alloc]init];
                [self.navigationController pushViewController:order animated:YES];
                
            }else if (sender.tag == 101){
                
                //地址管理
                AddressManageViewController * amvc = [[AddressManageViewController alloc]init];
                
                [self.navigationController pushViewController:amvc animated:YES];
                
            }
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
    
    
}

@end
