//
//  WLMapViewController.h
//  MaiBaTe
//
//  Created by LONG on 2017/12/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BasicMainVC.h"

@interface WLMapViewController : BasicMainVC
@property (nonatomic,strong)NSString *type;
@property (nonatomic,assign)CLLocationCoordinate2D location;//上个点
@property (nonatomic, copy) void (^qidianBlock)(NSString* strQD,CLLocationCoordinate2D location);
@property (nonatomic, copy) void (^zhongdianBlock)(NSString* strZD,CLLocationCoordinate2D location);

@end
