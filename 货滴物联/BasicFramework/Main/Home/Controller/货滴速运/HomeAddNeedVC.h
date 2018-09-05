//
//  HomeAddNeedVC.h
//  BasicFramework
//
//  Created by LONG on 2018/1/31.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "BasicMainVC.h"

@interface HomeAddNeedVC : BasicMainVC
@property (nonatomic, copy) void (^needBlock)(NSMutableArray* Arr);
@property (nonatomic,strong)NSArray *needArr;
@end
