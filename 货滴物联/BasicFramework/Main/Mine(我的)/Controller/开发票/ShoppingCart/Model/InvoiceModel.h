//
//  InvoiceModel.h
//  BasicFramework
//
//  Created by 钱龙 on 2018/3/1.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface InvoiceModel : JSONModel
@property (nonatomic,strong)NSString *createtime;
@property (nonatomic,strong)NSString *endaddress;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *ordertotalprice;
@property (nonatomic,strong)NSString *startaddress;

@property (nonatomic, assign) BOOL isSelected;//商品是否被选
@end
