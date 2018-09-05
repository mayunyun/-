//
//  ZHKuaiYTableViewCell2.h
//  BasicFramework
//
//  Created by LONG on 2018/5/8.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHKuaiYModel.h"

@interface ZHKuaiYTableViewCell2 : UITableViewCell
@property(nonatomic,strong)ZHKuaiYModel *dataModel;
@property(nonatomic,strong)UIViewController *controller;

- (void)setwithDataModel:(ZHKuaiYModel *)dataModel;
@end
