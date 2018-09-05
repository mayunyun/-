//
//  ShopcartCountView.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShopcartCountView.h"

@interface ShopcartCountView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *increaseButton;
@property (nonatomic, strong) UIButton *decreaseButton;
@property (nonatomic, strong) UITextField *editTextField;

@end
@implementation ShopcartCountView

- (instancetype)init {
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.increaseButton];
    [self addSubview:self.decreaseButton];
    [self addSubview:self.editTextField];
}

- (void)configureShopcartCountViewWithProductCount:(NSInteger)productCount productStock:(NSInteger)productStock {
    if (productCount == 1) {
        self.decreaseButton.enabled = NO;
        self.increaseButton.enabled = YES;
    } else if (productCount == productStock) {
        self.decreaseButton.enabled = YES;
        self.increaseButton.enabled = NO;
    } else {
        self.decreaseButton.enabled = YES;
        self.increaseButton.enabled = YES;
    }
    
    self.editTextField.text = [NSString stringWithFormat:@"%ld", productCount];
}

- (void)decreaseButtonAction {
    NSInteger count = self.editTextField.text.integerValue;
    if (self.shopcartCountViewEditBlock) {
        self.shopcartCountViewEditBlock(-- count);
    }
}

- (void)increaseButtonAction {
    NSInteger count = self.editTextField.text.integerValue;
    if (self.shopcartCountViewEditBlock) {
        self.shopcartCountViewEditBlock(++ count);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.shopcartCountViewEditBlock) {
        self.shopcartCountViewEditBlock(self.editTextField.text.integerValue);
    }
}

- (UITextField *)editTextField {
    if(_editTextField == nil) {
        _editTextField = [[UITextField alloc] init];
        _editTextField.frame = CGRectMake(30*MYWIDTH, 0, 40*MYWIDTH, 30*MYWIDTH);
        _editTextField.textAlignment=NSTextAlignmentCenter;
        _editTextField.keyboardType=UIKeyboardTypeNumberPad;
        _editTextField.clipsToBounds = YES;
        _editTextField.layer.borderColor = [[UIColor colorWithRed:0.776  green:0.780  blue:0.789 alpha:1] CGColor];
        _editTextField.layer.borderWidth = 0.5;
        _editTextField.delegate = self;
        _editTextField.font=[UIFont systemFontOfSize:13];
        _editTextField.backgroundColor = [UIColor whiteColor];
    }
    return _editTextField;
}

- (UIButton *)decreaseButton {
    if(_decreaseButton == nil) {
        _decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _decreaseButton.frame = CGRectMake(0, 0, 30*MYWIDTH, 30*MYWIDTH);
        [_decreaseButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_normal"] forState:UIControlStateNormal];
        [_decreaseButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_no"] forState:UIControlStateDisabled];
        [_decreaseButton addTarget:self action:@selector(decreaseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _decreaseButton;
}

- (UIButton *)increaseButton
{
    if(_increaseButton == nil)
    {
        _increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _increaseButton.frame = CGRectMake(70*MYWIDTH, 0, 30*MYWIDTH, 30*MYWIDTH);
        [_increaseButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_normal"] forState:UIControlStateNormal];
        [_increaseButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_no"] forState:UIControlStateDisabled];
        [_increaseButton addTarget:self action:@selector(increaseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _increaseButton;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.decreaseButton.sd_layout
//    .leftEqualToView(self)
//    .topEqualToView(self)
//    .bottomEqualToView(self)
//    .widthIs(self.height);
//
//    self.increaseButton.sd_layout
//    .rightEqualToView(self)
//    .topEqualToView(self)
//    .bottomEqualToView(self)
//    .widthIs(self.height);
//
//    self.editTextField.sd_layout
//    .topEqualToView(self)
//    .bottomEqualToView(self)
//    .leftEqualToView(self.decreaseButton)
//    .rightEqualToView(self.increaseButton);
    
}


@end
