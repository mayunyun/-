//
//  FreeRideTripMapViewController.h
//  BasicFramework
//
//  Created by LONG on 2018/8/22.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "BasicMainVC.h"

@interface FreeRideTripMapViewController : BasicMainVC
@property (nonatomic,assign)CLLocationCoordinate2D Qlocation;//起点
@property (nonatomic,assign)CLLocationCoordinate2D Zlocation;//终点
@property (nonatomic, copy) void (^TJdidianBlock)(NSArray* arr);

@end
