//
//  HomeMapViewC1.h
//  BasicFramework
//
//  Created by LONG on 2018/1/31.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "BasicMainVC.h"

@interface HomeMapViewC1 : BasicMainVC

@property (nonatomic,assign)CLLocationCoordinate2D location;//上个点
@property (nonatomic, copy) void (^qidianBlock)(NSString* strQD,NSString* province,NSString* city,NSString* area);

@property (nonatomic,strong)NSString *provinceStr;
@property (nonatomic,strong)NSString *cityStr;
@property (nonatomic,strong)NSString *areaStr;


@end
