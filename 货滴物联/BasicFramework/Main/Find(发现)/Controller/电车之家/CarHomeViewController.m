//
//  CarHomeViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/9/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarHomeViewController.h"
#import "CarBrandViewController.h"
#import "CarFloorPriceViewController.h"
#import "CarHomeTableViewCell.h"
#import "CarHomeHeadView.h"
#import "CarBrandModel.h"
@interface CarHomeViewController ()<UITableViewDataSource,UITableViewDelegate,CarHomeHeadViewDelegate,UITextFieldDelegate>{
    UITextField *_textField1;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)CarHomeHeadView *carHomeHeadView;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@end

@implementation CarHomeViewController

- (UITableView *)tableview{
    if (_tableview == nil) {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, 43.5*MYWIDTH)];
        if (statusbarHeight>20) {
            header.frame = CGRectMake(0, 88, kScreenWidth, 43.5*MYWIDTH);
        }
        header.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:header];
        
        UIButton *sousuo = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, header.height)];
        [sousuo setTitle:@" 品牌搜索" forState:UIControlStateNormal];
        sousuo.titleLabel.font = [UIFont systemFontOfSize:13];
        [sousuo setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [sousuo setImage:[UIImage imageNamed:@"查询.png"] forState:UIControlStateNormal];
        [sousuo addTarget:self action:@selector(sousuoCliak) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:sousuo];
        
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 4, 1, header.height-8)];
        xian.backgroundColor = UIColorFromRGB(MYLine);
        [header addSubview:xian];
        
        UIButton *dijia = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2+1, 0, kScreenWidth/2, header.height)];
        [dijia setTitle:@" 询底价" forState:UIControlStateNormal];
        dijia.titleLabel.font = [UIFont systemFontOfSize:13];
        [dijia setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [dijia setImage:[UIImage imageNamed:@"询底价.png"] forState:UIControlStateNormal];
        [dijia addTarget:self action:@selector(dijiaCliak) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:dijia];
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 43.5*MYWIDTH+NavBarHeight, kScreenWidth, kScreenHeight-43.5*MYWIDTH-NavBarHeight)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 43.5*MYWIDTH+88, kScreenWidth, kScreenHeight-43.5*MYWIDTH-88);
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        _carHomeHeadView = [[CarHomeHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210*MYWIDTH)];
        _carHomeHeadView.delegate = self;
        _tableview.tableHeaderView = _carHomeHeadView;
        
        [_tableview registerClass:[CarHomeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CarHomeTableViewCell class])];

        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
    }
    return _tableview;
    
}
-(void)sousuoCliak{
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];

    CGFloat width = 300*MYWIDTH;

    UIView *customView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 150*MYWIDTH)];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH)];
    imageview.image = [UIImage imageNamed:@"查询.png"];
    [customView1 addSubview:imageview];
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(45*MYWIDTH, 0, 120*MYWIDTH, 45*MYWIDTH)];
    [title1 setFont:[UIFont systemFontOfSize:15]];
    [title1 setTextColor:[UIColor blackColor]];
    title1.textAlignment = NSTextAlignmentLeft;
    title1.text = @"品牌搜索";
    [customView1 addSubview:title1];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 45*MYWIDTH, width-30, 1.5)];
    xian1.backgroundColor = UIColorFromRGB(MYLine);
    [customView1 addSubview:xian1];
    
    _textField1 = [[UITextField alloc]initWithFrame:CGRectMake(30*MYWIDTH, 70*MYWIDTH, width-110*MYWIDTH, 40*MYWIDTH)];
    _textField1.layer.cornerRadius = 3;
    _textField1.layer.borderWidth = 0.5;
    _textField1.layer.borderColor = UIColorFromRGB(0x444444).CGColor;
    _textField1.placeholder = @" 输入您要搜索的品牌";
    _textField1.textAlignment = NSTextAlignmentCenter;
    _textField1.font = [UIFont systemFontOfSize:13];
    [_textField1 setReturnKeyType:UIReturnKeyDone];
    _textField1.delegate = self;
    [customView1 addSubview:_textField1];
    
    UIButton *sousuo = [[UIButton alloc]initWithFrame:CGRectMake(_textField1.right+10*MYWIDTH, 70*MYWIDTH, 40*MYWIDTH, 40*MYWIDTH)];
    [sousuo setImage:[UIImage imageNamed:@"搜索_2.png"] forState:UIControlStateNormal];
    [sousuo addTarget:self action:@selector(sousuoCliakGO) forControlEvents:UIControlEventTouchUpInside];
    [customView1 addSubview:sousuo];
    
    [SMAlert showCustomView:customView1];
}
- (void)dijiaCliak{
    CarFloorPriceViewController* vc = [[CarFloorPriceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sousuoCliakGO{
    [SMAlert hide:NO];

    NSString *URLStr = @"/mbtwz/CarHome?action=searchCarBrand";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"brandname\":\"%@\"}",_textField1.text]};
    [_dataArr removeAllObjects];
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSArray* Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"品牌列表%@",Arr);
        
        if (!IsEmptyValue(Arr)) {
            for (NSDictionary* dict in Arr) {
                CarBrandModel* model = [[CarBrandModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArr addObject:model];
            }
            //根据Person对象的 name 属性 按中文 对 Person数组 排序
            self.indexArray = [BMChineseSort IndexWithArray:_dataArr Key:@"brandname"];
            self.letterResultArr = [BMChineseSort sortObjectArray:_dataArr Key:@"brandname"];
        }
        [_tableview reloadData];
        
    }];
}
//下拉刷新
- (void)loadNewData{
    [self loadNew];
    [self headviewlodaData];
    [_tableview.mj_header endRefreshing];
    
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
    _dataArr = [[NSMutableArray alloc]init];
    
    
    self.navigationItem.title = @"电车之家";
    [self headviewlodaData];
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
    NSString *URLStr = @"/mbtwz/CarHome?action=getCarBrand";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"ishot\":\"%@\"}",@""]};
    
    [_dataArr removeAllObjects];

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSArray* Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"品牌列表%@",Arr);
        
        if (!IsEmptyValue(Arr)) {
            for (NSDictionary* dict in Arr) {
                CarBrandModel* model = [[CarBrandModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArr addObject:model];
            }
            //根据Person对象的 name 属性 按中文 对 Person数组 排序
            self.indexArray = [BMChineseSort IndexWithArray:_dataArr Key:@"brandname"];
            self.letterResultArr = [BMChineseSort sortObjectArray:_dataArr Key:@"brandname"];
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
- (void)headviewlodaData{
    NSString *URLStr = @"/mbtwz/CarHome?action=getCarBrand";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"ishot\":\"%@\"}",@"1"]};

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSArray* Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"热门品牌列表%@",Arr);
        NSMutableArray *data = [[NSMutableArray alloc]init];
        if (!IsEmptyValue(Arr)) {
            if ([Arr count] >5) {
                _carHomeHeadView.frame = CGRectMake(0, 0, kScreenWidth, 210*MYWIDTH);
            }else if ([Arr count]>0){
                _carHomeHeadView.frame = CGRectMake(0, 0, kScreenWidth, 132*MYWIDTH);
            }else{
                [_carHomeHeadView removeFromSuperview];
            }
            
            for (NSDictionary* dict in Arr) {
                CarBrandModel* model = [[CarBrandModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [data addObject:model];
            }
        }
        [_carHomeHeadView dataHeadView:data];
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.indexArray.count) {
        return [self.indexArray count];
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.letterResultArr.count) {
        return [[self.letterResultArr objectAtIndex:section] count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*MYWIDTH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56*MYWIDTH;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30*MYWIDTH)];
    headview.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30*MYWIDTH)];
    lab.text = [NSString stringWithFormat:@"%@",self.indexArray[section]];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = UIColorFromRGB(0x333333);
    [headview addSubview:lab];
    if (section != 0) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 0.5)];
        xian.backgroundColor = UIColorFromRGB(MYLine);
        [headview addSubview:xian];
    }
    return headview;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class HomeClass = [CarHomeTableViewCell class];
    CarHomeTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HomeClass)];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头

    if (self.letterResultArr.count) {
        //获得对应的Person对象<替换为你自己的model对象>
        CarBrandModel *model = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.data = model;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarBrandModel *model = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    CarBrandViewController *carbrand = [[CarBrandViewController alloc]init];
    carbrand.idStr = model.id;
    carbrand.brandStr = model.brandname;
    [self.navigationController pushViewController:carbrand animated:YES];
    
}
- (void)CarHomeHeadViewBtnHaveString:(NSString *)brandname idStr:(NSString *)idStr{
    CarBrandViewController *carbrand = [[CarBrandViewController alloc]init];
    carbrand.idStr = idStr;
    carbrand.brandStr = brandname;
    [self.navigationController pushViewController:carbrand animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    kWindow.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    kWindow.frame = CGRectMake(0, -kScreenHeight/3, kScreenWidth, kScreenHeight);
}
@end
