//
//  NewShopingClassViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/7/3.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "NewShopingClassViewController.h"
#import "NewShopCollectionViewCell.h"
#import "HomeFavorableModel.h"
#import "HXSearchBar.h"
#import "FeiLeiShopViewController.h"
#import "ShopCarViewController.h"
#import "MenuViewController.h"
#import "ZongheViewController.h"
#import "DetailsViewController.h"
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define Start_X          5.0f      // 第一个按钮的X坐标
//#define Start_Y          90.0f     // 第一个按钮的Y坐标
#define Width_Space      2.0f      // 2个按钮之间的横间距
#define Height_Space     5.0f     // 竖间距
#define Button_Height   70*MYWIDTH    // 高
#define Button_Width    (UIScreenW-10-2*2)/3    // 宽

@interface NewShopingClassViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView2;

@end

@implementation NewShopingClassViewController
{
    NSMutableArray* _favorableDataArray;
    NSMutableArray* _hotProDataArray;
    NSMutableArray* _youLikeDataArray;
    NSMutableArray* _bannerDataArray;
    NSMutableArray* _typeDataArray;
    NSMutableArray* _headerImageArray;
    HXSearchBar *_search;//搜索
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    [self dataRequest];
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftNavBarClick)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xFFFFFF)];
    
    _favorableDataArray = [[NSMutableArray alloc]init];
    _hotProDataArray = [[NSMutableArray alloc]init];
    _youLikeDataArray = [[NSMutableArray alloc]init];
    _bannerDataArray = [[NSMutableArray alloc]init];
    _typeDataArray = [[NSMutableArray alloc]init];
    _headerImageArray = [[NSMutableArray alloc]init];
    [self creatUI];
    [self searchview];
    
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [_search resignFirstResponder];// 放弃第一响应者
    [self.view endEditing:YES];
    
}
- (void)leftNavBarClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
- (void)dataRequest{
    
    NSString *URLStr = @"/mbtwz/scshop?action=selectMallIndex";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        
        [_favorableDataArray removeAllObjects];
        [_hotProDataArray removeAllObjects];
        [_youLikeDataArray removeAllObjects];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            _bannerDataArray = [NSMutableArray arrayWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"toppic"]];
            _typeDataArray = [NSMutableArray arrayWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"toptype"]];
            [[NSUserDefaults standardUserDefaults]setObject:_typeDataArray forKey:@"shopARR"];
            for (NSDictionary* dict in [[dic objectForKey:@"response"][0] objectForKey:@"prodlistth"]) {
                HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_favorableDataArray addObject:model];
            }
            for (NSDictionary* dict in [[dic objectForKey:@"response"][0] objectForKey:@"prodlistrm"]) {
                HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_hotProDataArray addObject:model];
            }
            for (NSDictionary* dict in [[dic objectForKey:@"response"][0] objectForKey:@"prodlistcnxh"]) {
                HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_youLikeDataArray addObject:model];
            }
            NSArray *image = [[NSArray alloc]initWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"centpicth"]];
            if (image.count) {
                [_headerImageArray addObject:[[dic objectForKey:@"response"][0] objectForKey:@"centpicth"][0]];
            }
            NSArray *image1 = [[NSArray alloc]initWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"centpicrm"]];
            if (image1.count) {
                [_headerImageArray addObject:[[dic objectForKey:@"response"][0] objectForKey:@"centpicrm"][0]];
            }
            NSArray *image2 = [[NSArray alloc]initWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"centpiccnxh"]];
            if (image2.count) {
                [_headerImageArray addObject:[[dic objectForKey:@"response"][0] objectForKey:@"centpiccnxh"][0]];
            }
        }
        [_collection reloadData];
    }];
    
}
- (void)creatUI
{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize =CGSizeMake(UIScreenW, UIScreenH-64-49);
    layout.minimumInteritemSpacing = 0; //列间距
    layout.minimumLineSpacing = 0;//行间距
    _collection =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-44*MYWIDTH) collectionViewLayout:layout];
//    if (statusbarHeight>20) {
//        layout.headerReferenceSize =CGSizeMake(UIScreenW, UIScreenH-88);
//        _collection.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-88);
//    }
    _collection.delegate =self;
    _collection.dataSource =self;
    _collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collection];
    
    [_collection registerNib:[UINib nibWithNibName:@"HomeYouLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeYouLikeCollectionViewCellID"];
    
    // 注册头视图
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerKing"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader1"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader2"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader3"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader4"];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _collection.mj_header.automaticallyChangeAlpha = YES;
    
    NSArray *butArr = @[@"导航-首页拷贝",@"fenleihei",@"gouwuhei",@"wodehei"];
    NSArray *butArr1 = @[@"首页",@"分类",@"购物车",@"我的"];

    for (int i=0; i<4; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/4*i, UIScreenH-44*MYWIDTH, UIScreenW/4, 44*MYWIDTH)];
        [but setImage:[UIImage imageNamed:butArr[i]] forState:UIControlStateNormal];
        [but setTitle:butArr1[i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:11];
        but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [but setTitleEdgeInsets:UIEdgeInsetsMake(but.imageView.frame.size.height+10 ,-but.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [but setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,but.titleLabel.bounds.size.height, -but.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
        but.tag = i;
        [but addTarget:self action:@selector(tabbarBut:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
    }
}
- (void)tabbarBut:(UIButton*)but{
    switch (but.tag) {
        case 1:
        {
            FeiLeiShopViewController *fenlei = [[FeiLeiShopViewController alloc]init];
            [self.navigationController pushViewController:fenlei animated:YES];
            break;
        }
        case 2:
        {
            ShopCarViewController *ShopCar = [[ShopCarViewController alloc]init];
            [self.navigationController pushViewController:ShopCar animated:YES];
            break;
        }
        case 3:
        {
            MenuViewController *Menu = [[MenuViewController alloc]init];
            [self.navigationController pushViewController:Menu animated:YES];
            break;
        }
            
        default:
            break;
    }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"HomeYouLikeCollectionViewCellID";
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"NewShopCollectionViewCell" bundle: [NSBundle mainBundle]];
    [_collection registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    NewShopCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //[self framAdd:cell];
    
    HomeFavorableModel* model;
    if (indexPath.section==1) {
        if (_favorableDataArray.count!=0) {
            model = _favorableDataArray[indexPath.row];
        }
    }else if (indexPath.section==2){
        if (_hotProDataArray.count!=0) {
            model = _hotProDataArray[indexPath.row];
            
        }
    }else if (indexPath.section==3){
        if (_youLikeDataArray.count!=0) {
            model = _youLikeDataArray[indexPath.row];
        }
    }
    model.proname = [self convertNull:model.proname];
    model.price = [self convertNull:model.price];
    model.price_jf = [self convertNull:model.price_jf];
    
    cell.titleLabel.text = nil;
    cell.imgView.image = nil;
    cell.priceLabel.text = nil;
    cell.jifenLabel.text = nil;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.proname];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥: %@",model.price];
    cell.priceLabel.textColor = UIColorFromRGB(0xFF0000);
    cell.jifenLabel.textColor = UIColorFromRGB(0xFF0000);
    cell.jifenLabel.text = [NSString stringWithFormat:@"积: %@",model.price_jf];

    
    NSString* url = _Environment_Domain;
    //NSLog(@"%@",[NSString stringWithFormat:@"%@/%@%@",url,model.folder,model.autoname]);
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",url,model.prodpic]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    
    return cell;
    
}


//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

//- (void)framAdd:(id)sender
//{
//    CALayer *layer = [sender layer];
//    layer.borderColor = SecondBackGorundColor.CGColor;
//    layer.borderWidth = .5f;
//
//}

-(NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //400*kScreen_Width/714
    return CGSizeMake(UIScreenW/2, (UIScreenW/2-8)*6/5);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section==0) {
        if (IsIphone5S) {
            return CGSizeMake(UIScreenW,150*MYWIDTH+100);
        }else if (IsIphone6){
            return CGSizeMake(UIScreenW,150*MYWIDTH+120);
        }else if (IsIphone6P){
            return CGSizeMake(UIScreenW,150*MYWIDTH+130);
        }
    }
    return CGSizeMake(kScreenWidth,50+200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else if (section==1){
        if (_favorableDataArray.count<4) {
            return _favorableDataArray.count;
        }
    }else if (section==2){
        if (_hotProDataArray.count<4) {
            return _hotProDataArray.count;
        }
    }else if (section==3){
        if (_youLikeDataArray.count<4) {
            return _youLikeDataArray.count;
        }
    }
    
    return 8;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

#pragma mark ----- 重用的问题
    
    if (indexPath.section==0) {
        
        UICollectionReusableView *header;
        if (header==nil) {
            header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerKing" forIndexPath:indexPath];
        }
        header.backgroundColor = [UIColor whiteColor];
        for (UIView *view in header.subviews) { [view removeFromSuperview]; }
        
        UIView *headview;
        if (headview==nil) {
            if (IsIphone5S) {
                headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,150*MYWIDTH+100)];
            }else if (IsIphone6){
                headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,150*MYWIDTH+120)];
            }else if (IsIphone6P){
                headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,150*MYWIDTH+130)];
            }
            
            [header addSubview:headview];
        }
        //banner
        // 情景二：采用网络图片实现
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
        for (NSDictionary* dic in _bannerDataArray) {
            NSString *serverAddress = _Environment_Domain;
            NSString* imageurl = [NSString stringWithFormat:@"%@/%@%@",serverAddress,[dic objectForKey:@"folder"],[dic objectForKey:@"autoname"]];
            [imagesURLStrings addObject:imageurl];
            
        }
        
        // 网络加载 --- 创建带标题的图片轮播器
        self.cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 150*MYWIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        self.cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView2.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
        [headview addSubview:self.cycleScrollView2];
        self.cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
        
        //
        NSArray *imagearr = @[@"img_huodishangchengfenlei1",@"img_huodishangchengfenlei2",@"img_huodishangchengfenlei3"];
        for (int i = 0; i<[_typeDataArray count]; i++) {
            NSInteger index = i % 3;
            NSInteger page = i / 3;
            
            UIImageView *butimage = [[UIImageView alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space+30)+_cycleScrollView2.bottom+10, Button_Width, Button_Height)];
            butimage.image = [UIImage imageNamed:imagearr[i]];
            butimage.tag = 10+i;
            butimage.userInteractionEnabled = YES;
            [butimage setContentScaleFactor:[[UIScreen mainScreen] scale]];
            butimage.contentMode =  UIViewContentModeScaleAspectFit;
            butimage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            butimage.clipsToBounds  = YES;
            [headview addSubview:butimage];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
            [butimage addGestureRecognizer:tapRecognizer];
            
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, butimage.bottom, Button_Width, 30)];
            but.tag = i;
            [but setTitle:[_typeDataArray[i] objectForKey:@"name"] forState:UIControlStateNormal];
            but.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
            but.titleLabel.font = [UIFont systemFontOfSize:14];
            [but setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            but.tag = 300+i;
            [but addTarget:self action:@selector(Classbut:) forControlEvents:UIControlEventTouchUpInside];
            [headview addSubview:but];
        }
        UIView* line1;
        if (IsIphone5S) {
            line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _cycleScrollView2.bottom+92, kScreenWidth, 8)];
        }else if (IsIphone6){
            line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _cycleScrollView2.bottom+112, kScreenWidth, 8)];
        }else if (IsIphone6P){
            line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _cycleScrollView2.bottom+122, kScreenWidth, 8)];
        }
        line1.backgroundColor = UIColorFromRGB(0xEFEFEF);
        [headview addSubview:line1];

        return header;
        
    }
    UICollectionReusableView *headerheader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"headerheader%zd",indexPath.section] forIndexPath:indexPath];
    
    headerheader.backgroundColor = [UIColor whiteColor];
    for (UIView *view in headerheader.subviews) { [view removeFromSuperview]; }
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 1)];
    xian.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [headerheader addSubview:xian];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
    lab.font = [UIFont systemFontOfSize:14];
    [headerheader addSubview:lab];
    lab.text = @"";
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW-35, 17, 25, 4)];
    image.image = [UIImage imageNamed:@"more"];
    [headerheader addSubview:image];
    
    UIImageView *banner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, UIScreenW, 200)];
    [headerheader addSubview:banner];
    
    if (_headerImageArray.count&&indexPath.section!=0) {
        
        NSString *serverAddress = _Environment_Domain;
        NSString* imageurl = [NSString stringWithFormat:@"%@/%@%@",serverAddress,[_headerImageArray[indexPath.section-1] objectForKey:@"folder"],[_headerImageArray[indexPath.section-1] objectForKey:@"autoname"]];
        [banner sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:nil];
    }
    
    
    if (indexPath.section==1) {
        lab.text = @"特惠产品";
    }else if (indexPath.section==2){
        lab.text = @"热卖产品";
    }else if (indexPath.section==3){
        lab.text = @"猜你喜欢";
    } 
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 40+200)];
    but.tag = indexPath.section+170;
    [but addTarget:self action:@selector(typebut:) forControlEvents:UIControlEventTouchUpInside];
    but.tag = 200+indexPath.section;
    [headerheader addSubview:but];
    return headerheader;
}
- (void)typebut:(UIButton *)but{
    
    ZongheViewController *ZongheVi = [[ZongheViewController alloc]init];
    ZongheVi.souStr = @"";
    ZongheVi.prodtype = [NSString stringWithFormat:@"%ld",but.tag-201];
    [self.navigationController pushViewController:ZongheVi animated:YES];
}
- (void)Classbut:(UIButton *)but{
    FeiLeiShopViewController *fenlei = [[FeiLeiShopViewController alloc]init];
    fenlei.selectedIndexs = but.tag-300;
    [self.navigationController pushViewController:fenlei animated:YES];
}
- (void)SingleTap:(UITapGestureRecognizer*)recognizer  {
    FeiLeiShopViewController *fenlei = [[FeiLeiShopViewController alloc]init];
    fenlei.selectedIndexs = recognizer.view.tag-10;
    [self.navigationController pushViewController:fenlei animated:YES];
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeFavorableModel* model;
    if (indexPath.section==1) {
        if (_favorableDataArray.count!=0) {
            model = _favorableDataArray[indexPath.row];
        }
    }else if (indexPath.section==2){
        if (_hotProDataArray.count!=0) {
            model = _hotProDataArray[indexPath.row];
            
        }
    }else if (indexPath.section==3){
        if (_youLikeDataArray.count!=0) {
            model = _youLikeDataArray[indexPath.row];
        }
    }
    
    DetailsViewController *detailsVc = [[DetailsViewController alloc]init];
    detailsVc.id = model.id;
    detailsVc.type = @"1";
    [self.navigationController pushViewController:detailsVc animated:YES];
    
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == self.cycleScrollView2) {
        //        NSLog(@"---点击了专题第%ld张图片", (long)index);
        if (!IsEmptyValue(_bannerDataArray)&&_bannerDataArray.count>index) {
            
        }
        
    }
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
        ZongheViewController *ZongheVi = [[ZongheViewController alloc]init];
        ZongheVi.souStr = _search.text;
        ZongheVi.prodtype = @"";
        [self.navigationController pushViewController:ZongheVi animated:YES];
    }
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
}

//搜索按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_search resignFirstResponder];// 放弃第一响应者
    if (!IsEmptyValue(_search.text)) {
        ZongheViewController *ZongheVi = [[ZongheViewController alloc]init];
        ZongheVi.souStr = _search.text;
        ZongheVi.prodtype = @"";
        [self.navigationController pushViewController:ZongheVi animated:YES];
    }
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
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
   
