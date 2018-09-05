//
//  MyErSCViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/7/20.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "MyErSCViewController.h"
#import "MyPurseTableViewCell.h"
#import "MyErSCshopViewController.h"
#import "FaBuErSCViewController.h"

@interface MyErSCViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView2;

@end

@implementation MyErSCViewController

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight);
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled =NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIView *bgimage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 170*MYWIDTH)];
        
        //banner
        // 情景二：采用网络图片实现
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
        for (NSDictionary* dic in self.arr) {
            NSString *serverAddress = _Environment_Domain;
            NSString* imageurl = [NSString stringWithFormat:@"%@/%@%@",serverAddress,[dic objectForKey:@"folder"],[dic objectForKey:@"autoname"]];
            [imagesURLStrings addObject:imageurl];
            
        }
        
        // 网络加载 --- 创建带标题的图片轮播器
        self.cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 170*MYWIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        self.cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView2.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
        [bgimage addSubview:self.cycleScrollView2];
        self.cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
        
        
        _tableview.tableHeaderView = bgimage;
        
        [_tableview registerClass:[MyPurseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyPurseTableViewCell class])];
        
    }
    return _tableview;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLab.text = @"我的";
    titleLab.textColor = [UIColor redColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    self.navigationItem.titleView = titleView;
    [self tableview];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [MyPurseTableViewCell class];
    MyPurseTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *data = @[@"我的二手车",@"发布二手车"];
    NSArray *image = @[@"二手车",@"发布二手车"];
    [cell setdata:data[indexPath.row] image:image[indexPath.row] push:@"4"];
    cell.otherView.text = @"";
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MyErSCshopViewController *MyYuE = [[MyErSCshopViewController alloc]init];
        [self.navigationController pushViewController:MyYuE animated:YES];
    }else if (indexPath.row == 1){

        FaBuErSCViewController *MyYuE = [[FaBuErSCViewController alloc]init];
        [self.navigationController pushViewController:MyYuE animated:YES];
    }
    
    NSLog(@"%ld",indexPath.row);
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
