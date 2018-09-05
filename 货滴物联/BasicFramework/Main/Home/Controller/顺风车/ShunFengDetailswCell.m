//
//  ShunFengDetailswCell.m
//  BasicFramework
//
//  Created by LONG on 2018/8/22.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ShunFengDetailswCell.h"

@implementation ShunFengDetailswCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataImage:(NSString*)str1 Title:(NSString*)str2 Detail:(NSString*)str3{
    [self.leftImage setImage:[UIImage imageNamed:str1]];
    self.titleLabel.text = str2;
    self.detailLabel.text = [NSString stringWithFormat:@"%@",str3];
    
}

@end
