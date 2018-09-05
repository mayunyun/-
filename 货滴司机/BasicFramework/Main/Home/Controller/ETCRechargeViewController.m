//
//  ETCRechargeViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/11/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ETCRechargeViewController.h"

@interface ETCRechargeViewController ()<UIWebViewDelegate>
{
    UIWebView* _webView;
}
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;


@end

@implementation ETCRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.push isEqualToString:@"1"]) {
        self.navigationItem.title = @"ETC充值";
    }else if([self.push isEqualToString:@"2"]){
        self.navigationItem.title = @"服务手册";
    }else{
        self.navigationItem.title = @"用户指南";
    }
    
    [self creatUI];

    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self.view addSubview:self.activityIndicator];
    //设置小菊花的frame
    self.activityIndicator.frame= CGRectMake(UIScreenW/2-50, UIScreenH/2-50, 100, 100);
    //设置小菊花颜色
    self.activityIndicator.color = [UIColor blackColor];
    //设置背景颜色
    self.activityIndicator.backgroundColor = [UIColor clearColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    //self.activityIndicator.hidesWhenStopped = NO;
    
}

- (void)creatUI{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, statusbarHeight+44, UIScreenW, UIScreenH-statusbarHeight-44)];
//    if ([_push isEqualToString:@"3"]) {
//        _webView.frame = CGRectMake(0, -statusbarHeight, UIScreenW, UIScreenH+statusbarHeight);
//    }
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSString* baseurl;
    if ([self.push isEqualToString:@"1"]) {
        baseurl = @"http://m.huodiwulian.com/etc/etc.html";
    }else if([self.push isEqualToString:@"2"]){
        baseurl = @"http://m.huodiwulian.com/kczj/sjsc.html";
    }else{
        baseurl = @"http://m.huodiwulian.com/yhzn/yhzn.html";
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseurl]]];
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    NSLog(@"webViewDidStartLoad");
    //进度HUD
    [self.activityIndicator startAnimating];


}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    //    NSLog(@"didFailLoadWithError===%@", error);
    
}

@end
