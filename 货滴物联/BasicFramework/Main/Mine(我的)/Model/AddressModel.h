//
//  AddressModel.h
//  MaiBaTe
//
//  Created by 邱 德政 on 17/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AddressModel : JSONModel
@property (nonatomic,strong)NSString *provinceid;
@property (nonatomic,strong)NSString *postcode;
@property (nonatomic,strong)NSString *note;
@property (nonatomic,strong)NSString *addresslabel;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *custid;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *cityid;
@property (nonatomic,strong)NSString *taxphone;
@property (nonatomic,strong)NSString *shphone;
@property (nonatomic,strong)NSString *shcustname;
@property (nonatomic,strong)NSString *areaid;
@property (nonatomic,strong)NSString *isdefault;
@end
