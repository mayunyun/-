//
//  FabuTableViewCell.m
//  BasicFramework
//
//  Created by LONG on 2018/7/20.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "FabuTableViewCell.h"
@interface FabuTableViewCell()

@end
@implementation FabuTableViewCell

- (void)setdata:(NSString *)title other:(NSString *)other placeholder:(NSString *)placeholder IndexPath:(NSIndexPath *)indexPath{
    CGFloat margin = 15*MYWIDTH;
    UIView *contentView = self.contentView;
    
    //设置各控件的frame以及data
    //背景
    
    _bgview.sd_layout
    .leftSpaceToView(contentView,0)
    .topSpaceToView(contentView,0.5)
    .rightSpaceToView(contentView,0)
    .bottomSpaceToView(contentView,0);
    
    
    //标题
    _titleView.sd_layout
    .leftSpaceToView(_bgview,1)
    .topSpaceToView(_bgview,0)
    .bottomSpaceToView(_bgview,0)
    .widthIs(90*MYWIDTH);
    
    
    
    _otherView.sd_layout
    .leftSpaceToView(_titleView,margin)
    .topSpaceToView(_bgview,2)
    .bottomSpaceToView(_bgview,0)
    .rightSpaceToView(_bgview,1);
    
    if (indexPath.row == 1||indexPath.row == 2) {
        _otherView.hidden = YES;
        _button.hidden = NO;
        UIImage *image = [UIImage imageNamed:@"车型三角"];
        [_button setTitle:other forState:UIControlStateNormal];
        [_button setImage:image forState:UIControlStateNormal];

        CGSize size = [_button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
        // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
        CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
        _button.sd_layout
        .leftSpaceToView(_titleView,margin)
        .topSpaceToView(_bgview,2)
        .bottomSpaceToView(_bgview,0)
        .widthIs(size1.width+25);
        [_button setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
        [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
        
    }else if(indexPath.row == 5||indexPath.row == 6){
        _otherView.hidden = YES;
        _button.hidden = NO;
        
        _button.sd_layout
        .leftSpaceToView(_titleView,margin)
        .topSpaceToView(_bgview,2)
        .bottomSpaceToView(_bgview,0)
        .rightSpaceToView(_bgview,1);
        [_button setTitle:other forState:UIControlStateNormal];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }else{
        _otherView.hidden = NO;
        _button.hidden = YES;
    }
    
    _titleView.text = title;
    _otherView.text = other;
    _otherView.placeholder = placeholder;
    [self placeholderColor:_otherView str:_otherView.placeholder color:UIColorFromRGB(0x666666)];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self bgview];
        [self titleView];
        [self otherView];
        [self button];
    }
    return self;
}
- (UIButton *)button{
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        _button.titleLabel.numberOfLines = 0;
        [_bgview addSubview:_button];
    }
    return _button;
}
- (UIView *)bgview
{
    if(_bgview ==nil)
    {
        _bgview =[[UIView alloc]init];
        _bgview.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgview];
    }
    
    return _bgview;
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:15];
        _titleView.textColor = UIColorFromRGB(0x333333);
        _titleView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _titleView];
    }
    
    return _titleView;
    
}
- (UITextField *)otherView
{
    if(_otherView ==nil)
    {
        _otherView =[[UITextField alloc]init];
        _otherView.font = [UIFont systemFontOfSize:15];
        [_bgview addSubview: _otherView];
    }
    
    return _otherView;
    
}
//改textField中placeholderColor
- (void)placeholderColor:(UITextField*)textField str:(NSString*)holderText color:(UIColor*)color{
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:color
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"PingFangSC-Regular" size:13*MYWIDTH]
                        range:NSMakeRange(0, holderText.length)];
    textField.attributedPlaceholder = placeholder;
}
@end
