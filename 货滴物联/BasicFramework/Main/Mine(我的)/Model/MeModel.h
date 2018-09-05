//
//  MeModel.h
//  MaiBaTe
//
//  Created by LONG on 17/8/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MeModel : JSONModel

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *uuid;
@property (nonatomic,strong)NSString *custphone;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *custname;
@property (nonatomic,strong)NSString *scores;//积分
@property (nonatomic,strong)NSString *tickets;//优惠券
@property (nonatomic,strong)NSString *balance;//余额
@property (nonatomic,strong)NSString* sex;
@property (nonatomic,strong)NSString* birthday;
@property (nonatomic,strong)NSString* occupation;
@property (nonatomic,strong)NSString* addressdetail;
@property (nonatomic,strong)NSString* incomelevel;
@property (nonatomic,strong)NSString* vehicle_information;
@property (nonatomic,strong)NSString* email;
@property (nonatomic,strong)NSString* qq;
@property (nonatomic,strong)NSString* wechat;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,strong)NSString* isdriver;

/*
 我的信息[
	{
 folder = "";
 birthday = "1995-02-15 00:00:00";
 isvalid = 1;
 vehicle_information = "FFFAFGW23144";
 custname = "Ma";
 custphone = "18353130831";
 addressdetail = "测试";
 sex = 0;
 scores = "9999";
 incomelevel = "5-8万/年";
 uuid = "ed82d8e1-9fc9-4252-85aa-daa9c8469137";
 picname = "";
 balance = "1355.00";
 tickets = "125";
 autoname = "";
 id = 61;
 occupation = "程序猿";
 email = "";
 note = "";
 createtime = "2017-08-29 15:00:29";
 password = "1234567";
 qq = ""
	}

 */
@end
