//
//  WLAddNeedViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WLAddNeedViewController.h"
#import "WLAddNeedViewCell.h"
#import "WLAddNeedModel.h"

@interface WLAddNeedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation WLAddNeedViewController
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
    self.dataArr = [[NSMutableArray alloc]init];
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, NavBarHeight)];
    bgview.userInteractionEnabled = YES;
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, bgview.height-44, kScreenWidth, 44)];
    titleLab.text = @"添加额外需求";
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.userInteractionEnabled = YES;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = UIColorFromRGBValueValue(0x333333);
    [bgview addSubview:titleLab];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
    imageview.image = [UIImage imageNamed:@"关闭_1"];
    imageview.userInteractionEnabled = YES;
    [titleLab addSubview:imageview];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NavBarHeight, NavBarHeight)];
    [but addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:but];
    
    UIButton *Upbut = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-55*MYWIDTH, kScreenWidth, 55*MYWIDTH)];
    [Upbut setTitle:@"确认" forState:UIControlStateNormal];
    [Upbut setBackgroundColor:MYColor];
    [Upbut addTarget:self action:@selector(UpbutClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Upbut];
    
    [self tableview];
    [self loadNewData];
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight-NavBarHeight-55*MYWIDTH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
        [_tableview registerClass:[WLAddNeedViewCell class] forCellReuseIdentifier:NSStringFromClass([WLAddNeedViewCell class])];

        [self.view addSubview:_tableview];
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30*MYWIDTH)];
        UIView *baihead = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 20*MYWIDTH, kScreenWidth-30*MYWIDTH, 10*MYWIDTH)];
        baihead.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:baihead.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = baihead.bounds;
        maskLayer.path = maskPath.CGPath;
        baihead.layer.mask = maskLayer;
        [head addSubview:baihead];
        _tableview.tableHeaderView = head;
        
        UIView *baifoot = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, kScreenWidth-30*MYWIDTH, 10*MYWIDTH)];
        baifoot.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:baihead.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = baifoot.bounds;
        maskLayer1.path = maskPath1.CGPath;
        baifoot.layer.mask = maskLayer1;
        _tableview.tableFooterView = baifoot;
        
    }
    return _tableview;
    
}

- (void)loadNewData{
    //
    NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=searchCarServices";
    NSDictionary* paramsname = @{@"params":[NSString stringWithFormat:@"{\"type\":\"%@\"}",@"1"]};

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:paramsname FinishedLogin:^(id responseObject) {
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSLog(@">>%@",Arr);
        if (Arr.count) {
            //建立模型
            for (NSDictionary*dic in Arr ) {
                WLAddNeedModel *model=[[WLAddNeedModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                if ([[NSString stringWithFormat:@"%@",model.service_price] isEqualToString:@"0"]) {
                    model.need=@"1";
                }else{
                    model.need=@"0";
                }
                [self.dataArr addObject:model];
            }
            
            [_tableview reloadData];
        }
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0 || indexPath.row==_dataArr.count-1) {
        return 50*MYWIDTH;
    }
    return 60*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [WLAddNeedViewCell class];
    WLAddNeedViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count) {
        if (indexPath.row==_dataArr.count-1) {
        cell.xianView.hidden = YES;
        }else{
        cell.xianView.hidden = NO;
        }
        WLAddNeedModel *model = _dataArr[indexPath.row];
        [cell setdata:model othernumer:indexPath.row needArr:self.needArr];
    }
    
    
    return cell;
}


- (void)butClick{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)UpbutClick{
    NSMutableArray *needArr = [[NSMutableArray alloc]init];
    for (WLAddNeedModel *model in self.dataArr) {
        if ([model.need isEqualToString:@"1"]) {
            [needArr addObject:model];
        }
    }
    if (_needBlock) {
        _needBlock(needArr);
    }
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
