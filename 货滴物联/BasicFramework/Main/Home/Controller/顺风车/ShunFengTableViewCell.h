//
//  ShunFengTableViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/8/21.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreeRideListModel.h"
@interface ShunFengTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *didButton;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
- (IBAction)phoneBtnClick:(id)sender;
@property (nonatomic,strong)FreeRideListModel* model;



@end
