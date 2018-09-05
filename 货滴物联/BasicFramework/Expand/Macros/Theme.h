//
//  Theme.h
//  BasicFramework
//
//  Created by Rainy on 16/8/18.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#ifndef Theme_h
#define Theme_h

#pragma mark -  * * * * * * * * * * * * * * 主题 * * * * * * * * * * * * * *
#define TabbarHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) // 适配iPhone x 底栏高度
#define NavBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88:64)

#define MYLine        0xF4F4F4//背景线
#define NavBarItemColor [UIColor blackColor]
/**
 *  无色
 */
#define kClearColor [UIColor clearColor]
/**
 *  默认页面背景色
 */
#define DefaultBackGroundColor UIColorFromRGBValueValue(0Xf5f7fa)
/**
 *  默认白色
 */
#define WhiteColor UIColorFromRGBValueValue(0Xffffff)
/**
 *  主题颜色
 */
#define ThemeColor UIColorFromRGBValueValue(0XC50033)
/**
 *  page control default color
 */
#define kPageDefaultColor UIColorFromRGBValueValue(0X828CA1)
/**
 *  主题辅助颜色（状态，提示等...）
 */
#define OrangeColor UIColorFromRGBValueValue(0Xef5a50)
/**
 *  遮盖半透明色
 */
#define kCoverColor [UIColorFromRGBValueValue(0X000000)colorWithAlphaComponent:0.3]

/**
 *  分割线灰色等...
 */
#define kBackDefaultGrayColor UIColorFromRGBValueValue(0Xdbdfe8)
/**
 *  主要字体颜色
 */
#define kMainFontColor UIColorFromRGBValueValue(0X333333)
/**
 *  次要字体颜色
 */
#define kSecondaryFontColor UIColorFromRGBValueValue(0X999999)
/**
 *  辅助字体颜色
 */
#define kAuxiliaryFontColor UIColorFromRGBValueValue(0Xcccccc)
/**
 *  默认字体颜色(非点击状态)
 */
#define kNormalFontColor UIColorFromRGBValueValue(0X999999)


#pragma mark -  * * * * * * * * * * * * * * set Font * * * * * * * * * * * * * *
/**
 *  10号字体
 */
#define TenFontSize [UIFont systemFontOfSize:10]
/**
 *  11号字体
 */
#define ElevenFontSize [UIFont systemFontOfSize:11]
/**
 *  12号字体
 */
#define TwelveFontSize [UIFont systemFontOfSize:12]
/**
 *  13号字体
 */
#define ThirteenFontSize [UIFont systemFontOfSize:13]
/**
 *  14号字体
 */
#define FourteenFontSize [UIFont systemFontOfSize:14]
/**
 *  15号字体
 */
#define FifteenFontSize [UIFont systemFontOfSize:15]
/**
 *  17号字体
 */
#define SeventeenFontSize [UIFont systemFontOfSize:17]
/**
 *  18号字体
 */
#define EighteenFontSize [UIFont systemFontOfSize:18]
/**
 *  20号字体
 */
#define TwentyFontSize [UIFont systemFontOfSize:20]




#pragma mark -  * * * * * * * * * * * * * * set Button * * * * * * * * * * * * * *
/**
 *  按钮的背景默认颜色
 */
#define kButtonBackColorForNormal UIColorFromRGBValueValue(0X0097f4)
/**
 *  按钮的背景点击颜色
 */
#define kButtonBackColorForSelect UIColorFromRGBValueValue(0X008ce3)
/**
 *  按钮的背景不可点击颜色
 */
#define kButtonBackColorForDisabled UIColorFromRGBValueValue(0X7fcaf9)
/**
 *  按钮的圆角
 */
#define kButtonCornerRad 5

/**
 *  R,G,B ／ A
 */
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define kRGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define kRGB_alpha(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
/**
 *  十六进制颜色
 */
#define UIColorFromRGBValueValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define MYOrange      0xFFB400//主色调
#define MYBack        0xEEEEEE//背景浅灰
#define MYColor UIColorFromRGBValueValue(0xC30E21)
/**
 *  随机色
 */
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]


//登录之后就返回
#define USERID @"USEID"                 //用户ID
#define USENAME @"USENAME"              //姓名
#define USERPHONE @"USERPHONE"          //用户手机号
#define USERUUID @"USERUUID"            //uuid
#define PASSWORD @"PASSWORD"            //密码
#define CITY @"CITY"            //城市
#define PROVINCE @"PROVINCE"            //省

#endif /* Theme_h */
