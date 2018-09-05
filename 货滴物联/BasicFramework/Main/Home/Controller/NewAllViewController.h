//
//  NewAllViewController.h
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BasicMainVC.h"
#import "MainModel.h"
#import "HuoDongModel.h"

@interface NewAllViewController : BasicMainVC<UIScrollViewDelegate>
@property (nonatomic,strong)MainModel *model;
@property (nonatomic,strong)HuoDongModel *huomodel;

@property (nonatomic,assign)int type;
@property (strong, nonatomic)  UILabel *titleLab;
@property (strong, nonatomic)  UIWebView *webView;

@end
