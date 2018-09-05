//
//  CarBrandTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 17/9/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarBrandModel.h"
@interface CarBrandTableViewCell : UITableViewCell
@property(nonatomic,strong) CarBrandModel *data;

@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *textView;//描述
@property(nonatomic,strong) UIView *xianview1;//分割线
@property(nonatomic,strong) UIView *xianview2;//分割线

@end
