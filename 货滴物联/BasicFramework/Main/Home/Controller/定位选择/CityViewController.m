//
//  CityViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CityViewController.h"
#import "DWTagView.h"

@interface CityViewController ()<DWTagViewDelegate, DWTagViewDataSource>
{
    DWTagView *_typeview;
    CGFloat _typeviewheight;
    NSArray *arr;
    NSString * _integer;
}
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);

    self.title = @"定位选择";
    _integer = @"";
    NSString *URLStr = @"/mbtwz/address?action=loadCity";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"provinceid\":\"%@\"}",_provinceId]};

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"城市地址%@",arr);
        if (arr.count) {
            _typeview = [[DWTagView alloc] init];
            _typeview.frame = CGRectMake(1, 1, UIScreenW-90*MYWIDTH, 0);
            _typeview.themeColor = MYColor;
            _typeview.backgroundColor = [UIColor whiteColor];
            _typeview.tagCornerRadius = 0;
            _typeview.dataSource = self;
            _typeview.delegate = self;
            [self.view addSubview:_typeview];
        }
        
    }];
}
- (void)creatUI{
    UIScrollView *_bgsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavBarHeight, UIScreenW, _typeviewheight+180*MYWIDTH)];
    _bgsView.contentSize = CGSizeMake(UIScreenW, _typeviewheight+180*MYWIDTH);
    _bgsView.showsVerticalScrollIndicator = NO;
    _bgsView.showsHorizontalScrollIndicator = YES;
    //_bgsView.bounces = NO;
    _bgsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgsView];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 15*MYWIDTH, UIScreenW-30*MYWIDTH, _bgsView.height-90*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10;
    [_bgsView addSubview:bgview];
    
    UIView *yuan = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 15*MYWIDTH, 8, 8)];
    yuan.backgroundColor = MYColor;
    yuan.layer.cornerRadius = 4;
    [bgview addSubview:yuan];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(yuan.right+5, yuan.top-4, 100, 16)];
    label.text = @"城市选择";
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:13];
    [bgview addSubview:label];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 30*MYWIDTH+8, bgview.width, 1)];
    xian.backgroundColor = UIColorFromRGB(MYLine);
    [bgview addSubview:xian];
    
    
    _typeview.frame = CGRectMake(30*MYWIDTH, xian.bottom+15*MYWIDTH, bgview.width-60*MYWIDTH, _typeviewheight);
    [bgview addSubview:_typeview];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(bgview.right-110*MYWIDTH, bgview.bottom+15*MYWIDTH, 110*MYWIDTH, 35*MYWIDTH)];
    button.backgroundColor = MYColor;
    button.layer.cornerRadius = 8;
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgsView addSubview:button];
}
- (NSInteger)DWnumOfItemstagView:(DWTagView *)tagView  {
    
    if (_typeview == tagView){
        return arr.count;
    }
    return 0;
}

- (NSString *)DWtagView:(DWTagView *)tagView titleForItemAtIndex:(NSInteger)index {
    if (_typeview == tagView){
        return [arr[index] objectForKey:@"areaname"];
    }
    return nil;
}
- (void)DWtagView:(DWTagView *)tagView heightUpdated:(CGFloat)height{
    NSLog(@">>>>>>>???>>>>>%.2f",height);
    if (_typeview == tagView){
        _typeviewheight = height;
        [self creatUI];
    }
}

- (void)DWtagView:(DWTagView *)tagView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@">>>>>>>???>>>>>%zd",index);
    //创建一个消息对象
    _integer = [NSString stringWithFormat:@"%zd",index];
    
}
- (void)butClick{
    if ([_integer isEqualToString:@""]) {
        jxt_showToastTitle(@"请选择城市", 1);
        return;
    }
    
    NSInteger intt = [_integer integerValue];

    if ([self.oneStr isEqualToString:@"1"]) {
        NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=searchCarType";
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"cityname\":\"%@\"}",[arr[intt] objectForKey:@"areaname"]]};
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:params FinishedLogin:^(id responseObject) {
            
            NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@">>%@",Arr);
            if (Arr.count) {
                
                NSNotification * notice = [NSNotification notificationWithName:@"cityone" object:nil userInfo:[arr[intt] objectForKey:@"areaname"]];
                //                发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
            }else{
                jxt_showAlertOneButton(@"提示", @"暂无数据", @"确定", ^(NSInteger buttonIndex) {
                    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
                });
            }
            
            
        }];
    }else{
        NSNotification * notice = [NSNotification notificationWithName:@"city" object:nil userInfo:[arr[intt] objectForKey:@"areaname"]];
        //                发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[arr[intt] objectForKey:@"areaname"]] forKey:CITY];
        [[NSUserDefaults standardUserDefaults]setObject:self.provin forKey:PROVINCE];

        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    }

    
}

@end
