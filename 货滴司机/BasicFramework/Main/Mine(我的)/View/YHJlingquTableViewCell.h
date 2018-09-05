//
//  YHJlingquTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouHuiModel.h"
@interface YHJlingquTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cheap_descript;
@property (weak, nonatomic) IBOutlet UILabel *cheap_coupon_count;
@property (weak, nonatomic) IBOutlet UILabel *cheap_equal_money;
@property (weak, nonatomic) IBOutlet UIButton *cheapBut;

@end
