//
//  zhoujieTableViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/5/17.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhoujieModel.h"
@class zhoujieTableViewCell;

@protocol zhoujieTableViewCellDelegate <NSObject>

/**
 cell上选中按钮代理
 
 @param cell self
 @param isSelected 是否是选中状态
 @param indexPath 当前cell对应的indexPath
 */
- (void)cell:(zhoujieTableViewCell *)cell selected:(BOOL)isSelected indexPath:(NSIndexPath *)indexPath;

@end

@interface zhoujieTableViewCell : UITableViewCell

@property (nonatomic, weak) id <zhoujieTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;//cell对应的indexPath
@property (nonatomic, assign) BOOL select;//是否是选中对应的商品
@property (nonatomic,strong)UILabel * lineLabel;
//赋值方法

- (void)setqianyueInfo:(ZhoujieModel *)inModel;

@end
