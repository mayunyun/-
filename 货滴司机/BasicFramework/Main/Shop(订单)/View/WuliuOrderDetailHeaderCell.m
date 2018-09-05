//
//  WuliuOrderDetailHeaderCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WuliuOrderDetailHeaderCell.h"

@implementation WuliuOrderDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(TCHXiaoJModel *)model{
    _model = model;
    self.orderNo.text = [NSString stringWithFormat:@"%@",_model.orderno];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_model.consigneename];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",_model.consigneephone];
    self.carType.text = [NSString stringWithFormat:@"%@",_model.weightofgoods];
    NSString * sendtime = [_model.pickuptime substringToIndex:[_model.pickuptime length] - 3];
    self.useCarTime.text = [NSString stringWithFormat:@"%@",sendtime];
    NSString * createTime = [_model.expectedarrivaltime substringToIndex:[_model.expectedarrivaltime length] - 3];
    self.createTime.text = [NSString stringWithFormat:@"%@",createTime];
    NSString * shengcheng = [_model.createtime substringToIndex:[_model.createtime length] - 3];
    self.shengchengtime.text = [NSString stringWithFormat:@"%@",shengcheng];
    
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
