//
//  FreeRideTripListCell.h
//  BasicFramework
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeRideTripListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *vehicle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *fabutime;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@end
