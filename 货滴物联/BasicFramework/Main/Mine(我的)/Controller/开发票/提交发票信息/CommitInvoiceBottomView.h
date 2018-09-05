//
//  CommitInvoiceBottomView.h
//  BasicFramework
//
//  Created by 钱龙 on 2018/3/1.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitInvoiceBottomView : UIView
@property (nonatomic, assign) BOOL payEnable;//结算安妮是否可点击
@property (nonatomic,strong)void(^commitBtnBlock)();

@end
