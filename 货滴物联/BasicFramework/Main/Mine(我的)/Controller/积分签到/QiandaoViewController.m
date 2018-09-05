//
//  QiandaoViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/7/25.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "QiandaoViewController.h"
#import "LXCalender.h"
@interface QiandaoViewController ()
@property(nonatomic,strong)LXCalendarView *calenderView;

@end


@implementation QiandaoViewController
{
    UILabel *headtitle;
    UILabel *continuitySigninLab;
    UIButton *buttonon;
    UILabel *setSigninDayLab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =UIColorFromRGB(0xF8F8F8);
    
    self.title = @"积分签到";
    [self setScoresUIView];

    [self loadNew];
}
#pragma 在这里面请求数据
- (void)loadNew
{
    
    
    NSString *XWURLStr = @"/mbtwz/signinintegral?action=selectSigninIndex";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:nil FinishedLogin:^(id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            NSString * _userScores = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"response"][0] objectForKey:@"userScores"]];
            NSString * _setSigninDay = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"response"][0] objectForKey:@"setSigninDay"]];
            NSString * _signinFlag = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"response"][0] objectForKey:@"signinFlag"]];
            NSString * _continuitySignin = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"response"][0] objectForKey:@"continuitySignin"]];
            NSLog(@"%@",[dic objectForKey:@"response"][0]);
            
            if ([[NSString stringWithFormat:@"%@",_userScores] isEqualToString:@"(null)"]) {
                headtitle.text = @"0";
            }else if ([_userScores floatValue]==[_userScores intValue]){
                headtitle.text = [NSString stringWithFormat:@"%d",[_userScores intValue]];
            }else{
                headtitle.text = [NSString stringWithFormat:@"%.2f",[_userScores floatValue]];
            }

            continuitySigninLab.text = [NSString stringWithFormat:@"☆已连续签到%@天",_continuitySignin];
            [self changeTextfont:continuitySigninLab Txt:continuitySigninLab.text changeTxt:_continuitySignin];
            
            if ([_signinFlag intValue]==1) {
                buttonon.backgroundColor = UIColorFromRGB(0xCACACA);
                [buttonon setTitle:@"已 签 到" forState:UIControlStateNormal];
                buttonon.userInteractionEnabled = NO;
            }else{
                buttonon.userInteractionEnabled = YES;
                [buttonon setTitle:@"立 即 签 到" forState:UIControlStateNormal];
            }
            
            setSigninDayLab.text = [NSString stringWithFormat:@"签到送积分，连续签到%@天送豪礼",_setSigninDay];
            [Command changeTextfont:setSigninDayLab Txt:setSigninDayLab.text changeTxt:_setSigninDay];
        }
        
    }];
}

- (void)setScoresUIView{
    
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavBarHeight, UIScreenW, 180*MYWIDTH)];
    bgimage.userInteractionEnabled = YES;
    bgimage.image = [UIImage imageNamed:@"积分页"];
    
    [self.view addSubview:bgimage];
    UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(25*MYWIDTH, 20*MYWIDTH, 150*MYWIDTH, 25*MYWIDTH)];
    title.text = @"当前积分:";
    title.textAlignment = NSTextAlignmentLeft;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:15];
    [bgimage addSubview:title];
    
    headtitle  = [[UILabel alloc]initWithFrame:CGRectMake(25*MYWIDTH, title.bottom, UIScreenW-50*MYWIDTH, 40*MYWIDTH)];
    headtitle.textAlignment = NSTextAlignmentCenter;
    headtitle.textColor = [UIColor redColor];
    headtitle.font = [UIFont boldSystemFontOfSize:32];
    [bgimage addSubview:headtitle];
    
    continuitySigninLab = [[UILabel alloc]initWithFrame:CGRectMake(0, headtitle.bottom+15*MYWIDTH, UIScreenW, 20*MYWIDTH)];
    
    continuitySigninLab.textAlignment = NSTextAlignmentCenter;
    continuitySigninLab.textColor = UIColorFromRGB(0x333333);
    continuitySigninLab.font = [UIFont systemFontOfSize:13];
    [bgimage addSubview:continuitySigninLab];
    
    buttonon = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/2-100*MYWIDTH, continuitySigninLab.bottom + 5*MYWIDTH, 200*MYWIDTH, 35*MYWIDTH)];
    [buttonon setTitle:@"立 即 签 到" forState:UIControlStateNormal];
    buttonon.backgroundColor = [UIColor redColor];
    buttonon.titleLabel.font = [UIFont systemFontOfSize:12];
    buttonon.layer.cornerRadius = 8;
    [buttonon addTarget:self action:@selector(addSignin:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:buttonon];
   
    UILabel *mingxi = [[UILabel alloc]initWithFrame:CGRectMake(0, bgimage.bottom, UIScreenW, 8*MYWIDTH)];
    //mingxi.text = @"  明细";
    mingxi.font = [UIFont systemFontOfSize:13];
    mingxi.backgroundColor = [UIColor whiteColor];
    mingxi.textColor = UIColorFromRGB(0x333333);
    [self.view addSubview:mingxi];
    
    
    self.calenderView =[[LXCalendarView alloc]initWithFrame:CGRectMake(20, mingxi.bottom, UIScreenW - 40, 0)];
    
    self.calenderView.currentMonthTitleColor =UIColorFromRGB(0xFFFFFF);
    self.calenderView.lastMonthTitleColor =UIColorFromRGB(0xFFFFFF);
    self.calenderView.nextMonthTitleColor =UIColorFromRGB(0xFFFFFF);

    self.calenderView.isCanScroll = YES;
    self.calenderView.isShowLastAndNextBtn = YES;
    
    self.calenderView.isShowLastAndNextDate = YES;
    
    self.calenderView.todayTitleColor =[UIColor cyanColor];
    
    self.calenderView.selectBackColor =[UIColor greenColor];
    
    [self.calenderView dealData];
    
    self.calenderView.backgroundColor =UIColorFromRGB(0xF8F8F8);
    [self.view addSubview:self.calenderView];
    
    self.calenderView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%ld年 - %ld月 - %ld日",year,month,day);
        
    };
    
    setSigninDayLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.calenderView.bottom+15*MYWIDTH, UIScreenW, 20*MYWIDTH)];
    
    setSigninDayLab.textAlignment = NSTextAlignmentCenter;
    setSigninDayLab.textColor = UIColorFromRGB(0x333333);
    setSigninDayLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:setSigninDayLab];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(52*MYWIDTH, setSigninDayLab.top-2.5*MYWIDTH, 25*MYWIDTH, 25*MYWIDTH)];
    image.image = [UIImage imageNamed:@"img_jifenqiandao44"];
    [self.view addSubview:image];
    
}
- (void)addSignin:(UIButton *)button{
    
    NSString *XWURLStr = @"/mbtwz/signinintegral?action=addSignin";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:nil FinishedLogin:^(id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            [self.calenderView dealData];
            button.backgroundColor = UIColorFromRGB(0xCACACA);
            button.userInteractionEnabled = NO;
            [buttonon setTitle:@"已 签 到" forState:UIControlStateNormal];

            [self loadNew];

        }else{
            button.backgroundColor = [UIColor redColor];
            button.userInteractionEnabled = YES;
            [buttonon setTitle:@"立 即 签 到" forState:UIControlStateNormal];

        }
        
    }];
}
- (void)changeTextfont:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(location, length)];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];

        [str1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(location, length)];
        
        //赋值
        label.attributedText = str1;
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
