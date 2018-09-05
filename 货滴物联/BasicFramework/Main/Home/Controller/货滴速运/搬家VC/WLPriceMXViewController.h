//
//  WLPriceMXViewController.h
//  MaiBaTe
//
//  Created by LONG on 2017/12/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BasicMainVC.h"
#import "WuLiuFHModel.h"
@interface WLPriceMXViewController : BasicMainVC
@property (weak, nonatomic) IBOutlet UIButton *priceBut;

@property (nonatomic,strong)WuLiuFHModel *model;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSString *zongPrice;
@property (nonatomic,strong)NSString *zongMileage;
@end
