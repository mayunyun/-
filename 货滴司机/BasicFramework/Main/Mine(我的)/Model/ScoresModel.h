//
//  ScoresModel.h
//  MaiBaTe
//
//  Created by LONG on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ScoresModel : JSONModel
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *custid;
@property (nonatomic,strong)NSString *score;//流水积分
@property (nonatomic,strong)NSString *reason;//原因
@property (nonatomic,strong)NSString *scores;//总积分
@property (nonatomic,strong)NSString *type;//(0: 减 1：增)
@property (nonatomic,strong)NSString *createtime;

@end
