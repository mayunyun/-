//
//  TiXianJLModel.h
//  MaiBaTe
//
//  Created by LONG on 2017/9/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TiXianJLModel : JSONModel
@property (nonatomic,strong)NSString *custid;
@property (nonatomic,strong)NSString *custname;
@property (nonatomic,strong)NSString *note;
@property (nonatomic,strong)NSString *userid;
@property (nonatomic,strong)NSString *isvalid;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *bankcard;
@property (nonatomic,strong)NSString *createtime;
@property (nonatomic,strong)NSString *money;

@end
/*
 {
 custid = 88;
 custname = "zhangxiao";
 note = "测试";
 userid = 0;
 isvalid = "0";
 id = 90;
 username = "";
 bankcard = "6228480402564890018";
 createtime = "2017-09-21 14:46:28";
 money = 2
	}
 
 */
