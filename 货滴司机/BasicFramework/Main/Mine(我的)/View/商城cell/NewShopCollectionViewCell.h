//
//  NewShopCollectionViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/7/3.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewShopCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *xian;

@end
