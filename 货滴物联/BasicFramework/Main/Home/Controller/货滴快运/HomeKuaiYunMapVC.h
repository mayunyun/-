//
//  HomeKuaiYunMapVC.h
//  BasicFramework
//
//  Created by LONG on 2018/2/2.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "BasicMainVC.h"

@interface HomeKuaiYunMapVC : BasicMainVC

@property (nonatomic,strong)NSString *type;
@property (nonatomic,assign)CLLocationCoordinate2D location;//上个点
@property (nonatomic, copy) void (^qidianBlock)(NSString* strQD,CLLocationCoordinate2D location,NSString* sprovince,NSString* scity,NSString* scounty,NSString*moreQ);
@property (nonatomic, copy) void (^zhongdianBlock)(NSString* strZD,CLLocationCoordinate2D location,NSString* eprovince,NSString* ecity,NSString* ecounty,NSString*moreZ);


@end
