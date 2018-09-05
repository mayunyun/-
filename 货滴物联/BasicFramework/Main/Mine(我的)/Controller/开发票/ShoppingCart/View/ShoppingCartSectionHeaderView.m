//
//  ShoppingCartSectionHeaderView.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/6.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ShoppingCartSectionHeaderView.h"
#import "ShoppingCartModel.h"

@interface ShoppingCartSectionHeaderView ()
{
//    DDButton *_selectBtn;
//    UIImageView *_shopImageView;
    DDLabel *_shopTitleLabel;
}
@end

@implementation ShoppingCartSectionHeaderView

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    _selectBtn.frame = CGRectMake(10, self.height*0.5-16, 32, 32);
//    _shopImageView.frame = CGRectMake(_selectBtn.toLeftMargin+10, self.height*0.5-14, 28, 28);
    
    _shopTitleLabel.frame = CGRectMake(SCREEN_WIDTH-100, 0, 100, self.height);
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _shopTitleLabel = [[DDLabel alloc] init];
        _shopTitleLabel.textAlignment = NSTextAlignmentRight;
        _shopTitleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_shopTitleLabel];
    }
    return self;
}
- (void)setInfo:(ShopModel *)shopModel {
    _shopTitleLabel.text = shopModel.shopName;
    _shopTitleLabel.text = @"01月";
}
@end
