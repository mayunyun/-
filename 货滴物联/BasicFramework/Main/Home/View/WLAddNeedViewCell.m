//
//  WLAddNeedViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WLAddNeedViewCell.h"
@interface WLAddNeedViewCell()

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UIButton *xuanbut;//

@end

@implementation WLAddNeedViewCell
- (void)setdata:(WLAddNeedModel *)model othernumer:(NSInteger)numer needArr:(NSArray *)arr
{
    self.model = model;
    UIView *contentView = self.contentView;
    CGFloat margin = 10*MYWIDTH;
    
    //设置各控件的frame以及data
    //背景
    _bgview.sd_layout
    .leftSpaceToView(contentView, 1.5*margin)
    .topSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 1.5*margin)
    .bottomSpaceToView(contentView, 0);
    
    //BUT
    if (numer==0) {
        _xuanbut.sd_layout
        .topSpaceToView(_bgview, margin)
        .leftSpaceToView(_bgview,2 * margin)
        .heightIs(30*MYWIDTH)
        .widthIs(30*MYWIDTH);
        
        _titleView.sd_layout
        .topSpaceToView(_bgview, margin)
        .leftSpaceToView(_xuanbut, margin)
        .rightSpaceToView(_bgview,2 * margin)
        .heightIs(30*MYWIDTH);
    }else{
        _xuanbut.sd_layout
        .topSpaceToView(_bgview,1.5 * margin)
        .leftSpaceToView(_bgview,2 * margin)
        .heightIs(30*MYWIDTH)
        .widthIs(30*MYWIDTH);
        
        _titleView.sd_layout
        .topSpaceToView(_bgview, 1.5 * margin)
        .leftSpaceToView(_xuanbut, margin)
        .rightSpaceToView(_bgview,2 * margin)
        .heightIs(30*MYWIDTH);
    }
    
    _xianView.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .rightSpaceToView(_bgview, 1.5*margin)
    .bottomSpaceToView(_bgview, 0)
    .heightIs(1);

    if ([model.service_price floatValue]==0) {
        _titleView.text = [NSString stringWithFormat:@"%@(免费)",model.service_name];

    }else{
        _titleView.text = [NSString stringWithFormat:@"%@(附加%.f%%路费)",model.service_name,[model.service_price floatValue]*100];
    }
    
    if ([[NSString stringWithFormat:@"%@",model.need] isEqualToString:@"0"]) {
        _xuanbut.selected = NO;
    }else{
        _xuanbut.selected = YES;
    }
    
    if (arr.count) {
        for (WLAddNeedModel *needmodel in arr) {
            if ([needmodel.id integerValue]==[model.id integerValue]) {
                _xuanbut.selected = YES;
                self.model.need = @"1";
            }
        }
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
        [self bgview];
        [self xuanbut];
        [self titleView];
        [self xianView];
        
    }
    return self;
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
- (UIButton *)xuanbut{
    if (_xuanbut == nil) {
        _xuanbut = [[UIButton alloc]init];
        [_xuanbut setImage:[UIImage imageNamed:@"xuanzhong_2"] forState:UIControlStateNormal];
        [_xuanbut setImage:[UIImage imageNamed:@"xuanzhong_1"] forState:UIControlStateSelected];
        [_xuanbut addTarget:self action:@selector(xuanbutClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_xuanbut];
    }
    return _xuanbut;
}
-(void)xuanbutClick:(UIButton *)but{
    but.selected = !but.selected;
    if (but.selected) {
        self.model.need = @"1";
    }else{
        self.model.need = @"0";
    }
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:14];
        _titleView.textColor = UIColorFromRGBValueValue(0x333333);
        _titleView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _titleView];
    }
    
    return _titleView;
    
}
- (UILabel *)xianView
{
    if(_xianView ==nil)
    {
        _xianView =[[UILabel alloc]init];
        _xianView.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
        [_bgview addSubview: _xianView];
    }
    
    return _xianView;
    
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
