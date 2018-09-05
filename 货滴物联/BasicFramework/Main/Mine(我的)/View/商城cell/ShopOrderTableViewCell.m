//
//  ShopOrderTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShopOrderTableViewCell.h"

@implementation ShopOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgview.contentMode = UIViewContentModeScaleAspectFit;

    //添加边框
    CALayer * layer = [_imgview layer];
    layer.borderColor = [MYColor CGColor];
    layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
