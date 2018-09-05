//
//  YouHuiJuanViewController.h
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BasicMainVC.h"
#import "YouHuiModel.h"

@interface YouHuiJuanViewController : BasicMainVC
@property (nonatomic,strong)NSString *push;
@property (nonatomic, copy) void (^youhuiVaule)(YouHuiModel* model);

@end
