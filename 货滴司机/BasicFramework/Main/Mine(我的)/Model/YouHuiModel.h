//
//  YouHuiModel.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YouHuiModel : JSONModel
@property (nonatomic,strong)NSString *cheap_ange;
@property (nonatomic,strong)NSString *cheap_coupon_count;
@property (nonatomic,strong)NSString *cheap_descript;
@property (nonatomic,strong)NSString *cheap_equal_money;
@property (nonatomic,strong)NSString *cheap_name;
@property (nonatomic,strong)NSString *cheap_type;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *isvalid;
@property (nonatomic,strong)NSString *couponid;

@end
/*
 领取优惠券
 {
 "cheap_ange" = 1;
 "cheap_coupon_count" = 9;
 "cheap_descript" = "\U5c71\U4e1c\U6d4e\U5357\U8054\U7cfb\U7f51\U7edc";
 "cheap_equal_money" = 5;
 "cheap_name" = "\U5546\U57ce\U73b0\U91d1\U5238";
 "cheap_type" = 1;
 id = 8;
 isvalid = 1;
 }
 我的优惠券列表
 {
 "cheap_ange" = 0;
 "cheap_descript" = "\U5feb\U4e50\U58eb\U5927\U592b\U5783\U573e\U623f\U5efa\U8bbe";
 "cheap_equal_money" = "0.5";
 "cheap_name" = "\U73b0\U91d1\U523834";
 "cheap_type" = 1;
 couponid = 9;
 createtime = "2017-10-28 13:57:45";
 custid = 62;
 id = 23;
 isuse = 0;
 money = "";
 orderid = 0;
 orderno = "";
 reason = "";
 }
 */
