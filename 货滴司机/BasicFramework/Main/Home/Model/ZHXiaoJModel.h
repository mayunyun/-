//
//  ZHXiaoJModel.h
//  BasicFramework
//
//  Created by LONG on 2018/3/6.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZHXiaoJModel : JSONModel
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *consigneename;
@property (nonatomic,strong)NSString *consigneephone;
@property (nonatomic,strong)NSString *createtime;
@property (nonatomic,strong)NSString *endaddress;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *orderno;
@property (nonatomic,strong)NSString *ordertotalprice;
@property (nonatomic,strong)NSString *pickuptime;
@property (nonatomic,strong)NSString *siji_money;
@property (nonatomic,strong)NSString *startaddress;
@property (nonatomic,strong)NSString *startlatitude;
@property (nonatomic,strong)NSString *startlongitude;
@property (nonatomic,strong)NSString *sprocitcou;
@property (nonatomic,strong)NSString *eprocitcou;
@property (nonatomic,strong)NSString *cust_num;
@property (nonatomic,strong)NSString *cust_star;
@property (nonatomic,strong)NSString *beizhu;

/*
 autoname = "2f274dbc926b47aabb31e97d1ccf544d.png";
 consigneename = "\U54e6\U54e6";
 consigneephone = 17663080550;
 createtime = "2018-03-03 14:31:17";
 endaddress = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U5386\U4e0b\U533a\U6d77\U5c14\U7eff\U57ce\U5168\U8fd0\U6751\U5fa1\U56ed";
 folder = customerImages;
 id = 17;
 orderno = ZDD201803030002;
 ordertotalprice = 100;
 pickuptime = "2018-03-03 14:32:00";
 "siji_money" = 80;
 startaddress = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U5386\U57ce\U533a\U6e2f\U6c9f\U8857\U9053\U5609\U5851\U7f8e\U98df\U516c\U56ed\U6c49\U5cea\U91d1\U8c37";
 startlatitude = 37;
 startlongitude = 117;
 */
@end
