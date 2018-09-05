//
//  MingXiModel.h
//  MaiBaTe
//
//  Created by LONG on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MingXiModel : JSONModel
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *custid;//客户ID
@property (nonatomic,strong)NSString *money;//金额
@property (nonatomic,strong)NSString *createtime;//时间
@property (nonatomic,strong)NSString *tradeno;//交易单号
@property (nonatomic,strong)NSString *chargeno;//充值单号
@property (nonatomic,strong)NSString *type;//支付类型 (0:充 1：减)
@property (nonatomic,strong)NSString *paytype;//支付方式 (0:微信 1:支付宝 2:银行卡 3:充电扣减)
@property (nonatomic,strong)NSString *ordertype;

/*
 {
 custid = 62;
 tradeno = "111";
 note = "232";
 id = 3;
 chargeno = "222";
 paytype = 1;
 type = 1;
 createtime = "1900-01-01 00:00:00";
 money = 23
	}
 */
@end
