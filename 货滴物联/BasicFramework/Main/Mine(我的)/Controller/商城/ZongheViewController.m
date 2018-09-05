//
//  ZongheViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/7/6.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ZongheViewController.h"
#import "NewShopCollectionViewCell.h"
#import "HomeFavorableModel.h"
#import "HXSearchBar.h"
#import "DetailsViewController.h"

@interface ZongheViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
@property (nonatomic) NSInteger selectedIndex;
@property(nonatomic,strong)UICollectionView *collection;
@end

@implementation ZongheViewController
{
    NSMutableArray* _dataArray;
    //    MBProgressHUD* _hud;
    NSInteger _page;
    
    NSArray *_items;
    UIView *buttonview;
    HXSearchBar *_search;//搜索
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftNavBarClick)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xFFFFFF)];
    [self requestData];
    [self setButtons];
    
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}
- (void)leftNavBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [_search resignFirstResponder];// 放弃第一响应者
    [self.view endEditing:YES];
    
}
- (void)creatUI
{
    [self setInitialValue];
    
    [self setButtonsFrames];
    [self searchview];
    
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize =CGSizeMake(UIScreenW, UIScreenH-64-49);
    layout.minimumInteritemSpacing = 0; //列间距
    layout.minimumLineSpacing = 0;//行间距
    _collection =[[UICollectionView alloc]initWithFrame:CGRectMake(0, statusbarHeight+44+40, UIScreenW, UIScreenH-40-statusbarHeight-44) collectionViewLayout:layout];
    
    _collection.delegate =self;
    _collection.dataSource =self;
    _collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collection];
    
    [_collection registerNib:[UINib nibWithNibName:@"NewShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NewShopCollectionViewCellID"];
    
    //     下拉刷新
    _collection.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArray removeAllObjects];
        [self requestData];
        // 结束刷新
        [_collection.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _collection.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _collection.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self requestData];
        [_collection.mj_footer endRefreshing];
        
    }];
    
}
- (void)setButtons{
    _items = @[@"综合",@"销量",@"价格"];
    
    buttonview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, 40)];
    if (statusbarHeight>20) {
        buttonview.frame = CGRectMake(0, 88, UIScreenW, 40);
    }
    buttonview.backgroundColor = [UIColor whiteColor];
    int i = 0;
    for (NSString *titleStr in _items) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = 1000+i;
        [button setTitle:titleStr forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonview addSubview:button];
        if (i==0) {
            [button setTitleColor:MYColor forState:UIControlStateNormal];
        }
        i++;
    }
    
    UIView *underLine = [[UIView alloc] init];
    underLine.backgroundColor = MYColor;
    underLine.tag = 2000;
    underLine.layer.cornerRadius = 1;
    [buttonview addSubview:underLine];
    [self.view addSubview:buttonview];
    [self creatUI];
}
#pragma mark - 三个有下划线的Button
- (void)setInitialValue
{
    self.selectedIndex = 0;
    [self selectButtonWithIndex:0];
}
- (void)selectButtonWithIndex:(NSInteger)index;
{
    CGFloat width = UIScreenW/3;
    CGFloat height = 40;
    CGFloat underLineW = width - 2*10;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+index];
        if (button != nil){
            [button setTitleColor:MYColor forState:UIControlStateNormal];
        }
        
        UIView *underLine = [weakself.view viewWithTag:2000];
        if (underLine != nil) {
            underLine.frame = CGRectMake(index*width+10, height-2,
                                         underLineW, 2);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) return;
    _selectedIndex = selectedIndex;
    [self selectButtonWithIndex:selectedIndex];
}
- (void)buttonAction:(UIButton *)button
{
    NSInteger index = button.tag-1000;
    for (NSInteger i = 0; i < _items.count; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+i];
        if (button != nil){
            if (!(index==i)) {
                
                [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
                
            }
        }
    }
    if (index == self.selectedIndex) return;
    self.selectedIndex = index;
    NSLog(@"%@",_items[index]);
    _page = 1;
    [self requestData];
}
- (void)setButtonsFrames
{
    CGFloat width = UIScreenW/3;
    CGFloat height = 40;
    for (int i = 0; i < _items.count; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+i];
        if (button != nil) button.frame = CGRectMake(i*width, 0, width, height);
    }
    
    UIView *underLine = [self.view viewWithTag:2000];
    CGFloat underLineW = width - 2*10;
    if (underLine != nil) {
        underLine.frame = CGRectMake(self.selectedIndex*underLineW + 10, height-2,
                                     underLineW, 2);
    }
}
- (UISearchBar *)searchview{
    if (_search == nil) {
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenW-60, 25)];
        //        titleView.layer.cornerRadius = 12;
        //        titleView.layer.masksToBounds = YES;
        //        titleView.backgroundColor = [UIColor whiteColor];
        //加上 搜索栏
        _search = [[HXSearchBar alloc] initWithFrame:CGRectMake(10, 0, UIScreenW-80, 25)];
        _search.backgroundColor = [UIColor clearColor];
        _search.delegate = self;
        _search.searchBarTextField.font = [UIFont systemFontOfSize:13];
        //输入框提示
        _search.placeholder = @"搜你想要的";
        //光标颜色
        _search.cursorColor = [UIColor blackColor];
        //TextField
        _search.searchBarTextField.layer.cornerRadius = 12;
        _search.searchBarTextField.layer.masksToBounds = YES;
        //        _search.searchBarTextField.layer.borderColor = [UIColor whiteColor].CGColor;
        //        _search.searchBarTextField.layer.borderWidth = 1.0;
        //清除按钮图标
        _search.clearButtonImage = [UIImage imageNamed:@"demand_delete"];
        
        //去掉取消按钮灰色背景
        _search.hideSearchBarBackgroundImage = YES;
        [titleView addSubview:_search];
        self.navigationItem.titleView = titleView;
    }
    return _search;
}
- (void)requestData
{
    /*
     mall/showproduct?action=loadProductInfo
     */
    NSArray *array = @[@"3",@"2",@"0"];
    NSDictionary* params = [[NSDictionary alloc]init];
    params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"type\":\"%@\",\"ordertype\":\"0\",\"prodtype\":\"%@\",\"searchstr\":\"%@\"}",array[self.selectedIndex],self.prodtype,self.souStr]};
    
    NSString *URLStr = @"/mbtwz/scshop?action=selectMallProdsByParam_type";
    if ([self.prodtype isEqualToString:@""]) {
        URLStr = @"/mbtwz/scshop?action=selectMallProdsByParam";
    }
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        if (_page==1) {
            [_dataArray removeAllObjects];
        }
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            
            
            for (NSDictionary* dict in [[dic objectForKey:@"response"] objectForKey:@"rows"]) {
                HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
            
        }
        [_collection reloadData];
    }];
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"NewShopCollectionViewCellID";
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"NewShopCollectionViewCell" bundle: [NSBundle mainBundle]];
    [_collection registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    NewShopCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //[self framAdd:cell];
    
    HomeFavorableModel* model;
    if (_dataArray.count!=0) {
        model = _dataArray[indexPath.row];
    }
    model.proname = [Command convertNull:model.proname];
    model.price = [Command convertNull:model.price];
    model.price_jf = [Command convertNull:model.price_jf];
    
    cell.titleLabel.text = nil;
    cell.imgView.image = nil;
    cell.priceLabel.text = nil;
    cell.jifenLabel.text = nil;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.proname];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥: %@",model.price];
    cell.jifenLabel.text = [NSString stringWithFormat:@"积: %@",model.price_jf];
    cell.priceLabel.textColor = UIColorFromRGB(0xFF0000);
    cell.jifenLabel.textColor = UIColorFromRGB(0xFF0000);
    
    NSString* url = _Environment_Domain;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",url,model.prodpic]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //400*kScreen_Width/714
    return CGSizeMake(UIScreenW/2, (UIScreenW/2-8)*6/5);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth,1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return _dataArray.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeFavorableModel* model = _dataArray[indexPath.row];
    DetailsViewController *detailsVc = [[DetailsViewController alloc]init];
    detailsVc.id = model.id;
    detailsVc.type = @"1";
    [self.navigationController pushViewController:detailsVc animated:YES];
    
}

#pragma mark - UISearchBar Delegate
//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //    HXSearchBar *sear = (HXSearchBar *)searchBar;
    //    //取消按钮
    //    sear.cancleButton.backgroundColor = [UIColor clearColor];
    //    [sear.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    //    [sear.cancleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    //    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"搜索" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}

//编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText:%@",searchText);
}

//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_search resignFirstResponder];// 放弃第一响应者
    
    if (!IsEmptyValue(_search.text)) {
        self.souStr = _search.text;
        [self requestData];
    }
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_search resignFirstResponder];// 放弃第一响应者
    if (!IsEmptyValue(_search.text)) {
        self.souStr = _search.text;
        [self requestData];
    }
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
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
