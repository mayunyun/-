//
//  UserModel.h
//  BasicFramework
//
//  Created by Rainy on 2016/12/19.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserModel : JSONModel

@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* uuid;
@property (nonatomic,strong)NSString* tickets;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* balance;
@property (nonatomic,strong)NSString* password;
@property (nonatomic,strong)NSString* scores;
@property (nonatomic,strong)NSString* custphone;
@property (nonatomic,strong)NSString* qq;
@property (nonatomic,strong)NSString* email;
@property (nonatomic,strong)NSString* custname;


/*
 id = 61;
 uuid = "ed82d8e1-9fc9-4252-85aa-daa9c8469137";
 tickets = "125";
 isvalid = 1;
 createtime = "2017-08-29 15:00:29";
 note = "";
 balance = "1355.00";
 password = "123456";
 scores = "9999";
 custphone = "18353130831";
 qq = "";
 email = "";
 custname = "Ma"
 */

@end
