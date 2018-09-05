//
//  MYYOrterClassTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYYOrterClassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *typeLab;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *numLab;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLab;
@end
