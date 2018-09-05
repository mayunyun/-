//
//  UserRequestTool.h
//  BasicFramework
//
//  Created by Rainy on 2017/10/30.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRequestTool : NSObject

/**
 *  login 用户登录
 */
-(void)loginWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters  FinishedLogin:(void(^)(id responseObject))FinishedLogin;

-(void)loginWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters loading:(BOOL)loading FinishedLogin:(void(^)(id responseObject))FinishedLogin;

@end
