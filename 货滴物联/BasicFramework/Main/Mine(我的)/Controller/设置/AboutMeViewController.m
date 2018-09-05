//
//  AboutMeViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AboutMeViewController.h"
#import "WXApi.h"
#import "LSActionView.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "AboutWXViewController.h"
#import "wentiViewController.h"
@interface AboutMeViewController ()


@end

@implementation AboutMeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于我们";
    [self setAboutWXView];
}
-(void)setAboutWXView{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, UIScreenH)];
    if (statusbarHeight>20) {
        bgview.frame = CGRectMake(0, 88, kScreenWidth, UIScreenH);
    }
    bgview.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [self.view addSubview:bgview];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微信公众号"]];
    image.frame = CGRectMake(kScreenWidth/2-86*MYWIDTH, 30*MYWIDTH, 172*MYWIDTH, 172*MYWIDTH);
    [bgview addSubview:image];
    
    UILabel *other = [[UILabel alloc]initWithFrame:CGRectMake(0, image.bottom, kScreenWidth, 40*MYWIDTH)];
    other.textAlignment = NSTextAlignmentCenter;
    other.numberOfLines = 4;
    other.text = @"关注货滴微信公众号";
    other.font = [UIFont systemFontOfSize:14];
    other.textColor = [UIColor blackColor];
    [bgview addSubview:other];
    
    UIImageView *image2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"推荐给朋友"]];
    image2.frame = CGRectMake(0, other.bottom+30*MYWIDTH, kScreenWidth, 200*MYWIDTH);
    image2.userInteractionEnabled  = YES;
    [bgview addSubview:image2];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wxlogin)];
    tap1.cancelsTouchesInView = NO;
    [image2 addGestureRecognizer:tap1];
}
//#pragma mark - UITableViewDataSource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return 2;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 80*MYWIDTH;
//
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    static NSString* cellID = @"cell";
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//
//    NSArray *arr = @[@"  推荐给好友",@"  关注货滴微信公众号"];
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 10*MYWIDTH, kScreenWidth-30*MYWIDTH, 60*MYWIDTH)];
//    lab.text = [NSString stringWithFormat:@"%@",arr[indexPath.row]];
//    lab.textColor = [UIColor blackColor];
//    lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
//    lab.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
//    lab.layer.borderWidth = 1.0f;//设置边框
//    [cell addSubview:lab];
//
//    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(lab.width-25*MYWIDTH, 20*MYWIDTH, 13*MYWIDTH, 20*MYWIDTH)];
//    imageview.image = [UIImage imageNamed:@"rightRed"];
//    [lab addSubview:imageview];
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
////    if (indexPath.row == 0){
////        wentiViewController *aboutwx = [[wentiViewController alloc]init];
////        [self.navigationController pushViewController:aboutwx animated:YES];
////
////    }else
//    if(indexPath.row == 0){
//        [self wxlogin];
//    }else if (indexPath.row == 1){
//        AboutWXViewController *aboutwx = [[AboutWXViewController alloc]init];
//        [self.navigationController pushViewController:aboutwx animated:YES];
//    }
//
//    NSLog(@"%ld",indexPath.row);
//}


- (void)wxlogin{
    NSArray* images = @[@"shareweixin",@"sharemoments",@"sharecollect"];//,@"sharecollect"
    NSArray* titles = @[@"分享到好友",@"分享到朋友圈",@"分享到收藏"];//,@"分享到空间"
    
    WXMediaMessage* message = [WXMediaMessage message];
    message.title = @"货滴物联";
    message.description = @"欢迎使用货滴物联，你身边的物流平台。";
    UIImageView *image = [[UIImageView alloc]init];
    [image sd_setImageWithURL:[NSURL URLWithString:@"http://www.huodiwulian.com/logo_hz.png"] placeholderImage:nil];
    [message setThumbImage:[UIImage imageNamed:@"LOGO.png"]];
    WXWebpageObject* webpage = [WXWebpageObject object];
    webpage.webpageUrl = @"http://www.huodiwulian.com/hdsywz/weixin/page/xiazai.html";
    message.mediaObject = webpage;
    
    [[LSActionView sharedActionView] showWithImages:images titles:titles actionBlock:^(NSInteger index) {
        NSLog(@"Action trigger at %ld:", (long)index);
        if (index == 0) {
            //WXSceneSession
            if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
            {
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneSession;
                [WXApi sendReq:req];
            }else{
                jxt_showAlertOneButton(@"您没有安装微信客户端", nil, @"确定", nil);
            }
        }else if (index == 1){
            if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
            {
                //WXSceneTimeline
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneTimeline;
                [WXApi sendReq:req];
             }else{
                 jxt_showAlertOneButton(@"您没有安装微信客户端", nil, @"确定", nil);
             }
        }else if (index == 2){
            if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
            {
                //WXSceneTimeline
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneFavorite;
                [WXApi sendReq:req];
            }else{
                jxt_showAlertOneButton(@"您没有安装微信客户端", nil, @"确定", nil);
            }
            
        }else if (index == 3){
            // 设置预览图片
            NSURL *previewURL = [NSURL URLWithString:@"…"];
            // 设置分享链接
            NSURL* url = [NSURL URLWithString: @"…"];
            QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:url title: @"…" description: @"…" previewImageURL:previewURL];
            // 设置分享到QZone的标志位
            [imgObj setCflag: kQQAPICtrlFlagQZoneShareOnStart ];
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleSendResult:sent];
        }
    }];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}


@end
