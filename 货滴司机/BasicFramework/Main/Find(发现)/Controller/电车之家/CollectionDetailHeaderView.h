//
//  CollectionHeaderView.h
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/19.
//  Copyright © 2017年 apple. All rights reserved.
//

@protocol CollectionHeadDetailDelegate <NSObject>

@optional
-(void)CollectionHeadBtnHaveString:(NSInteger *)resultString;

@end

#import <UIKit/UIKit.h>

@interface CollectionDetailHeaderView : UICollectionReusableView<SDCycleScrollViewDelegate>

@property(nonatomic,weak) id<CollectionHeadDetailDelegate> delegate;


@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong)UIViewController *viewController;

@property (nonatomic,strong)NSString* idStr;

-(void)dataHeadView;

@end
