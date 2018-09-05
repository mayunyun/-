//
//  FreeRideTripReleaseVC.m
//  BasicFramework
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "FreeRideTripReleaseVC.h"
#import "WLMapViewController.h"
#import "FreeRideTripMapViewController.h"
@interface FreeRideTripReleaseVC()<AMapSearchDelegate,UITextFieldDelegate>
{
    CLLocationCoordinate2D _Qlocation;//起点
    CLLocationCoordinate2D _Zlocation;//终点
    NSString* _Saddress;
    NSString* _Eaddress;
    NSArray *_TJdidianArr;
    NSString *_QZmileage;//两点之间的距离
   
}
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation FreeRideTripReleaseVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self selDriverInfo];
}
- (void)selDriverInfo{
    NSString *url = @"/mbtwz/freeride?action=selDriverInfo";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"flag"] intValue]==200) {
    
            UITextField *name = [self.view viewWithTag:2000];
            UITextField *phone = [self.view viewWithTag:2001];
            name.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"response"][0] objectForKey:@"dname"]];
            phone.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"response"][0] objectForKey:@"dcall"]];

        }else{
            jxt_showAlertOneButton(@"提示", [NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]], @"返回", ^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    }];
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"货滴顺风车发布";
    self.view.backgroundColor = [UIColor whiteColor];
    _TJdidianArr = [[NSArray alloc]init];
    [self creatUI];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
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
- (void)creatUI{
    UIView* bView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusbarHeight+44, kScreenWidth, UIScreenH)];
    bView.backgroundColor = UIColorFromRGB(0xEEEEEE);;
    [self.view addSubview:bView];
    
    UIView* sView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, UIScreenH)];
    sView.backgroundColor = UIColorFromRGB(0xEEEEEE);;
    [bView addSubview:sView];
    NSArray* imageArray = @[@"司机姓名",@"输入电话",@"起点",@"终点",@"途径",@"总车长",@"总车长",@"行程发布时间"];
    NSArray* titleArray = @[@"姓名",@"电话",@"起点",@"终点",@"途径",@"总车长",@"可用车长",@"出发时间"];
    NSArray* pleaceArray =@[@"请输入姓名",@"请输入电话",@"请选择起点",@"请选择终点",@"请选择途径城市",@"请输入总车长",@"请输入可用车长",@""];
    for (int i=0; i < 8; i++) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, i*45, kScreenWidth, 45)];
        view.backgroundColor = [UIColor whiteColor];
        [sView addSubview:view];
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [view addSubview:line];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 15, 15)];
        imageView.tag = 1000+i;
        if (i < imageArray.count) {
            [imageView setImage:[UIImage imageNamed:imageArray[i]]];
        }
        [view addSubview:imageView];
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 10, imageView.top - 5, 80, imageView.height + 10)];
        if (i < titleArray.count) {
            titleLabel.text = titleArray[i];
        }
        titleLabel.font = [UIFont systemFontOfSize:16];
        [view addSubview:titleLabel];
        CGFloat fontF = 14;
        UIColor* mycolor = [UIColor grayColor];
        if (i == 0||i == 1) {
            UITextField* field = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, kScreenWidth - titleLabel.right, 44)];
            field.tag = 2000+i;
            field.font = [UIFont systemFontOfSize:fontF];
            field.placeholder = pleaceArray[i];
            [view addSubview:field];
        }else if (i == 2 || i == 3 || i == 4){
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(titleLabel.right, 0, kScreenWidth - titleLabel.right-20, 44);
            btn.tag = 2000+i;
            btn.titleLabel.font = [UIFont systemFontOfSize:fontF];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitle:pleaceArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:mycolor forState:UIControlStateNormal];
            [view addSubview:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView* rightimg = [[UIImageView alloc]initWithFrame:CGRectMake(btn.right, 10, 17, 20)];
            rightimg.image = [UIImage imageNamed:@"rightArrow"];
            [view addSubview:rightimg];
        }else if (i == 5 || i == 6){
            UITextField* field = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, kScreenWidth - titleLabel.right, 44)];
            field.tag = 2000+i;
            field.delegate = self;
            field.placeholder = pleaceArray[i];
            field.keyboardType = UIKeyboardTypeNumberPad;
            field.font = [UIFont systemFontOfSize:fontF];
            [view addSubview:field];
            UILabel* miLabel = [[UILabel alloc]initWithFrame:CGRectMake(field.width - 30, 10, 20, 20)];
            miLabel.text = @"米";
            miLabel.textColor = [UIColor grayColor];
            [field addSubview:miLabel];
        }else if (i == 7){
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(titleLabel.right, 0, kScreenWidth - titleLabel.right - 10, 44);
            btn.tag = 2000+i;
            btn.titleLabel.font = [UIFont systemFontOfSize:fontF];
            [btn setTitle:pleaceArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:mycolor forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [view addSubview:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
    }
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50);
    [nextBtn setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"发 布 行 程" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnClick:(UIButton*)sender{
    if (sender.tag - 2000 == 2) {
        WLMapViewController *map = [[WLMapViewController alloc]init];
        map.type = @"0";
        map.location = _Qlocation;
        [map setQidianBlock:^(NSString *strQD,CLLocationCoordinate2D location,NSString *saddress) {
            [sender setTitle:strQD forState:UIControlStateNormal];
            _Qlocation = location;
            _Saddress = saddress;
            [self onSearchDone];
        }];
        [self.navigationController pushViewController:map animated:YES];
    }else if (sender.tag - 2000 == 3) {
        WLMapViewController *map = [[WLMapViewController alloc]init];
        map.type = @"1";
        map.location = _Zlocation;
        [map setZhongdianBlock:^(NSString *strZD,CLLocationCoordinate2D location,NSString *eaddress) {
            [sender setTitle:strZD forState:UIControlStateNormal];
            _Zlocation = location;
            _Eaddress = eaddress;
            [self onSearchDone];
        }];
        [self.navigationController pushViewController:map animated:YES];
    }else if (sender.tag - 2000 == 4) {
        UIButton *qiBut = [self.view viewWithTag:2002];
        UIButton *zhongBut = [self.view viewWithTag:2003];
        if ([qiBut.titleLabel.text isEqualToString:@"请选择起点"]) {
            jxt_showToastTitle(@"请选择起点", 1);
            return;
        }
        if ([zhongBut.titleLabel.text isEqualToString:@"请选择终点"]){
            jxt_showToastTitle(@"请选择终点", 1);
            return;
        }
        FreeRideTripMapViewController*map = [[FreeRideTripMapViewController alloc]init];
        map.Qlocation = _Qlocation;
        map.Zlocation = _Zlocation;
        [map setTJdidianBlock:^(NSArray *arr) {
            _TJdidianArr = arr;
            NSString *str = @"";
            for (NSDictionary *dic in arr) {
                str = [NSString stringWithFormat:@"%@,%@",str,[dic objectForKey:@"waytocitysshow"]];
            }
            [sender setTitle:[str substringFromIndex:1] forState:UIControlStateNormal];
        }];
        [self.navigationController pushViewController:map animated:YES];

    }else if (sender.tag - 2000 == 7) {
            __weak typeof(self) weakSelf = self;
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *now = [NSDate date];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
            NSDate *startDate = [calendar dateFromComponents:components];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            
            NSMutableArray *year = [[NSMutableArray alloc]init];
            [year addObject:[NSString stringWithFormat:@"%@",[formatter stringFromDate:startDate]]];
            
            for (int i=0; i<29; i++) {
                NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
                
                [year addObject:[NSString stringWithFormat:@"%@",[formatter stringFromDate:endDate]]];
                startDate = [formatter dateFromString:[formatter stringFromDate:endDate]];
            }
            NSLog(@"%@",year);
            
            NSMutableArray *day = [[NSMutableArray alloc]init];
            NSString *dayStr;
            for (int i=0; i<24; i++) {
                dayStr = [NSString stringWithFormat:@"%d点",i];
                [day addObject:dayStr];
            }
            
            NSMutableArray *hour = [[NSMutableArray alloc]init];
            NSString *hourStr;
            for (int i=0; i<6; i++) {
                hourStr = [NSString stringWithFormat:@"%d0分",i];
                [hour addObject:hourStr];
            }
            
            //    // 自定义多列字符串
            NSArray *dataSources = @[year,day,hour];
            [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSources defaultSelValue:weakSelf isAutoSelect:NO resultBlock:^(id selectValue) {
                
                NSString *hourstr = selectValue[1];
                hourstr = [hourstr substringToIndex:hourstr.length-1];
                if ([hourstr intValue]<10) {
                    hourstr = [NSString stringWithFormat:@"0%@",hourstr];
                }else{
                    hourstr = [NSString stringWithFormat:@"%@",hourstr];
                }
                
                NSString *minstr = selectValue[2];
                minstr = [minstr substringToIndex:minstr.length-1];
                
                NSString *timeStr = [NSString stringWithFormat:@"%@ %@:%@",selectValue[0],hourstr,minstr];
                
                //当前时间
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *dateTime = [formatter stringFromDate:[NSDate date]];
                
                if ([self dateTimeDifferenceWithStartTime:dateTime endTime:timeStr]==0) {
                    jxt_showAlertTitle(@"选择的时间需大于当前时间");
                }else{
                    [sender setTitle:timeStr forState:UIControlStateNormal];
                }
            }];
    }
}
- (void)nextClick:(UIButton*)sender{
    
    
    UITextField *name = [self.view viewWithTag:2000];
    UITextField *phone = [self.view viewWithTag:2001];
    UIButton *qiBut = [self.view viewWithTag:2002];
    UIButton *zhongBut = [self.view viewWithTag:2003];
    
    UITextField *zongche = [self.view viewWithTag:2005];
    UITextField *keyongche = [self.view viewWithTag:2006];
    UIButton *time = [self.view viewWithTag:2007];

    if ([name.text isEqualToString:@"请输入姓名"]) {
        jxt_showToastTitle(@"请输入姓名", 1);
        return;
    }
    if ([phone.text isEqualToString:@"请输入电话"]){
        jxt_showToastTitle(@"请输入电话", 1);
        return;
    }
    if ([qiBut.titleLabel.text isEqualToString:@"请选择起点"]) {
        jxt_showToastTitle(@"请选择起点", 1);
        return;
    }
    if ([zhongBut.titleLabel.text isEqualToString:@"请选择终点"]){
        jxt_showToastTitle(@"请选择终点", 1);
        return;
    }
    if ([zongche.text isEqualToString:@"请输入总车长"]) {
        jxt_showToastTitle(@"请输入总车长", 1);
        return;
    }
    if ([keyongche.text isEqualToString:@"请输入可用车长"]){
        jxt_showToastTitle(@"请输入可用车长", 1);
        return;
    }
    if ([time.titleLabel.text isEqualToString:@""]){
        jxt_showToastTitle(@"请选择出发时间", 1);
        return;
    }
    
    NSString *XWURLStr = @"/mbtwz/freeride?action=addFreeRideTrip";
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:[NSString stringWithFormat:@"%f",_Qlocation.longitude] forKey:@"slongitude"];
    [param setValue:[NSString stringWithFormat:@"%f",_Qlocation.latitude] forKey:@"slatitude"];
    NSArray *sarr = [qiBut.titleLabel.text componentsSeparatedByString:@"-"];
    [param setValue:[NSString stringWithFormat:@"%@",sarr[0]] forKey:@"sprovince"];
    [param setValue:[NSString stringWithFormat:@"%@",sarr[1]] forKey:@"scity"];
    [param setValue:[NSString stringWithFormat:@"%@",sarr[2]] forKey:@"scounty"];
    [param setValue:_Saddress forKey:@"saddress"];
    [param setValue:[NSString stringWithFormat:@"%.6f",_Zlocation.longitude] forKey:@"elongitude"];
    [param setValue:[NSString stringWithFormat:@"%.6f",_Zlocation.latitude] forKey:@"elatitude"];
    NSArray *earr = [zhongBut.titleLabel.text componentsSeparatedByString:@"-"];
    [param setValue:[NSString stringWithFormat:@"%@",earr[0]] forKey:@"eprovince"];
    [param setValue:[NSString stringWithFormat:@"%@",earr[1]] forKey:@"ecity"];
    [param setValue:[NSString stringWithFormat:@"%@",earr[2]] forKey:@"ecounty"];
    [param setValue:_Eaddress forKey:@"eaddress"];
    
    NSString *waytocitys = @"";
    NSString *waytocitystemp = @"";
    NSString *waytocitysshow = @"";
    for (NSDictionary *dic in _TJdidianArr) {
        waytocitys = [NSString stringWithFormat:@"%@,%@",waytocitys,[dic objectForKey:@"waytocitys"]];
        waytocitystemp = [NSString stringWithFormat:@"%@,%@",waytocitystemp,[dic objectForKey:@"waytocitystemp"]];
        waytocitysshow = [NSString stringWithFormat:@"%@,%@",waytocitysshow,[dic objectForKey:@"waytocitysshow"]];
    }
    [param setValue:[waytocitys substringFromIndex:1] forKey:@"waytocitys"];
    [param setValue:[waytocitystemp substringFromIndex:1] forKey:@"waytocitystemp"];
    [param setValue:[waytocitysshow substringFromIndex:1] forKey:@"waytocitysshow"];

    [param setValue:_QZmileage forKey:@"distance"];
    [param setValue:[NSString stringWithFormat:@"%@",zongche.text] forKey:@"totalvehicle"];
    [param setValue:[NSString stringWithFormat:@"%@",keyongche.text] forKey:@"availablevehicle"];
    [param setValue:[NSString stringWithFormat:@"%@",time.titleLabel.text] forKey:@"departuretime"];
    [param setValue:[NSString stringWithFormat:@"%@",name.text] forKey:@"contactname"];
    [param setValue:[NSString stringWithFormat:@"%@",phone.text] forKey:@"contactphone"];

    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:param]};//
    
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:KCparams FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic objectForKey:@"flag"]) {
            jxt_showToastTitle(@"发布成功", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"发布失败", 1);
        }
        
        NSLog(@">>%@",dic);
        
        
    }];

}

/**
 * 开始到结束的时间差
 */
- (float)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    if (value<0) {
        value = 0;
    }
    return value / 3600;
}
- (void)onSearchDone{
    
    NSLog(@"起点：%f，%f  终点：%f，%f",_Qlocation.latitude,_Qlocation.longitude,_Zlocation.latitude,_Zlocation.longitude);
    if ((!_Qlocation.latitude==0)&&(!_Zlocation.latitude==0)) {
        
        AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
        
        navi.requireExtension = YES;
        navi.strategy = 0;
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:_Qlocation.latitude
                                               longitude:_Qlocation.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:_Zlocation.latitude
                                                    longitude:_Zlocation.longitude];
        [self.search AMapDrivingRouteSearch:navi];
        
    }
}
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    if (response.route.paths.count) {
        NSLog(@">>>>>%zd",response.route.paths[0].distance);
        float distance = response.route.paths[0].distance;
        _QZmileage = [NSString stringWithFormat:@"%.2f",distance/1000];
        
    }else{
        jxt_showToastTitle(@"路线计算错误，请重新选点", 1);
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
@end
