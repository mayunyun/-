//
//  WPNetworkTools.m
//
//  Created by apple on 15/1/21.
//  Copyright (c) 2015年 vfusifang. All rights reserved.
//

#import "ZZNetworkTools.h"

@implementation ZZNetworkTools

+ (instancetype)sharedNetworkTools {
    static ZZNetworkTools *tools;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tools = [[ZZNetworkTools alloc] init];
        
        // 设置反序列化的数据格式－> 官方建议的修改方式
        // 面试的问题：你修改过 AFN 的框架吗？没有修改能用吗？
        
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    });
    return tools;
}
@end
