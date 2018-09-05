//
//  MYYMyOrderClassModer.h
//  BaseFrame
//
//  Created by apple on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYYMyOrderClassModer : NSObject
//
@property (nonatomic, copy) NSString *id;//
@property (nonatomic, copy) NSString *specification;//类型
@property (nonatomic, copy) NSString *orderid;//
@property (nonatomic, copy) NSString *proname;//名称
@property (nonatomic, copy) NSString *count;//数量
@property (nonatomic, copy) NSString *price;//价格
@property (nonatomic, copy) NSString *price_jf;//
@property (nonatomic, copy) NSString *autoname;//图片
@property (nonatomic, copy) NSString *folder;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *productdes;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *orderno;
@property (nonatomic, copy) NSString *totalcount;
@property (nonatomic, copy) NSString *totalmoney;
@property (nonatomic, copy) NSString *totaljifen;

/*
 {
 autoname = "f9a4e2aaf325457fb44bdff087d4780b.png";
 color = "\U767d";
 count = 1;
 folder = "productimages/";
 id = 69;
 money = 200;
 note = "";
 orderid = 95;
 price = 200;
 proid = 38;
 proname = "\U5145\U7535\U6869\U5546\U54c1\U4e00\U53f7";
 specification = "\U56db\U8f6e";
 type = 0;
 }
 */
@end
