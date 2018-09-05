//
//  CarDetailModel.h
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CarDetailModel : JSONModel
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* autoname;
@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* factoryprice;
@property (nonatomic,strong)NSString* carname;
@property (nonatomic,strong)NSString* groupname;
@property (nonatomic,strong)NSString* localprice;
@property (nonatomic,strong)NSString* carid;
/*
 folder = "cargroupdetailImg/";
 picname = "car.png";
 note = "<p><img src="/maibate/ueditor/jsp/upload/image/20170922/1506064463405089211.jpg" title="1506064463405089211.jpg" alt="449926006074669418.jpg"/></p>";
 autoname = "c6f8261c2f654fd39b456b98a7452d9d.png";
 type = 1;
 id = 47;
 factoryprice = "200～300";
 carname = "保十洁";
 groupname = "iso--11";
 localprice = "300～400";
 carid = 39
 */
@end
