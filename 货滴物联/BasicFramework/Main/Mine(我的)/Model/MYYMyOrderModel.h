//
//  MYYMyOrderModel.h
//  BaseFrame
//
//  Created by apple on 17/5/12.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYYMyOrderModel : NSObject


@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *createtime;//时间

@property (nonatomic, copy) NSString *orderstatus;//订单状态 0待支付 1待发货 2待收货 3待评价 4订单完成

@property (nonatomic, copy) NSString *totalmoney;
@property (nonatomic, copy) NSString *totaljifen;

@property (nonatomic, copy) NSString *totalcount;

@property (nonatomic, copy) NSString *custname;
@property (nonatomic, copy) NSString *custphone;
@property (nonatomic, copy) NSString *custaddress;

@property (nonatomic,strong)NSString* orderno;

@property (nonatomic,strong)NSString* shcustname;
@property (nonatomic,strong)NSString* shphone;
@property (nonatomic,strong)NSString* type;//类型 1麦商城 2积分商城
@property (nonatomic,strong)NSString* uuid;

/*
 
 {
 areaid = 0;
 cityid = 0;
 createtime = "2017-10-25 09:50:58";
 custaddress = "";
 custid = 62;
 custname = LONG;
 custphone = 17663080550;
 id = 472;
 ispay = 0;
 note = "";
 orderno = YDD201710250003;
 orderstatus = 0;
 paymethod = 0;
 payno = "";
 provinceid = 0;
 shcustname = "";
 shphone = "";
 totalcount = 1;
 totalmoney = 96;
 type = 2;
 uuid = "dc93736d-7649-4203-afcd-24f9399cc9f6";
 }
 
 
 */
@end
