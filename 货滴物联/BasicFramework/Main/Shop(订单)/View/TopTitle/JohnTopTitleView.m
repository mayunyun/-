//
//  JohnTopTitleView.m
//  TopTitle
//
//  Created by aspilin on 2017/4/11.
//  Copyright © 2017年 aspilin. All rights reserved.
//

#import "JohnTopTitleView.h"

#define ViewWidth self.frame.size.width
#define ViewHeight self.frame.size.height

@interface JohnTopTitleView ()<UIScrollViewDelegate>{
    CGFloat _titleHeight;  //标题高度
    CGFloat _lineViewWidth;  //记录底部线长度
}

//@property (nonatomic,strong) UISegmentedControl *titleSegment;

@property (nonatomic,strong) UIScrollView *pageScrollView;

@property (nonatomic,strong) UIView *lineView;

@end
@implementation JohnTopTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setting];
        
    }
    return self;
}

#pragma mark - 初始化设置
- (void)setting{
    self.backgroundColor = [UIColor whiteColor];
    
    //title
    _titleHeight = 40.f;
    self.titleSegment = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0, 0, ViewWidth,_titleHeight)];
    self.titleSegment.tintColor = [UIColor whiteColor];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                             NSForegroundColorAttributeName: MYColor};
    [self.titleSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                               NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    [self.titleSegment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [self.titleSegment addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.titleSegment];
    
    //滑动sc
    self.pageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleSegment.frame), ViewWidth, ViewHeight - _titleHeight)];
    self.pageScrollView.bounces = YES;
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.showsVerticalScrollIndicator = NO;
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.delegate = self;
    [self addSubview:self.pageScrollView];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, _titleHeight-1, UIScreenW, 1)];
    xian.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self addSubview:xian];
    
    //底部线
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = MYColor;
    [self addSubview:self.lineView];
    
    
}

#pragma mark - 定制title
- (void)setTitle:(NSArray *)title{
    if (title.count > 0) {
        for (NSInteger i = 0; i < title.count; i ++) {
            [self.titleSegment insertSegmentWithTitle:[title objectAtIndex:i] atIndex:i animated:NO];
        }
    }
    self.titleSegment.selectedSegmentIndex = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InfoNotification" object:nil userInfo:nil];
}

#pragma mark - 定制VC
- (void)setupViewControllerWithFatherVC:(UIViewController *)fatherVC childVC:(NSArray<UIViewController *>*)childVC{
    NSInteger page = childVC.count;
    _lineViewWidth = ViewWidth / page;
    self.lineView.frame = CGRectMake(0, _titleHeight - 1,_lineViewWidth, 1);
    self.pageScrollView.contentSize = CGSizeMake(ViewWidth * page, 0);
    
    for (NSInteger i = 0; i < page; i ++) {
        UIViewController *vc = [childVC objectAtIndex:i];
        vc.view.frame = CGRectMake(ViewWidth * i, 0, ViewWidth, ViewHeight);
        [fatherVC addChildViewController:vc];
        [self.pageScrollView addSubview:vc.view];
    }
}

#pragma mark - 联动设置
- (void)pageChange:(UISegmentedControl *)seg{
    [self changeWithPage:seg.selectedSegmentIndex];
    [self.pageScrollView setContentOffset:CGPointMake(ViewWidth *seg.selectedSegmentIndex,0) animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / ViewWidth;
    self.titleSegment.selectedSegmentIndex = page;
    [self changeWithPage:page];
}

- (void)changeWithPage:(NSInteger)page{
    CGFloat lineViewCenterX = page *_lineViewWidth + _lineViewWidth / 2;
    if (page == 1) {
        self.lineView.backgroundColor = MYColor;
    }else{
        self.lineView.backgroundColor = MYColor;
    }
    [UIView transitionWithView:self.lineView duration:0.3 options:      UIViewAnimationOptionAllowUserInteraction  animations:^{
        self.lineView.center = CGPointMake(lineViewCenterX,_titleHeight - .5);
    } completion:^(BOOL finished) {
    }];
    if (_indexPageBlock) {
        self.indexPageBlock(page);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InfoNotification" object:nil userInfo:nil];
}
@end
