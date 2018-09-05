//
//  ChongYongViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/6/13.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ChongYongViewController.h"
#import "ChangYongTableViewCell.h"
@interface ChongYongViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation ChongYongViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, UIScreenH-64)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88);
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{
    
    [self loadNew];
    [_tableview.mj_header endRefreshing];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.pushtype isEqualToString:@"2"]) {
        self.navigationItem.title = @"管理常用发货地址";
    }else if ([self.pushtype isEqualToString:@"3"]){
        self.navigationItem.title = @"管理常用收货地址";
    }
    else if ([self.pushtype isEqualToString:@"1"]){
        self.navigationItem.title = @"管理常用收货人";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    _dataArr = [[NSMutableArray alloc]init];
    [self tableview];
    [self loadNew];
}

#pragma 刷新(在这里面发送请求，刷新数据)
- (void)loadNew
{
    
    [self.dataArr removeAllObjects];
    NSString *url = @"/mbtwz/logisticssendwz?action=selectUserRelevantList";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@">>%@",[dic objectForKey:@"response"][0]);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            if ([self.pushtype isEqualToString:@"2"]) {
                _dataArr = [[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"saddlist"] ];
            }else if ([self.pushtype isEqualToString:@"3"]){
                _dataArr = [[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"eaddlist"] ];
            }
            else if ([self.pushtype isEqualToString:@"1"]){
                _dataArr = [[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"custinfo"] ];
            }
            
        }else{
            jxt_showToastTitle([NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]], 1);
        }
        [_tableview reloadData];
    }];
   
    
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * stringCell = @"ChangYongTableViewCell";
    ChangYongTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.pushtype isEqualToString:@"2"]) {
        cell.titleLab.text = [NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"saddress"]];
        cell.photoLab.text = @"";
        if ([[_dataArr[indexPath.row] objectForKey:@"isdefault"] intValue]==1) {
            [cell.moren setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
            [cell.moren setTitle:@"默认地址" forState:UIControlStateNormal];
            [cell.moren setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [cell.moren setImage:[UIImage imageNamed:@"shehzimoren"] forState:UIControlStateNormal];
            [cell.moren setTitle:@"设为默认" forState:UIControlStateNormal];
            [cell.moren setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        }
    }else if ([self.pushtype isEqualToString:@"3"]){
        cell.titleLab.text = [NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"eaddress"]];
        cell.photoLab.text = @"";
        if ([[_dataArr[indexPath.row] objectForKey:@"isdefault"] intValue]==1) {
            [cell.moren setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
            [cell.moren setTitle:@"默认地址" forState:UIControlStateNormal];
            [cell.moren setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [cell.moren setImage:[UIImage imageNamed:@"shehzimoren"] forState:UIControlStateNormal];
            [cell.moren setTitle:@"设为默认" forState:UIControlStateNormal];
            [cell.moren setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        }
    }
    else if ([self.pushtype isEqualToString:@"1"]){
        cell.titleLab.text = [NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"name"]];
        cell.photoLab.text = [NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"call"]];
        if ([[_dataArr[indexPath.row] objectForKey:@"isdefault"] intValue]==1) {
            [cell.moren setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
            [cell.moren setTitle:@"默认收货人" forState:UIControlStateNormal];
            [cell.moren setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [cell.moren setImage:[UIImage imageNamed:@"shehzimoren"] forState:UIControlStateNormal];
            [cell.moren setTitle:@"设为默认收货人" forState:UIControlStateNormal];
            [cell.moren setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        }
    }
    [cell.moren addTarget:self action:@selector(morenclick:) forControlEvents:UIControlEventTouchUpInside];
    cell.moren.tag = indexPath.row;
    
    [cell.deleteBut addTarget:self action:@selector(deleteclick:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBut.tag = indexPath.row+1000;
    
    return cell;
}
- (void)morenclick:(UIButton *)but{
    NSString *idstr = [NSString stringWithFormat:@"%@",[_dataArr[but.tag] objectForKey:@"id"]];
    NSString *url = @"/mbtwz/logisticssendwz?action=setUserRelevantDef";
    NSDictionary * dic =@{@"relevant_type":self.pushtype,@"selectid":idstr};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@">>%@",dic );
        [self loadNew];
    }];
}
- (void)deleteclick:(UIButton *)but{
    NSString *strtitle;
    if ([self.pushtype isEqualToString:@"1"]) {
        strtitle = @"确定要删除该收货人吗？";
    }else{
        strtitle = @"确定要删除该地址吗？";
    }

    jxt_showAlertTwoButton(@"提示", strtitle, @"取消", ^(NSInteger buttonIndex) {
    
    }, @"确定", ^(NSInteger buttonIndex) {
        NSString *idstr = [NSString stringWithFormat:@"%@",[_dataArr[but.tag-1000] objectForKey:@"id"]];
        NSString *url = @"/mbtwz/logisticssendwz?action=deleteUserRelevant";
        NSDictionary * dic =@{@"relevant_type":self.pushtype,@"selectid":idstr};
        NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@">>%@",dic );
            [self loadNew];
        }];
    });

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.pushtype isEqualToString:@"2"]) {
        CLLocationCoordinate2D locationStr = CLLocationCoordinate2DMake([[_dataArr[indexPath.row] objectForKey:@"slatitude"] floatValue], [[_dataArr[indexPath.row] objectForKey:@"slongitude"] floatValue]);
        
        if (_morenqiBlock) {
            _morenqiBlock([NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"saddress"]],locationStr,[NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"sprovince"]],[NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"scity"]],[NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"scounty"]]);
        }
    }else if ([self.pushtype isEqualToString:@"3"]){
        CLLocationCoordinate2D locationStr = CLLocationCoordinate2DMake([[_dataArr[indexPath.row] objectForKey:@"elatitude"] floatValue], [[_dataArr[indexPath.row] objectForKey:@"elongitude"] floatValue]);
        if (_morenzhongBlock) {
            _morenzhongBlock([NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"eaddress"]],locationStr,[NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"eprovince"]],[NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"ecity"]],[NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"ecounty"]]);
        }
    }
    else if ([self.pushtype isEqualToString:@"1"]){
        if (_morenshouhuorenBlock) {
            _morenshouhuorenBlock([NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[_dataArr[indexPath.row] objectForKey:@"call"]]);
        }
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];

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
