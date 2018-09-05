//
//  CarDetailTitleTableViewCell.h
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarDetailTitleTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel* titleLabel;
@property (nonatomic,strong)UILabel* locopriceLabel;
@property (nonatomic,strong)UILabel* msrpLabel;
@property (nonatomic,strong)UIImageView* leftimgView;
@property (nonatomic,strong)UIImageView* rightimgView;
@property (nonatomic,strong)NSArray* dataArr;

- (void)setData;
@end
