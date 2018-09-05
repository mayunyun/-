//
//  mainCollectionViewCell.m
//  BasicFramework
//
//  Created by LONG on 2018/6/6.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "mainCollectionViewCell.h"

@implementation mainCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setdataimage:(NSString *)image title:(NSString *)title{
    [self.imageview setImage:[UIImage imageNamed:image]];
    self.imageview.layer.cornerRadius = 10;
    self.titleview.text = title;
    self.titleview.textColor = [UIColor whiteColor];
}
@end
