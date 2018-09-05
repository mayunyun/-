//
//  BaseTabBar.m
//  BasicFramework
//
//  Created by Rainy on 16/8/18.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#define middleBT_Normal_IMG @"post_normal"
#define middleBT_Highlighted_IMG @"post_normal"
#define middleBT_Disabled_IMG @"post_normal"

#define middleLab_Title @"找货"
#define middleLab_Font ElevenFontSize

#define Selected_textColor ThemeColor
#define Normal_textColor kNormalFontColor

#import "BaseTabBar.h"

#define LBMagin 5

@interface BaseTabBar ()

@property (nonatomic, strong) UIButton *middle_BT;
@property (nonatomic, strong) UILabel *middle_Lable;

@end

@implementation BaseTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];
        self.translucent = NO;//设置为no 表示完全不透明
        //以下两行操作 是将tabbar顶部的线修改为白色(即隐藏的效果)
        [self setBackgroundImage:[UIImage new]];
        [self setShadowImage:[UIImage createImageWithColor:[UIColor whiteColor]]];
        
        [self addSubview:self.middle_BT];
    }
    return self;
}
#pragma mark - setPoint
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.middle_BT.X = ([UIScreen mainScreen].bounds.size.width - self.middle_BT.currentBackgroundImage.size.width) * 0.5;
    self.middle_BT.size = CGSizeMake(self.middle_BT.currentBackgroundImage.size.width, self.middle_BT.currentBackgroundImage.size.height);

    self.middle_Lable.Cx = self.middle_BT.Cx;
    _middle_Lable.Y = self.Sh - _middle_Lable.Sh - 1 - TabbarHeight + 49;

    self.middle_BT.Y = _middle_Lable.Y - self.middle_BT.Sh - LBMagin;

    Class class = NSClassFromString(@"UITabBarButton");
    
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:class]) {
            
            btn.Sw = self.Sw / (self.items.count + 1);

            btn.X = btn.Sw * btnIndex;

            btnIndex++;
            
            if (btnIndex == 2) {
                btnIndex++;
            }
            
        }
    }
    
    [self bringSubviewToFront:self.middle_BT];
}
- (void)middle_BTDidClick
{
    [self setWithSeccessView];
}
- (void)setWithSeccessView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:NO];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
    
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 220*MYWIDTH, 280*MYWIDTH)];
    imageview.userInteractionEnabled = YES;
    imageview.image = [UIImage imageNamed:@"发货弹框image"];
    
    UIButton *hidebut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [hidebut addTarget:self action:@selector(hideSMAlert) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:hidebut];
    
    UIButton *butSY = [[UIButton alloc]initWithFrame:CGRectMake(20*MYWIDTH, 130*MYWIDTH, imageview.width-40*MYWIDTH, 50*MYWIDTH)];
    [butSY setTitle:@"同城/搬家" forState:UIControlStateNormal];
    [butSY setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    butSY.titleLabel.font = [UIFont systemFontOfSize:20*MYWIDTH];
    butSY.backgroundColor = [UIColor whiteColor];
    butSY.layer.masksToBounds = YES;
    butSY.layer.cornerRadius = 5;
    butSY.layer.borderColor = [UIColor blackColor].CGColor;//设置边框颜色
    butSY.layer.borderWidth = 1;//设置边缘宽度
    [butSY setImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateNormal];
    
    CGFloat labelWidth = butSY.titleLabel.intrinsicContentSize.width; //注意不能直接使用titleLabel.frame.size.width,原因为有时候获取到0值
    //CGFloat imageWidth = butSY.imageView.frame.size.width;
    CGFloat space = 8.f; //定义两个元素交换后的间距
    butSY.titleEdgeInsets = UIEdgeInsetsMake(0, -5*MYWIDTH, 0, 0);
    butSY.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space + 25*MYWIDTH, 0,  -labelWidth - space);
    [butSY addTarget:self action:@selector(SYbutHideClick) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:butSY];
    
    UIButton *butKY = [[UIButton alloc]initWithFrame:CGRectMake(20*MYWIDTH,butSY.bottom+20*MYWIDTH, imageview.width-40*MYWIDTH, 50*MYWIDTH)];
    [butKY setTitle:@"省际/城际" forState:UIControlStateNormal];
    [butKY setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    butKY.titleLabel.font = [UIFont systemFontOfSize:20*MYWIDTH];
    butKY.backgroundColor = [UIColor whiteColor];
    butKY.layer.masksToBounds = YES;
    butKY.layer.cornerRadius = 5;
    butKY.layer.borderColor = [UIColor blackColor].CGColor;//设置边框颜色
    butKY.layer.borderWidth = 1;//设置边缘宽度
    [butKY setImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateNormal];
    butKY.titleEdgeInsets = UIEdgeInsetsMake(0, -5*MYWIDTH, 0, 0);
    butKY.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space + 25*MYWIDTH, 0,  -labelWidth - space);
    [butKY addTarget:self action:@selector(KYbutHideClick) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:butKY];
    [SMAlert showCustomView:imageview];
    
}
- (void)hideSMAlert{
    [SMAlert hide:NO];
}
- (void)SYbutHideClick{
    [SMAlert hide:NO];
    NSDictionary *dic = @{@"FH":@"SY"};
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"huoyunTK" object:nil userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    if ([self.delegate respondsToSelector:@selector(tabBarMiddle_BTClickSY:)]) {
        [self.myDelegate tabBarMiddle_BTClickSY:self];
    }
}
- (void)KYbutHideClick{
    [SMAlert hide:NO];
    NSDictionary *dic = @{@"FH":@"KY"};
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"huoyunTK" object:nil userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    if ([self.delegate respondsToSelector:@selector(tabBarMiddle_BTClickKY:)]) {
        [self.myDelegate tabBarMiddle_BTClickKY:self];
    }
}
#pragma mark - 重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {

        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.middle_BT];

        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.middle_BT pointInside:newP withEvent:event]) {
            return self.middle_BT;
        }else{//如果点不在发布按钮身上，直接让系统处理就可以了

            return [super hitTest:point withEvent:event];
        }
    }

    else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}
#pragma mark - lazy
-(UIButton *)middle_BT
{
    if (!_middle_BT) {
        
        _middle_BT = [UIButton buttonWithType:UIButtonTypeSystem];
        [_middle_BT setBackgroundImage:[UIImage imageNamed:middleBT_Normal_IMG] forState:UIControlStateNormal];
        [_middle_BT setBackgroundImage:[UIImage imageNamed:middleBT_Highlighted_IMG] forState:UIControlStateHighlighted];
        [_middle_BT setBackgroundImage:[UIImage imageNamed:middleBT_Disabled_IMG] forState:UIControlStateDisabled];
        [_middle_BT addTarget:self action:@selector(middle_BTDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middle_BT;
}
-(UILabel *)middle_Lable
{
    if (!_middle_Lable) {
        
        _middle_Lable = [[UILabel alloc] init];
        _middle_Lable.text = middleLab_Title;
        _middle_Lable.font = middleLab_Font;
        [_middle_Lable sizeToFit];
        _middle_Lable.textColor = Normal_textColor;
        [self addSubview:_middle_Lable];
    }
    return _middle_Lable;
}
@end
