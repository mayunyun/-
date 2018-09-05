//
//  UIButton+Extension.h
//  BasicFramework
//
//  Created by Rainy on 16/10/26.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
//创建一个按钮,传入按钮的标题，标题颜色，字体，对齐方式，位置，背景颜色，位置，点击状态
+ (UIButton *)buttonWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont image:(UIImage *)image backgroundImage:(UIImage *)image bgColor:(UIColor *)bgColor rect:(CGRect)rect state:(UIControlState)state target:(id)target action:(SEL)action;
-(dispatch_source_t )startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle finished:(void(^)(UIButton *button))finished;
-(void)cancelTimer:(dispatch_source_t)timer;

-(UIImageView *)addImg:(UIImage *)img withIMGframe:(CGRect )IMGframe;

-(void)setFrame:(CGRect)frame Title:(NSString *)title font:(UIFont *)font fontColor:(UIColor *)fontColor State:(UIControlState)state;

@end
