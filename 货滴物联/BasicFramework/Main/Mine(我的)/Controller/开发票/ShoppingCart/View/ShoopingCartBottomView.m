//
//  ShoopingCartBottomView.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/5.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ShoopingCartBottomView.h"

@interface ShoopingCartBottomView ()
{
    DDButton *_selectAllBtn;
    UIButton *_balanceBtn;
}
@end

@implementation ShoopingCartBottomView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _selectAllBtn.frame = CGRectMake(0, 0, 88+20, self.height);
    _allPriceLabel.frame = CGRectMake(88+20, 0, kScreenWidth-(88+20)*2-10-40, self.height);
    _balanceBtn.frame = CGRectMake(kScreenWidth-100-20-10, 10, 100+20, self.height-20);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _selectAllBtn = [DDButton buttonWithType:UIButtonTypeCustom];
        [_selectAllBtn setImage:[UIImage imageNamed:@"开发票未选择"] forState:UIControlStateNormal];
        [_selectAllBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectAllBtn addTarget:self action:@selector(selectedAll:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectAllBtn];
        
        _allPriceLabel = [[DDLabel alloc] init];
        _allPriceLabel.text = @"";
        _allPriceLabel.numberOfLines = 2;
        _allPriceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_allPriceLabel];
        
        _balanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_balanceBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_balanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_balanceBtn setBackgroundColor:UIColorFromRGB(0xFF4E4E)];
        [_balanceBtn setAlpha:0.5];
        [_balanceBtn setEnabled:NO];
        _balanceBtn.layer.cornerRadius = 15;
        [_balanceBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_balanceBtn];
    }
    return self;
}

- (void)selectedAll:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self setBtnImg:btn.selected];
    if ([self.delegate respondsToSelector:@selector(allGoodsIsSelected:withButton:)])
    {
        [self.delegate allGoodsIsSelected:btn.selected withButton:btn];
    }
}
- (void)setBtnImg:(BOOL)selected {
    if (selected) {
        [_selectAllBtn setImage:ImgName(@"开发票选择") forState:(UIControlStateNormal)];
    } else {
        [_selectAllBtn setImage:ImgName(@"开发票未选择") forState:(UIControlStateNormal)];
    }
}
- (void)pay:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(paySelectedGoods:)]) {
        [self.delegate paySelectedGoods:btn];
    }
}

- (void)setIsClick:(BOOL)isClick {
    _isClick = isClick;
    _selectAllBtn.selected = _isClick;
    [self setBtnImg:_isClick];
}
- (void)setPayEnable:(BOOL)payEnable {
    _payEnable = payEnable;
    if (_payEnable) {
        [_balanceBtn setAlpha:1.0];
    } else {
        [_balanceBtn setAlpha:0.5];
    }
    [_balanceBtn setEnabled:_payEnable];
}

@end
