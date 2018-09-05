//
//  XiaoFeiTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 17/9/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "XiaoFeiTableViewCell.h"

@implementation XiaoFeiTableViewCell

- (void)setData:(MingXiModel *)data
{
    _data = data;
    if ([_data.type intValue] == 1) {
        //_typeimage.image = [UIImage imageNamed:@"账户入金"];
        _moneyLab.text =  [NSString stringWithFormat:@"+%.2f",[_data.money floatValue]];
    }else if([_data.type intValue] == 0){
        //_typeimage.image = [UIImage imageNamed:@"账户出金"];
        _moneyLab.text =  [NSString stringWithFormat:@"-%.2f",[_data.money floatValue]];
    }
    
    _timeLab.text = [NSString stringWithFormat:@"%@",_data.createtime];
    _jiaoyiDH.text = [NSString stringWithFormat:@"%@",_data.tradeno];
    _typeLab.text = [NSString stringWithFormat:@"%@",_data.ordertype];


//    if ([_data.paytype intValue] == 0) {
//        if ([[_jiaoyiDH.text substringToIndex:3] isEqualToString:@"YDD"]) {
//            _paytypeLab.text = @"商城（微信）";
//        }else{
//            _paytypeLab.text = @"充电（微信）";
//        }
//    }else if ([_data.paytype intValue] == 1){
//        if ([[_jiaoyiDH.text substringToIndex:3] isEqualToString:@"YDD"]) {
//            _paytypeLab.text = @"商城（支付宝）";
//        }else{
//            _paytypeLab.text = @"充电（支付宝）";
//        }
//    }else if ([_data.paytype intValue] == 2){
//        _paytypeLab.text = @"银行卡提现";
//    }else if ([_data.paytype intValue] == 3){
//        if ([[_jiaoyiDH.text substringToIndex:3] isEqualToString:@"YDD"]) {
//            _paytypeLab.text = @"商城（余额）";
//        }else{
//            _paytypeLab.text = @"充电（余额）";
//        }
//    }
    if ([_data.paytype intValue] == 0) {
        _paytypeLab.text = @"微信充值";
    }else if ([_data.paytype intValue] == 1){
        _paytypeLab.text = @"支付宝充值";
    }else if ([_data.paytype intValue] == 2){
        _paytypeLab.text = @"余额提现";
    }else if ([_data.paytype intValue] == 3){
        _paytypeLab.text = @"充电支付";
    }else if ([_data.paytype intValue] == 4){
        _paytypeLab.text = @"商城支付";
    }else if ([_data.paytype intValue] == 5){
        _paytypeLab.text = @"货主取消发货";
    }else if ([_data.paytype intValue] == 6){
        _paytypeLab.text = @"货主发货";
    }else if ([_data.paytype intValue] == 7){
        _paytypeLab.text = @"货主发货-超时取消";
    }else if ([_data.paytype intValue] == 8){
        _paytypeLab.text = @"平台盈利-取消发货";
    }else if ([_data.paytype intValue] == 9){
        _paytypeLab.text = @"司机找货-盈利";
    }else if ([_data.paytype intValue] == 10){
        _paytypeLab.text = @"平台盈利-司机找货";
    }
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
