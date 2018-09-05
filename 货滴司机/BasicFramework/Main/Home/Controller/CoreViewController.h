//
//  CoreViewController.h
//  MaiBaTe
//
//  Created by LONG on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IS_VAILABLE_IOS8  ([[[UIDevice currentDevice] systemVersion] intValue] >= 8)

@interface CoreViewController : UIViewController
typedef void (^QRCodeDidReceiveBlock)(NSString *result);
@property (nonatomic, copy, readonly) QRCodeDidReceiveBlock didReceiveBlock;
- (void)setDidReceiveBlock:(QRCodeDidReceiveBlock)didReceiveBlock;
@end
