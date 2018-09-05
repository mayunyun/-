//
//  IconsCollectionViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2017/9/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopAddrModel.h"

@interface IconsCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) ShopAddrModel *data;

@property (weak, nonatomic) IBOutlet UIImageView *imgStr;
@property (weak, nonatomic) IBOutlet UIButton *titleBut;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end
