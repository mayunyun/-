//
//  WLAddNeedModel.h
//  MaiBaTe
//
//  Created by LONG on 2018/1/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WLAddNeedModel : JSONModel

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *isvalid;
@property (nonatomic,strong)NSString *service_name;
@property (nonatomic,strong)NSString *service_price;
@property (nonatomic,strong)NSString *need;

/*
 {
 id = 5;
 isvalid = 1;
 "service_name" = "\U8fd4\U7a0b";
 "service_price" = 1;
 }
 */
@end
