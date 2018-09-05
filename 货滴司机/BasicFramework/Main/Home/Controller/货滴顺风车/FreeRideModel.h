//
//  FreeRideModel.h
//  BasicFramework
//
//  Created by LONG on 2018/8/23.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreeRideModel : JSONModel
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *tripno;
@property (nonatomic,strong)NSString *sprovince;
@property (nonatomic,strong)NSString *scity;
@property (nonatomic,strong)NSString *scounty;
@property (nonatomic,strong)NSString* saddress;

@property (nonatomic,strong)NSString *eprovince;
@property (nonatomic,strong)NSString *ecity;
@property (nonatomic,strong)NSString *ecounty;
@property (nonatomic,strong)NSString *eaddress;

@property (nonatomic,strong)NSString *waytocitysshow;
@property (nonatomic,strong)NSString *totalvehicle;
@property (nonatomic,strong)NSString *availablevehicle;
@property (nonatomic,strong)NSString *departuretime;
@property (nonatomic,strong)NSString *createtime;
@property (nonatomic,strong)NSString *state;

@property (nonatomic,strong)NSString *contactname;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *autoname;

/*
 {
 id : 33,  (id)
 tripno : "TRIP201808170001",  (订单号)
 
 sprovince : "山东省",  (出发地省)
 scity : "济南市",  (出发地市)
 scounty : "历城区",  (出发地县区)
 saddress : "山东省济南市历城区药谷1号楼",  (出发地详细地址)
 
 eprovince : "山东省",  (目的地省)
 ecity : "济南市",  (目的地市)
 ecounty : "历下区",  (目的地县区)
 eaddress : "山东省济南市历下区山东新闻大厦",  (目的地详细地址)
 
 waytocitysshow : "德州市平原县,济南市高新区"，  (途径城市)
 totalvehicle : "13.50",  (总车长)
 availablevehicle : "2.50",  (可用车长)
 departuretime : "2018-08-20 12:22:00",  (出发时间)
 createtime : "2018-08-17 10:44:24.000",  (行程单生成时间)
 state : 1,  (行程单状态 0:已取消,1:启用(不显示提示) )
 
 contactname : '张三',  (司机姓名)
 folder : 'sijiheadimg',  (司机头像路径)
 autoname : '334645243342.jpg'  (司机头像名称)
 }
 */
@end
