//
//  JohnTopTitleView.h
//  TopTitle
//
//  Created by aspilin on 2017/4/11.
//  Copyright © 2017年 aspilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JohnTopTitleView : UIView

@property(nonatomic,strong)void(^indexPageBlock)(NSInteger );
//传入title数组
@property (nonatomic,strong) NSArray *title;

@property (nonatomic,strong) UISegmentedControl *titleSegment;
/**
 *传入父控制器和子控制器数组即可
 **/
- (void)setupViewControllerWithFatherVC:(UIViewController *)fatherVC childVC:(NSArray<UIViewController *>*)childVC;

@end
