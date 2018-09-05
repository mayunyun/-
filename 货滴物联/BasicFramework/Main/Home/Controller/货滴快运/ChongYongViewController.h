//
//  ChongYongViewController.h
//  BasicFramework
//
//  Created by LONG on 2018/6/13.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "BasicMainVC.h"

@interface ChongYongViewController : BasicMainVC
@property (nonatomic,strong)NSString *pushtype;//2 起点 3终点 1收货人

@property (nonatomic, copy) void (^morenqiBlock)(NSString* strQD,CLLocationCoordinate2D location,NSString* sprovince,NSString* scity,NSString* scounty);

@property (nonatomic, copy) void (^morenzhongBlock)(NSString* strZD,CLLocationCoordinate2D location,NSString* eprovince,NSString* ecity,NSString* ecounty);

@property (nonatomic, copy) void (^morenshouhuorenBlock)(NSString* name,NSString* phone);
@end
