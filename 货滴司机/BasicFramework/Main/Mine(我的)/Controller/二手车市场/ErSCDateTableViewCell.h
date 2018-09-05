//
//  ErSCDateTableViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/7/17.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErSCDateTableViewCell : UITableViewCell
@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *otherView;//

- (void)setdata:(NSString *)title other:(NSString *)other;

@end
