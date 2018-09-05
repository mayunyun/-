//
//  MyOrterTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYYMyOrderModel.h"
#import "MYYMyOrderClassModer.h"
@interface MyOrterTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ordernoLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *hejiLab;
@property (weak, nonatomic) IBOutlet UILabel *ordelState;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;
@property (weak, nonatomic) IBOutlet UIButton *deleteBut;

@property (nonatomic, strong)NSArray *prolistArr;
- (void)configModel:(MYYMyOrderModel *)model;
@end
