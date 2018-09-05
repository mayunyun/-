//
//  ErSCModel.h
//  BasicFramework
//
//  Created by LONG on 2018/7/16.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ErSCModel : JSONModel
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *car_type_name;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *watch_car_add;
@property (nonatomic,strong)NSString *registered_year;
@property (nonatomic,strong)NSString *region;
@property (nonatomic,strong)NSString *ErScarpic;
@property (nonatomic,strong)NSString *car_brand_name;
@property (nonatomic,strong)NSString *model_number;
@property (nonatomic,strong)NSString *kilometre;
@property (nonatomic,strong)NSString *contacts;
@property (nonatomic,strong)NSString *contact_number;
@property (nonatomic,strong)NSString *describe;
@property (nonatomic,strong)NSString *create_time;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSString *twoscarpic;
@property (nonatomic,strong)NSString *erscarpic;



/*
 {
 、
 "car_brand_id" = 123;
 "car_brand_name" = "\U9a6c\U81ea\U8fbe";
 "car_type_id" = 123;
 "car_type_name" = "\U7d27\U51d1\U7ea7\U5bb6\U7528";
 city = "\U6d4e\U5357\U5e02";
 "city_id" = 0;
 "contact_number" = 15165155555;
 contacts = "\U5f20\U4e09\U4e30";      
 county = "\U5386\U57ce\U533a";
 "county_id" = 0;
 "create_time" = "2018-07-12 12:22:20";
 "create_user" = 99;
 describe = "\U8fd9\U8f66\U6211\U5f00\U4e86\U534a\U5e74\U51c6\U5907\U51fa\U624b";
 erscarpic = "";
 id = 1;
 kilometre = 5000km;
 "model_number" = "1.5\U81ea\U7136\U5438\U6c14";
 price = "13\U4e07";
 province = "\U5c71\U4e1c\U7701";
 "province_id" = 0;
 region = "\U5c71\U4e1c\U7701\U6d4e\U5357\U5e02\U5386\U57ce\U533a";
 "registered_year" = "2017-10-20";
 retain1 = 0;
 retain2 = "";
 state = 1;
 title = "\U4e8c\U624b\U6602\U514b\U8d5b\U62c9";
 uuid = 123123123;
 "watch_car_add" = "\U6d4e\U5357\U836f\U8c379\U697c";
 }
 */
@end
