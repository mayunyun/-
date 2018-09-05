//
//  MainTableViewCell.h
//  PetrpleumLove
//
//  Created by LONG on 16/8/24.
//  Copyright © 2016年 徐番茄丶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWMainModel.h"
#import "HuoDongModel.h"
@interface MainTableViewCell : UITableViewCell

@property(nonatomic,strong) XWMainModel *data;
@property(nonatomic,strong) HuoDongModel *model;

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UIView *xianview;//分割线
@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *textView;//描述
@property(nonatomic,strong) UILabel *timeView;//时间


@end

