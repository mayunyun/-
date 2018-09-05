//
//  PLTagView.h
//  BasicFramework
//
//  Created by LONG on 2018/6/21.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJTagViewProtocol.h"


@interface PLTagView : UIView

@property (nonatomic, weak) id<PLTagViewDelegate> delegate;
@property (nonatomic, weak) id<PLTagViewDataSource> dataSource;

/** 外观配置项 */

@property (nonatomic, strong) UIColor *themeColor;

@property (nonatomic, assign) NSInteger tagCornerRadius;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) int numer;

- (void)reloadData;

@end
