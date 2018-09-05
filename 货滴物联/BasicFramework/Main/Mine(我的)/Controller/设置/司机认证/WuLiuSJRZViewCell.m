//
//  WuLiuSJRZViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WuLiuSJRZViewCell.h"

@implementation WuLiuSJRZViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)YZMButClick:(UIButton *)sender {
    [_phoneField resignFirstResponder];
    //if ([Command isMobileNumber:_phoneField.text]) {
        [self isExitsPhoneRequest];
        [sender startTime:60 title:@"请重新发送" waitTittle:@"s" finished:^(UIButton *button) {
        }];
//    }else{
//        jxt_showToastTitle(@"手机格式不正确", 1);
//    }
}
- (void)isExitsPhoneRequest{
    /*
     /mbtwz/register?action=getSMSCode"+callback1
     参数：phone  放在params中
     */
    NSString* urlstr = @"/mbtwz/register?action=getSMSCode";
    _phoneField.text = [Command convertNull:_phoneField.text];
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {

        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"验证码发送失败", 1);
        }else{
            jxt_showToastTitle(@"验证码已发送", 1);
            NSString * string = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if (_yzmCodeBlock) {
                self.yzmCodeBlock(string);
            }
        }
        
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
