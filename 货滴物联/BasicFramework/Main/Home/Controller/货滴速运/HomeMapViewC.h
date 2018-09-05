//
//  HomeMapViewC.h
//  BasicFramework
//
//  Created by LONG on 2018/1/31.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "BasicMainVC.h"

@interface HomeMapViewC : BasicMainVC

@property (nonatomic,strong)NSString *type;
@property (nonatomic,assign)CLLocationCoordinate2D location;//上个点
@property (nonatomic, copy) void (^qidianBlock)(NSString* strQD,CLLocationCoordinate2D location,NSString *addessStr,NSString *_provinceId,NSString *_cityId,NSString *_areaId);
@property (nonatomic, copy) void (^zhongdianBlock)(NSString* strZD,CLLocationCoordinate2D location,NSString *addessStr,NSString *_provinceId,NSString *_cityId,NSString *_areaId);
@property (nonatomic,strong)NSString *provinceId;
@property (nonatomic,strong)NSString *cityId;
@property (nonatomic,strong)NSString *areaId;

@property (nonatomic,strong)NSString *otherCityID;//另一点城市的ID

@property (nonatomic,strong)NSString *_provinceStr;
@property (nonatomic,strong)NSString *_cityStr;
@property (nonatomic,strong)NSString *_areaStr;


@end
