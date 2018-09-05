//
//  TiXianRecordCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TiXianRecordCell.h"

@implementation TiXianRecordCell

- (void)setData:(TiXianJLModel *)data
{
    _data = data;
    if ([_data.isvalid intValue] == 1) {
        _isvalidLab.text = @"审核通过";
        _isvalidLab.textColor = [UIColor greenColor];
    }else if([_data.isvalid intValue] == 0){
        _isvalidLab.text = @"待审核";
        _isvalidLab.textColor = [UIColor blueColor];
    }else if([_data.isvalid intValue] == 2){
        _isvalidLab.text = @"审核拒绝";
        _isvalidLab.textColor = [UIColor redColor];
    }
    _createtimeLab.text = [NSString stringWithFormat:@"%@",_data.createtime];
    _moneyLab.text = [NSString stringWithFormat:@"%@",_data.money];
    _noteLab.text = [NSString stringWithFormat:@"%@",_data.note];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.bgview.layer.cornerRadius = 10;
    self.bgview.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
