//
//  ErSCshopViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/7/16.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ErSCshopViewController.h"
#import "ErSCCollectionViewCell.h"
#import "ErSCModel.h"
#import "ErSCshopDateViewController.h"
#import "MyErSCViewController.h"
#import "DWTagView.h"

@interface ErSCshopViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DWTagViewDelegate, DWTagViewDataSource>
@property(nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView2;

@end

@implementation ErSCshopViewController
{
    NSMutableArray* _bannerDataArray;
    NSMutableArray* _DataArray;
    UIButton *_oneBut;
    UIButton *_twoBut;
    UIButton *_threeBut;
    UIView *_bgView;
    NSMutableArray *_arr;
    DWTagView *_typeview;
    NSString*_type1;
    NSString *_sprovince;
    NSString *_cartypenames;
    NSString *_car_brand_name;
    
    NSArray *_brandnameArr;
    UIView *_alicteView1;
    
    
    NSArray *_carTypeArr;
    UIView *_alicteView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bannerDataArray = [[NSMutableArray alloc]init];
    _DataArray = [[NSMutableArray alloc]init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _sprovince = [user objectForKey:CITY];
    _cartypenames = @"车型";
    _car_brand_name = @"品牌";
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLab.text = @"二手车市场";
    titleLab.textColor = [UIColor redColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    
    UIButton *button = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(UIScreenW - 70, 10, 50, 40);
    [button setTitle:@"我的" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = right;
    
    [self dataRequest];
    [self loadNewsearchKuaiyunCartype];
    [self selectPubSechancarBrand];
    [self creatUI];
}
-(void)addNext{
    MyErSCViewController *myersh = [[MyErSCViewController alloc]init];
    myersh.arr = _bannerDataArray;
    [self.navigationController pushViewController:myersh animated:YES];
}
- (void)dataRequest{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *URLStr = @"/mbtwz/secondhandcar?action=selectSecondhandcarIndex";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"region\":\"%@\"}",[user objectForKey:CITY]]};
    _sprovince = [user objectForKey:CITY];
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            _bannerDataArray = [NSMutableArray arrayWithArray:[[dic objectForKey:@"response"][0] objectForKey:@"toppic"]];
            
//            for (NSDictionary* dict in [[dic objectForKey:@"response"][0] objectForKey:@"secondhandcarList"]) {
//                ErSCModel* model = [[ErSCModel alloc]init];
//                [model setValuesForKeysWithDictionary:dict];
//                [_DataArray addObject:model];
//            }
            [self loadNewData];
        }
        [_collection reloadData];
    }];
    
}
- (void)loadNewData{
    self.collection.scrollEnabled = YES;
    
    NSString *typenames;
    NSString *brand_name;
    NSString *province;
    
    if ([_sprovince isEqualToString:@"全国"]) {
        province = @"";
    }else{
        province = _sprovince;
    }
    if ([_cartypenames isEqualToString:@"车型"]) {
        typenames = @"";
    }else{
        typenames = _cartypenames;
    }
    if ([_car_brand_name isEqualToString:@"品牌"]) {
        brand_name = @"";
    }else{
        brand_name = _car_brand_name;
    }
    NSString *URLStr = @"/mbtwz/secondhandcar?action=searchSecondhandcarListByPage";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"region\":\"%@\",\"brand_name\":\"%@\",\"type_name\":\"%@\"}",province,typenames,brand_name]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        _DataArray = [[NSMutableArray alloc]init];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            
            for (NSDictionary* dict in [dic objectForKey:@"response"]) {
                ErSCModel* model = [[ErSCModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_DataArray addObject:model];
            }
        }
        [_collection reloadData];
    }];
    
}
- (void)creatUI
{
    
    
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize =CGSizeMake(UIScreenW, UIScreenH);
    
    _collection =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH) collectionViewLayout:layout];
    //    if (statusbarHeight>20) {
    //        layout.headerReferenceSize =CGSizeMake(UIScreenW, UIScreenH-88);
    //        _collection.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-88);
    //    }
    _collection.delegate =self;
    _collection.dataSource =self;
    _collection.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:_collection];
    
    [_collection registerNib:[UINib nibWithNibName:@"ErSCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ErSCCollectionViewCellID"];
    
    // 注册头视图
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerKing"];
    
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _collection.mj_header.automaticallyChangeAlpha = YES;
    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, statusbarHeight+44)];
    topview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topview];
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"ErSCCollectionViewCellID";
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"ErSCCollectionViewCell" bundle: [NSBundle mainBundle]];
    [_collection registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    ErSCCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //[self framAdd:cell];
    
    ErSCModel* model;
    if (_DataArray.count!=0) {
        model = _DataArray[indexPath.row];
    }
    model.title = [Command convertNull:model.title];
    model.price = [Command convertNull:model.price];
    model.car_type_name = [Command convertNull:model.car_type_name];
    
    cell.titleLabel.text = nil;
    cell.imgView.image = nil;
    cell.priceLabel.text = nil;
    cell.otherLab.text = nil;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
    cell.priceLabel.textColor = UIColorFromRGB(0xFF0000);
    cell.otherLab.textColor = UIColorFromRGB(0x666666);
    cell.otherLab.text = [NSString stringWithFormat:@" %@",model.car_type_name];
    
    
    NSString* url = _Environment_Domain;
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",url,model.erscarpic]);
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",url,model.erscarpic]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    
    return cell;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //400*kScreen_Width/714
    return CGSizeMake(UIScreenW/2-20*MYWIDTH, (UIScreenW/2-20*MYWIDTH)*4/3-10*MYWIDTH);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth,170*MYWIDTH+35);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10*MYWIDTH, 10*MYWIDTH, 10*MYWIDTH, 10*MYWIDTH);
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return _DataArray.count;
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
            headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,170*MYWIDTH+35)];
            
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
        self.cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 170*MYWIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        self.cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView2.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
        [headview addSubview:self.cycleScrollView2];
        self.cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
        
        //
        
        _oneBut = [[UIButton alloc]initWithFrame:CGRectMake(0, self.cycleScrollView2.bottom, UIScreenW/3-0.5, 34)];
        [_oneBut addTarget:self action:@selector(oneClick) forControlEvents:UIControlEventTouchUpInside];
        [_oneBut setTitle:_sprovince forState:UIControlStateNormal];
        [_oneBut setImage:[UIImage imageNamed:@"ssx_jt"] forState:UIControlStateNormal];
        [self setmodelBut:_oneBut];
        [_oneBut setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _oneBut.titleLabel.font = [UIFont systemFontOfSize:13];
        [header addSubview:_oneBut];
        _twoBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/3+0.5, self.cycleScrollView2.bottom, UIScreenW/3-1, 34)];
        [_twoBut addTarget:self action:@selector(twoClick) forControlEvents:UIControlEventTouchUpInside];
        [_twoBut setTitle:_car_brand_name forState:UIControlStateNormal];
        [_twoBut setImage:[UIImage imageNamed:@"ssx_jt"] forState:UIControlStateNormal];
        [self setmodelBut:_twoBut];
        [_twoBut setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _twoBut.titleLabel.font = [UIFont systemFontOfSize:13];
        [header addSubview:_twoBut];
        _threeBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/3*2+0.5, self.cycleScrollView2.bottom, UIScreenW/3-0.5, 34)];
        [_threeBut addTarget:self action:@selector(threeClick) forControlEvents:UIControlEventTouchUpInside];
        [_threeBut setTitle:_cartypenames forState:UIControlStateNormal];
        [_threeBut setImage:[UIImage imageNamed:@"ssx_jt"] forState:UIControlStateNormal];
        [self setmodelBut:_threeBut];
        [_threeBut setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_threeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _threeBut.titleLabel.font = [UIFont systemFontOfSize:13];
        [header addSubview:_threeBut];
        
        return header;
        
    }
    
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ErSCModel* model = _DataArray[indexPath.row];
    
    ErSCshopDateViewController *ersc = [[ErSCshopDateViewController alloc]init];
    ersc.selectid = model.id;
    [self.navigationController pushViewController:ersc animated:YES];
    
    
}

- (void)setmodelBut:(UIButton *)modelButton{
    // 交换button中title和image的位置
    CGFloat labelWidth = modelButton.titleLabel.intrinsicContentSize.width; //注意不能直接使用titleLabel.frame.size.width,原因为有时候获取到0值
    CGFloat imageWidth = modelButton.imageView.frame.size.width;
    CGFloat space = 4.f; //定义两个元素交换后的间距
    modelButton.titleEdgeInsets = UIEdgeInsetsMake(0, - imageWidth - space,0,imageWidth + space);
    modelButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space, 0,  -labelWidth - space);
    
}
- (void)oneClick{
    [self.collection setContentOffset:CGPointMake(0,170*MYWIDTH-44-statusbarHeight) animated:YES];
    self.collection.scrollEnabled =NO;
    [_oneBut setTitleColor:MYColor forState:UIControlStateNormal];
    [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_threeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bgView removeFromSuperview];
    [_alicteView removeFromSuperview];
    _bgView = nil;
    _alicteView = nil;
    _type1 = @"1";
    NSString *URLStr = @"/mbtwz/address?action=loadProvince";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        _arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"城市地址%@",_arr);
        NSDictionary *dic = @{@"areaname":@"全国"};
        [_arr insertObject:dic atIndex:0];
        if (_arr.count) {
            [self creatUI1];
            
        }
        
    }];
}
- (void)twoClick{
    [self.collection setContentOffset:CGPointMake(0,170*MYWIDTH-44-statusbarHeight) animated:YES];
    self.collection.scrollEnabled =NO;
    
    if (_alicteView1) {
        [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_alicteView1 removeFromSuperview];
        _alicteView1 = nil;
        self.collection.scrollEnabled = YES;
        return;
    }
    [_twoBut setTitleColor:MYColor forState:UIControlStateNormal];
    [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_threeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bgView removeFromSuperview];
    [_alicteView removeFromSuperview];
    [_alicteView1 removeFromSuperview];
    _bgView = nil;
    _alicteView = nil;
    _alicteView1 = nil;
    
    [self typeCarButClick1];
}
- (void)threeClick{
    [self.collection setContentOffset:CGPointMake(0,170*MYWIDTH-44-statusbarHeight) animated:YES];
    self.collection.scrollEnabled =NO;
    
    if (_alicteView) {
        [_threeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_alicteView removeFromSuperview];
        _alicteView = nil;
        self.collection.scrollEnabled = YES;
        return;
    }
    [_threeBut setTitleColor:MYColor forState:UIControlStateNormal];
    [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bgView removeFromSuperview];
    [_alicteView removeFromSuperview];
    [_alicteView1 removeFromSuperview];
    
    _bgView = nil;
    _alicteView = nil;
    _alicteView1 = nil;
    
    [self typeCarButClick];
}
- (void)creatUI1{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 99, UIScreenW, UIScreenH)];
    if (statusbarHeight>20) {
        _bgView.frame = CGRectMake(0, 88+35, UIScreenW, UIScreenH);
    }
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _typeview = [[DWTagView alloc] init];
    _typeview.frame = CGRectMake(0, 1, UIScreenW, _bgView.height-2);
    _typeview.themeColor = [UIColor whiteColor];
    _typeview.backgroundColor = [UIColor whiteColor];
    _typeview.tagCornerRadius = 0;
    _typeview.dataSource = self;
    _typeview.delegate = self;
    _typeview.numer = 5;
    [_bgView addSubview:_typeview];
}
- (NSInteger)DWnumOfItemstagView:(DWTagView *)tagView  {
    
    if (_typeview == tagView){
        return _arr.count;
    }
    return 0;
}

- (NSString *)DWtagView:(DWTagView *)tagView titleForItemAtIndex:(NSInteger)index {
    if (_typeview == tagView){
        return [_arr[index] objectForKey:@"areaname"];
    }
    return nil;
}
- (void)DWtagView:(DWTagView *)tagView heightUpdated:(CGFloat)height{
    NSLog(@">>>>>>>???>>>>>%.2f",height);
    if (_typeview == tagView){
        
    }
}

- (void)DWtagView:(DWTagView *)tagView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@">>>>>>>???>>>>>%zd",index);
    
    if ([_type1 isEqualToString:@"1"]) {
        _type1 = @"2";
        if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全国"]) {
            _sprovince = @"全国";
            [_oneBut setTitle:@"全国" forState:UIControlStateNormal];
            [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self loadNewData];
            [_bgView removeFromSuperview];
            _bgView = nil;
        }else{
            _sprovince = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
            [_oneBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
        }
        [self setmodelBut:_oneBut];
        
        NSString *URLStr = @"/mbtwz/address?action=loadCity";
        NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"provinceid\":\"%@\"}",[_arr[index] objectForKey:@"areaid"]]};
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
            _arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"城市地址%@",_arr);
            NSDictionary *dic = @{@"areaname":@"全省"};
            [_arr insertObject:dic atIndex:0];
            if (_arr.count) {
                [_typeview reloadData];
            }
            
        }];
    }else if ([_type1 isEqualToString:@"2"]){
        _type1 = @"3";
        if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全省"]) {
            [_oneBut setTitle:_sprovince forState:UIControlStateNormal];
            [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self loadNewData];
            [_bgView removeFromSuperview];
            _bgView = nil;
        }else{
            _sprovince = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
            [_oneBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
        }
        [self setmodelBut:_oneBut];
        
        NSString *URLStr = @"/mbtwz/address?action=loadCountry";
        NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"cityid\":\"%@\"}",[_arr[index] objectForKey:@"areaid"]]};
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
            _arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"城市地址%@",_arr);
            NSDictionary *dic = @{@"areaname":@"全市"};
            [_arr insertObject:dic atIndex:0];
            if (_arr.count) {
                [_typeview reloadData];
            }
            
        }];
    }else if ([_type1 isEqualToString:@"3"]){
        if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全市"]) {
            [_oneBut setTitle:_sprovince forState:UIControlStateNormal];
        }else{
            _sprovince = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
            [_oneBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
        }
        [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setmodelBut:_oneBut];
        [self loadNewData];
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    
}
- (void)typeCarButClick{
    
    _alicteView = [[UIView alloc]initWithFrame:CGRectMake(0, 99, UIScreenW, UIScreenH-99)];
    if (statusbarHeight>20) {
        _alicteView.frame = CGRectMake(0, 88+35, UIScreenW, UIScreenH-88-35);
    }
    _alicteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_alicteView];
    
    
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _carTypeArr) {
        [arr addObject:[dic objectForKey:@"cartypename"]];
    }
    
    float w = (kScreenWidth-75*MYWIDTH)/4;
    float dowe = 0;
    for (int i=0; i<arr.count; i++) {
        UIButton *But = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH+i%4*(w+15*MYWIDTH),  20*MYWIDTH+i/4*55*MYWIDTH, w, 25*MYWIDTH)];
        [But setTitle:arr[i] forState:UIControlStateNormal];
        [But setTitle:arr[i] forState:UIControlStateSelected];
        [But setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [But setBackgroundColor:[UIColor whiteColor]];
        But.titleLabel.font = [UIFont systemFontOfSize:13*MYWIDTH];
        But.layer.cornerRadius = 3.0;
        But.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
        But.layer.borderWidth = 0.5f;//设置边框颜色
        But.tag = 1155+i;
        [But addTarget:self action:@selector(ButClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alicteView addSubview:But];
        
        if (i==arr.count-1) {
            dowe = But.bottom;
        }
    }
    
    UIButton *toumingBut = [[UIButton alloc]initWithFrame:CGRectMake(0, _alicteView.height-45*MYWIDTH, kScreenWidth, 45*MYWIDTH)];
    [toumingBut addTarget:self action:@selector(cartypeClick) forControlEvents:UIControlEventTouchUpInside];
    [toumingBut setBackgroundColor:MYColor];
    [toumingBut setTitle:@"确定" forState:UIControlStateNormal];
    [_alicteView addSubview:toumingBut];
}
- (void)ButClick:(UIButton *)but{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _carTypeArr) {
        [arr addObject:[dic objectForKey:@"cartypename"]];
    }
    for (int i=0; i<arr.count; i++) {
        UIButton *button = [_alicteView viewWithTag:1155+i];
        button.selected = NO;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
    but.selected = YES;
    [but setBackgroundColor:MYColor];
    but.layer.borderColor = MYColor.CGColor;
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
}
- (void)cartypeClick{
    
    NSMutableString *_carTypeStr;
    for (int i=0 ; i<_carTypeArr.count; i++) {
        UIButton *but = [_alicteView viewWithTag:1155+i];
        if (but.selected) {
            _carTypeStr = [NSMutableString stringWithFormat:@"%@,%@",_carTypeStr,[_carTypeArr[i] objectForKey:@"cartypename"]];
        }
    }
    [_carTypeStr deleteCharactersInRange:NSMakeRange(0, 7)];
    if (_carTypeStr.length>0) {
        _cartypenames = _carTypeStr;
        [_threeBut setTitle:_carTypeStr forState:UIControlStateNormal];
    }else{
        _cartypenames = @"";
        [_threeBut setTitle:@"车型" forState:UIControlStateNormal];
    }
    [_threeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setmodelBut:_threeBut];
    [self loadNewData];
    [_alicteView removeFromSuperview];
    _alicteView = nil;
}

- (void)typeCarButClick1{
    
    _alicteView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 99, UIScreenW, UIScreenH-99)];
    if (statusbarHeight>20) {
        _alicteView1.frame = CGRectMake(0, 88+35, UIScreenW, UIScreenH-88-35);
    }
    _alicteView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_alicteView1];
    
    
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _brandnameArr) {
        [arr addObject:[dic objectForKey:@"brandname"]];
    }
    
    float w = (kScreenWidth-75*MYWIDTH)/4;
    float dowe = 0;
    for (int i=0; i<arr.count; i++) {
        UIButton *But = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH+i%4*(w+15*MYWIDTH),  20*MYWIDTH+i/4*55*MYWIDTH, w, 25*MYWIDTH)];
        [But setTitle:arr[i] forState:UIControlStateNormal];
        [But setTitle:arr[i] forState:UIControlStateSelected];
        [But setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [But setBackgroundColor:[UIColor whiteColor]];
        But.titleLabel.font = [UIFont systemFontOfSize:13*MYWIDTH];
        But.layer.cornerRadius = 3.0;
        But.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
        But.layer.borderWidth = 0.5f;//设置边框颜色
        But.tag = 1255+i;
        [But addTarget:self action:@selector(ButClick1:) forControlEvents:UIControlEventTouchUpInside];
        [_alicteView1 addSubview:But];
        
        if (i==arr.count-1) {
            dowe = But.bottom;
        }
    }
    
    UIButton *toumingBut = [[UIButton alloc]initWithFrame:CGRectMake(0, _alicteView1.height-45*MYWIDTH, kScreenWidth, 45*MYWIDTH)];
    [toumingBut addTarget:self action:@selector(cartypeClick1) forControlEvents:UIControlEventTouchUpInside];
    [toumingBut setBackgroundColor:MYColor];
    [toumingBut setTitle:@"确定" forState:UIControlStateNormal];
    [_alicteView1 addSubview:toumingBut];
}
- (void)ButClick1:(UIButton *)but{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _brandnameArr) {
        [arr addObject:[dic objectForKey:@"brandname"]];
    }
    for (int i=0; i<arr.count; i++) {
        UIButton *button = [_alicteView1 viewWithTag:1255+i];
        button.selected = NO;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
    but.selected = YES;
    [but setBackgroundColor:MYColor];
    but.layer.borderColor = MYColor.CGColor;
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}
- (void)cartypeClick1{
    
    NSMutableString *_carTypeStr;
    for (int i=0 ; i<_brandnameArr.count; i++) {
        UIButton *but = [_alicteView1 viewWithTag:1255+i];
        if (but.selected) {
            _carTypeStr = [NSMutableString stringWithFormat:@"%@,%@",_carTypeStr,[_brandnameArr[i] objectForKey:@"brandname"]];
        }
    }
    [_carTypeStr deleteCharactersInRange:NSMakeRange(0, 7)];
    if (_carTypeStr.length>0) {
        _car_brand_name = _carTypeStr;
        [_twoBut setTitle:_carTypeStr forState:UIControlStateNormal];
    }else{
        _car_brand_name = @"";
        [_twoBut setTitle:@"车型" forState:UIControlStateNormal];
    }
    [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setmodelBut:_twoBut];
    [self loadNewData];
    [_alicteView1 removeFromSuperview];
    _alicteView1 = nil;
}
- (void)loadNewsearchKuaiyunCartype
{
    //快运 车型选择 查询接口
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=searchKuaiyunCartype";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        _carTypeArr = [[NSArray alloc]init];
        _carTypeArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
    }];
}
- (void)selectPubSechancarBrand
{
    // 车型选择 查询接口
    NSString *URLStr = @"/mbtwz/secondhandcar?action=selectPubSechancarBrand";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            _brandnameArr = [[NSArray alloc]initWithArray:[dic objectForKey:@"response"]];
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
