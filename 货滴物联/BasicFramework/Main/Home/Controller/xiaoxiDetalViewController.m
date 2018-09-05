//
//  xiaoxiDetalViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/6/26.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "xiaoxiDetalViewController.h"

@interface xiaoxiDetalViewController ()

@end

@implementation xiaoxiDetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";

    [self creatUI];
    [self dataRequest];
}
//态置为已读接口
- (void)dataRequest{
    /*
     /mbtwz/sendusermsg?action=searchUserMsgById
     */
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:self.model.id forKey:@"selid"];
    
    NSDictionary* params = @{@"params":[Command dictionaryToJson:param]};
    
    NSString *url = @"/mbtwz/sendusermsg?action=searchUserMsgById";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:params FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
    }];
    
    
}
- (void)creatUI{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, statusbarHeight+44, UIScreenW, UIScreenH-statusbarHeight-44)];
    bgview.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [self.view addSubview:bgview];
    
    UIView *bgview1 = [[UIView alloc]initWithFrame:CGRectMake(10*MYWIDTH, 20*MYWIDTH, UIScreenW-20*MYWIDTH, 200*MYWIDTH)];
    bgview1.backgroundColor = [UIColor whiteColor];
    bgview1.layer.cornerRadius = 10;
    [bgview addSubview:bgview1];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 10*MYWIDTH, bgview1.width-30*MYWIDTH, 20*MYWIDTH)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor blackColor];
    title.text = [NSString stringWithFormat:@"%@",self.model.title];
    [bgview1 addSubview:title];
    

    UITextView *other = [[UITextView alloc]initWithFrame:CGRectMake(15*MYWIDTH, title.bottom + 10*MYWIDTH, bgview1.width-30*MYWIDTH, bgview1.height-title.bottom - 40*MYWIDTH)];
    other.font = [UIFont systemFontOfSize:13];
    other.textColor = UIColorFromRGB(0x333333);
    other.userInteractionEnabled = NO;
    
    other.text = [NSString stringWithFormat:@"%@",self.model.content];
    [bgview1 addSubview:other];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(bgview1.width-150-15*MYWIDTH, other.bottom, 150, 20*MYWIDTH)];
    time.font = [UIFont systemFontOfSize:13];
    time.textColor = UIColorFromRGB(0x333333);
    time.textAlignment = NSTextAlignmentRight;
    time.text = [NSString stringWithFormat:@"%@",self.model.create_time];
    [bgview1 addSubview:time];
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
