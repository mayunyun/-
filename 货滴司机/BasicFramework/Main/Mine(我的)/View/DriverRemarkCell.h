//
//  DriverRemarkCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDZStarsControl.h"
#import "WQLStarView.h"
@interface DriverRemarkCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *dicinfo;
@property (nonatomic,strong)WQLStarView *xingxingView;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *cotent;
@property (weak, nonatomic) IBOutlet UIView *bgview;


@end
