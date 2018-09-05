//
//  WuLiuFHModel.h
//  MaiBaTe
//
//  Created by LONG on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WuLiuFHModel : JSONModel
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *car_id;
@property (nonatomic,strong)NSString *car_load;
@property (nonatomic,strong)NSString *car_size;
@property (nonatomic,strong)NSString *car_type;
@property (nonatomic,strong)NSString *car_volume;
@property (nonatomic,strong)NSString *cityname;
@property (nonatomic,strong)NSString *createtime;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *isvalid;
@property (nonatomic,strong)NSString *picname;
@property (nonatomic,strong)NSString *uuid;
@property (nonatomic,strong)NSString *mileage_price;
@property (nonatomic,strong)NSString *proname;
@property (nonatomic,strong)NSString *starting_mileage;
@property (nonatomic,strong)NSString *starting_price;


/*
 {
 autoname = "467c672b44dc4a549676100d8534a034.png";
 "car_id" = 2;
 "car_load" = 5;
 "car_size" = 23333333333333;
 "car_type" = "\U4e2d\U578b\U8f66";
 "car_volume" = "\U6492\U53d1\U9001";
 cityname = "\U6d4e\U5357\U5e02";
 createtime = "";
 folder = "logisticscartypeImage/";
 id =         (
 2,
 2
 );
 isvalid =         (
 0,
 0
 );
 "mileage_price" = 10;
 picname = "07.png";
 proname = "\U5c71\U4e1c\U7701";
 "starting_mileage" = 10;
 "starting_price" = 20;
 uuid = "7fdeb614-ffba-4314-b27c-dfb2691cb48c";
 }
 */
@end
