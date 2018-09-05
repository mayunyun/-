//
//  HDSousuoViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HDSousuoViewController.h"
#import "MainTableViewCell.h"
#import "NewAllViewController.h"

@interface HDSousuoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSInteger _page;
    UITextField *_textField;

}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation HDSousuoViewController

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
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20+64)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        header.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        UIView *headerbgview =[[UIView alloc]init];
        headerbgview.backgroundColor = [UIColor whiteColor];
        [header addSubview:headerbgview];
        headerbgview.frame = CGRectMake(10, 15, kScreenWidth-20, 10);
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:headerbgview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = headerbgview.bounds;
        maskLayer1.path = maskPath1.CGPath;
        headerbgview.layer.mask = maskLayer1;
        _tableview.tableHeaderView = header;
        
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        food.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        UIView *foodbgview =[[UIView alloc]init];
        foodbgview.backgroundColor = [UIColor whiteColor];
        [food addSubview:foodbgview];
        foodbgview.frame = CGRectMake(10, 0, kScreenWidth-20, 10);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:foodbgview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = foodbgview.bounds;
        maskLayer.path = maskPath.CGPath;
        foodbgview.layer.mask = maskLayer;
        _tableview.tableFooterView = food;
        
        [_tableview registerClass:[MainTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MainTableViewCell class])];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        //_tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addUpData)];
        
        
    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{
    [self.dataArr removeAllObjects];
    _page = 1;
    [self loadNew];
    [_tableview.mj_header endRefreshing];
    
}
- (void)addUpData{
    _page++;
    [self loadNew];
    [_tableview.mj_footer endRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-110*MYWIDTH, 35)];
    _textField.layer.cornerRadius = 3;
    _textField.layer.borderWidth = 1;
    _textField.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    _textField.textColor = [UIColor whiteColor];
    _textField.placeholder = @"输入搜索关键字";
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:13];
    [_textField setReturnKeyType:UIReturnKeyDone];
    _textField.delegate = self;
    self.navigationItem.titleView = _textField;
    [Command placeholderColor:_textField str:_textField.placeholder color:[UIColor whiteColor]];

    _dataArr = [[NSMutableArray alloc]init];
    [self tableview];
    [self loadNew];
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

#pragma 刷新(在这里面发送请求，刷新数据)
- (void)loadNew
{
    
    
    //最新动态
    NSString *XWURLStr = @"/mbtwz/find?action=getActiveList";
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8",@"params":[NSString stringWithFormat:@"{\"activityname\":\"%@\"}",_textField.text]};
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:params FinishedLogin:^(id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"最新%@",array);
        if (array.count) {
            
            //建立模型
            for (NSDictionary*dic in array ) {
                HuoDongModel *model=[[HuoDongModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count>0) {
//                [self.tableview dismissNoView];
                [self.tableview reloadData];
                
            }else{
//                [self.tableview showNoView:nil image:nil certer:CGPointZero];
            }
        }
        
    }];
    
    
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75*MYWIDTH+30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Class MainClass = [MainTableViewCell class];
    MainTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.xianview.hidden = YES;
    }else{
        cell.xianview.hidden = NO;
    }
    if (_dataArr.count) {
        HuoDongModel*model = self.dataArr[indexPath.row];
        cell.model = model;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewAllViewController *newAll = [[NewAllViewController alloc]init];
    newAll.hidesBottomBarWhenPushed = YES;
    newAll.huomodel = self.dataArr[indexPath.row];
    newAll.type = 2;
    [self.navigationController pushViewController:newAll animated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self loadNewData];

}
@end
