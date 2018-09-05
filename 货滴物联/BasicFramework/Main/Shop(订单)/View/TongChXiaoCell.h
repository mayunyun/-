//
//  TongChXiaoCell.h
//  BasicFramework
//
//  Created by LONG on 2018/2/7.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCHXiaoJModel.h"
@interface TongChXiaoCell : UITableViewCell
@property(nonatomic,strong)TCHXiaoJModel *dataModel;

- (void)setwithDataModel:(TCHXiaoJModel *)dataModel;
@end
