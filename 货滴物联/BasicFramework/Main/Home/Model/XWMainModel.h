//
//  MainModel.h
//  MaiBaTe
//
//  Created by LONG on 17/8/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XWMainModel : JSONModel
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *createtime;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *uuid;

@end
