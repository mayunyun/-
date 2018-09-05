//
//  FreeRideTripMapViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/8/22.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "FreeRideTripMapViewController.h"
//#import "ProvinceViewController.h"
#import "WuLiuSeaPolTableViewCell.h"
#import "SYCitySelectionController.h"
#import "CustomAnnotationView.h"

@interface FreeRideTripMapViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate,AMapSearchDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    //MAPointAnnotation *annotation;
    UIButton * _locationBut;
    CLLocationCoordinate2D touchMapCoordinate;
    int ip;
    NSMutableArray *_ipArr;
    NSMutableArray *_twoarr;
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic, strong)NSString *mapStr;
@property (nonatomic, strong)NSString *mapStrXXX;
@property (nonatomic, strong)NSString *mapStrTT;
@property (nonatomic, assign)CLLocationCoordinate2D locationStr;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong)NSMutableArray *poiAnnotations;

@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UITableView *tableview;

@end

@implementation FreeRideTripMapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ip = 1;
    _twoarr = [[NSMutableArray alloc]init];
    self.poiAnnotations = [[NSMutableArray alloc]init];
    _ipArr = [[NSMutableArray alloc]init];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240*MYWIDTH, 35)];
    titleView.backgroundColor = [UIColor whiteColor];
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, titleView.height)];
    xian.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [titleView addSubview:xian];
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(titleView.width-1, 0, 1, titleView.height)];
    xian1.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [titleView addSubview:xian1];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(1, 0, titleView.width-2, titleView.height)];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"点击搜索地址";
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.font = [UIFont systemFontOfSize:14];
    [searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIImage *image = [UIImage imageNamed: @"查询"];
    UIImageView *iView = [[UIImageView alloc] initWithImage:image];
    iView.frame = CGRectMake(0, 0, 14 , 14);
    searchField.leftView = iView;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    _locationBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBut addTarget:self action:@selector(leftToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [_locationBut setFrame:CGRectMake(0, 0, 120, 40)];
    [_locationBut setTitle:[user objectForKey:CITY] forState:UIControlStateNormal];
    _locationBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [_locationBut setTitleColor:UIColorFromRGBValueValue(0x555555) forState:UIControlStateNormal];
    CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _locationBut.frame = CGRectMake(5, 0, size1.width, size1.height);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataCity:) name:@"cityone" object:nil];
    
    
    UIButton *newBut = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bottom-55*MYWIDTH, kScreenWidth, 55*MYWIDTH)];
    newBut.backgroundColor = MYColor;
    [newBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBut setTitle:@"确认途径地点" forState:UIControlStateNormal];
    newBut.titleLabel.font = [UIFont systemFontOfSize:20];
    [newBut addTarget:self action:@selector(newButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBut];
    
    [self initMapView];
    
    [self bgView];
    
}
- (void)newButClick:(UIButton *)but{
    
    
    NSMutableArray *allarr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _ipArr) {
        
        NSArray *val = [dic allValues];
        [allarr addObject:val[0]];
    }
    NSLog(@"%@",allarr);
    if (_TJdidianBlock) {
        _TJdidianBlock(allarr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight-NavBarHeight-55*MYWIDTH)];
        [self.mapView setDelegate:self];
        [self.mapView setZoomLevel:12 animated:NO];
        [self.view addSubview:self.mapView];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
        
        [self addAnnotationWithCooordinate:_Qlocation tag:@"1100"];
        [self addAnnotationWithCooordinate:_Zlocation tag:@"1101"];
        
        //给_mapView添加手势
        UITapGestureRecognizer *lpress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_mapView addGestureRecognizer:lpress];

       
    }
}

- (void)longPress:(UITapGestureRecognizer*)gestureRecognizer{
    
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    touchMapCoordinate =
    [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
    

}
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        
        NSString *result = [NSString stringWithFormat:@"%@%@",response.regeocode.addressComponent.city,response.regeocode.addressComponent.district];
        self.mapStrTT = result;
        self.mapStr = [NSString stringWithFormat:@"%@%@%@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.city,response.regeocode.addressComponent.district];
        self.mapStrXXX = [NSString stringWithFormat:@"%@*%@*%@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.city,response.regeocode.addressComponent.district];
        [self addAnnotationWithCooordinate:touchMapCoordinate tag:[NSString stringWithFormat:@"%d",ip]];
        ip++;
    
    }
    else /* from drag search, update address */
    {
        
    }
}
-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate tag:(NSString *)tag
{
    MAPointAnnotation *annotationn = [[MAPointAnnotation alloc] init];
    annotationn.coordinate = coordinate;
    annotationn.title    = tag;
    annotationn.subtitle = @"";
    
    [self.mapView addAnnotation:annotationn];
    
    if ([tag isEqualToString:@"1100"]) {
        [_twoarr addObject:annotationn];
    }
    if ([tag isEqualToString:@"1101"]) {
        [_twoarr addObject:annotationn];
        [_mapView showAnnotations:_twoarr animated:YES];
    }
}


- (void)leftToLastViewController{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    _bgView.hidden = YES;
    //    ProvinceViewController *provc = [[ProvinceViewController alloc]init];
    //    provc.oneStr = @"1";
    //    [self.navigationController pushViewController:provc animated:YES];
    SYCitySelectionController *city = [SYCitySelectionController new];
    city.selectCity = ^(NSString *city) {
        NSLog(@"%@", city);
        [self getLoadDataCity:city];
    };
    city.hotCitys = @[@"北京市", @"济南市",@"上海市",@"深圳市",@"广州市",@"成都市",@"杭州市",@"武汉市"];
    city.openLocation = YES;
    
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:city];
    [self presentViewController:navi animated:YES completion:nil];
    
}
//- (void)getLoadDataCity:(NSNotification *)notifiation{

- (void)getLoadDataCity:(NSString *)userInfo{
    //NSLog(@"%@",notifiation.userInfo);
    [_locationBut setTitle:[NSString stringWithFormat:@"%@",userInfo] forState:UIControlStateNormal];
    CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _locationBut.frame = CGRectMake(5, 0, size1.width, size1.height);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];
    
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = [NSString stringWithFormat:@"%@",userInfo];
    dist.requireExtension = YES;
    [self.search AMapDistrictSearch:dist];
}
- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    
    if (response == nil)
    {
        return;
    }
    if (response.districts.count){
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(response.districts[0].center.latitude, response.districts[0].center.longitude) animated:YES];
    }else{
        jxt_showAlertOneButton(@"提示", @"定位地点错误", @"确定", ^(NSInteger buttonIndex) {
            
        });
    }
    
    //解析response获取行政区划，具体解析见 Demo
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    if(self.searchBar.text.length == 0) {
        return;
    }
    
    //[self searchPoiByKeyword:self.searchBar.text];
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if (theTextField.text.length>0) {
        [self searchPoiByKeyword:theTextField.text];
    }
}
- (void)searchPoiByKeyword:(NSString *)str{
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = str;
    request.city                = _locationBut.titleLabel.text;
    //request.types               = @"高等院校";
    request.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
    
    
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    for (AMapPOI *search in response.pois) {
        
        NSLog(@"%@,%@    %@",search.name,search.address,search.location);
    }
    
    self.poiAnnotations = [NSMutableArray arrayWithArray:response.pois];
    
    _bgView.hidden = NO;
    [_tableview reloadData];
    
}


- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight-NavBarHeight)];
        _bgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bgView];
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(60*MYWIDTH, 0, 260, kScreenHeight/2)];
        _tableview.layer.cornerRadius = 1.0;
        _tableview.layer.borderColor = UIColorFromRGBValueValue(0x555555).CGColor;
        _tableview.layer.borderWidth = 0.5f;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor whiteColor];
        [_tableview registerClass:[WuLiuSeaPolTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WuLiuSeaPolTableViewCell class])];
        
        [_bgView addSubview:_tableview];
        
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, _tableview.bottom, kScreenWidth, kScreenHeight/2)];
        [but addTarget:self action:@selector(imgViewTapClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:but];
        _bgView.hidden = YES;
        
        UIButton *but1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _tableview.left, kScreenHeight/2)];
        [but1 addTarget:self action:@selector(imgViewTapClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:but1];
        
        UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(_tableview.right, 0, kScreenWidth-_tableview.right, kScreenHeight/2)];
        [but2 addTarget:self action:@selector(imgViewTapClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:but2];
        _bgView.hidden = YES;
        
    }
    return _bgView;
    
}
- (void)imgViewTapClick{
    _bgView.hidden = YES;
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.poiAnnotations.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Class ZuLinCarClass = [WuLiuSeaPolTableViewCell class];
    WuLiuSeaPolTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    if (self.poiAnnotations.count) {
        AMapPOI *search = self.poiAnnotations[indexPath.row];
        [cell setDataCity:search.name Address:search.address];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    _bgView.hidden = YES;
    AMapPOI *search = self.poiAnnotations[indexPath.row];
    self.searchBar.text = search.name;
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(search.location.latitude, search.location.longitude) animated:YES];
    [self.mapView setZoomLevel:18 animated:NO];
    
}
#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.strokeColor = [UIColor blueColor];
        polylineRenderer.lineWidth   = 5.f;
        polylineRenderer.lineDashType = kMALineDashTypeNone;
        
        
        return polylineRenderer;
    }
    
    return nil;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation.title isEqualToString:@"当前位置"]) {
        return nil;
    }

    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = NO;
            annotationView.userInteractionEnabled = YES;
        
        }
        
        if ([annotation.title isEqualToString:@"1100"]) {
            
            annotationView.name     = @"起点";
            annotationView.portrait = [UIImage imageNamed:@"定位绿"];
        }else if([annotation.title isEqualToString:@"1101"]){
            annotationView.name     = @"终点";
            annotationView.portrait = [UIImage imageNamed:@"定位红"];
            
        }else{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(0.f, 0, 60*MYWIDTH, 55*MYWIDTH);
            [btn addTarget:self action:@selector(longPressClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = ip;
            [annotationView addSubview:btn];
            
            annotationView.tag = ip+10000;
            annotationView.name     = self.mapStrTT;
            annotationView.portrait = [UIImage imageNamed:@"wtc"];
            [_mapView removeAnnotation:annotation];
            NSDictionary *dict = @{@"lat":[NSString stringWithFormat:@"%f",touchMapCoordinate.latitude],@"lon":[NSString stringWithFormat:@"%f",touchMapCoordinate.longitude],@"waytocitysshow":self.mapStrTT,@"waytocitys":self.mapStr,@"waytocitystemp":self.mapStrXXX};
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:dict forKey:[NSString stringWithFormat:@"%d",ip]];
            [_ipArr addObject:dic];
            
        }
    
        
        
        return annotationView;
    }
    
    return nil;
}
- (void)longPressClick:(UIButton *)but{
    CustomAnnotationView *annotationView = [_mapView viewWithTag:but.tag+10000];
    [annotationView removeFromSuperview];
    
    int i=0;
    for (NSDictionary *dic in _ipArr) {
        if ([dic objectForKey:[NSString stringWithFormat:@"%d",but.tag]]) {
            [_ipArr removeObjectAtIndex:i];
            return;
        }
        i++;
    }
   
    
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
