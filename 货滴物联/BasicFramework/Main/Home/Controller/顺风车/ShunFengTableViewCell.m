//
//  ShunFengTableViewCell.m
//  BasicFramework
//
//  Created by LONG on 2018/8/21.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ShunFengTableViewCell.h"

@implementation ShunFengTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FreeRideListModel *)model{
    _model = model;
    self.startLabel.text = [NSString stringWithFormat:@"%@",model.scity];
    self.endLabel.text = [NSString stringWithFormat:@"%@",model.ecity];
    NSString* middlestr = [NSString stringWithFormat:@"%@",model.waytocitysshow];
    NSArray *array = [middlestr componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    NSString* newstr = @"";
    for (int i = 0; i < array.count; i++) {
        if (i == 0) {
            newstr = array[0];
        }else{
            newstr = [NSString stringWithFormat:@"%@-%@",newstr,array[i]];
        }
    }
    self.middleLabel.text = [NSString stringWithFormat:@"-%@-",newstr];
    CGFloat yu = [model.totalvehicle floatValue] - [model.availablevehicle floatValue];
    self.lengthLabel.text = [NSString stringWithFormat:@"车长：%@/余：%.f米",model.totalvehicle,yu];
    self.startTimeLabel.text = [NSString stringWithFormat:@"%@",model.departuretime];
    NSString* imgurl = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,model.folder,model.autoname];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.contactname];
    self.numLabel.text = [NSString stringWithFormat:@"交易%@笔",model.driver_num];
    [self.starImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@个",model.driver_star]]];
    
}

- (IBAction)phoneBtnClick:(id)sender {
    
    
    if (!IsEmptyValue(_model.contactphone)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_model.contactphone]]];
    }
}
@end
