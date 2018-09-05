//
//  CarBrandModel.h
//  MaiBaTe
//
//  Created by LONG on 17/9/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CarBrandModel : JSONModel
@property (nonatomic,strong)NSString *brandname;
@property (nonatomic,strong)NSString *picname;
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *note;
@property (nonatomic,strong)NSString *ishot;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *uuid;

@property (nonatomic,strong)NSString *brandid;
@property (nonatomic,strong)NSString *groupname;
@property (nonatomic,strong)NSString *groupprice;

@end

/*
 {
 "brandname": "213",
 "picname": "fw3.png",
 "autoname": "a23ed65b9af64cf48d1a284b76931e9a.png",
 "folder": "carbrandImg/",
 "note": "",
 "ishot": 0,
 "id": 9,
 "uuid": "0c23da70-699c-42d2-90dc-4af2e2bdf10b"
 },
*/

/*
 {
 folder = "carbrandgroupImg/";
 brandname = "奥迪";
 id = 6;
 uuid = "8c26c7f7-8b0b-4773-a469-778858b54f7e";
 brandid = 2;
 picname = "fw3.png";
 groupname = "奥迪品牌系列";
 autoname = "c46ad555b1fa4a5a913f23e03f893c40.png";
 groupprice = 65
	}
 */
