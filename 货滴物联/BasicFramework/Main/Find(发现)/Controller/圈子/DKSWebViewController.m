//
//  DKSWebViewController.m
//  DKSWebView
//
//  Created by aDu on 2017/2/14.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "DKSWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LoginVC.h"
@interface NSURLRequest (InvalidSSLCertificate)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end

@interface DKSWebViewController ()<UIActionSheetDelegate,UIGestureRecognizerDelegate,NSURLSessionDelegate>{
    UIView *statusBarView;
}

@property (nonatomic, strong) NSURLRequest *request;
//判断是否是HTTPS的
@property (nonatomic, assign) BOOL isAuthed;

@property (nonatomic,strong)NSString * imgUrl;
@end

@implementation DKSWebViewController

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    self.view.bounds.size.width, 20)];
    if (statusbarHeight>20) {
        statusBarView.frame = CGRectMake(0, -44,    self.view.bounds.size.width, 44);
    }
    statusBarView.backgroundColor = color;
    [self.view addSubview:statusBarView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self setStatusBarBackgroundColor:UIColorFromRGB(0x333333)];
    UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [self.webView addGestureRecognizer:longPressed];

}
- (void)longPressed:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }

    CGPoint touchPoint = [recognizer locationInView:self.webView];
    //这里是js，主要目的实现对图片url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";

    [self.webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResult = [self.webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    NSArray *urlArray = [NSMutableArray arrayWithArray:[urlResult componentsSeparatedByString:@"+"]];
    //urlResurlt 就是获取到得所有图片的url的拼接；mUrlArray就是所有Url的数组
    NSLog(@"--获取的图片地址url数组%@",urlArray);
//    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
//    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
    _imgUrl = urlArray[1];
    if (_imgUrl.length == 0) {
        return;
    }

    [self showImageOptionsWithUrl];
}
- (void)showImageOptionsWithUrl
{
    UIActionSheet* sheet = [[UIActionSheet alloc
                             ]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    sheet.tag = 1001;
    [sheet showInView:self.view];


}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //头像
    if (actionSheet.tag == 1001) {
        if (0 == buttonIndex) {

            [self saveImageToDiskWithUrl:_imgUrl];

        } else if (1 == buttonIndex) {

        }
    }

}
- (void)saveImageToDiskWithUrl:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];

    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];

    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];

    NSURLSessionDownloadTask  *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return ;
        }

        NSData * imageData = [NSData dataWithContentsOfURL:location];

        dispatch_async(dispatch_get_main_queue(), ^{

            UIImage * image = [UIImage imageWithData:imageData];

            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];

    [task resume];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"error错误是啥子%@",contextInfo);
    if (error) {

        jxt_showToastTitle(@"保存失败", 1);
    }else{
        jxt_showToastTitle(@"保存成功", 1);
    }
}

//加载URL
- (void)loadHTML:(NSString *)htmlString
{
    NSURL *url = [NSURL URLWithString:htmlString];
    self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    [self.webView loadRequest:self.request];
}

#pragma mark - UIWebViewDelegate
//开始加载
- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString* scheme = [[request URL] scheme];
    
    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [awebView stopLoading];
            return NO;
        }
    }
    return YES;
}
-(void)addJScustomAction{
    JSContext * context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self addGoBackWithContext:context];
    [self addAlertSureWithContext:context];
    
}
-(void)addAlertSureWithContext:(JSContext *)context{
    context[@""] = ^(){
        
    };
}
-(void)addGoBackWithContext:(JSContext *)context{
    //当点击网页中的button的时候，触发jump方法， 在OC中用如下代码可以捕捉到jump方法， 并拿到JS给我传的参数‘3’
    context[@"fahui"] = ^(){
        [self closeNative];
    };
    
    context[@"jump_login"] = ^(){
        NSLog(@"????>>>>>jump_login");
        jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"前往", ^(NSInteger buttonIndex) {
            LoginVC* vc = [[LoginVC alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        });
        
    };
}
//设置webview的title为导航栏的title
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    [self addJScustomAction];
    
    self.webView.backgroundColor = [UIColor blackColor];
    
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    
    

}

#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        self.isAuthed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"网络不给力");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.isAuthed = YES;
    //webview 重新加载请求。
    [self.webView loadRequest:self.request];
    [connection cancel];
}



//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBarBackgroundColor:UIColorFromRGB(0x333333)];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除progressView  because UINavigationBar is shared with other ViewControllers
    [statusBarView removeFromSuperview];

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}



@end
