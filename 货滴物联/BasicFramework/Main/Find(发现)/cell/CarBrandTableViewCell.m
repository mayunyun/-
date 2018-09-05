//
//  CarBrandTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 17/9/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarBrandTableViewCell.h"

@implementation CarBrandTableViewCell

- (void)setData:(CarBrandModel *)data
{
    _data = data;
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10*MYWIDTH;
    
    //设置各控件的frame以及data
    
  
    
    //头像
    _iconView.sd_layout
    .leftSpaceToView(contentView,margin)
    .topSpaceToView(contentView,1.25 * margin)
    .widthIs(125*MYWIDTH)
    .heightIs(75*MYWIDTH);
    
    //线
    _xianview1.sd_layout
    .leftSpaceToView(_iconView,1.5 * margin)
    .topSpaceToView(contentView,20*MYWIDTH)
    .widthIs(0.5)
    .heightIs(60*MYWIDTH);

    //标题
    _titleView.sd_layout
    .leftSpaceToView(_xianview1,1.5 * margin)
    .topSpaceToView(contentView,1.25 * margin)
    .rightSpaceToView(contentView,1.25 * margin)
    .heightIs(30);
    
    
    //描述
    _textView.sd_layout
    .leftSpaceToView(_xianview1,1.5 * margin)
    .topSpaceToView(_titleView,0.5 * margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(30);
    
    //线
    _xianview2.sd_layout
    .leftSpaceToView(contentView,margin)
    .bottomSpaceToView(contentView,0)
    .rightSpaceToView(contentView,margin)
    .heightIs(0.5);

    
    NSString *image = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,_data.folder,_data.autoname];
    
    NSLog(@"%@",image);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [_titleView setText:[NSString stringWithFormat:@"%@",_data.groupname]];

    NSString *urlString = [NSString stringWithFormat:@"厂商指导价:%.2f万起",[_data.groupprice floatValue]];
    NSScanner *scanner = [NSScanner scannerWithString:urlString];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    
    float number;
    [scanner scanFloat:&number];
    NSString *num=[NSString stringWithFormat:@"%.2f",number];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:urlString];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:num];
    [hintString addAttribute:NSForegroundColorAttributeName value:MYColor range:range1];
    [hintString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18.0] range:range1];

    _textView.attributedText = hintString;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self xianview1];
        [self xianview2];
        [self iconView];//头像
        [self titleView];
        [self textView];
        
    }
    return self;
}


- (UIView *)xianview1
{
    if(_xianview1 ==nil)
    {
        _xianview1 =[[UIView alloc]init];
        _xianview1.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self.contentView addSubview:_xianview1];
    }
    
    return _xianview1;
}
- (UIView *)xianview2
{
    if(_xianview2 ==nil)
    {
        _xianview2 =[[UIView alloc]init];
        _xianview2.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self.contentView addSubview:_xianview2];
    }
    
    return _xianview2;
}
//头像view
- (UIImageView *)iconView
{
    if(_iconView ==nil)
    {
        _iconView =[[UIImageView alloc]init];
        
        [self.contentView addSubview:_iconView];
    }
    
    return _iconView;
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:13];
        _titleView.textColor = UIColorFromRGB(0x333333);
        _titleView.numberOfLines = 0;
        [self.contentView addSubview: _titleView];
    }
    
    return _titleView;
    
}
- (UILabel *)textView
{
    if(_textView ==nil)
    {
        _textView =[[UILabel alloc]init];
        _textView.font = [UIFont systemFontOfSize:11];
        _textView.textColor = UIColorFromRGB(0x555555);
        _textView.numberOfLines = 0;
        [self.contentView addSubview: _textView];
    }
    
    return _textView;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
