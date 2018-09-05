//
//  WeixinPhotoView.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WeixinPhotoView.h"
#import "SDPhotoBrowser.h"

@interface WeixinPhotoView()<SDPhotoBrowserDelegate>

@end

@implementation WeixinPhotoView

- (void)setPicPathStringArray:(NSArray *)picPathStringArray
{
    _picPathStringArray = picPathStringArray;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //如果这个数组没有图片的话，则让这块view的高度为0
    if(_picPathStringArray.count==0)
    {
        self.height = 0;
        self.fixedHeight=@(0);
        return;
    }
    
    //图片的宽度
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringArray];
    CGFloat itemH = 0;
    //如果只有一张照片的话，则让图片显示实际高度
    if(_picPathStringArray.count==1)
    {
        UIImage *image =[UIImage imageNamed:_picPathStringArray.firstObject];
        if(image.size.width)
        {
            itemH = image.size.height / image.size.width * itemW;
        }
    }
    //如果有多张图片的话，则让图片的宽高一样
    else
    {
        itemH = itemW;
    }
    
    
    long perRowItemCount = [self perRowItemCountForPicArray:_picPathStringArray];
    CGFloat margin = 10;
    
    [_picPathStringArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        long columIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView =[UIImageView new];
        imageView.image = [UIImage imageNamed:obj];
        imageView.frame = CGRectMake((margin + itemW)*columIndex, ((itemH+margin)*rowIndex), itemW, itemH);
        [self addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        imageView.tag = idx;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) *margin;
    int columnCount =  ceil(_picPathStringArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount -1)*margin;
    self.width = w;
    self.height = h;
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
    
    
}

//点击图片手势执行的操作
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *brower = [[SDPhotoBrowser alloc]init];
    brower.currentImageIndex = imageView.tag;
    brower.sourceImagesContainerView = self;
    brower.imageCount = self.picPathStringArray.count;
    brower.delegate=self;
    [brower show];
}


//根据图片的数量返回对应的图片宽度
- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    //如果照片只有一张的话，则照片高度为120，如果有多张的话，则返回80
    if(array.count==1)
    {
        return 120*MYWIDTH;
    }
    else
        return 80*MYWIDTH;
}

//每行最多显示多少张照片
- (NSInteger)perRowItemCountForPicArray:(NSArray *)array
{
    if(array.count<3)
    {
        return array.count;
    }
    //如果是3张或4张
    else if(array.count<=4)
    {
        return 2;
    }
    //如果
    else
    {
        return 3;
    }
    
}


#pragma mark SDPhotoDelegate

//如果利用网络加载图片的话则要用SDWebImage
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName =self.picPathStringArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}


@end
