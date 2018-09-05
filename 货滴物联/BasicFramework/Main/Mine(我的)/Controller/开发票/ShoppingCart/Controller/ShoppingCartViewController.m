//
//  ShoppingCartViewController.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/3.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartCell.h"
#import "ShoopingCartBottomView.h"
#import "InvoiceModel.h"
#import "CommitInvoicePageVC.h"

@interface ShoppingCartViewController ()
<UITableViewDataSource,UITableViewDelegate,ShoopingCartBottomViewDelegate,ShoppingCartCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;//所有商铺数组
@property (nonatomic, strong) NSMutableArray *selectedShop;//选中的商品数组
@property (nonatomic, strong) ShoopingCartBottomView *bottomView;

@end

@implementation ShoppingCartViewController
{
    NSString *allPriceStr;
}
#pragma mark - 设置状态栏颜色
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
}

-(void)viewWillDisappear:(BOOL)animated

{
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xFF4E4E);
    UILabel *titleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLab2.text = @"按行程开票";
    titleLab2.textColor = [UIColor whiteColor];
    titleLab2.font = [UIFont boldSystemFontOfSize:17*MYWIDTH];
    self.navigationItem.titleView = titleLab2;
    [self setUpUI];
    [self initData];
    
    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}
- (void)setUpUI
{
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomView];
}
//网络请求数据
- (void)initData {
    NSString* urlstr = [NSString stringWithFormat:@"/invoice?action=searchInvoiceOrder&ordertype=%@",self.ordertype];
    [NetWorkManagerTwo requestDataWithURL:[NSString stringWithFormat:@"%@%@",_Environment_Domain,urlstr] requestType:GET parameters:nil loading:YES uploadProgress:^(float progress) {
        
    } success:^(id responseObject, id data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",array);
        [_dataSource removeAllObjects];
        for (NSDictionary* dic in array) {
            InvoiceModel *model=[[InvoiceModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [_dataSource addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark - delegate
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellID = @"ShoppingCartViewController_cell";
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.lineLabel.hidden = YES;
    }
    cell.backgroundColor = UIColorFromRGB(0xFF4E4E);
    //刷新cell
    cell.indexPath = indexPath;
    InvoiceModel *inModel = self.dataSource[indexPath.row];
    [cell setInfo:inModel];
    
    //计算并刷新价格、刷新结算按钮状态
    [self caculatePrice:inModel];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}
//设置自定义的sectionFooter,去除sectionFooter
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - ShoopingCartBottomViewDelegate
//全选
- (void)allGoodsIsSelected:(BOOL)selccted withButton:(UIButton *)btn {
    //修改数据源数据，刷新列表
    for (InvoiceModel *goodsModel in self.dataSource) {
        goodsModel.isSelected = selccted;
    }
    [self.tableView reloadData];
}
//结算
- (void)paySelectedGoods:(UIButton *)btn {
    NSLog(@"结算，选中的有：\n ");
    NSString * orderid;
    NSMutableArray * orderids = [[NSMutableArray alloc]init];
    for (InvoiceModel *goods in self.selectedShop) {
        NSLog(@"%@ \n",goods.id);
        [orderids addObject:goods.id];
    }
    orderid = [orderids componentsJoinedByString:@","];
    CommitInvoicePageVC * vc = [[CommitInvoicePageVC alloc]init];
    vc.ordertype = self.ordertype;
    vc.invoicemoney = allPriceStr;
    vc.orderids = orderid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ShoppingCartCellDelegate
- (void)cell:(ShoppingCartCell *)cell selected:(BOOL)isSelected indexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"section:%ld row:%ld isSelected:%d",indexPath.section,indexPath.row,isSelected);
    //更新选中cell的section下的数据
    InvoiceModel *inModel = self.dataSource[indexPath.row];
    inModel.isSelected = isSelected;
    //判断整个section是不是全被选中
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL sectionSelected = YES;
        for (InvoiceModel *inModel in self.dataSource) {
            if (!inModel.isSelected) {
                sectionSelected = NO;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bottomView setIsClick:sectionSelected];
        });
    });
//    NSLog(@"all section selected:%d",sectionSelected);
    [self.tableView reloadData];
}
#pragma mark - 自定义
- (void)caculatePrice:(InvoiceModel *)goodsModel{
    @synchronized (self.selectedShop)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (goodsModel.isSelected) {
                if (![self.selectedShop containsObject:goodsModel]) {
                    [self.selectedShop addObject:goodsModel];
                }
            }
            else {
                if ([self.selectedShop containsObject:goodsModel]) {
                    [self.selectedShop removeObject:goodsModel];
                }
            }
            
            NSDecimalNumber *allPriceDecimal = [NSDecimalNumber zero];
            for (InvoiceModel *goods in self.selectedShop) {
                NSString *price = [NSString stringWithFormat:@"%@",goods.ordertotalprice];
                NSDecimalNumber *decimalPrice = [NSDecimalNumber decimalNumberWithString:price];
                allPriceDecimal = [allPriceDecimal decimalNumberByAdding:decimalPrice];
            }
            allPriceStr = [allPriceDecimal stringValue];
            NSLog(@"总价：%@",allPriceStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([allPriceStr floatValue]>0) {
                    [self.bottomView setPayEnable:YES];
                    self.bottomView.allPriceLabel.text = [NSString stringWithFormat:@"共%@元",[allPriceDecimal stringValue]];
                } else {
                    [self.bottomView setPayEnable:NO];
                    self.bottomView.allPriceLabel.text = [NSString stringWithFormat:@"共%@元",@"0"];
                }
            });
        });
    }
}

#pragma mark - set/get
- (ShoopingCartBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ShoopingCartBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50-kIPhoneXBottomHeight, kScreenWidth, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight-NavBarHeight-kIPhoneXBottomHeight-50) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorFromRGB(0xFF4E4E);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (NSMutableArray *)selectedShop {
    if (!_selectedShop) {
        _selectedShop = [[NSMutableArray alloc] init];
    }
    return _selectedShop;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSLog(@"dealloc");
}

@end
