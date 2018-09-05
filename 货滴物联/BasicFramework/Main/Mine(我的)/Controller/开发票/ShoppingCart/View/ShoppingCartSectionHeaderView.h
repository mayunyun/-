//
//  ShoppingCartSectionHeaderView.h
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/6.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopModel;
@class ShoppingCartSectionHeaderView;

@interface ShoppingCartSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic) NSInteger section;//SectionHeader对应的section的index

- (void)setInfo:(ShopModel *)shopModel;
@end
