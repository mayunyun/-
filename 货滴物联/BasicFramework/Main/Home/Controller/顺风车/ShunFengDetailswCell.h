//
//  ShunFengDetailswCell.h
//  BasicFramework
//
//  Created by LONG on 2018/8/22.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreeRideListModel.h"
@interface ShunFengDetailswCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

- (void)setDataImage:(NSString*)str1 Title:(NSString*)str2 Detail:(NSString*)str3;
@end
