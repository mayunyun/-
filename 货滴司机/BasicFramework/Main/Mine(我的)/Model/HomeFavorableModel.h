//
//  HomeFavorableModel.h
//  BasicFramework
//
//  Created by LONG on 2018/7/3.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HomeFavorableModel : JSONModel
@property (nonatomic,strong)NSString *proname;
@property (nonatomic,strong)NSString *prono;
@property (nonatomic,strong)NSString *specification;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *unit;
@property (nonatomic,strong)NSString *protypeid;
@property (nonatomic,strong)NSString *protypename;
@property (nonatomic,strong)NSString *isvalid;
@property (nonatomic,strong)NSString *note;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *uuid;
@property (nonatomic,strong)NSString *productdes;
@property (nonatomic,strong)NSString *color;
@property (nonatomic,strong)NSString *appstatus;
@property (nonatomic,strong)NSString *price_jf;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *prodpic;

/*
 {
 "proname": "键盘",    (产品名称)
 "prono": "如意鸟",    (产品编码)
 "specification": "如意鸟",    (产品规格)
 "price": 30,    (价格(现金))
 "unit": "个",    (产品单位)
 "protypeid": 550,    (产品类型id)
 "protypename": "车辆配件",    (产品类型名称)
 "isvalid": 1,    (产品类型名称)
 "note": "",    (备注)
 "id": 77,    (id)
 "uuid": "d3fa24da-8384-45bb-a5f2-8ad870be8616",    (uuid)
 "productdes": "如意鸟 背光游戏电脑台式家用发光机械手感笔记本外接USB有线键盘",    (商品描述)
 "color": "黑色,白色,",    (商品颜色，英文逗号分隔)
 "appstatus": 0,   (0:特惠，1：热卖，2猜你喜欢)
 "price_jf": 149    (价格(积分)，可为0)
 },
 */
@end
