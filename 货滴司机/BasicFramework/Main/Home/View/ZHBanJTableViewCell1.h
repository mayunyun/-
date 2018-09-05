//
//  ZHBanJTableViewCell1.h
//  BasicFramework
//
//  Created by LONG on 2018/5/19.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHBanJModel.h"
@interface ZHBanJTableViewCell1 : UITableViewCell<AMapSearchDelegate>
@property(nonatomic,strong)ZHBanJModel *dataModel;
@property(nonatomic,strong)UIViewController *controller;
@property (nonatomic, strong) AMapSearchAPI *search;

- (void)setwithDataModel:(ZHBanJModel *)dataModel locationStr:(CLLocationCoordinate2D)location;

@end
