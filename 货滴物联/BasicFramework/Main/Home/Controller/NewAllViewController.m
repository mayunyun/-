//
//  NewAllViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NewAllViewController.h"
#import "ZZNetworkTools.h"
#import "WXApi.h"
#import "LSActionView.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"

@interface NewAllViewController ()<UIWebViewDelegate>

@end

@implementation NewAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.type == 1) {
        self.title = @"新闻详情";
    }else if (self.type == 2){
        self.title = @"活动详情";
    }
    //[self dataRequest];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(wxlogin)];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    
    [self PageViewDidLoad1];
}
//- (void)dataRequest{
//    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_model.id]};
//    if (self.type == 2){
//        params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_huomodel.id]};
//    }
//    NSLog(@">>>%@",params);
//    NSString *XWURLStr;
//    if (self.type == 1) {
//        XWURLStr = @"/mbtwz/index?action=getNewsDetail";
//    }else if (self.type == 2){
//        XWURLStr = @"/mbtwz/index?action=getActivityDetail";
//    }
//    [Command loadDataWithParams:params withPath:XWURLStr completionBlock:^(id responseObject, NSError *error) {
//        NSLog(@"最新%@",responseObject);
//        if (responseObject) {
//
//        }
//
//    } autoShowError:YES];
//
//
//}
- (void)PageViewDidLoad1
{
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
    if (statusbarHeight>20) {
        self.titleLab.frame = CGRectMake(0, 88, kScreenWidth, 50);
    }
    self.titleLab.numberOfLines = 0;
    self.titleLab.font = [UIFont boldSystemFontOfSize:17];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLab];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.titleLab.bottom, kScreenWidth, kScreenHeight-self.titleLab.height-64)];
    if (statusbarHeight>20) {
        _webView.frame = CGRectMake(0, self.titleLab.bottom, kScreenWidth, kScreenHeight-self.titleLab.height-88);
    }
    [self.view addSubview:_webView];
    
    NSString* linkCss = @"<style type=\"text/css\"> img {"
    "width:100%;"
    "height:auto;"
    "}"
    "</style>";
    
    if (self.type == 1) {
        if ([[Command convertNull:_model.title] isEqualToString:@""]) {
            self.titleLab.text = @"";
        }else{
            self.titleLab.text = _model.title;
        }
        [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",self.model.note,linkCss] baseURL:[NSURL URLWithString:_Environment_Domain]];
    }else if (self.type == 2){
        if ([[Command convertNull:self.huomodel.activityname] isEqualToString:@""]) {
            self.titleLab.text = @"";
        }else{
            self.titleLab.text = [NSString stringWithFormat:@"%@",self.huomodel.activityname];
        }
        [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",self.huomodel.note,linkCss] baseURL:[NSURL URLWithString:_Environment_Domain]];
    }
    
    self.webView.delegate = self;
    //新闻内容的Label的自适应大小
    [self.webView sizeToFit];
    self.webView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    
    
}
//设置字体大小

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改百分比即可
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '40%'"];
    
}

- (void)wxlogin{
    NSArray* images = @[@"shareweixin",@"sharemoments",@"sharecollect"];//,@"sharecollect"
    NSArray* titles = @[@"分享到好友",@"分享到朋友圈",@"分享到收藏"];//,@"分享到空间"
    
    WXMediaMessage* message = [WXMediaMessage message];
    if ([[Command convertNull:_model.title] isEqualToString:@""]) {
        message.title = @"";
    }else{
        message.title = _model.title;
    }
//    message.title = @"货滴物联";
//    message.description = @"欢迎使用货滴物联，你身边的物流平台。";
    UIImageView *image = [[UIImageView alloc]init];
    
    NSString *urlimage = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,_model.folder,_model.autoname];
    [image sd_setImageWithURL:[NSURL URLWithString:urlimage] placeholderImage:nil];
    [message setThumbImage:[UIImage imageNamed:@"LOGO.png"]];
    WXWebpageObject* webpage = [WXWebpageObject object];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.huodiwulian.com/hdsywz/page/xinwen/xinwenxiangqingm.html?id=%@&type=%d",_model.id,self.type];
    if (self.type == 2){
        urlStr = [NSString stringWithFormat:@"http://www.huodiwulian.com/hdsywz/page/xinwen/xinwenxiangqingm.html?id=%@&type=%d",_huomodel.id,self.type];
    }
    webpage.webpageUrl = urlStr;
    message.mediaObject = webpage;
    [[LSActionView sharedActionView] setContainerColor:[UIColor whiteColor]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

