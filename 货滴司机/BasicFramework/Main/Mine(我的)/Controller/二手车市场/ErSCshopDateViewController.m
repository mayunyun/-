//
//  ErSCshopDateViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/7/17.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ErSCshopDateViewController.h"
#import "ErSCModel.h"
#import "ErSCDateTableViewCell.h"
@interface ErSCshopDateViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView2;

@end

@implementation ErSCshopDateViewController

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+statusbarHeight, kScreenWidth, kScreenHeight-statusbarHeight-44)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIView *bgimage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 170*MYWIDTH)];
        //banner
        
        // 网络加载 --- 创建带标题的图片轮播器
        self.cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 170*MYWIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        self.cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView2.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
        [bgimage addSubview:self.cycleScrollView2];
        
        _tableview.tableHeaderView = bgimage;
        
        if ([self.push isEqualToString:@"1"]) {
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 45*MYWIDTH)];
            but.backgroundColor = MYColor;
            [but setTitle:@"删除" forState:UIControlStateNormal];
            [but addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
            _tableview.tableFooterView = but;
        }
        
        [_tableview registerClass:[ErSCDateTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ErSCDateTableViewCell class])];
        
    }
    return _tableview;
    
}
//删除我的二手车
- (void)butClick{
    jxt_showAlertTwoButton(@"提示", @"确定删除当前车辆吗", @"确定", ^(NSInteger buttonIndex) {
        NSString *XWURLStr = @"/mbtwz/secondhandcar?action=deleteSelfSecondhandcar";
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"selectid\":\"%@\"}",self.selectid]};
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:params FinishedLogin:^(id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([[dic objectForKey:@"flag"] intValue]==200) {
                jxt_showAlertOneButton(@"提示", @"删除成功", @"确定", ^(NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                jxt_showToastTitle(@"操作失败", 1);
            }
            
            
        }];
    }, @"取消", ^(NSInteger buttonIndex) {
        
    });
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self loadNew];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLab.text = @"二手车详情";
    titleLab.textColor = [UIColor redColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    
    [self tableview];
    
}
#pragma 在这里面请求数据
- (void)loadNew
{
    [_dataArr removeAllObjects];
    
    NSString *XWURLStr = @"/mbtwz/secondhandcar?action=searchSecondhandcarDet";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"selectid\":\"%@\"}",self.selectid]};

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:params FinishedLogin:^(id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            NSMutableArray *  bannerDataArray = [NSMutableArray arrayWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"twoScarpics"]];
            
            NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
            for (NSString* strurl in bannerDataArray) {
                NSString *serverAddress = _Environment_Domain;
                NSString* imageurl = [NSString stringWithFormat:@"%@/%@",serverAddress,strurl];
                [imagesURLStrings addObject:imageurl];
            }
            self.cycleScrollView2.imageURLStringsGroup = imagesURLStrings;

            
            ErSCModel* model = [[ErSCModel alloc]init];
            [model setValuesForKeysWithDictionary:[[dic objectForKey:@"response"][0] objectForKey:@"twoScarinfo"]];
            [_dataArr addObject:model];
            
        }
        [_tableview reloadData];
        
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==10) {
        return 90*MYWIDTH;
    }
    return 40*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [ErSCDateTableViewCell class];
    ErSCDateTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (_dataArr.count>0) {
        ErSCModel *model = _dataArr[0];
        NSArray *data = @[@"标题:",@"车型:",@"品牌:",@"车型号:",@"价格:",@"看车地址:",@"注册年份:",@"公里数:",@"联系人:",@"联系电话:",@"描述:"];
        NSArray *other = @[[NSString stringWithFormat:@"%@",model.title],[NSString stringWithFormat:@"%@",model.car_type_name],[NSString stringWithFormat:@"%@",model.car_brand_name],[NSString stringWithFormat:@"%@",model.model_number],[NSString stringWithFormat:@"%@",model.price],[NSString stringWithFormat:@"%@",model.watch_car_add],[NSString stringWithFormat:@"%@",model.registered_year],[NSString stringWithFormat:@"%@",model.kilometre],[NSString stringWithFormat:@"%@",model.contacts],[NSString stringWithFormat:@"%@",model.contact_number],[NSString stringWithFormat:@"%@",model.describe]];
        [cell setdata:data[indexPath.row] other:other[indexPath.row]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
