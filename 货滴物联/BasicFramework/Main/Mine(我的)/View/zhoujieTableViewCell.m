//
//  zhoujieTableViewCell.m
//  BasicFramework
//
//  Created by LONG on 2018/5/17.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "zhoujieTableViewCell.h"

#import <UIImageView+WebCache.h>

@interface zhoujieTableViewCell ()
{
    UIView * _bgview;
    DDButton *_selectBtn;
    UIButton *_bigBut;
    UILabel *_orderLabel;
    UILabel *_priceLabel;
    UILabel *_nameLabel;
    UILabel *_photoLabel;
    UIImageView *_endPoint;
    UILabel *_endLabel;
    
}
@end

@implementation zhoujieTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgview.frame = CGRectMake(30, 0, SCREEN_WIDTH-30, 100);
    _lineLabel.frame = CGRectMake(0, 0,_bgview.width, 1);
    _selectBtn.frame = CGRectMake(-12, self.height*0.5-16, 24, 24);
    _bigBut.frame = CGRectMake(0, 0, 50, 100);

    _orderLabel.frame = CGRectMake(_selectBtn.toLeftMargin+15, 0, SCREEN_WIDTH-110, 30);
    _priceLabel.frame = CGRectMake(SCREEN_WIDTH-110, 0, 60, 30);
    _nameLabel.frame = CGRectMake(_selectBtn.toLeftMargin+15, 30, SCREEN_WIDTH-160, 30);
    _photoLabel.frame = CGRectMake(_bgview.width-120, 30, 100, 30);
    _endPoint.frame = CGRectMake(_selectBtn.toLeftMargin+15, _photoLabel.toTopMargin+10, 10, 10);
    _endLabel.frame = CGRectMake(_endPoint.toLeftMargin+5, _photoLabel.toTopMargin+5, SCREEN_WIDTH-100, 20);
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _bgview = [[UIView alloc]init];
        _bgview.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgview];
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_bgview addSubview:_lineLabel];
        _selectBtn = [DDButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhong_2"] forState:UIControlStateNormal];
        //[_selectBtn addTarget:self action:@selector(selectedGoods:) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_selectBtn];
        
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.font = [UIFont systemFontOfSize:14];
        _orderLabel.textColor = [UIColor blackColor];
        [_bgview addSubview:_orderLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.textColor = UIColorFromRGB(0xD10000);
        _priceLabel.font = [UIFont systemFontOfSize:14];
        [_bgview addSubview:_priceLabel];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor blackColor];
        [_bgview addSubview:_nameLabel];
        
        _photoLabel = [[UILabel alloc] init];
        _photoLabel.font = [UIFont systemFontOfSize:14];
        _photoLabel.textColor = [UIColor blackColor];
        _photoLabel.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview:_photoLabel];
        
        _endPoint = [[UIImageView alloc] init];
        _endPoint.backgroundColor = UIColorFromRGB(0xC80000);
        _endPoint.layer.cornerRadius = 5.f;
        _endPoint.layer.masksToBounds = YES;
        [_bgview addSubview:_endPoint];
    
        _endLabel = [[UILabel alloc] init];
        [_bgview addSubview:_endLabel];
        
        _bigBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigBut addTarget:self action:@selector(selectedGoods:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_bigBut];
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


- (void)setqianyueInfo:(ZhoujieModel *)model{
    
    //    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.imageUrl] placeholderImage:[UIImage imageNamed:@"shopCart"]];
    
    _select = model.isSelected;
    UIImage *selectBtnImage = _select?(ImgName(@"xuanzhong_1")):(ImgName(@"xuanzhong_2"));
    [_selectBtn setBackgroundImage:selectBtnImage forState:UIControlStateNormal];
    
    _orderLabel.text = [NSString stringWithFormat:@"订单号：%@",model.orderno];
    _endLabel.text = [NSString stringWithFormat:@"%@",model.eaddress];
    _nameLabel.text = [NSString stringWithFormat:@"收货人：%@",model.linkname];
    _photoLabel.text = [NSString stringWithFormat:@"%@",model.linkphone];
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.money];
}

@end
