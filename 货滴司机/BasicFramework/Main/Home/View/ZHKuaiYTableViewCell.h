//
//  ZHKuaiYTableViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/3/8.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHKuaiYModel.h"
@interface ZHKuaiYTableViewCell : UITableViewCell
@property(nonatomic,strong)ZHKuaiYModel *dataModel;
@property(nonatomic,strong)UIViewController *controller;

- (void)setwithDataModel:(ZHKuaiYModel *)dataModel;
@end
