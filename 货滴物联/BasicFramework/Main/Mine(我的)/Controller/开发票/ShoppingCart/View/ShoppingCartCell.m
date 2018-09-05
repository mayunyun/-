//
//  ShoppingCartCell.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/5.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "InvoiceModel.h"
#import <UIImageView+WebCache.h>

@interface ShoppingCartCell ()
{
    UIImageView * _bgview;
    DDButton *_selectBtn;
    UILabel *_startPoint;
    UILabel *_endPoint;
    UILabel *_startLabel;
    UILabel *_endLabel;
    UILabel *_timeLabel;
    UILabel *_priceLabel;
    
}
@end

@implementation ShoppingCartCell

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgview.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 165);
    _selectBtn.frame = CGRectMake(10, _bgview.height-35, 24, 24);
    _startPoint.frame = CGRectMake(10, 15, 45, 20);
    _startLabel.frame = CGRectMake(_startPoint.toLeftMargin+5, 15, SCREEN_WIDTH-150, 20);
    _endPoint.frame = CGRectMake(10, _startLabel.toTopMargin+5, 45, 20);
    _endLabel.frame = CGRectMake(_endPoint.toLeftMargin+5, _startLabel.toTopMargin+5, SCREEN_WIDTH-150, 20);
    _lineLabel.frame = CGRectMake(0, _endLabel.toTopMargin+15,_bgview.width, 1);

    _timeLabel.frame = CGRectMake(10, _lineLabel.toTopMargin+5, SCREEN_WIDTH-150, 20);
    _priceLabel.frame = CGRectMake((_bgview.width-140*MYWIDTH)/2, _timeLabel.toTopMargin+15, 140*MYWIDTH, 35);
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _bgview = [[UIImageView alloc]init];
        _bgview.userInteractionEnabled = YES;
        _bgview.image = [UIImage imageNamed:@"开发票"];
        [self.contentView addSubview:_bgview];
        
        
        _selectBtn = [DDButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhong_2"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectedGoods:) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_selectBtn];

        _startPoint = [[UILabel alloc] init];
        _startPoint.textColor = [UIColor blackColor];
        _startPoint.font = [UIFont systemFontOfSize:14];
        _startPoint.text = @"起点:";
        [_bgview addSubview:_startPoint];
        
        _endPoint = [[UILabel alloc] init];
        _endPoint.textColor = [UIColor blackColor];
        _endPoint.font = [UIFont systemFontOfSize:14];
        _endPoint.text = @"终点:";
        [_bgview addSubview:_endPoint];
        
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_bgview addSubview:_lineLabel];
        
        _startLabel = [[UILabel alloc] init];
        _startLabel.font = [UIFont systemFontOfSize:14];
        [_bgview addSubview:_startLabel];
        
        _endLabel = [[UILabel alloc] init];
        _endLabel.font = [UIFont systemFontOfSize:14];
        [_bgview addSubview:_endLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
        [_bgview addSubview:_timeLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.backgroundColor = UIColorFromRGB(0xFF4E4E);
        _priceLabel.layer.cornerRadius = 8;
        _priceLabel.layer.masksToBounds = YES;
        [_bgview addSubview:_priceLabel];
    }
    return self;
}

- (void)selectedGoods:(UIButton *)btn {
    _select = !_select;
    UIImage *selectBtnImage = (_select)?(ImgName(@"xuanzhong_1")):(ImgName(@"xuanzhong_2"));
    [_selectBtn setBackgroundImage:selectBtnImage forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(cell:selected:indexPath:)]) {
        [self.delegate cell:self selected:_select indexPath:self.indexPath];
    }
}

- (void)setInfo:(InvoiceModel *)inModel {
    
//    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.imageUrl] placeholderImage:[UIImage imageNamed:@"shopCart"]];
    
    _select = inModel.isSelected;
    UIImage *selectBtnImage = _select?(ImgName(@"xuanzhong_1")):(ImgName(@"xuanzhong_2"));
    [_selectBtn setBackgroundImage:selectBtnImage forState:UIControlStateNormal];

    _startLabel.text = inModel.startaddress;
    _endLabel.text = inModel.endaddress;
    _timeLabel.text = [NSString stringWithFormat:@"行程时间:%@",inModel.createtime];
    _priceLabel.text = [NSString stringWithFormat:@"%@元",inModel.ordertotalprice];
}

@end
