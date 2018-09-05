//
//  DriverOrderInfoCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverOrderInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *driverName;
@property (weak, nonatomic) IBOutlet UIButton *driverPhone;

@property (weak, nonatomic) IBOutlet UILabel *driverstar;
@property (weak, nonatomic) IBOutlet UILabel *drivernum;

@end
