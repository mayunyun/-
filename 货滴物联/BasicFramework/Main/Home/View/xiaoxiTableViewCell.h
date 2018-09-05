//
//  xiaoxiTableViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/6/22.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xiaoxiModel.h"
@interface xiaoxiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *otherLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *dianjiview;

@property (nonatomic,strong)xiaoxiModel* model;
@end
