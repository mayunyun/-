//
//  TCHXiaoJModel.h
//  BasicFramework
//
//  Created by LONG on 2018/2/27.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCHXiaoJModel : NSObject
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *fname;
@property (nonatomic,strong)NSString *fphone;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *remarks;
@property (nonatomic,strong)NSString *cancelmoney;
@property (nonatomic,strong)NSString *siji_money;
@property (nonatomic,strong)NSString *consigneename;
@property (nonatomic,strong)NSString *consigneephone;
@property (nonatomic,strong)NSString *uuid;
@property (nonatomic,strong)NSString *expectedarrivaltime;
@property (nonatomic,strong)NSString *floorhousenumber;
@property (nonatomic,strong)NSString *owner_custid;
@property (nonatomic,strong)NSString *driver_custid;//司机ID
@property (nonatomic,strong)NSString *orderno;//订单号
@property (nonatomic,strong)NSString *pickuptime;//取货时间
@property (nonatomic,strong)NSString *createtime;//订单生成时间
@property (nonatomic,strong)NSString *startlongitude;//出发点经度
@property (nonatomic,strong)NSString *startlatitude;//出发点纬度
@property (nonatomic,strong)NSString *startaddress;//出发点地址
@property (nonatomic,strong)NSString *endlongitude;//目的地经度
@property (nonatomic,strong)NSString *endlatitude;//目的地纬度
@property (nonatomic,strong)NSString *endaddress;//目的地地址
@property (nonatomic,strong)NSString *weightofgoods;//货物重量名称
@property (nonatomic,strong)NSString *ordertotalprice;//订单总价
@property (nonatomic,strong)NSString *cust_orderstatus;//货主端状态  -1已取消，0等待接货，1服务开始，2已完成
@property (nonatomic,strong)NSString *driver_orderstatus;//司机端状态  -2未接单，-1已取消，0前往中，1开始订单，2已完成

/*
 {
 autoname = "115e3b7f173443319a7e40627c604c6d.png";
 cancelmoney = "";
 consigneename = LONG;
 consigneephone = 17663080550;
 createtime = "2018-03-08 13:50:55";
 "cust_orderstatus" = 0;
 "driver_custid" = 99;
 "driver_orderstatus" = 0;
 ecityid = 1458;
 ecountyid = 1478;
 endaddress = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U5e02\U4e2d\U533a\U5174\U9686\U8857\U9053G2001\U6d4e\U5357\U7ed5\U57ce\U9ad8\U901f";
 endlatitude = 37;
 endlongitude = 117;
 eprocitcou = "\U5c71\U4e1c\U7701 \U6d4e\U5357\U5e02 \U5929\U6865\U533a";
 eprovinceid = 16;
 expectedarrivaltime = "2018-03-10 00:00:00";
 floorhousenumber = "";
 folder = customerImages;
 id = 44;
 isevaluate = 0;
 isinvoice = 0;
 ispay = 1;
 "money_status" = 0;
 orderno = ZDD201803080001;
 ordertotalprice = 10;
 "owner_custid" = 62;
 "pay_no" = ZDD201803080001;
 "pay_time" = "2018-03-08 13:51:02";
 paymethod = 2;
 pickuptime = "2018-03-08 13:50:00";
 "pingtai_money" = 2;
 remarks = "";
 scityid = 1458;
 scountyid = 1476;
 "siji_money" = 8;
 "siji_singletime" = "2018-03-08 13:52:04";
 sprocitcou = "\U5c71\U4e1c\U7701 \U6d4e\U5357\U5e02 \U5e02\U4e2d\U533a";
 sprovinceid = 16;
 startaddress = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U5386\U57ce\U533a\U6e2f\U6c9f\U8857\U9053\U5609\U5851\U7f8e\U98df\U516c\U56ed\U6c49\U5cea\U91d1\U8c37";
 startlatitude = 37;
 startlongitude = 117;
 uuid = 004b3addc5cc4e6ea208;
 weightofgoods = "0-20";
 },
 */
@end
