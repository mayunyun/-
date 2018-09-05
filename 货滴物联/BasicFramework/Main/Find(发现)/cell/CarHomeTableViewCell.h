//
//  CarHomeTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2017/9/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarBrandModel.h"

@interface CarHomeTableViewCell : UITableViewCell

@property(nonatomic,strong) CarBrandModel *data;

@property(nonatomic,strong) UIView *xianview;//分割线
@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *titleView;//标题

@end
