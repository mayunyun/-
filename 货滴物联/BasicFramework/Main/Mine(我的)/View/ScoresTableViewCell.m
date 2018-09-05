//
//  ScoresTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ScoresTableViewCell.h"

@implementation ScoresTableViewCell

- (void)setData:(ScoresModel *)data
{
    _data = data;
    
    if ([_data.type intValue] == 1) {
        _headView.image = [UIImage imageNamed:@"积分加"];
        _titleView.text = [NSString stringWithFormat:@"积分增加%.2f",[_data.score floatValue]];
    }else if([_data.type intValue] == 0){
        _headView.image = [UIImage imageNamed:@"积分减"];
        _titleView.text = [NSString stringWithFormat:@"积分减少%.2f",[_data.score floatValue]];
    }
    
    _timeView.text = [NSString stringWithFormat:@"%@",[_data.createtime substringToIndex:16]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
