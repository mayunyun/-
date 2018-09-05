//
//  FreeRideDetailModel.h
//  BasicFramework
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FreeRideDetailModel : JSONModel
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* contactname;
@property (nonatomic,strong)NSString* sprovince;
@property (nonatomic,strong)NSString* scity;
@property (nonatomic,strong)NSString* scounty;
@property (nonatomic,strong)NSString* eprovince;
@property (nonatomic,strong)NSString* ecity;
@property (nonatomic,strong)NSString* ecounty;
@property (nonatomic,strong)NSString* saddress;
@property (nonatomic,strong)NSString* eaddress;
@property (nonatomic,strong)NSString* waytocitysshow;
@property (nonatomic,strong)NSString* totalvehicle;
@property (nonatomic,strong)NSString* availablevehicle;
@property (nonatomic,strong)NSString* deptime;
@property (nonatomic,strong)NSString* cretime;
@property (nonatomic,strong)NSString* contactphone;
@property (nonatomic,strong)NSString* slongitude;
@property (nonatomic,strong)NSString* slatitude;
@property (nonatomic,strong)NSString* elongitude;
@property (nonatomic,strong)NSString* elatitude;

/*
 id : 33,  (id)
 tripno : "TRIP201808170001",  (订单号)
 slongitude : "117.202947",   (出发点经度)
 slatitude : "36.663814",   (出发点纬度)
 sprovince : "山东省",  (出发地省)
 scity : "济南市",  (出发地市)
 scounty : "历城区",  (出发地县区)
 saddress : "山东省济南市历城区药谷1号楼",  (出发地详细地址)
 elongitude : "117.061025",  (目的地经度)
 elatitude : "36.631249",  (目的地纬度)
 eprovince : "山东省",  (目的地省)
 ecity : "济南市",  (目的地市)
 ecounty : "历下区",  (目的地县区)
 eaddress : "山东省济南市历下区山东新闻大厦",  (目的地详细地址)
 waytocitysshow : "德州市平原县,济南市高新区"，  (途径城市)  **************** 修改
 distance : "44.50"，  (出发点目的地距离)
 totalvehicle : "13.50",  (总车长)
 availablevehicle : "2.50",  (可用车长)
 departuretime : "2018-08-20 12:22:00",  (出发时间，弃用)
 deptime : "2018-08-20 12:22:00",  (出发时间，字符串显示)      ************** 新增字段
 contactname : "张三",  (联系人)
 contactphone : "15165155555",  (联系人电话)
 createtime : "2018-08-17 10:44:24",  (行程单生成时间，弃用)
 cretime : "2018-08-17 10:44:24",  (行程单生成时间，字符串显示)  ************ 新增字段
 state : 1  (行程单状态 0:已取消,1:启用(不显示提示) )
 */
@end
