//
//  FabuTableViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/7/20.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabuTableViewCell : UITableViewCell
@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UITextField *otherView;//
@property(nonatomic,strong) UIButton *button;//


- (void)setdata:(NSString *)title other:(NSString *)other placeholder:(NSString *)placeholder IndexPath:(NSIndexPath *)indexPath;
@end
