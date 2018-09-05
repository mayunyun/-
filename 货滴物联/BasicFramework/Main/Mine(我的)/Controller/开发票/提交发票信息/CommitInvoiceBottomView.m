//
//  CommitInvoiceBottomView.m
//  BasicFramework
//
//  Created by 钱龙 on 2018/3/1.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "CommitInvoiceBottomView.h"
@interface CommitInvoiceBottomView ()
{
    
    UIButton *_commitBtn;
}
@end
@implementation CommitInvoiceBottomView
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _commitBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //_commitBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_commitBtn setBackgroundColor:UIColorFromRGB(0xD50000) forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commitBtn];
    }
    return self;
}
-(void)commitBtnClicked{
    if (_commitBtnBlock) {
        self.commitBtnBlock();
    }
}

- (void)setPayEnable:(BOOL)payEnable {
    _payEnable = payEnable;
    if (_payEnable) {
        [_commitBtn setAlpha:1.0];
    } else {
        [_commitBtn setAlpha:0.5];
    }
    [_commitBtn setEnabled:_payEnable];
}

@end
