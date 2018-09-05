//
//  InvoiceHistoryCell.m
//  BasicFramework
//
//  Created by 钱龙 on 2018/2/27.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "InvoiceHistoryCell.h"

@implementation InvoiceHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.time.text = [NSString stringWithFormat:@"%@",_dict[@"createtime"]];
    self.price.text = [NSString stringWithFormat:@"%@元",_dict[@"invoicemoney"]];
    [Command changeTextfont:self.price Txt:self.price.text changeTxt:[NSString stringWithFormat:@"%@",_dict[@"invoicemoney"]]];
    
    if ([_dict[@"invoicetype"] integerValue] == 0) {
        self.type.text = [NSString stringWithFormat:@"%@",@"企业发票"];
    }else{
        self.type.text = [NSString stringWithFormat:@"%@",@"个人非企业发票"];
    }
    if ([_dict[@"typeorder"] integerValue] == 0) {
        self.guige.text = [NSString stringWithFormat:@"%@",@"同城小件"];
    }else if ([_dict[@"typeorder"] integerValue] == 1) {
        self.guige.text = [NSString stringWithFormat:@"%@",@"搬家订单"];
    }else{
        self.guige.text = [NSString stringWithFormat:@"%@",@"快运订单"];
    }
    if ([_dict[@"spstatus"] integerValue] == 0) {
        self.status.text = [NSString stringWithFormat:@"%@",@"审核中"];
    }else if ([_dict[@"spstatus"] integerValue] == 1) {
        self.status.text = [NSString stringWithFormat:@"%@",@"审核通过"];
        self.status.textColor = UIColorFromRGB(0x318808);
    }else{
        self.status.text = [NSString stringWithFormat:@"%@",@"审核拒绝"];
        self.status.textColor = UIColorFromRGB(0xFF0000);
    }
    self.time.text = [NSString stringWithFormat:@"%@",_dict[@"createtime"]];
    if ([_dict[@"spcontent"] isEqualToString:@""]) {
        
        self.note.text = [NSString stringWithFormat:@"备注:%@",@"无"];
    }else{
        self.note.text = [NSString stringWithFormat:@"备注:%@",_dict[@"spcontent"]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
