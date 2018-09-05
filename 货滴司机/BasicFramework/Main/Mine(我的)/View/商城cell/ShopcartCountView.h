//
//  ShopcartCountView.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopcartCountViewEditBlock)(NSInteger count);

@interface ShopcartCountView : UIView

@property (nonatomic, copy) ShopcartCountViewEditBlock shopcartCountViewEditBlock;

- (void)configureShopcartCountViewWithProductCount:(NSInteger)productCount
                                      productStock:(NSInteger)productStock;

@end
