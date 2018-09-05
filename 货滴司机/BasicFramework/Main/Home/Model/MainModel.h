//
//  MainModel.h
//  BasicFramework
//
//  Created by Rainy on 2016/11/14.
//  Copyright © 2016年 Rainy. All rights reserved.
//


#import <JSONModel/JSONModel.h>

@protocol ProductModel

@end

@interface ProductModel : JSONModel

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString <Optional>*userid;
@property(nonatomic,copy)NSString *sex;

@end

@interface MainModel : JSONModel

@property(nonatomic,copy)NSString *team;
@property(nonatomic,copy)NSString *dataBase_ID;
@property(nonatomic,strong)NSArray<ProductModel>* mans;

@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *createtime;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *uuid;

@end
