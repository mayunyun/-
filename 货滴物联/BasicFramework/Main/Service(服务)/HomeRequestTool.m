//
//  HomeRequestTool.m
//  BasicFramework
//
//  Created by Rainy on 2017/10/30.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "HomeRequestTool.h"

@implementation HomeRequestTool
-(void)homePageBannerList:(NSDictionary *)parameters FinishedTest:(void(^)(id responseObject))FinishedTest{
    [NetWorkManagerTwo requestDataWithURL:[NSString stringWithFormat:@"%@%@",_Environment_Domain,_URL_HomePage_Banner]
                              requestType:POST
                               parameters:parameters
                                  loading:YES
                           uploadProgress:nil
                                  success:^(id responseObject,id data)
     {
         
         FinishedTest(data);
         
     } failure:^(NSError *error) {
         
     }];
}
@end
