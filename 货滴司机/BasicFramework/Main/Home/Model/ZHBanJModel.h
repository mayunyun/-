//
//  ZHBanJModel.h
//  BasicFramework
//
//  Created by LONG on 2018/3/7.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZHBanJModel : JSONModel
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *car_type;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *latitude;
@property (nonatomic,strong)NSString *longitude;
@property (nonatomic,strong)NSString *owner_address;
@property (nonatomic,strong)NSString *owner_createtime;
@property (nonatomic,strong)NSString *owner_link_name;
@property (nonatomic,strong)NSString *owner_link_phone;
@property (nonatomic,strong)NSString *owner_orderno;
@property (nonatomic,strong)NSString *owner_send_address;
@property (nonatomic,strong)NSString *owner_sendtime;
@property (nonatomic,strong)NSString *owner_totalprice;
@property (nonatomic,strong)NSString *siji_money;
@property (nonatomic,strong)NSString *cust_num;
@property (nonatomic,strong)NSString *cust_star;
@property (nonatomic,strong)NSString *beizhu;


/*
 {
 autoname = "47784027449e430d8f4db9627570ac32.png";
 "car_type" = "\U4e2d\U9762\U5305\U8f66";
 folder = customerImages;
 id = 326;
 latitude = "36.657871";
 longitude = "117.14643";
 "owner_address" = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U5386\U57ce\U533a\U6e2f\U6c9f\U8857\U9053\U9f99\U5965\U5317\U8def307\U53f7\U6c49\U5cea\U91d1\U878d\U5546\U52a1\U4e2d\U5fc3";
 "owner_createtime" = "2018-03-07 15:02:56";
 "owner_link_name" = "\U8054\U7965\U79d1\U6280";
 "owner_link_phone" = 18654694810;
 "owner_orderno" = SDD201803070002;
 "owner_send_address" = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U5386\U4e0b\U533a\U9f99\U6d1e\U8857\U9053\U9526\U5c4f\U5bb6\U56ed(\U9f99\U9f0e\U5927\U9053)86\U53f7\U697c\U6052\U5927\U9f99\U5965\U5fa1\U82d1(\U5efa\U8bbe\U4e2d)";
 "owner_sendtime" = "2018-03-08 00:00:00";
 "owner_totalprice" = 10;
 "siji_money" = 8;
 }
 */
@end
