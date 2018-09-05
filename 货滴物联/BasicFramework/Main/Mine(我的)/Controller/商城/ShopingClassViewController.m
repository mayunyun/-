//
//  ShopingClassViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/2/7.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ShopingClassViewController.h"
#import "PeiJianViewController.h"
#import "MenuViewController.h"
#import "ShopCarViewController.h"
#import "JiFenShopViewController.h"

@interface ShopingClassViewController ()

@end

@implementation ShopingClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView * titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"商城title"]];
    titleImageView.frame = CGRectMake(0, 0, 50, 20);
    self.navigationItem.titleView = titleImageView;
    [self IconsCollectionView];

}
- (void)IconsCollectionView{
    UIButton *leftBut = [[UIButton alloc]initWithFrame:CGRectMake(10*MYWIDTH, NavBarHeight, 35*MYWIDTH, 35*MYWIDTH)];
    [leftBut setImage:[UIImage imageNamed:@"菜单"] forState:UIControlStateNormal];
    [leftBut addTarget:self action:@selector(leftButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBut];
    
    UIButton *rightBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-45*MYWIDTH, NavBarHeight, 35*MYWIDTH, 35*MYWIDTH)];
    [rightBut setImage:[UIImage imageNamed:@"灰购物车"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(rightButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBut];
    
    UIButton *oneimage = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH, leftBut.bottom + 25*MYWIDTH, UIScreenW-30*MYWIDTH, 120*MYWIDTH)];
    [oneimage setImage:[UIImage imageNamed:@"货滴商城_1"] forState:UIControlStateNormal];
    [oneimage addTarget:self action:@selector(oneimageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:oneimage];
    
    UIButton *twoimage = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH, oneimage.bottom + 25*MYWIDTH, UIScreenW-30*MYWIDTH, 120*MYWIDTH)];
    [twoimage setImage:[UIImage imageNamed:@"积分商城_1"] forState:UIControlStateNormal];
    [twoimage addTarget:self action:@selector(twoimageClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:twoimage];
}
- (void)leftButClick:(UIButton *)but{
    MenuViewController * vc = [[MenuViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rightButClick:(UIButton *)but{
    ShopCarViewController * vc = [[ShopCarViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)oneimageClick:(UIButton *)but{
    PeiJianViewController  *peijian = [[PeiJianViewController alloc]init];
    [self.navigationController pushViewController:peijian animated:YES];
}
- (void)twoimageClick:(UIButton *)but{
    JiFenShopViewController  *peijian = [[JiFenShopViewController alloc]init];
    [self.navigationController pushViewController:peijian animated:YES];
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
