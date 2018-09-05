//
//  ShoppingCartSectionHeaderView.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/6.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ShoppingCartSectionHeaderView.h"


@interface ShoppingCartSectionHeaderView ()
{
    
    UILabel *_titleLabel;
}
@end

@implementation ShoppingCartSectionHeaderView

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(10, 0, kScreenWidth-100, self.height);
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}
-(void)setInfo:(NSString *)title{
    _titleLabel.text = title;
}
@end
