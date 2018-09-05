//
//  InvoiceHistoryCell.h
//  BasicFramework
//
//  Created by 钱龙 on 2018/2/27.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *type;

@property (weak, nonatomic) IBOutlet UILabel *guige;
@property (weak, nonatomic) IBOutlet UILabel *note;

@property (nonatomic,strong)NSDictionary * dict;

@end
