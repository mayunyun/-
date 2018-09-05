//
//  editAddressViewController.h
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BasicMainVC.h"
#import "AddressModel.h"
@interface editAddressViewController : BasicMainVC

@property (nonatomic,strong)NSString * strtitle;
@property (nonatomic,strong)AddressModel * model;

@property (nonatomic,strong)NSString * idString;
@property (nonatomic,strong)NSString * provinceName;
@property (nonatomic,strong)NSString * cityName;
@property (nonatomic,strong)NSString * townName;
@end
