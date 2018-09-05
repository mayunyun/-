//
//  XiaZaiViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/6/6.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "XiaZaiViewController.h"

@interface XiaZaiViewController ()<UIWebViewDelegate>
{
    UIWebView* _webView;
}
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;


@end

@implementation XiaZaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSString* baseurl = @"http://m.huodiwulian.com/index.html";
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseurl]]];
    
    UIButton *backbut = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60,44)];
    [backbut setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backbut addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbut];
}
- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
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
