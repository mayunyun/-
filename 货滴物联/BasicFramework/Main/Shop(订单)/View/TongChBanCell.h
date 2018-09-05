//
//  TongChBanCell.h
//  BasicFramework
//
//  Created by LONG on 2018/2/7.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCHBanJModel.h"
@interface TongChBanCell : UITableViewCell
@property(nonatomic,strong)TCHBanJModel *dataModel;

- (void)setwithDataModel:(TCHBanJModel *)dataModel;

@end
