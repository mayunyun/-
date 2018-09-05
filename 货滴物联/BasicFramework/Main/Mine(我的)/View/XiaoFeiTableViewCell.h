//
//  XiaoFeiTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 17/9/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MingXiModel.h"
@interface XiaoFeiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeimage;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyiDH;
@property (weak, nonatomic) IBOutlet UILabel *paytypeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (nonatomic, strong)MingXiModel *data;

@end
