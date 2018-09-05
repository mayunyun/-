//
//  HomeSuYunBanJVC.m
//  BasicFramework
//
//  Created by LONG on 2018/3/6.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "HomeSuYunBanJVC.h"
#import "ZHBanJModel.h"
#import "ZHBanJTableViewCell1.h"
@interface HomeSuYunBanJVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign)CLLocationCoordinate2D locationStr;

@end

@implementation HomeSuYunBanJVC

{
    NSInteger _page;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];
    
    [self tableview];
    
}
//下拉刷新
- (void)loadNewData{
    [self.dataArr removeAllObjects];
    _page = 1;
    [self configLocationManager];
    [self loadData];
    [_tableview.mj_header endRefreshing];
    
}
- (void)addUpData{
    _page++;
    [self loadData];
    [_tableview.mj_footer endRefreshing];
}
#pragma 在这里面请求数据
- (void)loadData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //
    NSString *URLStr = @"/mbtwz/find?action=selectLogisticsOrderList";
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8",@"params":[NSString stringWithFormat:@"{\"city\":\"%@\"}",[user objectForKey:CITY]]};
    NSLog(@"参数==%@",params);
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"zulin%@",diction);
        if ([[diction objectForKey:@"rows"] count]) {
            for (NSDictionary *dic in [diction objectForKey:@"rows"]) {
                //建立模型
                ZHBanJModel *model=[[ZHBanJModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [self.dataArr addObject:model];
            }
        }
        
        [self.tableview reloadData];
        
        
        
    }];
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-45)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-34-45);
            
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        //        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 40*MYWIDTH)];
        //        _tableview.tableFooterView = food;
        [_tableview registerClass:[ZHBanJTableViewCell1 class] forCellReuseIdentifier:NSStringFromClass([ZHBanJTableViewCell1 class])];
        
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 243*MYWIDTH;
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addUpData)];
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class ZuLinCarClass = [ZHBanJTableViewCell1 class];
    ZHBanJTableViewCell1 *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    cell.controller = self;
    if (_dataArr.count) {
        NSLog(@"%@",_dataArr);
        ZHBanJModel *model = _dataArr[indexPath.row];
        [cell setwithDataModel:model locationStr:_locationStr];
    }
    
    return cell;
}
- (void)configLocationManager
{
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
            self.locationStr = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
            [_tableview reloadData];
        }
        
    }];
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
