//
//  DetailsModel.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DetailsModel : JSONModel

@property (nonatomic,strong)NSString *specification;
@property (nonatomic,strong)NSString *unit;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *uuid;
@property (nonatomic,strong)NSString *isvalid;
@property (nonatomic,strong)NSString *note;
@property (nonatomic,strong)NSString *proname;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *productdes;
@property (nonatomic,strong)NSString *protypeid;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *price_jf;
@property (nonatomic,strong)NSString *color;
@property (nonatomic,strong)NSString *picname;
@property (nonatomic,strong)NSString *fitcar;
@property (nonatomic,strong)NSString *prono;
@property (nonatomic,strong)NSString *protypename;
@property (nonatomic,strong)NSString *autoname;

/*
 specification = "003";
 unit = "辆";
 id = 32;
 uuid = "712c7938-799c-4a69-9f58-ad94dbf7eeda";
 isvalid = 1;
 note = "<p>0</p>";
 proname = "配件测试三";
 folder = "";
 productdes = "此车舒适空间大";
 protypeid = 541;
 price = 2000;
 color = "红,黄,蓝,紫,青,";
 picname = "";
 fitcar = "普通,suv,舒适,";
 prono = "pj003";
 protypename = "配件一";
 autoname = ""
 */
@end
