//
//  HuoDongModel.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HuoDongModel : JSONModel
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *uuid;
@property (nonatomic,strong)NSString *publisher;
@property (nonatomic,strong)NSString *createtime;
@property (nonatomic,strong)NSString *activityname;
@property (nonatomic,strong)NSString *publishid;
@property (nonatomic,strong)NSString *picname;
@property (nonatomic,strong)NSString *content;
@end

/*
 {
 folder = "ActivityImg/";
 autoname = "e3be0bd7e4a342d89ce668c1545c8fc8.png";
 note = "<p><img src="/maibate/ueditor/jsp/upload/image/20170911/1505100508050003035.png" title="1505100508050003035.png" alt="fw3.png"/>活动建设中</p>";
 id = 41;
 uuid = "b54df2f2-eb2c-4201-af36-bbda91d44cbb";
 publisher = "lx02";
 activityname = "活动三";
 createtime = "2017-09-11 11:10:01";
 publishid = 198;
 picname = "fw1.png"
 },
 */
