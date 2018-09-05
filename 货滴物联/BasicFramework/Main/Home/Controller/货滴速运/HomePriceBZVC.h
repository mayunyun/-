//
//  HomePriceBZVC.h
//  BasicFramework
//
//  Created by LONG on 2018/1/31.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "BasicMainVC.h"

@interface HomePriceBZVC : BasicMainVC
@property (nonatomic,strong)NSArray *bzPrice;
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *price3;
@property (weak, nonatomic) IBOutlet UILabel *price4;
@property (weak, nonatomic) IBOutlet UILabel *price5;

@property (weak, nonatomic) IBOutlet UILabel *weight1;
@property (weak, nonatomic) IBOutlet UILabel *weight2;
@property (weak, nonatomic) IBOutlet UILabel *weight3;
@property (weak, nonatomic) IBOutlet UILabel *weight4;
@property (weak, nonatomic) IBOutlet UILabel *weight5;

@end
