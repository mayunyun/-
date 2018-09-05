//
//  ShopAddrModel.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ShopAddrModel : JSONModel

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *proname;
@property (nonatomic,strong)NSString *protypename;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *type;

/*
 {
 id = 25;
 autoname = "b8d4307fb3664c7189399e2b5cae179b.jpg";
 folder = "productImages/";
 proname = "配件测试二"
 }
 
 {
 id = 24;
 autoname = "b26f6afef1084465981a7012c959785e.png";
 folder = "productImages/";
 proname = "配件测试一";
 protypename = "配件一"
 }
 */


@end
