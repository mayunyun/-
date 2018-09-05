//
//  DWTagView.h
//  MaiBaTe
//
//  Created by LONG on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJTagViewProtocol.h"

@interface DWTagView : UIView
@property (nonatomic, weak) id<DWTagViewDelegate> delegate;
@property (nonatomic, weak) id<DWTagViewDataSource> dataSource;

/** 外观配置项 */

@property (nonatomic, strong) UIColor *themeColor;

@property (nonatomic, assign) NSInteger tagCornerRadius;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) int numer;

- (void)reloadData;
@end
