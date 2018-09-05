//
//  DiscoverData.h
//  MaiBaTe
//
//  Created by LONG on 2017/9/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverData : NSObject
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *read;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,strong)NSArray *picturesArray;//图片数组
@property(nonatomic,copy)NSString *location;//位置
@property(nonatomic,strong)NSArray *zanArray;//点赞人数数组
@property(nonatomic,copy)NSString *articleTitle;//文章标题

@property(nonatomic,assign)int zan;
@property(nonatomic,assign)int comment;

@end
