//
//  TCHXiaoJModel.h
//  BasicFramework
//
//  Created by LONG on 2018/2/27.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCHXiaoJModel : NSObject
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *autoname;

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *paytype;
@property (nonatomic,strong)NSString *cust_star;
@property (nonatomic,strong)NSString *cust_num;
@property (nonatomic,strong)NSString *driver_name;
@property (nonatomic,strong)NSString *driver_phone;
@property (nonatomic,strong)NSString *remarks;
@property (nonatomic,strong)NSString *cancelmoney;
@property (nonatomic,strong)NSString *consigneename;
@property (nonatomic,strong)NSString *isevaluate;
@property (nonatomic,strong)NSString *consigneephone;
@property (nonatomic,strong)NSString *uuid;
@property (nonatomic,strong)NSString *expectedarrivaltime;
@property (nonatomic,strong)NSString *floorhousenumber;
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
 autoname = "1e9635231a2541a1bbaeed01e280fa65.jpg";
 cancelmoney = "";
 consigneename = "\U54c8\U54c8\U54c8\U54c8";
 consigneephone = 17663080550;
 createtime = "2018-02-27 10:08:22";
 "cust_orderstatus" = 0;
 "driver_custid" = 0;
 "driver_name" = "";
 "driver_orderstatus" = "-2";
 "driver_phone" = "";
 endaddress = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U5386\U4e0b\U533a\U9f99\U6d1e\U8857\U9053\U6d4e\U5357\U5e02\U4eba\U5927\U5e38\U59d4\U4f1a\U6d4e\U5357\U9f99\U5965\U5927\U53a6(\U9f99\U5965\U5317\U8def)";
 endlatitude = 37;
 endlongitude = 117;
 expectedarrivaltime = "2018-02-28 00:00:00";
 floorhousenumber = "\U5728";
 folder = customerImages;
 id = 7;
 isinvoice = 0;
 ispay = 1;
 "money_status" = 0;
 orderno = SDD201802270001;
 ordertotalprice = 10;
 "owner_custid" = 62;
 "pay_no" = SDD201802270001;
 "pay_time" = "2018-02-27 10:08:29";
 paymethod = 2;
 pickuptime = "2018-02-27 10:07:00";
 "pingtai_money" = 2;
 remarks = "";
 "siji_money" = 8;
 "siji_singletime" = "";
 startaddress = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U5386\U57ce\U533a\U6e2f\U6c9f\U8857\U9053\U5609\U5851\U7f8e\U98df\U516c\U56ed\U6c49\U5cea\U91d1\U8c37";
 startlatitude = 37;
 startlongitude = 117;
 uuid = 130283584c25430b881c;
 weightofgoods = "0-20";
 }
 */
@end
