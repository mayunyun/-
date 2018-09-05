//
//  CancleOrderView.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancleOrderView : UITableViewHeaderFooterView
@property (nonatomic,strong)void(^cancleBtnBlock)(void);
@property (nonatomic,strong)void(^startBtnBlock)(void);
@property (nonatomic,strong)void(^endBtnBlock)(void);
@property (nonatomic,strong)void(^driverSyBlock)(void);
@property (nonatomic,strong) UIButton * startbut;
@property (nonatomic,strong) UIButton * canclebut;
@property (nonatomic,strong) UIButton * endbut;
@property (nonatomic,strong) UIButton * driverSybut;
@property (nonatomic,strong) UIButton * goRemarkdbut;
@property (nonatomic,strong)NSArray * status;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
