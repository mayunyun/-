//
//  ZhoujieModel.h
//  BasicFramework
//
//  Created by LONG on 2018/5/17.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhoujieModel : NSObject
@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * orderno;
@property (nonatomic,copy) NSString * linkname;
@property (nonatomic,copy) NSString * linkphone;
@property (nonatomic,copy) NSString * sendtime;
@property (nonatomic,copy) NSString * money;
@property (nonatomic,copy) NSString * ispay;
@property (nonatomic,copy) NSString * createtime;
@property (nonatomic,copy) NSString * saddress;
@property (nonatomic,copy) NSString * eaddress;
@property (nonatomic,copy) NSString * uuid;
@property (nonatomic,copy) NSString * driver_custid;
@property (nonatomic, assign) BOOL isSelected;//商品是否被选



/*
 {
 type : '0'  (订单类型：0搬家单，1速运单，2快运单)
 id : 33,  (订单id)
 orderno : "LGD201804110001",  (订单号)
 linkname : "唐吉歌德",  (收货人姓名)
 linkphone : "15165155672",  (收货人电话)
 sendtime : "2018-05-10 16:28:00",  (发货时间)
 money : 13.40,  (订单金额)
 ispay : 0,  (是否支付完成：0未支付，1已支付)
 createtime : "2018-04-30 00:00:00",  (订单生成时间)
 saddress : "山东省济南市历城区港沟街道龙奥北路305",  (出发地)
 eaddress : "山东省济南市历城区彩石镇三龙路"  (目的地)
 }
 */
@end
