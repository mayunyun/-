//
//  TCHBanJOrderDetailHeaderCell.m
//  BasicFramework
//
//  Created by LONG on 2018/2/27.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "TCHBanJOrderDetailHeaderCell.h"

@implementation TCHBanJOrderDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(TCHBanJModel *)model{
    _model = model;
    self.orderNo.text = [NSString stringWithFormat:@"%@",_model.owner_orderno];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_model.owner_link_name];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",_model.owner_link_phone];
    self.carType.text = [NSString stringWithFormat:@"%@",_model.car_type];
    NSString * sendtime = [_model.owner_sendtime substringToIndex:[_model.owner_sendtime length] - 3];
    self.useCarTime.text = [NSString stringWithFormat:@"%@",sendtime];
    NSString * createTime = [_model.owner_sendtime substringToIndex:[_model.owner_sendtime length] - 3];
    self.createTime.text = [NSString stringWithFormat:@"%@",createTime];
    
    NSString * status = [NSString stringWithFormat:@"%@",_model.cust_orderstatus];
    if ([status isEqualToString:@"0"]) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@",@"等待接货"];
    }else if ([status isEqualToString:@"1"]){
        self.statusLabel.text = [NSString stringWithFormat:@"%@",@"服务开始"];
        self.statusLabel.textColor = UIColorFromRGB(0xFE5100);
    }else if ([status isEqualToString:@"2"]){
        self.statusLabel.text = [NSString stringWithFormat:@"%@",@"已完成"];
    }else{
        //        self.statusLabel.hidden = YES;
        self.statusLabel.text = [NSString stringWithFormat:@"%@",@"已取消"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
