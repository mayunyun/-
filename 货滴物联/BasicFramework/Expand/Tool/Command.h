//
//  Command.h
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Command : NSObject

+ (NSString *)currentDateString;
//新版正则表达式代码：
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isMobileNumber2:(NSString *)mobileNum;

+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)checkCarID:(NSString *)carID;

//转换成空串
+ (NSString*)convertNull:(id)object;
+ (NSString *)replaceAllOthers:(NSString *)responseString;


//+(void)isloginRequest:(void(^)(bool))string;
+ (void)customAlert:(NSString*)msg;
+ (BOOL)isValidateNmuber:(NSString *)candidate length:(NSInteger) length;
+ (BOOL)isPassword:(NSString *) candidate;

+ (void)addUnderline:(UIButton*)button str:(NSString*)str color:(UIColor*)color;
//改textField中placeholderColor
+ (void)placeholderColor:(UITextField*)textField str:(NSString*)holderText color:(UIColor*)color;

//+ (void)loadDataWithParams:(NSDictionary *)params withPath:(NSString *)pathUrl completionBlock:(void (^)(id responseObject,NSError *error))completionBlock autoShowError:(BOOL)autoShowError;
+ (id)tryToParseData:(id)json;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;
+ (UIViewController *)getCurrentVC;
+ (void)changeTextfont:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change;
//判断登录
+(void)isloginRequest:(void(^)(bool))string;
@end
