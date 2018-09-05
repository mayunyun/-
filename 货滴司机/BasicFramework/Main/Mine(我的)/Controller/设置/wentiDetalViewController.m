//
//  wentiDetalViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/6/26.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "wentiDetalViewController.h"

@interface wentiDetalViewController ()

@end

@implementation wentiDetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"常见问题";
    
    [self creatUI];
    
    UIButton *tuichu = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-60*MYWIDTH, kScreenWidth, 60*MYWIDTH)];
    [tuichu setTitle:@"电话客服" forState:UIControlStateNormal];
    [tuichu setTitleColor:UIColorFromRGBValueValue(0xffffff) forState:UIControlStateNormal];
    [tuichu setBackgroundColor:[UIColor redColor]];
    [tuichu addTarget:self action:@selector(tuichuClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tuichu];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(UIScreenW/2-90*MYWIDTH, tuichu.top-50*MYWIDTH, 80*MYWIDTH, 40*MYWIDTH);
    [leftBtn setImage:[UIImage imageNamed:@"youyonghong"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [leftBtn setTitle:@"有用" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(UIScreenW/2+10*MYWIDTH, tuichu.top-50*MYWIDTH, 80*MYWIDTH, 40*MYWIDTH);
    [rightBtn setImage:[UIImage imageNamed:@"wuyonghui"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [rightBtn setTitle:@"无用" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
}
- (void)leftBtnAll{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:[self.dic objectForKey:@"id"] forKey:@"id"];
    [param setValue:@"0" forKey:@"flag"];
    NSDictionary* params = @{@"data":[Command dictionaryToJson:param]};
    
    NSString *url = @"/mbtwz/comprob?action=updateCommProblemsUse";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:params FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            jxt_showToastTitle(@"操作成功", 1);
        }
       
        
    }];
}
- (void)rightBtnAll{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:[self.dic objectForKey:@"id"] forKey:@"id"];
    [param setValue:@"1" forKey:@"flag"];
    NSDictionary* params = @{@"data":[Command dictionaryToJson:param]};
    
    NSString *url = @"/mbtwz/comprob?action=updateCommProblemsUse";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:params FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            jxt_showToastTitle(@"操作成功", 1);
        }
        
        
    }];
}
- (void)tuichuClick{
    NSString *phone = [NSString stringWithFormat:@"拨打客服电话：%@",@"0531-88807916"];
    jxt_showAlertTwoButton(@"提示", phone, @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"0531-88807916"]]];
    });
}
- (void)creatUI{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, statusbarHeight+44, UIScreenW, UIScreenH-statusbarHeight-44)];
    bgview.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [self.view addSubview:bgview];
    
    UIView *bgview1 = [[UIView alloc]initWithFrame:CGRectMake(10*MYWIDTH, 20*MYWIDTH, UIScreenW-20*MYWIDTH, 200*MYWIDTH)];
    bgview1.backgroundColor = [UIColor whiteColor];
    bgview1.layer.cornerRadius = 10;
    [bgview addSubview:bgview1];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 6*MYWIDTH, bgview1.width-30*MYWIDTH, 20*MYWIDTH)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor blackColor];
    title.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"problem"]];
    [bgview1 addSubview:title];
    
    UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, title.bottom+4*MYWIDTH, bgview1.width, 1*MYWIDTH)];
    xian.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [bgview1 addSubview:xian];
    
    UITextView *other = [[UITextView alloc]initWithFrame:CGRectMake(15*MYWIDTH, title.bottom + 14*MYWIDTH, bgview1.width-30*MYWIDTH, bgview1.height-title.bottom - 14*MYWIDTH)];
    other.font = [UIFont systemFontOfSize:13];
    other.textColor = UIColorFromRGB(0x333333);
    other.userInteractionEnabled = NO;
    
    other.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"describe"]];
    [bgview1 addSubview:other];
    
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
