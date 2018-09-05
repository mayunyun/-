//
//  editTwoTableViewCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *provenceBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *townBtn;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTf;
@property (weak, nonatomic) IBOutlet UITextField *postCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *addressLabelTf;


@property(nonatomic,strong)void(^provenceBtnBlock)();
@property (nonatomic,strong)void(^cityBtnBlock)();
@property(nonatomic,strong)void(^townBtnBlock)();
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end
