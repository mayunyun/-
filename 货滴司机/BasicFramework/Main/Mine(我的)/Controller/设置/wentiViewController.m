//
//  wentiViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/6/26.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "wentiViewController.h"
#import "wentiTableViewCell.h"
#import "wentiDetalViewController.h"
@interface wentiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation wentiViewController
- (UITableView *)tableview{
    if (_tableview == nil) {
        
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 8*MYWIDTH)];
        if (statusbarHeight>20) {
            bgview.frame = CGRectMake(0, 88, kScreenWidth, 8*MYWIDTH);
        }
        bgview.backgroundColor = UIColorFromRGBValueValue(0xefefef);
        [self.view addSubview:bgview];
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, bgview.bottom, kScreenWidth, kScreenHeight-68*MYWIDTH)];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGBValueValue(0xefefef);
        _tableview.scrollEnabled = NO;
        [self.view addSubview:_tableview];
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        _tableview.tableHeaderView = head;
        [_tableview registerNib:[UINib nibWithNibName:@"wentiTableViewCell" bundle:nil] forCellReuseIdentifier:@"wentiTableViewCell"];
        
    }
    return _tableview;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 25)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 25)];
    titleLab.text = @"常见问题";
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    _dataArray = [[NSMutableArray alloc]init];
    [self tableview];
    [self dataRequest];
    
    UIButton *tuichu = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-60*MYWIDTH, kScreenWidth, 60*MYWIDTH)];
    [tuichu setTitle:@"电话客服" forState:UIControlStateNormal];
    [tuichu setTitleColor:UIColorFromRGBValueValue(0xffffff) forState:UIControlStateNormal];
    [tuichu setBackgroundColor:[UIColor redColor]];
    [tuichu addTarget:self action:@selector(tuichuClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tuichu];
}
- (void)tuichuClick{
    NSString *phone = [NSString stringWithFormat:@"拨打客服电话：%@",@"0531-88807916"];
    jxt_showAlertTwoButton(@"提示", phone, @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"0531-88807916"]]];
    });
}
//查询接口
- (void)dataRequest{
    /*
     collect?action=searchCollection
     */
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:@"1" forKey:@"type"];
    
    NSDictionary* params = @{@"params":[Command dictionaryToJson:param]};
    
    NSString *url = @"/mbtwz/comprob?action=selectCommProblems";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:params FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        
        for (NSDictionary* dict in dic[@"response"]) {
            [_dataArray addObject:dict];
        }
        [_tableview reloadData];
        
    }];
    
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    wentiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"wentiTableViewCell"];
    if (!cell) {
        cell=[[wentiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wentiTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLab.text = [NSString stringWithFormat:@"%ld、%@",indexPath.row+1,_dataArray[indexPath.row][@"problem"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    wentiDetalViewController *detal = [[wentiDetalViewController alloc]init];
    detal.dic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:detal animated:YES];
    
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
