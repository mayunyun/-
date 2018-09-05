//
//  FreeRideListModel.h
//  BasicFramework
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FreeRideListModel : JSONModel
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* tripno;
@property (nonatomic,strong)NSString* sprovince;
@property (nonatomic,strong)NSString* scity;
@property (nonatomic,strong)NSString* scounty;
@property (nonatomic,strong)NSString* saddress;
@property (nonatomic,strong)NSString* eprovince;
@property (nonatomic,strong)NSString* ecity;
@property (nonatomic,strong)NSString* ecounty;
@property (nonatomic,strong)NSString* eaddress;
//@property (nonatomic,strong)NSString* waytocitys;
@property (nonatomic,strong)NSString* waytocitysshow;
@property (nonatomic,strong)NSString* totalvehicle;
@property (nonatomic,strong)NSString* availablevehicle;
@property (nonatomic,strong)NSString* departuretime;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* contactname;
@property (nonatomic,strong)NSString* contactphone;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* autoname;
@property (nonatomic,strong)NSString* driver_num;
@property (nonatomic,strong)NSString* driver_star;
@property (nonatomic,strong)NSString* slongitude;
@property (nonatomic,strong)NSString* slatitude;
@property (nonatomic,strong)NSString* elongitude;
@property (nonatomic,strong)NSString* elatitude;
/*
 autoname = "df1942ac4d8c406bac5c6c820bbc137b.jpg";
 availablevehicle = 20;
 contactname = "\U6b27\U9633\U950b";
 contactphone = 15165155672;
 createtime = "2018-08-22 16:53:04";
 departuretime = "2018-08-23 16:55:00";
 "driver_num" = 5;
 "driver_star" = 5;
 eaddress = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U5386\U57ce\U533a";
 ecity = "\U6d4e\U5357\U5e02";
 ecounty = "\U5386\U57ce\U533a";
 eprovince = "\U5c71\U4e1c\U7701";
 folder = customerImages;
 id = 6;
 saddress = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U69d0\U836b\U533a";
 scity = "\U6d4e\U5357\U5e02";
 scounty = "\U69d0\U836b\U533a";
 sprovince = "\U5c71\U4e1c\U7701";
 totalvehicle = 50;
 tripno = TRIP201808220001;
 waytocitysshow = "\U6d4e\U5357\U5e02\U5929\U6865\U533a,\U6d4e\U5357\U5e02\U5386\U4e0b\U533a";
 */
@end
