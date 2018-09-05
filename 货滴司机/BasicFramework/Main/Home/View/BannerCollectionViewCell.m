//
//  BannerCollectionViewCell.m
//  BasicFramework
//
//  Created by 钱龙 on 17/12/5.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "BannerCollectionViewCell.h"

@implementation BannerCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _imageView.contentMode   = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
}

- (void)setImagesUrl:(NSString *)imagesUrl {
    _imagesUrl = imagesUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imagesUrl] placeholderImage:[UIImage imageNamed:_placeHolderImageName]];
}

- (void)setPlaceHolderImageName:(NSString *)placeHolderImageName {
    _placeHolderImageName = placeHolderImageName;
}
@end
