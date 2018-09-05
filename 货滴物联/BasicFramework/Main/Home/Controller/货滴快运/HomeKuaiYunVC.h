//
//  HomeKuaiYunVC.h
//  BasicFramework
//
//  Created by LONG on 2018/2/1.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "BasicMainVC.h"

@interface HomeKuaiYunVC : BasicMainVC
@property (nonatomic,strong)NSString* type;//1:顺风车  0：快运

@property (nonatomic,strong)NSString* idStr;//顺风车id
@property (nonatomic,strong)NSString* sprovince;//出发地省
@property (nonatomic,strong)NSString* scity;    //出发地市
@property (nonatomic,strong)NSString* scounty;  //出发地县
@property (nonatomic,strong)NSString* eprovince;//目的地省
@property (nonatomic,strong)NSString* ecity;    //目的地市
@property (nonatomic,strong)NSString* ecounty;  //目的地县


@property (nonatomic,assign)CLLocationCoordinate2D Qlocation;//起点
@property (nonatomic,assign)CLLocationCoordinate2D Zlocation;//终点


@end
