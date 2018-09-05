//
//  CarDetailTitleTableViewCell.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarDetailTitleTableViewCell.h"
#import "CarDetailModel.h"
@implementation CarDetailTitleTableViewCell{
    UILabel* _titleLabel;
    UILabel* _locopriceLabel;
    UILabel* _msrpLabel;
    UIImageView* _leftimgView;
    UIImageView* _rightimgView;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self creatUI];
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)creatUI{
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 25*GMYWIDTH, kScreenWidth - 30*GMYWIDTH, 20*GMYWIDTH)];
    [self addSubview:_titleLabel];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20.0];
    
    _locopriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom+15*GMYWIDTH, kScreenWidth - 30*GMYWIDTH, 15*GMYWIDTH)];
    _locopriceLabel.textColor = UIColorFromRGB(0x888888);
    _locopriceLabel.font = [UIFont systemFontOfSize:14*GMYWIDTH];
    [self addSubview:_locopriceLabel];

    _msrpLabel = [[UILabel alloc]initWithFrame:CGRectMake(_locopriceLabel.left, _locopriceLabel.bottom+15*GMYWIDTH, _locopriceLabel.width, _locopriceLabel.height)];
    _msrpLabel.textColor = _locopriceLabel.textColor;
    _msrpLabel.font = _locopriceLabel.font;
    [self addSubview:_msrpLabel];
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#C30E21"] range:NSMakeRange(location, length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:16.0] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}

- (void)setData
{
    CarDetailModel* model = [[CarDetailModel alloc]init];
    if (!IsEmptyValue(_dataArr)) {
        model = _dataArr[0];
    }
    if (!IsEmptyValue(model.carname)) {
        _titleLabel.text = [NSString stringWithFormat:@"%@",model.carname];
    }else{
        _titleLabel.text = @"";

    }
    NSString* money = [NSString stringWithFormat:@"%@",model.localprice];
    if (!IsEmptyValue(model.localprice)) {
        _locopriceLabel.text = [NSString stringWithFormat:@"本地参考报价：%@万起",money];
        [self changeTextColor:_locopriceLabel Txt:_locopriceLabel.text changeTxt:money];
    }else{
        _locopriceLabel.text = @"";
        
    }
    

    NSString* msrmoeystr = [NSString stringWithFormat:@"%@",model.factoryprice];
    if (!IsEmptyValue(model.factoryprice)) {
        _msrpLabel.text = [NSString stringWithFormat:@"厂商指导价：%@万起",msrmoeystr];
    }else{
        _msrpLabel.text = @"";
        
    }
    
}

@end
