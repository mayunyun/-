//
//  ShopCarTableViewCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SABookModel.h"
@interface ShopCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UITextField *countTf;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (strong, nonatomic) IBOutlet UIButton *bigDownBtn;
@property (strong, nonatomic) IBOutlet UIButton *bigUpBtn;


@property (weak, nonatomic) IBOutlet UILabel *productDescribtion;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (strong, nonatomic) IBOutlet UIView *bgView;


@property(assign,nonatomic)BOOL selectState;//选中状态
@property (nonatomic,strong)void(^downBtnClickBlock)();
@property (nonatomic,strong)void(^upBtnClickBlock)();
@property (nonatomic,strong)void(^delBtnClickBlock)();
@property (nonatomic,strong)void(^selectBtnClickBlock)();
@property (nonatomic,strong) SABookModel * bookModel;
@end
