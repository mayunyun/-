//
//  ProvinceViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ProvinceViewController.h"
#import "CityViewController.h"
#import "DWTagView.h"

@interface ProvinceViewController ()<DWTagViewDelegate, DWTagViewDataSource>
{
    DWTagView *_typeview;
    CGFloat _typeviewheight;
    NSArray *arr;
}
@end

@implementation ProvinceViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;

}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    self.title = @"定位选择";
    NSString *URLStr = @"/mbtwz/address?action=loadProvince";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"设置省份地址%@",arr);
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
    UIScrollView *_bgsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, _typeviewheight+120*MYWIDTH)];
    _bgsView.contentSize = CGSizeMake(UIScreenW, _typeviewheight+350*MYWIDTH);
    _bgsView.showsVerticalScrollIndicator = NO;
    _bgsView.showsHorizontalScrollIndicator = YES;
    //_bgsView.bounces = NO;
    _bgsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgsView];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 15*MYWIDTH, UIScreenW-30*MYWIDTH, _bgsView.height-30*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10;
    [_bgsView addSubview:bgview];
    
    UIView *yuan = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 15*MYWIDTH, 8, 8)];
    yuan.backgroundColor = MYColor;
    yuan.layer.cornerRadius = 4;
    [bgview addSubview:yuan];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(yuan.right+5, yuan.top-4, 100, 16)];
    label.text = @"省份选择";
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:13];
    [bgview addSubview:label];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 30*MYWIDTH+8, bgview.width, 1)];
    xian.backgroundColor = UIColorFromRGB(MYLine);
    [bgview addSubview:xian];
    
    
    _typeview.frame = CGRectMake(30*MYWIDTH, xian.bottom+15*MYWIDTH, bgview.width-60*MYWIDTH, _typeviewheight);
    [bgview addSubview:_typeview];

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
    CityViewController *cityVC = [[CityViewController alloc]init];
    cityVC.provinceId = [NSString stringWithFormat:@"%@",[arr[index] objectForKey:@"areaid"]];
    cityVC.provin = [NSString stringWithFormat:@"%@",[arr[index] objectForKey:@"areaname"]];

    cityVC.oneStr = self.oneStr;
    [self.navigationController pushViewController:cityVC animated:YES];
}
- (void)backToLastViewController:(UIButton *)button{
    if ([self.oneStr isEqualToString:@"5"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
