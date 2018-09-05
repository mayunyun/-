//
//  CarBrandViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/9/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarBrandViewController.h"
#import "CarBrandTableViewCell.h"
#import "CarBrandModel.h"
#import "CarDetailViewController.h"
@interface CarBrandViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITextField *_textfield;
    NSInteger _page;

}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation CarBrandViewController

- (UITableView *)tableview{
    if (_tableview == nil) {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, 43.5*MYWIDTH)];
        if (statusbarHeight>20) {
            header.frame = CGRectMake(0, 88, kScreenWidth, 43.5*MYWIDTH);
        }
        [self.view addSubview:header];
        
        _textfield = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-75, 43.5*MYWIDTH)];//- 50
        _textfield.delegate = self;
        _textfield.backgroundColor = [UIColor clearColor];
        _textfield.placeholder = @"请输入汽车类型";
        _textfield.textColor = UIColorFromRGB(0x333333);
        _textfield.font = [UIFont systemFontOfSize:14];
        _textfield.textAlignment = NSTextAlignmentLeft;
        [Command placeholderColor:_textfield str:_textfield.placeholder color:UIColorFromRGB(0x555555)];
        [header addSubview:_textfield];
        
        UIButton *chaxun = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-43.5*MYWIDTH, 0, 43.5*MYWIDTH, 43.5*MYWIDTH)];
        [chaxun setImage:[UIImage imageNamed:@"查询"] forState:UIControlStateNormal];
        [chaxun addTarget:self action:@selector(chaxunClick) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:chaxun];
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 43.5*MYWIDTH+NavBarHeight, kScreenWidth, kScreenHeight-43.5*MYWIDTH-NavBarHeight)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 43.5*MYWIDTH+88, kScreenWidth, kScreenHeight-43.5*MYWIDTH-88);
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_tableview];
        
        [_tableview registerClass:[CarBrandTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CarBrandTableViewCell class])];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addNemData)];
        
    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{
    _page = 1;
    [_dataArr removeAllObjects];
    [self loadNew];
    [_tableview.mj_header endRefreshing];
    
}
- (void)addNemData{
    _page++;
    [self loadNew];
    [_tableview.mj_footer endRefreshing];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.brandStr;
    _dataArr = [[NSMutableArray alloc]init];
    _page = 1;
    [self loadNew];
    [self tableview];
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
}
- (void)loadNew{
    NSString *URLStr = @"/mbtwz/CarHome?action=getCarSeries";
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_idStr]};
    NSLog(@"%@",params);

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"系列列表%@",resultDic);
        
        if (responseObject) {
            for (NSDictionary* dict in [resultDic objectForKey:@"rows"]) {
                CarBrandModel* model = [[CarBrandModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArr addObject:model];
            }
            
        }
        if (self.dataArr.count>0) {
//            [self.tableview dismissNoView];
            [self.tableview reloadData];
            
        }else{
            [self.tableview reloadData];
//            [self.tableview showNoView:nil image:nil certer:CGPointZero];
        }

    }];
}
//汽车系列搜索
- (void)chaxunClick{
    NSString *URLStr = @"/mbtwz/CarHome?action=getCarSeries";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\",\"groupname\":\"%@\"}",_idStr,_textfield.text]};
    [_dataArr removeAllObjects];
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        
        NSArray* Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"搜索系列列表%@",Arr);
        
        if (!IsEmptyValue(Arr)) {
            for (NSDictionary* dict in Arr) {
                CarBrandModel* model = [[CarBrandModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArr addObject:model];
            }
        }else{
            jxt_showToastTitle(@"暂无搜索结果", 1);
        }
        [self.tableview reloadData];
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self chaxunClick];

    return [textField resignFirstResponder];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*MYWIDTH;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class CarBrandClass = [CarBrandTableViewCell class];
    CarBrandTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CarBrandClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    CarBrandModel *model;
    if (_dataArr.count) {
        model = [self.dataArr objectAtIndex:indexPath.row];
    }
    cell.data = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CarDetailViewController* vc = [[CarDetailViewController alloc]init];
    CarBrandModel *model;
    if (_dataArr.count) {
        model = [self.dataArr objectAtIndex:indexPath.row];
        vc.idStr = [NSString stringWithFormat:@"%@",model.id];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end
