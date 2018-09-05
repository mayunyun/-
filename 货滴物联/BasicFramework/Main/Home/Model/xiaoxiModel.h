//
//  xiaoxiModel.h
//  BasicFramework
//
//  Created by LONG on 2018/6/22.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "JSONModel.h"

@interface xiaoxiModel : JSONModel
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *create_time;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *issee;
@property(nonatomic,strong)NSString *mark;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *isselect;



/*
 {
 flag = 200;
 msg = "\U67e5\U8be2\U6210\U529f";
 response =     {
 "page_number" = 1;
 rows =         (
 {
 content = "\U5e73\U53f0\U6d4b\U8bd5\U63a8\U9001\U6d88\U606f\U7ed9\U8d27\U4e3b\U7aef\Uff0c\U6b64\U6d88\U606f\U4e3a\U6d4b\U8bd5\U7248\U672c\Uff0c\U8bf7\U81ea\U884c\U5ffd\U7565\U3002";
 "create_time" = "2018-06-22 16:11:33";
 id = 107;
 issee = 1;
 mark = 0;
 title = "\U6d4b\U8bd5\U63a8\U9001";
 type = 0;
 "user_id" = 99;
 },
 {
 content = "\U60a8\U7684\U7701\U9645/\U57ce\U9645\U8ba2\U5355\U3010FP201806220001\U3011\U6709\U53f8\U673a\U63a5\U5355\U4e86\Uff0c\U8bf7\U67e5\U770b\Uff01";
 "create_time" = "2018-06-22 14:59:02";
 id = 105;
 issee = 1;
 mark = 1;
 title = "\U8ba2\U5355\U63a5\U5355";
 type = 0;
 "user_id" = 99;
 },
 {
 content = "\U60a8\U7684\U7701\U9645/\U57ce\U9645\U8ba2\U5355\U3010FP201806220002\U3011\U6709\U53f8\U673a\U63a5\U5355\U4e86\Uff0c\U8bf7\U67e5\U770b\Uff01";
 "create_time" = "2018-06-22 14:58:57";
 id = 104;
 issee = 1;
 mark = 1;
 title = "\U8ba2\U5355\U63a5\U5355";
 type = 0;
 "user_id" = 99;
 },
 {
 content = "\U60a8\U7684\U7701\U9645/\U57ce\U9645\U8ba2\U5355\U3010FP201806220003\U3011\U6709\U53f8\U673a\U63a5\U5355\U4e86\Uff0c\U8bf7\U67e5\U770b\Uff01";
 "create_time" = "2018-06-22 14:58:37";
 id = 103;
 issee = 0;
 mark = 1;
 title = "\U8ba2\U5355\U63a5\U5355";
 type = 0;
 "user_id" = 99;
 }
 );
 total = 4;
 };
 }
 */
@end
