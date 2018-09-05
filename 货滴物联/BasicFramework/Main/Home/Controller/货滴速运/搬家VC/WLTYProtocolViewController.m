//
//  WLTYProtocolViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WLTYProtocolViewController.h"

@interface WLTYProtocolViewController ()<UIWebViewDelegate>

@end

@implementation WLTYProtocolViewController{
    UIWebView *_webView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, NavBarHeight)];
    bgview.userInteractionEnabled = YES;
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, bgview.height-44, kScreenWidth, 44)];
    titleLab.text = @"货物托运服务协议";
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.userInteractionEnabled = YES;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = UIColorFromRGBValueValue(0x333333);
    [bgview addSubview:titleLab];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(18, 15, 15, 15)];
    imageview.image = [UIImage imageNamed:@"关闭_1"];
    imageview.userInteractionEnabled = YES;
    [titleLab addSubview:imageview];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NavBarHeight, NavBarHeight)];
    [but addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:but];
    
    [self loadNew];
}
#pragma 刷新(在这里面发送请求，刷新数据)
- (void)loadNew
{
    
    //
    NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=searchCarDeal";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:nil FinishedLogin:^(id responseObject) {

        
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@">>%@",Arr);
        if (Arr.count) {
            
            [self PageViewDidLoad1:[Arr[0] objectForKey:@"content"]];
        }
        
    }];
    
    
}
- (void)PageViewDidLoad1:(NSString *)content
{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, NavBarHeight+15*MYWIDTH, kScreenWidth-30*MYWIDTH, kScreenHeight-NavBarHeight-30*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10; 
    bgview.layer.masksToBounds = YES;
    [self.view addSubview:bgview];
    
    NSString* linkCss = @"<style type=\"text/css\"> img {"
    "width:100%;"
    "height:auto;"
    "}"
    "</style>";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, bgview.width, bgview.height)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
//    NSString* baseurl = [NSString stringWithFormat:@"%@/mbtwz/logisticssendwz?action=searchCarDeal",WEB_ADDRESS];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseurl]]];
    [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",content,linkCss] baseURL:[NSURL URLWithString:_Environment_Domain]];

    [bgview addSubview:_webView];
    
    
    
    
}
//设置字体大小

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改百分比即可
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '40%'"];
    [ProgressHUD hideProgressHUDAfterDelay:0];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    NSLog(@"webViewDidStartLoad");
    //进度HUD
    [ProgressHUD showProgressHUDWithMode:0 withText:Loading isTouched:NO inView:kWindow];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    //    NSLog(@"didFailLoadWithError===%@", error);
    
}
- (void)butClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
