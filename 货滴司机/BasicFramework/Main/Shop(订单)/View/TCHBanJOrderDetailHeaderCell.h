//
//  TCHBanJOrderDetailHeaderCell.h
//  BasicFramework
//
//  Created by LONG on 2018/2/27.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCHBanJModel.h"
@interface TCHBanJOrderDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *useCarTime;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

@property (nonatomic,strong)TCHBanJModel * model;
@end
