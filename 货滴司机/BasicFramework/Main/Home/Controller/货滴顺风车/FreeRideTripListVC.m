//
//  FreeRideTripListVC.m
//  BasicFramework
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "FreeRideTripListVC.h"
#import "FreeRideTripListCell.h"
#import "FreeRideTripReleaseVC.h"
#import "FreeRideTripDetailVC.h"
#import "FreeRideModel.h"

@interface FreeRideTripListVC()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    NSMutableArray* _dataArray;

}
@property (nonatomic,strong)UITableView* tbView;
@end

@implementation FreeRideTripListVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _page = 1;
    [self dataRequest];
}
- (void)viewDidLoad{
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"货滴顺风车行程列表";
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    [self tbView];
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50);
    [nextBtn setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"发 布 行 程" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
}
//查询接口
- (void)dataRequest{
    

    
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20"};
    
    NSString *url = @"/mbtwz/freeride?action=selectSelfFreeRideList";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:params FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (_page == 1) {
            [_dataArray removeAllObjects];
        }
        NSArray *arr = [[NSArray alloc]initWithArray: dic[@"response"][@"rows"]];
        
        for (NSDictionary* dict in arr) {
            FreeRideModel* model = [[FreeRideModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArray addObject:model];
        }
        [_tbView reloadData];
        
    }];
    
    
}
- (UITableView*)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64 - 50) style:UITableViewStylePlain];
        if (statusbarHeight>20) {
            _tbView.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88);
        }
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self.view addSubview:_tbView];
        
        //下拉刷新
        _tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            if (!IsEmptyValue(_dataArray)) {
                [_dataArray removeAllObjects];
            }
            [self dataRequest];
            [_tbView.mj_header endRefreshing];
            
        }];
        //
        _tbView.mj_header.automaticallyChangeAlpha = YES;
        //
        _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _page ++;
            [self dataRequest];
            [_tbView.mj_footer endRefreshing];
        }];
    }
    
    return _tbView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160*MYWIDTH;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10    )];
    view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FreeRideTripListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeRideTripListCell"];
    if (!cell) {
        cell = (FreeRideTripListCell *)[[[NSBundle mainBundle]loadNibNamed:@"FreeRideTripListCell" owner:self options:nil]firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count) {
        FreeRideModel *free = _dataArray[indexPath.section];
        cell.address.text = [NSString stringWithFormat:@"%@-%@",free.scity,free.ecity];
        cell.vehicle.text = [NSString stringWithFormat:@"%@米/余:%@米",free.totalvehicle,free.availablevehicle];
        cell.time.text = [NSString stringWithFormat:@"%@",free.departuretime];
        NSString *image = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,free.folder,free.autoname];
        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",free.contactname];
        cell.fabutime.text = [NSString stringWithFormat:@"%@",free.createtime];
        if ([free.state intValue]==0) {
            cell.stateLab.text = @"已取消";
            cell.stateLab.textColor = [UIColor redColor];
        }else{
            cell.stateLab.text = @"";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FreeRideTripDetailVC* vc = [[FreeRideTripDetailVC alloc]init];
    FreeRideModel *free = _dataArray[indexPath.section];
    vc.id = free.id;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)nextClick:(UIButton*)sender{
    FreeRideTripReleaseVC* vc = [[FreeRideTripReleaseVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
