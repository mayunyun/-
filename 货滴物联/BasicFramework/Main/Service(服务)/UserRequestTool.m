//
//  UserRequestTool.m
//  BasicFramework
//
//  Created by Rainy on 2017/10/30.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "UserRequestTool.h"
#import "NetWorkManagerTwo.h"

@implementation UserRequestTool
-(void)loginWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters  FinishedLogin:(void(^)(id responseObject))FinishedLogin
{
    [NetWorkManagerTwo requestDataWithURL:[NSString stringWithFormat:@"%@%@",_Environment_Domain,url]
                              requestType:POST
                               parameters:parameters
                                  loading:YES
                           uploadProgress:nil
                                  success:^(id responseObject,id data)
     {
         NSLog(@"请求的接口地址%@",[NSString stringWithFormat:@"%@%@",_Environment_Domain,url]);
         FinishedLogin(responseObject);
         
     } failure:^(NSError *error) {
         
     }];
    
    
}

-(void)loginWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters loading:(BOOL)loading FinishedLogin:(void(^)(id responseObject))FinishedLogin
{
    [NetWorkManagerTwo requestDataWithURL:[NSString stringWithFormat:@"%@%@",_Environment_Domain,url]
                              requestType:POST
                               parameters:parameters
                                  loading:loading
                           uploadProgress:nil
                                  success:^(id responseObject,id data)
     {
         NSLog(@"请求的接口地址%@",[NSString stringWithFormat:@"%@%@",_Environment_Domain,url]);
         FinishedLogin(responseObject); 
         
     } failure:^(NSError *error) {
         
     }];
    
    
}


@end
