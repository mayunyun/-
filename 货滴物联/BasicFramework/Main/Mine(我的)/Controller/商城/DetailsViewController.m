//
//  DetailsViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DetailsViewController.h"
#import "ShopcartCountView.h"
#import "ShopOrderViewController.h"
#import "ShopCarViewController.h"
#import "DetailsModel.h"
#import "YJTagView.h"
#import "LoginVC.h"

@interface DetailsViewController ()<SDCycleScrollViewDelegate,YJTagViewDelegate, YJTagViewDataSource,UIWebViewDelegate>{
    UIScrollView* _bgsView;
    UIView *bgview;
    UILabel * proDetailLabel;
    UIWebView *webView;

    YJTagView *_typeview;
    YJTagView *_colorview;
    CGFloat _colorviewheight;
    CGFloat _typeviewheight;
    NSString *_typeNum;
    NSString *_colorNum;
    NSString *_countNum;

}
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) ShopcartCountView *shopcartCountView;
@property (nonatomic, strong) DetailsModel *model;

@end

@implementation DetailsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    UINavigationBar *bar = [UINavigationBar appearance];
    //    [bar setTranslucent:YES];
    self.navigationItem.title = @"";
    
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    _countNum = @"1";
    _bgsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -44, UIScreenW, UIScreenH+44)];
    _bgsView.contentSize = CGSizeMake(UIScreenW, UIScreenH);
    _bgsView.showsVerticalScrollIndicator = NO;
    _bgsView.showsHorizontalScrollIndicator = YES;
    _bgsView.bounces = NO;
    _bgsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgsView];
    
    [self loadNewData];
    [self loadNew];
}
- (void)loadNewData{
    // 网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenW/5*4) delegate:self placeholderImage:[UIImage imageNamed:@"7.1.png"]];
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.currentPageDotColor = MYColor; // 自定义分页控件小圆标颜色
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    [_bgsView addSubview:self.cycleScrollView];
    
    NSString *URLStr = @"/mbtwz/scshop?action=getProductDeatilBanner";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"proid\":\"%@\"}",_id]};

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"轮播图%@",array);
        if (array.count) {
            NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
            //建立模型
            for (NSDictionary*dic in array ) {
                
                NSString *image = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,[dic objectForKey:@"folder"],[dic objectForKey:@"autoname"]];
                
                //追加数据
                [imagesURLStrings addObject:image];
            }
            
            self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        }
        
    }];
}
- (void)loadNew{
    NSString *URLStr = @"/mbtwz/scshop?action=getProductDeatilParam";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_id]};
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"详情%@",array);
        if (array.count) {
            _model=[[DetailsModel alloc]init];
            [_model setValuesForKeysWithDictionary:array[0]];
            webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 1)];

            
            // 创建
            NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRun) object:nil];
            
            // 启动
            [thread start];
        }
        [self createUI];
        
    }];
    
    
}
- (void)threadRun{
    NSString* linkCss = @"<style type=\"text/css\"> img {"
    "width:100%;"
    "height:auto;"
    "}"
    "p {"
    "word-wrap:break-word;"
    "}"
    "</style>";
    [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",_model.note,linkCss] baseURL:[NSURL URLWithString:_Environment_Domain]];
    webView.delegate = self;
    webView.scrollView.bounces=NO;
    //自适应大小
    [webView sizeToFit];
}
-(void)createUI{
    
    
    bgview = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenW/5*4, UIScreenW, UIScreenH-UIScreenW/5*4)];
    bgview.backgroundColor = [UIColor whiteColor];
    [_bgsView addSubview:bgview];
    UIView *xianview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 10*MYWIDTH)];
    xianview.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview addSubview:xianview];
    
    UILabel *_titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 15*MYWIDTH, bgview.width-30*MYWIDTH, 40)];
    _titleLab.numberOfLines = 0;
    _titleLab.font = [UIFont systemFontOfSize:16];
    _titleLab.textColor = UIColorFromRGB(0x333333);
    _titleLab.text = [NSString stringWithFormat:@"%@",_model.proname];
    [bgview addSubview:_titleLab];
    CGSize titlesize = [_titleLab sizeThatFits:CGSizeMake(bgview.width-30*MYWIDTH, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    _titleLab.frame = CGRectMake(15*MYWIDTH, 15*MYWIDTH, bgview.width-30*MYWIDTH, titlesize.height);
    
    UILabel *_otherLab = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, _titleLab.bottom+5*MYWIDTH, bgview.width-30*MYWIDTH, 30)];
    _otherLab.numberOfLines = 0;
    _otherLab.lineBreakMode = NSLineBreakByWordWrapping;
    _otherLab.font = [UIFont systemFontOfSize:12];
    _otherLab.textColor = UIColorFromRGB(0x888888);
    _otherLab.text = [NSString stringWithFormat:@"%@",_model.productdes];
    [bgview addSubview:_otherLab];
    CGSize size = [_otherLab sizeThatFits:CGSizeMake(bgview.width-30*MYWIDTH, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    _otherLab.frame = CGRectMake(15*MYWIDTH, _titleLab.bottom+5*MYWIDTH, bgview.width-30*MYWIDTH, size.height);
    
    
    UILabel *_priceLab = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, _otherLab.bottom+10*MYWIDTH, bgview.width-30*MYWIDTH, 20)];
    _priceLab.font = [UIFont systemFontOfSize:20];
    _priceLab.textColor = MYColor;
    _priceLab.text = [NSString stringWithFormat:@"￥:%.2f / 积:%@",[_model.price floatValue],_model.price_jf];
    if ([_type isEqualToString:@"2"]) {
        _priceLab.text = [NSString stringWithFormat:@"%@积分",_model.price];
    }
    [bgview addSubview:_priceLab];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _priceLab.bottom+15*MYWIDTH, bgview.width-30*MYWIDTH, 1)];
    xian.backgroundColor = UIColorFromRGB(MYLine);
    [bgview addSubview:xian];
    
    UILabel * titleLabel1;
    if (_colorviewheight) {
        titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian.bottom+15*MYWIDTH, 70, 30*MYWIDTH)];
        titleLabel1.font = [UIFont systemFontOfSize:14];
        titleLabel1.textColor = UIColorFromRGB(0x333333);
        titleLabel1.text = @"可选颜色:";
        [bgview addSubview:titleLabel1];
    }
    _colorview = [[YJTagView alloc] initWithFrame:CGRectMake(70+49*MYWIDTH, titleLabel1.top, UIScreenW-85-49*MYWIDTH, _colorviewheight)];
    _colorview.themeColor = MYColor;
    _colorview.backgroundColor = [UIColor whiteColor];
    _colorview.tagCornerRadius = 0;
    _colorview.dataSource = self;
    _colorview.delegate = self;
    [bgview addSubview:_colorview];
    
    UILabel * titleLabel2;
    if (_typeviewheight) {
        titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, _colorview.bottom+15*MYWIDTH, 70, 30*MYWIDTH)];
        if (_colorviewheight == 0) {
            titleLabel2.frame = CGRectMake(15*MYWIDTH, xian.bottom+25*MYWIDTH, 70, 30*MYWIDTH);
        }
        titleLabel2.font = [UIFont systemFontOfSize:14];
        titleLabel2.textColor = UIColorFromRGB(0x333333);
        titleLabel2.text = @"适合车型:";
        [bgview addSubview:titleLabel2];
    }
    _typeview = [[YJTagView alloc] initWithFrame:CGRectMake(70+49*MYWIDTH, titleLabel2.top, UIScreenW-85-49*MYWIDTH, _typeviewheight)];
    _typeview.themeColor = MYColor;
    _typeview.backgroundColor = [UIColor whiteColor];
    _typeview.tagCornerRadius = 0;
    _typeview.dataSource = self;
    _typeview.delegate = self;
    [bgview addSubview:_typeview];
    
    UILabel * titleLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, _typeview.bottom+15*MYWIDTH, 70, 30*MYWIDTH)];
    if (_typeviewheight == 0) {
        titleLabel3.frame = CGRectMake(15*MYWIDTH, _colorview.bottom+10*MYWIDTH, 70, 30*MYWIDTH);
        if (_colorviewheight == 0) {
            titleLabel3.frame = CGRectMake(15*MYWIDTH, xian.bottom+25*MYWIDTH, 70, 30*MYWIDTH);
        }
    }
    titleLabel3.font = [UIFont systemFontOfSize:14];
    titleLabel3.textColor = UIColorFromRGB(0x333333);
    titleLabel3.text = @"选择数量:";
    [bgview addSubview:titleLabel3];
    
    _shopcartCountView = [[ShopcartCountView alloc] init];
    _shopcartCountView.frame = CGRectMake(70+49*MYWIDTH, titleLabel3.top, 100*MYWIDTH, 30*MYWIDTH);
    
    __weak __typeof(self) weakSelf = self;
    [self.shopcartCountView configureShopcartCountViewWithProductCount:1 productStock:1000];
    _shopcartCountView.shopcartCountViewEditBlock = ^(NSInteger count){
        NSLog(@"%zd",count);
        _countNum = [NSString stringWithFormat:@"%zd",count];
        [weakSelf.shopcartCountView configureShopcartCountViewWithProductCount:count productStock:1000];
        
    };
    [bgview addSubview:_shopcartCountView];
    

    
    UIButton *gobuyBut = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH, titleLabel3.bottom + 15*MYWIDTH, UIScreenW/2-20*MYWIDTH, 40*MYWIDTH)];
    [gobuyBut setBackgroundColor:[UIColor whiteColor]];
    [gobuyBut.layer setCornerRadius:5];
    gobuyBut.layer.masksToBounds = YES;
    [gobuyBut.layer setBorderWidth:1];
    [gobuyBut.layer setBorderColor:[UIColorFromRGB(0xc30e21) CGColor]];
    [gobuyBut setTitle:@"立即购买" forState:UIControlStateNormal];
    gobuyBut.titleLabel.font = [UIFont systemFontOfSize:16];
    [gobuyBut setTitleColor:MYColor forState:UIControlStateNormal];
    [gobuyBut addTarget:self action:@selector(ShopOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:gobuyBut];
    
    UIButton *shopCarBut = [[UIButton alloc]initWithFrame:CGRectMake(gobuyBut.right+10*MYWIDTH, titleLabel3.bottom + 15*MYWIDTH, UIScreenW/2-20*MYWIDTH, 40*MYWIDTH)];
    [shopCarBut setBackgroundColor:MYColor];
    [shopCarBut.layer setCornerRadius:5];
    shopCarBut.layer.masksToBounds = YES;
    [shopCarBut.layer setBorderWidth:1];
    [shopCarBut.layer setBorderColor:[UIColorFromRGB(0xFFB400) CGColor]];
    [shopCarBut setTitle:@"加入购物车" forState:UIControlStateNormal];
    shopCarBut.titleLabel.font = [UIFont systemFontOfSize:16];
    [shopCarBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shopCarBut addTarget:self action:@selector(shopCarButClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:shopCarBut];
    
    //商品详情label
    proDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, shopCarBut.bottom+15*MYWIDTH, UIScreenW, 20*MYWIDTH)];
    proDetailLabel.font = [UIFont systemFontOfSize:13];
    proDetailLabel.backgroundColor = UIColorFromRGB(0xFFFFFF);
    proDetailLabel.textColor = UIColorFromRGB(0x000000);
    proDetailLabel.textAlignment = NSTextAlignmentCenter;
    proDetailLabel.text = [NSString stringWithFormat:@"············· %@ ·············",@"商品详情"];
    [bgview addSubview:proDetailLabel];
    //
    if ([_model.note isEqualToString:@""]) {
        return;
    }
    //商品详情内容
    
    [bgview addSubview:webView];
    webView.backgroundColor = [UIColor whiteColor];
    bgview.frame = CGRectMake(0, UIScreenW/5*4, UIScreenW, proDetailLabel.bottom+webView.frame.size.height);

    _bgsView.contentSize = CGSizeMake(UIScreenW, UIScreenW/5*4 + bgview.height);
    

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth,oldheight;"
     "var maxwidth=300;"// 图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    CGFloat documentHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"webView的高度-----%f",documentHeight);
    if (documentHeight<20) {
        [proDetailLabel removeFromSuperview];
    }
    webView.frame = CGRectMake(0, proDetailLabel.bottom, UIScreenW, documentHeight+30);
    bgview.frame = CGRectMake(0, UIScreenW/5*4, UIScreenW, proDetailLabel.bottom+webView.frame.size.height+30);
    
    _bgsView.contentSize = CGSizeMake(UIScreenW, UIScreenW/5*4 + bgview.height);
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    NSLog(@"didFailLoadWithError===%@", error);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat frameHeight   = scrollView.frame.size.height;
    if(point.y < 0){
        [scrollView setContentOffset:CGPointMake(point.x, 0) animated:NO];
    }
    else if(contentHeight > frameHeight){
        if(contentHeight - point.y < frameHeight){
            [scrollView setContentOffset:CGPointMake(point.x, contentHeight - frameHeight) animated:NO];
        }
    }
    else if(contentHeight <= frameHeight){
        [scrollView setContentOffset:CGPointMake(point.x, 0) animated:NO];
    }
}
- (NSInteger)numOfItemstagView:(YJTagView *)tagView  {

    if (_colorview == tagView) {
        if ([_model.color componentsSeparatedByString:@","].count<2) {
            return 0;
        }
        return [_model.color componentsSeparatedByString:@","].count-1;
    }else if (_typeview == tagView){
        if ([_model.fitcar componentsSeparatedByString:@","].count<2) {
            return 0;
        }
        return [_model.fitcar componentsSeparatedByString:@","].count-1;
    }
    return 0;
}

- (NSString *)tagView:(YJTagView *)tagView titleForItemAtIndex:(NSInteger)index {
    if (_colorview == tagView) {
        return [_model.color componentsSeparatedByString:@","][index];
    }else if (_typeview == tagView){
        return [_model.fitcar componentsSeparatedByString:@","][index];
    }
    return nil;
}
- (void)tagView:(YJTagView *)tagView heightUpdated:(CGFloat)height{
    NSLog(@">>>>>>>???>>>>>%.2f",height);
    if (_colorview == tagView) {
        _colorviewheight = height;
        [self createUI];

    }else if (_typeview == tagView){
        _typeviewheight = height;
        [self createUI];

    }
}

- (void)tagView:(YJTagView *)tagView didSelectedItemAtIndex:(NSInteger)index {
    if (_colorview == tagView) {
        _colorNum = [_model.color componentsSeparatedByString:@","][index];
    }else if (_typeview == tagView){
        _typeNum = [_model.fitcar componentsSeparatedByString:@","][index];
    }
}

-(void)shopCarButClicked{
    [Command isloginRequest:^(bool str) {
        if (str) {
            if ([_model.color componentsSeparatedByString:@","].count>1) {
                NSLog(@">>>%@",_colorNum);
                if ([[Command convertNull:_colorNum] isEqualToString:@""]) {
                    jxt_showToastTitle(@"请选择颜色类型", 1);
                    return ;
                }
            }
            if ([_model.fitcar componentsSeparatedByString:@","].count>1) {
                if ([[Command convertNull:_typeNum] isEqualToString:@""]) {
                    jxt_showToastTitle(@"请选择适合车型", 1);
                    return ;
                }
            }
            
            NSString *URLStr = @"/mbtwz/shoppingcart?action=addShoppingCart";
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"color\":\"%@\",\"fitcar\":\"%@\",\"count\":\"%@\",\"type\":\"%@\"}",_id,_model.proname,[Command convertNull:_colorNum],[Command convertNull:_typeNum],_countNum,_type]};
            NSLog(@"%@",params);
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
                
                NSString* str = [[NSString alloc]initWithData:responseObject encoding:kCFStringEncodingUTF8];
                
                NSLog(@"购物车%@",str);
                if ([str rangeOfString:@"false"].location!=NSNotFound) {
                    jxt_showToastTitle(@"加入购物车失败", 1);
                }else{
                    jxt_showToastTitle(@"加入购物车成功", 2);
                }
                
            }];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
}
//立即购买
- (void)ShopOrderClick{
    [Command isloginRequest:^(bool str) {
        if (str) {
            //使用积分支付 判断积分
            if ([_type isEqualToString:@"2"]) {
                NSString *URLStr = @"/mbtwz/scshop?action=getCustScores";
                [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
                    NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"积分>>>>%@",arr);
                    if (arr.count) {
                        if ([[arr[0] objectForKey:@"scores"] floatValue]<[_model.price floatValue]*[_countNum intValue]) {
                            jxt_showToastTitle(@"剩余积分不足", 1);
                        }else{
                            [self shoporderWithToUUIDJiFen];
                        }
                        
                    }
                    
                    
                }];
            }else{//走正常支付 生成订单
                [self shoporderWithToUUIDJiFen];
            }
            
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
    
}
//走正常支付 生成订单
- (void)shoporderWithToUUIDJiFen{
    if ([_model.color componentsSeparatedByString:@","].count>1) {
        NSLog(@">>>%@",_colorNum);
        if ([[Command convertNull:_colorNum] isEqualToString:@""]) {
            jxt_showToastTitle(@"请选择颜色类型", 1);
            return ;
        }
    }
    if ([_model.fitcar componentsSeparatedByString:@","].count>1) {
        if ([[Command convertNull:_typeNum] isEqualToString:@""]) {
            jxt_showToastTitle(@"请选择适合车型", 1);
            return ;
        }
    }
    NSString *URLStr = @"/mbtwz/scshop?action=insertProOrder_0";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\",\"proname\":\"%@\",\"color\":\"%@\",\"specification\":\"%@\",\"totalcount\":\"%@\",\"type\":\"%@\"}",_id,_model.proname,[Command convertNull:_colorNum],[Command convertNull:_typeNum],_countNum,_type]};
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSString *str0 = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"UUID：%@",str0);
        NSString *str1 = [str0 substringFromIndex:1];
        
        NSString *str2 = [str1 substringToIndex:str1.length-1];
        if ([str2 rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"购买操作失败", 1);
        }else{
            ShopOrderViewController *shoporder = [[ShopOrderViewController alloc]init];
            shoporder.uuid = str2;
            shoporder.type = _type;
            [self.navigationController pushViewController:shoporder animated:YES];
        }
        
    }];
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == self.cycleScrollView) {
        NSLog(@"---点击了专题第%ld张图片", (long)index);
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
