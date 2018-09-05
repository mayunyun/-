//
//  WLQROrderViewController.h
//  MaiBaTe
//
//  Created by LONG on 2018/1/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BasicMainVC.h"
#import "WuLiuFHModel.h"

@interface WLQROrderViewController : BasicMainVC
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)WuLiuFHModel *model;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSString *zongPrice;
@property (nonatomic,strong)NSString *zongMileage;
@property (nonatomic,strong)NSString *qiAddress;
@property (nonatomic,strong)NSString *zhongAddress;
@property (nonatomic,assign)CLLocationCoordinate2D Qlocation;//起点
@property (nonatomic,assign)CLLocationCoordinate2D Zlocation;//终点
@end
