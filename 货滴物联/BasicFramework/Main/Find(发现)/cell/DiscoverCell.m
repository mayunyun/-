//
//  DiscoverCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DiscoverCell.h"


//列表
#import "PingLunView.h"

//照片墙
#import "WeixinPhotoView.h"
//上三角
#import "FFDropDownMenuTriangleView.h"



@interface DiscoverCell()

@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *nameView;//昵称
@property(nonatomic,strong) UILabel *textView;//正文
@property(nonatomic,strong) WeixinPhotoView *photosView;//照片墙
@property(nonatomic,strong) UILabel *timeView;//时间
@property(nonatomic,strong) UIButton *commentBtn;//评论按钮
@property(nonatomic,strong) PingLunView *PLView;//评论列表
@property (nonatomic, strong) FFDropDownMenuTriangleView *triangleView;



@end

@implementation DiscoverCell


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
        [_nameView setFont:[UIFont systemFontOfSize:14]];
        [_nameView setTextColor:COLOR(238, 47, 56, 1)];
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
        [_textView setFont:[UIFont systemFontOfSize:13]];
        [_textView setTextColor:[UIColor blackColor]];
        _textView.numberOfLines = 0;
        [self.contentView addSubview: _textView];
    }
    
    return _textView;
    
}



//图像view
- (WeixinPhotoView *)photosView
{
    if(_photosView ==nil)
    {
        _photosView =[[WeixinPhotoView alloc]init];
        
        [self.contentView addSubview:_photosView];
    }
    
    return _photosView;
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



- (UIButton *)commentBtn
{
    if(_commentBtn==nil)
    {
        _commentBtn =[UIButton buttonWithTitle:@" 12" TitleColor:UIColorFromRGB(0x888888) titleFont:[UIFont systemFontOfSize:12] image:[UIImage imageNamed:@"评论H"] backgroundImage:nil bgColor:nil rect:CGRectMake(0, 0, 0, 0) state:UIControlStateNormal target:self action:@selector(click)];
        
        [self.contentView addSubview:_commentBtn];
    }
    return _commentBtn;
}


- (void)click
{
    [UUKeyboardInputView showKeyboardConfige:^(UUInputConfiger * _Nonnull configer) {
        // 配置信息（后续可继续添加）
        configer.keyboardType = UIKeyboardTypeDefault;
        configer.content = @"";
        configer.backgroundColor = [UIColor clearColor];
        
    }block:^(NSString * _Nonnull contentStr) {
        // 回调事件处理
        if (contentStr.length == 0) return ;
        NSLog(@"我的评论：%@",contentStr);
    }];
}


- (PingLunView *)PLView
{
    if(_PLView==nil)
    {
        _PLView = [[PingLunView alloc]init];
        //设置圆角
        _PLView.layer.cornerRadius = 5;
        //将多余的部分切掉
        _PLView.layer.masksToBounds = YES;
        [self.contentView addSubview:_PLView];
    }
    return _PLView;
}


- (FFDropDownMenuTriangleView *)triangleView {
    if (_triangleView == nil) {
        _triangleView = [[FFDropDownMenuTriangleView alloc] init];
        _triangleView.backgroundColor = [UIColor clearColor];
        _triangleView.triangleColor = UIColorFromRGB(0xEEEEEE);
        [self.contentView addSubview:_triangleView];
    }
    return _triangleView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(DiscoverData *)data
{
    _data = data;
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    //设置各控件的frame以及data
    
    //头像
    _iconView.sd_layout
    .leftSpaceToView(contentView,margin)
    .topSpaceToView(contentView,margin)
    .heightIs(35)
    .widthIs(35);
    
    //昵称
    _nameView.sd_layout
    .leftSpaceToView(_iconView,margin)
    .topSpaceToView(contentView,1.5 * margin)
    .heightIs(16);
    [_nameView setSingleLineAutoResizeWithMaxWidth:200];
    
    //时间
    _timeView.sd_layout
    .leftEqualToView(_nameView)
    .topSpaceToView(_nameView,margin)
    .heightIs(18);
    [_timeView setSingleLineAutoResizeWithMaxWidth:250];
    
    //文本
    _textView.sd_layout
    .leftEqualToView(_nameView)
    .topSpaceToView(_timeView,margin)
    .rightSpaceToView(contentView,2 * margin)
    .autoHeightRatio(0);
    
    //照片墙
    CGFloat photoMargin = 0;
    if(data.picturesArray.count)
    {
        photoMargin = 10;
    }
    _photosView.sd_layout.leftEqualToView(_nameView);
    _photosView.sd_layout.topSpaceToView(_textView,photoMargin);
    
    
    //评论按钮
    _commentBtn.sd_layout
    .topSpaceToView(_photosView,margin)
    .rightSpaceToView(contentView,2 * margin)
    .widthIs(40)
    .heightIs(25);
    
    
    //评论列表
    
    CGFloat PLViewTopMargin = 0;
    
    if(data.zanArray.count)
    {
        PLViewTopMargin = 10;
    }
    _PLView.sd_layout
    .rightSpaceToView(contentView,2 * margin)
    .widthIs(kScreenWidth-4*margin)
    .topSpaceToView(_commentBtn,PLViewTopMargin);
    [self setupAutoHeightWithBottomView:_PLView bottomMargin:margin];

    //上三角
    
    if (data.zanArray.count!=0) {
        _triangleView.sd_layout
        .leftSpaceToView(contentView, 3 * margin)
        .bottomSpaceToView(_PLView, 0)
        .widthIs(12)
        .heightIs(12);
    }else{
        _triangleView.sd_layout
        .leftSpaceToView(contentView, 3 * margin)
        .bottomSpaceToView(_PLView, 0)
        .widthIs(12)
        .heightIs(0);
    }
    
    _iconView.image= [UIImage imageNamed:data.icon];
    _iconView.layer.cornerRadius = _iconView.width * 0.5;
    _iconView.clipsToBounds = YES;
    [_nameView setText:data.name];
    [_timeView setText:data.time];
    [_textView setText:data.text];
    _photosView.picPathStringArray = data.picturesArray;
    _PLView.PLArray = data.zanArray;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self iconView];//头像
        [self nameView];//昵称
        [self textView];//正文
        [self photosView];//照片墙
        [self timeView];//时间
        [self commentBtn];
        [self PLView];//评论列表
        [self triangleView];
    }
    return self;
}


@end
