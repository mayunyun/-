//
//  WLAddNeedViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLAddNeedModel.h"

@interface WLAddNeedViewCell : UITableViewCell

- (void)setdata:(WLAddNeedModel *)model othernumer:(NSInteger)numer needArr:(NSArray *)arr;
@property(nonatomic,strong)WLAddNeedModel *model;
@property(nonatomic,strong) UILabel *xianView;//线

@end
