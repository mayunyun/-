//
//  PingLunTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PingLunTableViewCell.h"

@interface PingLunTableViewCell()

@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *nameView;//昵称
@property(nonatomic,strong) UILabel *textView;//正文
@property(nonatomic,strong) UILabel *timeView;//时间
@property(nonatomic,strong) UIView *xianView;//线



@end
@implementation PingLunTableViewCell

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

//昵称
- (UILabel *)nameView
{
    if(_nameView ==nil)
    {
        _nameView =[[UILabel alloc]init];
        [_nameView setFont:[UIFont systemFontOfSize:13]];
        [_nameView setTextColor:[UIColor blueColor]];
        _nameView.numberOfLines = 0;
        
        [self.contentView addSubview:_nameView];
    }
    
    return _nameView;
}


- (UILabel *)textView
{
    if(_textView ==nil)
    {
        _textView =[[UILabel alloc]init];
        [_textView setFont:[UIFont systemFontOfSize:12]];
        [_textView setTextColor:UIColorFromRGB(0x333333)];
        _textView.numberOfLines = 0;
        [self.contentView addSubview: _textView];
    }
    
    return _textView;
    
}

//时间
- (UILabel *)timeView
{
    if(_timeView ==nil)
    {
        _timeView =[[UILabel alloc]init];
        [_timeView setFont:[UIFont systemFontOfSize:10]];
        [_timeView setTextColor:[UIColor lightGrayColor]];
        _timeView.numberOfLines = 0;
        
        [self.contentView addSubview:_timeView];
    }
    
    return _timeView;
}
//线
- (UIView *)xianView
{
    if(_xianView ==nil)
    {
        _xianView =[[UILabel alloc]init];
        _xianView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_xianView];
    }
    
    return _xianView;
}

- (void)setwithData:(NSArray *)arr inter:(NSInteger)inter;
{
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    //设置各控件的frame以及data
    
    //头像
    _iconView.sd_layout
    .leftSpaceToView(contentView,margin)
    .topSpaceToView(contentView,margin)
    .heightIs(20)
    .widthIs(20);
    
    //昵称
    _nameView.sd_layout
    .leftSpaceToView(_iconView,margin)
    .topSpaceToView(contentView,1.2 * margin)
    .heightIs(16);
    [_nameView setSingleLineAutoResizeWithMaxWidth:200];
    
    //文本
    _textView.sd_layout
    .leftSpaceToView(_nameView,0)
    .topSpaceToView(contentView,1.2 * margin)
    .rightSpaceToView(contentView,2 * margin)
    .autoHeightRatio(0);
    
    //时间
    _timeView.sd_layout
    .leftEqualToView(_nameView)
    .topSpaceToView(_textView,0.5*margin)
    .heightIs(16);
    [_timeView setSingleLineAutoResizeWithMaxWidth:250];
    
    //线
    _xianView.sd_layout
    .leftSpaceToView(contentView,margin)
    .topSpaceToView(_timeView,margin)
    .rightSpaceToView(contentView,margin);
    if (arr.count>0) {
        if (inter == arr.count-1) {
            _xianView.sd_layout.heightIs(0);
        }else{
            _xianView.sd_layout.heightIs(0.5);
        }
    }else{
        _xianView.sd_layout.heightIs(0);
    }
    
    
    [self setupAutoHeightWithBottomView:_xianView bottomMargin:0.5*margin];
    
    _iconView.image= [UIImage imageNamed:arr[inter]];
    _iconView.layer.cornerRadius = _iconView.width * 0.5;
    _iconView.clipsToBounds = YES;
    [_nameView setText:@"路人甲"];
    [_timeView setText:@"9/21 11:41"];
    [_textView setText:@"：小伙子开什么车啊！"];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self iconView];//头像
        [self nameView];//昵称
        [self textView];//正文
        [self timeView];//时间
        [self xianView];//线
    }
    return self;
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
