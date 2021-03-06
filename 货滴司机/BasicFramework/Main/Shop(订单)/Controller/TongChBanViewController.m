//
//  TongChBanViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/2/7.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "TongChBanViewController.h"
#import "TongChBanCell.h"
#import "TCHBanJModel.h"
#import "TongChBanOrderDetail.h"
@interface TongChBanViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation TongChBanViewController
{
    NSInteger _page;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self ajaxCallbak];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_push isEqualToString:@"1"]) {
        self.navigationItem.title = @"同城搬家单";
    }
    // Do any additional setup after loading the view.
    _page=1;
    _dataArr = [[NSMutableArray alloc]init];
    [self tableview];
    
}
- (void)loadNewSearchSuyunorder
{
    if (_page==1) {
        [_dataArr removeAllObjects];
    }
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=searchfindorder";
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8"};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [dict objectForKey:@"rows"];
        NSLog(@"%@",array);
        if (!IsEmptyValue(array)) {
            for (NSDictionary*dic in array) {
                TCHBanJModel *model=[[TCHBanJModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_dataArr addObject:model];
            }
        }
        
        [_tableview reloadData];
        
    }];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class ZuLinCarClass = [TongChBanCell class];
    TongChBanCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    if (_dataArr.count) {
        NSLog(@"%@",_dataArr);
        TCHBanJModel *model = _dataArr[indexPath.row];
        [cell setwithDataModel:model];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Command isloginRequest:^(bool str) {
        if (str) {
            TCHBanJModel *model = _dataArr[indexPath.row];
            
            TongChBanOrderDetail *detail = [[TongChBanOrderDetail alloc]init];
            detail.orderno = model.owner_orderno;
            detail.custid = model.owner_custid;
            detail.hidesBottomBarWhenPushed = YES;;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            });
        }
    }];
    
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-64-40-45)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-88-40-45);
            
        }
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        [_tableview registerClass:[TongChBanCell class] forCellReuseIdentifier:NSStringFromClass([TongChBanCell class])];
        
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addnewData)];
        if ([_push isEqualToString:@"1"]) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);
            UIView *bai = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 63)];
            bai.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bai];
            if (statusbarHeight>20) {
                bai.frame = CGRectMake(0, 0, UIScreenW, 87);
            }
        }
    }
    return _tableview;
    
}
- (void)loadNewData{
    _page=1;
    [self loadNewSearchSuyunorder];
    
    [_tableview.mj_header endRefreshing];
    
}
- (void)addnewData{
    _page ++;
    [self loadNewSearchSuyunorder];
    [_tableview.mj_footer endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)ajaxCallbak{
    [Command isloginRequest:^(bool str) {
        if (str) {
            [self loadNewSearchSuyunorder];
        }else{
            
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            });
        }
    }];
}
- (void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
