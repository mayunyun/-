//
//  InvoiceDetailCell.h
//  BasicFramework
//
//  Created by 钱龙 on 2018/3/1.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceDetailCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *personBtn;

@property (weak, nonatomic) IBOutlet UITextField *taitouTf;
@property (weak, nonatomic) IBOutlet UITextField *shuihaoTf;
@property (weak, nonatomic) IBOutlet UITextField *addressTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *kaihuhangTf;
@property (weak, nonatomic) IBOutlet UITextField *contentTf;
@property (weak, nonatomic) IBOutlet UITextField *priceTf;
@property (weak, nonatomic) IBOutlet UITextField *noteTf;





@end
