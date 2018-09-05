//
//  KuaiYunTableViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/2/7.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCHKuaiYModel.h"
@interface KuaiYunTableViewCell : UITableViewCell
@property(nonatomic,strong)TCHKuaiYModel *dataModel;

- (void)setwithDataModel:(TCHKuaiYModel *)dataModel;

@end
