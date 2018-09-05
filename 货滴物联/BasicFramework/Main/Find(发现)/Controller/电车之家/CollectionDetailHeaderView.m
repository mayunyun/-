//
//  CollectionHeaderView.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CollectionDetailHeaderView.h"
#import "NewAllViewController.h"

@implementation CollectionDetailHeaderView{
    CGFloat _margin;
    
    int _totalloc;
    
    NSMutableArray *_imagesURLStrings;
    NSArray *_iDStrings;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _imagesURLStrings = [[NSMutableArray alloc]init];
        _iDStrings = [[NSArray alloc]init];
        [self createUI];
    }
    return self;
}
-(void)dataHeadView{
    [_imagesURLStrings removeAllObjects];
    
    NSString *URLStr = @"/mbtwz/CarHome?action=getCarDetailUp";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_idStr]};
    NSLog(@">>>>%@",params);

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSArray* Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"轮播列表%@",Arr);
        _iDStrings = Arr;
        //建立模型
        for (NSDictionary*dic in Arr ) {
            
            NSString *image = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,[dic objectForKey:@"folder"],[dic objectForKey:@"autoname"]];
            
            //追加数据
            [_imagesURLStrings addObject:image];
        }
//        NSLog(@"轮播图数组%@",_imagesURLStrings);
        self.cycleScrollView.imageURLStringsGroup = _imagesURLStrings;
        
    }];
    
    
    
}
-(void)createUI{
    
    
    // 网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 220*MYWIDTH) delegate:self placeholderImage:nil];
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.currentPageDotColor = [UIColor redColor];
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.cycleScrollView];
}

- (void)Classbut:(UIButton *)but{
    [self.delegate CollectionHeadBtnHaveString:(NSInteger *)but.tag];
}
- (void)SingleTap:(UITapGestureRecognizer*)recognizer  {
    [self.delegate CollectionHeadBtnHaveString:(NSInteger *)(recognizer.view.tag-10)];
    
    
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == self.cycleScrollView) {
        NSLog(@"---点击了专题第%ld张图片", (long)index);
       
    }
}

@end
