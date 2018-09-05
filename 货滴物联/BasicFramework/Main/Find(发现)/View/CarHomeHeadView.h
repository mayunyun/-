//
//  CarHomeHeadView.h
//  MaiBaTe
//
//  Created by LONG on 2017/9/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarHomeHeadViewDelegate <NSObject>

@optional
-(void)CarHomeHeadViewBtnHaveString:(NSString *)brandname idStr:(NSString *)idStr;

@end

@interface CarHomeHeadView : UICollectionReusableView

@property(nonatomic,weak) id<CarHomeHeadViewDelegate> delegate;


-(void)dataHeadView:(NSMutableArray *)data;
@end
