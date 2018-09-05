//
//  ZHXiaoJTableViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/3/6.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHXiaoJModel.h"
@interface ZHXiaoJTableViewCell : UITableViewCell<AMapSearchDelegate>
@property(nonatomic,strong)ZHXiaoJModel *dataModel;
@property(nonatomic,strong)UIViewController *controller;
@property (nonatomic, strong) AMapSearchAPI *search;

- (void)setwithDataModel:(ZHXiaoJModel *)dataModel locationStr:(CLLocationCoordinate2D)location;

@end
