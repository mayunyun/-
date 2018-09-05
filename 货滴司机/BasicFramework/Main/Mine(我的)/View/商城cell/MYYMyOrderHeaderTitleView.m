//
//  MYYMyOrderHeaderTitleView.m
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMyOrderHeaderTitleView.h"

@interface MYYMyOrderHeaderTitleView()

@property(nonatomic,weak) UIButton *selectedBtn;

@property(nonatomic,strong) NSMutableArray *btns;
@property(nonatomic,strong) NSMutableArray *dividers;
@property(nonatomic,weak) UIView *selectedView;


@end
@implementation MYYMyOrderHeaderTitleView
- (NSMutableArray *)btns
{
    if(_btns==nil)
    {
        _btns =[NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if(_dividers==nil)
    {
        _dividers =[NSMutableArray array];
    }
    return _dividers;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        [self addButtonWithTitle:@"全部"];
        [self addButtonWithTitle:@"待支付"];
        [self addButtonWithTitle:@"待发货"];
        [self addButtonWithTitle:@"待收货"];
        [self addButtonWithTitle:@"已完成"];
        for (int i = 1; i<5; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UIScreenW/5*i, 10, 1, 20)];
            view.backgroundColor = UIColorFromRGB(0xececec);
            [self addSubview:view];
        }
        //添加底部的横线
        [self addSeparatorView];
        
    }
    return self;
}


- (void)addSeparatorView
{
    UIView *lineView =[[UIView alloc]init];
    lineView.frame = CGRectMake(0, 39, UIScreenW/5, 1);
    lineView.backgroundColor=MYColor;
    [self.dividers addObject:lineView];
    [self addSubview:lineView];
    self.selectedView = lineView;
    
    
}

- (void)addButtonWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, UIScreenW/5, 39)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.adjustsImageWhenHighlighted = NO;
    [btn setHighlighted:NO];
    [btn setTitleColor:MYColor forState:UIControlStateSelected];
    if(self.btns.count==0)
    {
        [self click:btn];
    }
    [self.btns addObject:btn];
    
    [self addSubview:btn];
    
}


- (void)click:(UIButton *)btn
{
    
    
    if([self.delegate respondsToSelector:@selector(titleView:scollToIndex:)])
    {
        [self.delegate titleView:self scollToIndex:btn.tag];
    }
    
    self.selectedBtn.selected = NO;
    self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    btn.selected = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.selectedBtn = btn;
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.selectedView.transform = CGAffineTransformMakeTranslation((btn.tag) * UIScreenW/5, 0);
    }];
    
}

- (void)wanerSelected:(NSInteger)tagIndex
{
    self.selectedBtn.selected = NO;
    self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    UIButton *btn = self.btns[tagIndex];
    btn.selected = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.selectedBtn = btn;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.selectedView.transform = CGAffineTransformMakeTranslation((btn.tag) * UIScreenW/5, 0);
    }];
    
    
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];

    
    CGFloat btnY=0;
    int count=(int)self.btns.count;
    CGFloat btnX=0;
    CGFloat btnW=self.frame.size.width/count;
    CGFloat btnH=self.frame.size.height;
    for(int i=0;i<count;i++){
        btnX=btnW*i;
        UIButton *btn=(UIButton *)self.btns[i];
        btn.tag=i;
        btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
    }
    
}

@end
