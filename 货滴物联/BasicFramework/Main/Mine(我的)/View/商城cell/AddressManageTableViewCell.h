//
//  AddressManageTableViewCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface AddressManageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIImageView *nameiconImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UIImageView *circleImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectCurrentButton;


@property (nonatomic,strong)AddressModel * model;
@property (nonatomic,strong)void(^editBtnClickBlock)();
@property (nonatomic,strong)void(^delBtnClickBlock)();
@property (nonatomic,strong)void(^bigEditBtnClickBlock)();
@property (nonatomic,strong)void(^bigDelBtnClickBlock)();
@property (nonatomic,strong)void(^setMorenBtnBlock)();
@property (nonatomic,strong)void(^selectCurrentButtonBlock)();
@end
