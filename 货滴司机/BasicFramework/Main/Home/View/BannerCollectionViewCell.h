//
//  BannerCollectionViewCell.h
//  BasicFramework
//
//  Created by 钱龙 on 17/12/5.
//  Copyright © 2017年 Rainy. All rights reserved.
//
/*
 加载的是网络图片，如果加载的是本地图片，直接修改一下imagesUrl的setter方法就好
 */
#import <UIKit/UIKit.h>

@interface BannerCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, copy) NSString * placeHolderImageName;
@property (nonatomic, copy) NSString * imagesUrl;
@end
