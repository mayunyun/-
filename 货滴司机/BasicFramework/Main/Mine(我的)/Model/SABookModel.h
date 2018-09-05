//
//  SABookModel.h
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SABookModel : NSObject
@property (nonatomic,copy) NSString * custid;
@property (nonatomic,copy) NSString * proname;
@property (nonatomic,copy) NSString * fitcar;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * price_jf;
@property (nonatomic,copy) NSString * proid;
@property (nonatomic,copy) NSString * color;
@property (nonatomic,copy) NSString * autoname;
@property (nonatomic,copy) NSString * money;
@property (nonatomic,copy) NSString * folder;
@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSString * id;
@property (nonatomic,assign) int  count;

@property(assign,nonatomic)BOOL  selectState;//是否选中状态

@end
/*
 custid = 62;
 fitcar = "二轮";
 proid = 38;
 proname = "充电桩商品一号";
 id = 10;
 count = 1;
 color = "白";
 price = 200;
 folder = "productimages/";
 autoname = "f9a4e2aaf325457fb44bdff087d4780b.png";
 money = 200
 */
