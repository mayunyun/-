//
//  MyYeEViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyYeEViewController.h"
#import "MingXiViewController.h"
#import "ChongZhiViewController.h"
#import "TiXianViewController.h"
#import "MeModel.h"
#import "MyPurseTableViewCell.h"

@interface MyYeEViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_headview;
    UILabel *_headtitle;
    MeModel *_model;
}
@property(nonatomic,strong)UITableView *tableview;


@end

@implementation MyYeEViewController
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight)];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_tableview registerClass:[MyPurseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyPurseTableViewCell class])];

        [self.view addSubview:_tableview];
        
        
        UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200*MYWIDTH)];
        bgimage.image = [UIImage imageNamed:@"钱包背景"];
        
        UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 175*MYWIDTH, bgimage.height/4, 150*MYWIDTH, 25*MYWIDTH)];
        title.text = @"账户余额";
        title.textAlignment = NSTextAlignmentRight;
        title.textColor = UIColorFromRGB(0x333333);
        title.font = [UIFont systemFontOfSize:15];
        [bgimage addSubview:title];
        
        _headtitle  = [[UILabel alloc]initWithFrame:CGRectMake(25*MYWIDTH, bgimage.height/2, kScreenWidth-50*MYWIDTH, 40)];
        _headtitle.textAlignment = NSTextAlignmentRight;
        _headtitle.textColor = UIColorFromRGB(0x333333);
        _headtitle.font = [UIFont systemFontOfSize:30];
        [bgimage addSubview:_headtitle];
        
        UIImageView *headviewBG = [[UIImageView alloc]initWithFrame:CGRectMake(25*MYWIDTH, bgimage.height/2-55*MYWIDTH, 110*MYWIDTH, 110*MYWIDTH)];
        headviewBG.image = [UIImage imageNamed:@"默认头像BG"];
        headviewBG.layer.masksToBounds = YES;
        headviewBG.layer.cornerRadius = headviewBG.width/2;
        [bgimage addSubview:headviewBG];
        
        _headview = [[UIImageView alloc]initWithFrame:CGRectMake(12*MYWIDTH, 12*MYWIDTH, 86*MYWIDTH, 86*MYWIDTH)];
        _headview.image = [UIImage imageNamed:@"默认头像"];
        _headview.layer.masksToBounds = YES;
        _headview.layer.cornerRadius = _headview.width/2;
        [headviewBG addSubview:_headview];
        
        _tableview.tableHeaderView = bgimage;
        
    }
    return _tableview;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadNew];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"余额";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    [self creatUI];
    //[self tableview];
}
- (void)creatUI{
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, UIScreenH)];
    if (statusbarHeight>20) {
        bgview.frame = CGRectMake(0, 88, kScreenWidth, UIScreenH);
    }
    bgview.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [self.view addSubview:bgview];
    
    UIImageView* bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15*MYWIDTH, kScreenWidth, 250*MYWIDTH)];
    bgimage.image = [UIImage imageNamed:@"余额卡片"];
    bgimage.userInteractionEnabled = YES;
    [bgview addSubview:bgimage];
    
    UIImageView *headviewBG = [[UIImageView alloc]initWithFrame:CGRectMake(25*MYWIDTH, bgimage.height/2-60*MYWIDTH, 90*MYWIDTH, 90*MYWIDTH)];
    headviewBG.image = [UIImage imageNamed:@"默认头像BG"];
    headviewBG.layer.masksToBounds = YES;
    headviewBG.layer.cornerRadius = headviewBG.width/2;
    [bgimage addSubview:headviewBG];
    
    _headview = [[UIImageView alloc]initWithFrame:CGRectMake(12*MYWIDTH, 12*MYWIDTH, 66*MYWIDTH, 66*MYWIDTH)];
    _headview.image = [UIImage imageNamed:@"默认头像"];
    _headview.layer.masksToBounds = YES;
    _headview.layer.cornerRadius = _headview.width/2;
    [headviewBG addSubview:_headview];
    
    UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(headviewBG.right+10*MYWIDTH, headviewBG.top+10*MYWIDTH, 150*MYWIDTH, 25*MYWIDTH)];
    title.text = @"账户余额";
    title.textAlignment = NSTextAlignmentLeft;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    [bgimage addSubview:title];
    
    _headtitle  = [[UILabel alloc]initWithFrame:CGRectMake(headviewBG.right+10*MYWIDTH, title.bottom+5*MYWIDTH, kScreenWidth-50*MYWIDTH, 40)];
    _headtitle.textAlignment = NSTextAlignmentLeft;
    _headtitle.textColor = [UIColor whiteColor];
    _headtitle.font = [UIFont systemFontOfSize:18];
    [bgimage addSubview:_headtitle];
    
    UIButton *mingxiBut = [[UIButton alloc]initWithFrame:CGRectMake(bgimage.width/3*2, bgimage.height-90*MYWIDTH, bgimage.width/3, 50*MYWIDTH)];
    [mingxiBut setTitle:@"明细" forState:UIControlStateNormal];
    [mingxiBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mingxiBut.titleLabel.font = [UIFont systemFontOfSize:18];
    [mingxiBut addTarget:self action:@selector(mingxiClick) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:mingxiBut];
    
    UIButton *chongzhiBut = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH, bgimage.bottom+80*MYWIDTH, UIScreenW-30*MYWIDTH, 45*MYWIDTH)];
    [chongzhiBut setTitle:@"充值" forState:UIControlStateNormal];
    [chongzhiBut setBackgroundColor:UIColorFromRGB(0xff4b52)];
    chongzhiBut.layer.cornerRadius = 22*MYWIDTH;
    [chongzhiBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongzhiBut.titleLabel.font = [UIFont systemFontOfSize:18];
    [chongzhiBut addTarget:self action:@selector(chongzhiButClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:chongzhiBut];
    
    
    UIButton *tixianBut = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH, chongzhiBut.bottom+20*MYWIDTH, UIScreenW-30*MYWIDTH, 45*MYWIDTH)];
    [tixianBut setTitle:@"提现" forState:UIControlStateNormal];
    [tixianBut setBackgroundColor:[UIColor clearColor]];
    tixianBut.layer.cornerRadius = 22*MYWIDTH;
    tixianBut.layer.borderWidth = 1.0f;
    tixianBut.layer.borderColor = UIColorFromRGBValueValue(0x333333).CGColor;//设置边框颜色
    [tixianBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    tixianBut.titleLabel.font = [UIFont systemFontOfSize:18];
    [tixianBut addTarget:self action:@selector(tixianButClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:tixianBut];
}
- (void)mingxiClick{
    MingXiViewController *MXVC = [[MingXiViewController alloc]init];
    [self.navigationController pushViewController:MXVC animated:YES];
}
- (void)chongzhiButClick{
    ChongZhiViewController *chongzhi = [[ChongZhiViewController alloc]init];
    [self.navigationController pushViewController:chongzhi animated:YES];
}
- (void)tixianButClick{
    TiXianViewController *tixian = [[TiXianViewController alloc]init];
    tixian.id = [NSString stringWithFormat:@"%@",_model.id];
    [self.navigationController pushViewController:tixian animated:YES];
}
#pragma 在这里面请求数据
- (void)loadNew
{
    
    NSString *XWURLStr = @"/mbtwz/personal?action=getPersonalInfo";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:nil FinishedLogin:^(id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的信息%@",array);
        //建立模型
        if (array.count) {
            _model =[[MeModel alloc]init];
            [_model setValuesForKeysWithDictionary:array[0]];
            //追加数据
            if ([[NSString stringWithFormat:@"￥%@",_model.balance] isEqualToString:@"(null)"]) {
                _headtitle.text = @"￥0";
            }else{
                _headtitle.text = [NSString stringWithFormat:@"￥%.2f",[_model.balance floatValue]];
            }
            if (![[NSString stringWithFormat:@"%@",_model.autoname] isEqualToString:@"(null)"]) {
                NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,_model.folder,_model.autoname];
                NSLog(@"%@",image);
                [_headview sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            }
        }
        [_tableview reloadData];
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [MyPurseTableViewCell class];
    MyPurseTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *data = @[@"充值",@"提现",@"明细"];
    [cell setdata:data[indexPath.row] image:data[indexPath.row] push:nil];
//    if (indexPath.row == 0) {
//        cell.otherView.text = @"";
//    }else if (indexPath.row == 1){
//        cell.otherView.text = @"";
//    }else if (indexPath.row == 2){
//        cell.otherView.text = @"";
//    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 2) {
        MingXiViewController *MXVC = [[MingXiViewController alloc]init];
        [self.navigationController pushViewController:MXVC animated:YES];
    }else if (indexPath.row == 0) {
        ChongZhiViewController *chongzhi = [[ChongZhiViewController alloc]init];
        [self.navigationController pushViewController:chongzhi animated:YES];
//        jxt_showAlertOneButton(@"提示", @"正在开发中",@"确定" , ^(NSInteger buttonIndex) {
//
//        });
    }else if (indexPath.row == 1){
        TiXianViewController *tixian = [[TiXianViewController alloc]init];
        tixian.id = [NSString stringWithFormat:@"%@",_model.id];
        [self.navigationController pushViewController:tixian animated:YES];
    }
    NSLog(@"%ld",indexPath.row);
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
