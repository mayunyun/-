//
//  InfoMationCell.m
//  BasicFramework
//
//  Created by 钱龙 on 2018/3/1.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "InfoMationCell.h"

@implementation InfoMationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.emailTf.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
//以下两个代理方法可以防止键盘遮挡textview
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:2];
//    InfoMationCell * infoCell = [self.tableView cellForRowAtIndexPath:index];
    
    
    [UIView animateWithDuration:0.5f animations:^{
        if (textField==self.emailTf) {
            kWindow.frame = CGRectMake(0, -UIScreenH/3, UIScreenW, UIScreenH);
        }
        
    }];
    
}
//完成编辑的时候下移回来（只要把offset重新设为0就行了）
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3f animations:^{
        kWindow.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);
        
    }];
    
}
@end
