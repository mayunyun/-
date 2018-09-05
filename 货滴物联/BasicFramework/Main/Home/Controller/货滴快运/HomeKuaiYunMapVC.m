//
//  HomeKuaiYunMapVC.m
//  BasicFramework
//
//  Created by LONG on 2018/2/2.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "HomeKuaiYunMapVC.h"
#import "WuLiuSeaPolTableViewCell.h"
#import "SYCitySelectionController.h"
@interface HomeKuaiYunMapVC ()<MAMapViewDelegate, AMapLocationManagerDelegate,AMapSearchDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    MAPointAnnotation *annotation;
    UIButton * _locationBut;
    UILabel *_mapLab;
    UITextView *_addressView;
    NSString *_province;//省
    NSString *_city;    //市
    NSString *_county;  //县
    
    UIImageView *_OK;
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic, strong)NSString *mapStr;
@property (nonatomic, assign)CLLocationCoordinate2D locationStr;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong)NSMutableArray *poiAnnotations;

@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UITableView *tableview;

@end

@implementation HomeKuaiYunMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.poiAnnotations = [[NSMutableArray alloc]init];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240*MYWIDTH, 35)];
    titleView.backgroundColor = [UIColor whiteColor];
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, titleView.height)];
    xian.backgroundColor = UIColorFromRGBValueValue(0xeeeeee);
    [titleView addSubview:xian];
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(titleView.width-1, 0, 1, titleView.height)];
    xian1.backgroundColor = UIColorFromRGBValueValue(0xeeeeee);
    [titleView addSubview:xian1];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(1, 0, titleView.width-2, titleView.height)];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"输入市/区/地址";
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
    if ([self.type isEqualToString:@"1"]) {
        [newBut setTitle:@"确认终点" forState:UIControlStateNormal];
    }else{
        [newBut setTitle:@"确认起点" forState:UIControlStateNormal];
    }
    newBut.titleLabel.font = [UIFont systemFontOfSize:20];
    [newBut addTarget:self action:@selector(newButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBut];
    
    [self initMapView];
    [self configLocationManager];
    [self bgView];
    
    
    
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
}
- (void)newButClick:(UIButton *)but{
    if ([self.type isEqualToString:@"1"] && [[Command convertNull:self.mapStr] isEqualToString:@""]) {
        jxt_showAlertTitle(@"请选择送达终点");
        return;
    }else if([self.type isEqualToString:@"0"] && [[Command convertNull:self.mapStr] isEqualToString:@""]){
        jxt_showAlertTitle(@"请选择发货起点");
        return;
    }
    NSString *addressStr;
    //if ([_addressView.text isEqualToString:@"填写详情地址"]) {
        addressStr = self.mapStr;
//    }else{
//        addressStr = [NSString stringWithFormat:@"%@ %@",self.mapStr,_addressView.text];
//    }
    NSString *moren;
    if (_OK.hidden) {
        moren = @"0";
    }else{
        moren = @"1";
    }
    if (_zhongdianBlock) {
        _zhongdianBlock(addressStr,self.locationStr,_province,_city,_county,moren);
    }
    if (_qidianBlock) {
        _qidianBlock(addressStr,self.locationStr,_province,_city,_county,moren);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
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
        _mapView.logoCenter = CGPointMake(30, 10);
        _mapView.scaleOrigin= CGPointMake(70 , -5);  //设置比例尺位置
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
        
        _addressView = [[UITextView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _mapView.height-125*MYWIDTH, _mapView.width-30*MYWIDTH, 80*MYWIDTH)];
        _addressView.delegate = self;
        _addressView.layer.borderWidth = 0.5;
        _addressView.layer.borderColor = UIColorFromRGB(0x444444).CGColor;
        _addressView.backgroundColor = [UIColor whiteColor];
        _addressView.text = @"填写详情地址";
        _addressView.textColor = [UIColor blackColor];
        //[_mapView addSubview:_addressView];
        
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _mapView.height-45*MYWIDTH, _mapView.width-30*MYWIDTH, 45*MYWIDTH)];
        bgview.backgroundColor = [UIColor whiteColor];
        [_mapView addSubview:bgview];
        
        UIImageView *duihao = [[UIImageView alloc]initWithFrame:CGRectMake(14*MYWIDTH, 14*MYWIDTH, 16*MYWIDTH, 16*MYWIDTH)];
        duihao.image = [UIImage imageNamed:@"shehzimoren"];
        [bgview addSubview:duihao];
        
        _OK = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 13*MYWIDTH, 20*MYWIDTH, 17*MYWIDTH)];
        _OK.image = [UIImage imageNamed:@"duihaohou"];
        _OK.hidden = YES;
        [bgview addSubview:_OK];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(duihao.right+10, 0, 200, bgview.height)];
        if ([self.type isEqualToString:@"1"]) {
            title.text = @"存为常用收货终点";
        }else{
            title.text = @"存为常用发货起点";
        }
        title.textColor = UIColorFromRGB(0x333333);
        title.font = [UIFont systemFontOfSize:13];
        [bgview addSubview:title];
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bgview.width, bgview.height)];
        [but addTarget:self action:@selector(hiderOKClick) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:but];
        //添加手势，为了关闭键盘的操作
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tap1.cancelsTouchesInView = NO;
        [self.mapView addGestureRecognizer:tap1];
    }
}
- (void)hiderOKClick{
    if (_OK.hidden) {
        _OK.hidden = NO;
    }else{
        _OK.hidden = YES;
    }
}
- (void)configLocationManager
{
    annotation = [[MAPointAnnotation alloc] init];
    
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
            if (self.location.latitude!=0) {
                [_mapView setCenterCoordinate:self.location animated:YES];
            }else{
                [_mapView setCenterCoordinate:location.coordinate animated:YES];
            }
            [_locationBut setTitle:regeocode.city forState:UIControlStateNormal];
//            AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
//            dist.keywords = [NSString stringWithFormat:@"%@",regeocode.city];
//            dist.requireExtension = YES;
//            [self.search AMapDistrictSearch:dist];
            
        }
        
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.mapView.width - 20*MYWIDTH) / 2, self.mapView.height/2-35*MYWIDTH, 20*MYWIDTH, 35*MYWIDTH)];

    if ([self.type isEqualToString:@"0"]) {
        imageView.image = [UIImage imageNamed:@"qidian"];
    }else{
        imageView.image = [UIImage imageNamed:@"zhongdian"];
    }
    [self.mapView addSubview:imageView];
    
    UIImageView *mapimageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.mapView.width - 200) / 2, self.mapView.height/2 - 125, 200, 80)];
    
    mapimageView.image = [UIImage imageNamed:@"气泡"];
    [self.mapView addSubview:mapimageView];
    
    _mapLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, mapimageView.width-10, mapimageView.height-10)];
    _mapLab.font = [UIFont systemFontOfSize:13];
    _mapLab.textColor = UIColorFromRGBValueValue(0x333333);
    _mapLab.numberOfLines = 0;
    [mapimageView addSubview:_mapLab];
}
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated

{
    
    MACoordinateRegion region;
    
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    
    region.center = centerCoordinate;
    self.locationStr = CLLocationCoordinate2DMake(centerCoordinate.latitude, centerCoordinate.longitude);
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
    
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        //NSString *result = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
        NSString *result = [NSString stringWithFormat:@"%@%@%@", response.regeocode.addressComponent.province,response.regeocode.addressComponent.city,response.regeocode.addressComponent.district];
        self.mapStr = result;
        _mapLab.text = result;
        _province = [NSString stringWithFormat:@"%@", response.regeocode.addressComponent.province];
        _city = [NSString stringWithFormat:@"%@", response.regeocode.addressComponent.city];
        _county = [NSString stringWithFormat:@"%@", response.regeocode.addressComponent.district];

    }
    else /* from drag search, update address */
    {
        
    }
}



- (void)dealloc
{
    [self cleanUpAction];
    
    self.completionBlock = nil;
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
    if (self.location.latitude!=0) {
        [_mapView setCenterCoordinate:self.location animated:YES];
        
    }else if (response.districts.count){
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

//以下两个代理方法可以防止键盘遮挡textview
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"填写详情地址"]) {
        textView.text = @"";
    }
    [UIView animateWithDuration:0.5f animations:^{
        
        kWindow.frame = CGRectMake(0, -UIScreenH/3-70*MYWIDTH, UIScreenW, UIScreenH);
    
    }];
}

//完成编辑的时候下移回来（只要把offset重新设为0就行了）
- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.3f animations:^{
        kWindow.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);
        
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
