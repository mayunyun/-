//
//  AddressManageTableViewCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AddressManageTableViewCell.h"

@implementation AddressManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(AddressModel *)model{
    _model = model;
    self.nameTextField.text = [NSString stringWithFormat:@"%@",model.shcustname];
    self.addressLabel.text = [NSString stringWithFormat:@"%@",model.address];
    self.telphoneLabel.text = [NSString stringWithFormat:@"%@",model.shphone];
    if ([model.isdefault isEqual:@1]) {
        self.selectImage.image = [UIImage imageNamed:@"morenDZ_1"];
        self.circleImageView.image = [UIImage imageNamed:@"xuanzhong"];
    }else{
        self.selectImage.image = [UIImage imageNamed:@"morenDZ_2"];
        self.circleImageView.image = [UIImage imageNamed:@"weixuanzhong"];
    }
    
}
- (IBAction)selectCurrentAddressBtnClicked:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (self.selectCurrentButton.selected) {
        self.circleImageView.image = [UIImage imageNamed:@"xuanzhong"];
    }else{
        self.circleImageView.image = [UIImage imageNamed:@"weixuanzhong"];
    }
    if (_selectCurrentButtonBlock) {
        self.selectCurrentButtonBlock();
    }
}
- (IBAction)bigDelBtnClicked:(id)sender {
    if (_bigDelBtnClickBlock) {
        self.bigDelBtnClickBlock();
    }
}

- (IBAction)bigEditBtnClicked:(id)sender {
    if (_bigEditBtnClickBlock) {
        self.bigEditBtnClickBlock();
    }
}

- (IBAction)editBtnClicked:(id)sender {
    if (_editBtnClickBlock) {
        self.editBtnClickBlock();
    }
}
- (IBAction)delBtnClicked:(id)sender {
    if (_delBtnClickBlock) {
        self.delBtnClickBlock();
    }
}
- (IBAction)setMorenBtnClicked:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (self.selectBtn.selected) {
        self.selectImage.image = [UIImage imageNamed:@"morenDZ_1"];
    }else{
        self.selectImage.image = [UIImage imageNamed:@"morenDZ_2"];
    }
    if (_selectBtn) {
        
        self.setMorenBtnBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
