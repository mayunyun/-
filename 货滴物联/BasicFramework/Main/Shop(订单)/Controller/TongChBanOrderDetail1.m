//
//  TongChBanOrderDetail1.m
//  BasicFramework
//
//  Created by LONG on 2018/2/27.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "TongChBanOrderDetail1.h"
#import "TCHBanJOrderDetailHeaderCell.h"
#import "AdressCell.h"
#import "ExNeedCell.h"
#import "TotalPriceCell.h"
#import "DriveInfoCell.h"
#import "DriverOrderInfoCell.h"
#import "CancleOrderView.h"
#import "CDZStarsControl.h"
#import "CustomAnnotationView.h"
#import "TongChBanOrderDetail.h"
#import "Paydetail.h"

@interface TongChBanOrderDetail1 ()<UITableViewDataSource,UITableViewDelegate,CDZStarsControlDelegate,UITextViewDelegate,MAMapViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * needArray;
@property (nonatomic,strong)NSMutableArray * detailArr;
@property (nonatomic,strong)NSMutableArray * needContentArray;
@property (nonatomic,strong)CancleOrderView * cancleView;
@property (nonatomic,strong)UIView * pcancelView;
@property (nonatomic, strong) CDZStarsControl *starsControl;
@property (nonatomic,strong)UITextView * inputTV;
@property (nonatomic,strong)UIButton * exitBtn;
@property (nonatomic,strong)UIButton * commitBtn;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSArray *mapGpsArr;
@property (nonatomic, strong) NSArray *lines;
@end

@implementation TongChBanOrderDetail1

{
    UIView * starView;
    UILabel *_placeHolderLabel;
    NSString * starScore;
    NSString * fee;
    NSArray * arr;
    UILabel * feeLabel;
    
    // 黑色的背景
    UIButton * backBtn;
    // 整个弹出框
    UIView *applyInputView;
    // TextView的输入框
    UITextField * jkTextField;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDetail];
    [self requestmapGps];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搬家单详情";
    _dataArr = [[NSMutableArray alloc]init];
    _needArray = [[NSMutableArray alloc]init];
    _needContentArray=[NSMutableArray array];
    _detailArr = [NSMutableArray array];
    
    [self requestDataForRate];
    
    [self tableview];
    starScore = @"5";
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseAliPayTrue:) name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseWXPayTrue:) name:WXPayTrue object:nil];
}
- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayTrue object:nil];
}
//下拉刷新
- (void)loadNewData{
    
    [_tableview.mj_header endRefreshing];
}
-(void)requestmapGps{
    NSString *url = @"/huodigps?action=queryGps";
    NSDictionary * dic =@{@"orderno":self.model.owner_orderno};
    NSDictionary* KCparams = @{@"page":@"1",@"rows":@"5000",@"params":[Command dictionaryToJson:dic]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",[dic objectForKey:@"rows"]);
        self.mapGpsArr = [dic objectForKey:@"rows"];
        if (self.mapGpsArr.count>0) {
            NSMutableArray *arr = [NSMutableArray array];
            
            CLLocationCoordinate2D line2Points[self.mapGpsArr.count];
            
            for (int i=0; i<self.mapGpsArr.count; i++) {
                line2Points[i].latitude = [[self.mapGpsArr[i] objectForKey:@"lattitude"] floatValue];
                line2Points[i].longitude = [[self.mapGpsArr[i] objectForKey:@"longitude"] floatValue];
            }
            MAPolyline *line2 = [MAPolyline polylineWithCoordinates:line2Points count:self.mapGpsArr.count];
            [arr addObject:line2];
            
            self.lines = [NSArray arrayWithArray:arr];
        }
        [_tableview reloadData];
    }];
}
-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate tag:(NSString *)tag
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title    = tag;
    annotation.subtitle = @"";
    
    [self.mapView addAnnotation:annotation];
}
-(void)requestDetail{
    NSString *url = @"/mbtwz/logisticssendwz?action=searchorder";
    NSDictionary * dic =@{@"orderno":self.model.owner_orderno};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单详情%@",arr);
        for (NSDictionary *dic in arr) {
            TCHBanJModel *model=[[TCHBanJModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_detailArr addObject:model];
        }
        [self searchNeedData];
        
        [_tableview reloadData];
        
    }];
}
-(void)requestDataForRate{
    NSString *url = @"/mbtwz/logisticssendwz?action=searchfee";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求费率%@",arr);
        if (arr.count == 0||arr == nil) {
            fee = @"0";
        }else{
            fee = [NSString stringWithFormat:@"%.2f",[arr[0][@"fee"] floatValue]*100];
        }
        
    }];
}
-(void)CommitBtnClicked:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    NSString *url = @"/mbtwz/logisticssendwz?action=evlateOrder";
    NSDictionary * dic;
    if ([_inputTV.text isEqualToString:@""]) {//默认不填任何信息是好评
        dic =@{@"order_id":self.model.id,@"driver_fraction":starScore,@"note":@"默认好评",@"driverid":self.model.driver_custid,@"ordertype":@"0",@"evalute_type":@"0"};
    }else{
        dic =@{@"order_id":self.model.id,@"driver_fraction":starScore,@"note":_inputTV.text,@"driverid":self.model.driver_custid,@"ordertype":@"0",@"evalute_type":@"0"};
    }
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
        
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"提交评价%@",str);
        
        if ([str containsString:@"true"]) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                [SMAlert hide:NO];
                _cancleView.hidden = YES;
                TCHBanJModel * model = _detailArr[0];
                model.cust_orderstatus = @"2";
                jxt_showToastTitle(@"提交评价成功", 1);
                sender.userInteractionEnabled = NO;
                [_tableview reloadData];
            });
        }else{
            jxt_showToastTitle(@"提交评价失败", 1);
            sender.userInteractionEnabled = NO;
        }
        
    }];
}
//根据订单id查询额外需求
-(void)searchNeedData{
    NSString *url = @"/mbtwz/find?action=selectLogisticsOrderDetailServ";
    NSDictionary * dic = @{@"id":self.model.id};
    NSDictionary* KCparams = @{@"params":[Command dictionaryToJson:dic]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"额外需求%@",arr);
        for (NSDictionary *dic in arr) {
            [_needArray addObject:[NSString stringWithFormat:@"%@",dic[@"owner_service_price"]]];
            [_needContentArray addObject:dic[@"service_name"]];
            
        }
        
        if (_detailArr.count) {
            TCHBanJModel * model;
            model = _detailArr[0];
            if (![[NSString stringWithFormat:@"%@",model.owner_note] isEqualToString:@""]) {
                [_needArray addObject:@"备注"];
                [_needContentArray addObject:@"备注"];
            }
        }
        [_tableview reloadData];
        
    }];
}
-(void)startOrder{
    NSString *url = @"/mbtwz/logisticssendwz?action=startOrder";
    NSDictionary * dic =@{@"orderno":self.model.owner_orderno};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"开始订单%@",str);
        if ([str containsString:@"true"]) {
            jxt_showToastTitle(@"订单已开始", 2);
            TCHBanJModel * model = _detailArr[0];
            model.cust_orderstatus = @"1";
            //刷新完数据滚动到顶部
            [_tableview setContentOffset:CGPointMake(0,0) animated:YES];
            [_tableview reloadData];
        }else{
            jxt_showToastTitle(@"开始订单失败", 2);
        }
        
    }];
}
//结束订单
-(void)endingOrderData{
    NSString *url = @"/mbtwz/logisticssendwz?action=finishOrder";
    TCHBanJModel * model = _detailArr[0];
    NSDictionary * dic =@{@"orderno":self.model.owner_orderno,
                          @"order_money":model.owner_totalprice,
                          @"driverid":model.driver_custid
                          };
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"结束订单%@",str);
        if ([str containsString:@"true"]) {
            starView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW-60, UIScreenH*1.4/3)];
            starView.backgroundColor = [UIColor whiteColor];
            starView.layer.cornerRadius = 40.f;
            starView.layer.masksToBounds = YES;
            [starView addSubview:self.starsControl];
            [starView addSubview:self.exitBtn];
            [starView addSubview:self.inputTV];
            [starView addSubview:self.commitBtn];
            [SMAlert showCustomView:starView];
            
        }else{
            jxt_showToastTitle(@"结束订单失败", 2);
        }
        
    }];
}
//-(void)DriverSyData{
//    TCHBanJModel * model;
//    if (_detailArr.count) {
//        model  = _detailArr[0];
//    }
//    NSString *url = @"/mbtwz/logisticssendwz?action=overTime";
//    NSDictionary * dic =@{@"orderno":self.model.owner_orderno,@"owner_createtime":self.model.owner_createtime,@"siji_findtime":model.siji_findtime,@"order_money":self.model.owner_totalprice,@"driverid":model.driver_custid};
//    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
//    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
//        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"司机失约%@",str);
//        if ([str containsString:@"true"]) {
//            jxt_showToastTitle(@"提交成功", 2);
//            TCHBanJModel * model = _detailArr[0];
//            model.cust_orderstatus = @"-1";
//            //刷新完数据滚动到顶部
//            [_tableview setContentOffset:CGPointMake(0,0) animated:YES];
//            [_tableview reloadData];
//        }else if([str isEqualToString:@""]){
//            //            NSString * string = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//            jxt_showToastTitle(@"提交失败", 2);
//        }else{
//            NSString * string = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//            jxt_showToastTitle(string, 2);
//        }
//
//
//    }];
//}
-(void)cancelOrderData{
    NSString *url = @"/mbtwz/logisticssendwz?action=cancelOrder";
    NSDictionary * dic =@{@"orderno":self.model.owner_orderno,@"siji_findtime":self.model.siji_findtime,@"order_money":self.model.owner_totalprice};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"取消订单%@",str);
        UIImageView * canView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250*MYWIDTH, 220*MYWIDTH)];
        canView.image = [UIImage imageNamed:@"已取消"];
        
        UILabel * note1Label = [[UILabel alloc]initWithFrame:CGRectMake(0, canView.height/2+10*MYWIDTH, canView.width, 20*MYWIDTH)];
        note1Label.text = @"订单已取消";
        note1Label.textColor = UIColorFromRGB(0x484848);
        note1Label.textAlignment = NSTextAlignmentCenter;
        note1Label.font = [UIFont systemFontOfSize:16*MYWIDTH];
        [canView addSubview:note1Label];
        feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, note1Label.bottom +10*MYWIDTH, note1Label.width, 20*MYWIDTH)];
        feeLabel.text = [NSString stringWithFormat:@"已扣除您%@%%费用",fee];
        feeLabel.textColor = UIColorFromRGB(0x484848);
        feeLabel.textAlignment = NSTextAlignmentCenter;
        feeLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        [canView addSubview:feeLabel];
        if ([str isEqualToString:@"\"trueTimeout\""]) {
            feeLabel.hidden = NO;
            [SMAlert showCustomView:canView];
            [SMAlert hideCompletion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if ([str isEqualToString:@"\"true\""]){
            feeLabel.hidden = YES;
            [SMAlert showCustomView:canView];
            [SMAlert hideCompletion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            jxt_showToastTitle(@"取消订单失败", 1);
        }
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return _needArray.count;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 238;
    }else if (indexPath.section == 1){
        
        TCHBanJModel * model;
        if (_detailArr.count) {
            model = _detailArr[0];
        }
        NSString * status = [NSString stringWithFormat:@"%@",_model.cust_orderstatus];
        if ([status isEqualToString:@"0"]) {
            return 137;
        }
        return 320;
    }else if (indexPath.section == 2){
        return 40;
    }else if (indexPath.section == 4){
        return 80;
    }else{
        TCHBanJModel * model;
        if (_detailArr.count) {
            model = _detailArr[0];
        }
        NSString * driver_custId = [NSString stringWithFormat:@"%@",model.driver_custid];
        if ([[Command convertNull:driver_custId] isEqualToString:@""]||[model.driver_custid intValue] == 0) {
            return 80;
        }else{
            return 120;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 240;
    }
    return 1;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 4) {
        __weak typeof(self) weakSelf = self;
        //        __weak typeof(_cancleView) _weakcancleView = _cancleView;
        _cancleView = [CancleOrderView headerViewWithTableView:tableView];
        if (_detailArr.count) {
            TCHBanJModel * model  = _detailArr[0];
            NSArray * arr = @[model.cust_orderstatus,model.driver_orderstatus];
            _cancleView.status = arr;
        }
        [_cancleView.startbut setTitle:@"去支付" forState:UIControlStateNormal];

        [_cancleView setCancleBtnBlock:^{
            //取消订单视图
            UIView * canView = [weakSelf cancelView];
            canView.backgroundColor = [UIColor whiteColor];
            [SMAlert showCustomView:canView];
            
        }];
        [_cancleView setStartBtnBlock:^{
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=checkRelease" Parameters:nil FinishedLogin:^(id responseObject) {
                NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                if([str rangeOfString:@"true"].location!=NSNotFound) {
                    [self setSMAlertWithView];//是签约用户，可以发布订单，可以选择周结
                }else if ([str rangeOfString:@"nosign"].location!=NSNotFound){
                    [self setSMAlertWithView1];//非签约用户，可以发布订单，不能选择周结
                }else if ([str rangeOfString:@"false"].location!=NSNotFound){
                    [self setSMAlertWithView1];//是签约用户，不能发布订单，上一个周期存在未周结完的单子
                }else{
                    jxt_showToastTitle(@"登录状态失效，请重新登录", 1);
                }
                
            }];
            
        }];
        [_cancleView setEndBtnBlock:^{
            jxt_showAlertTwoButton(@"提示", @"确认结束订单", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"确定", ^(NSInteger buttonIndex) {
                [weakSelf endingOrderData];
            });
            
        }];
        //        [_cancleView setDriverSyBlock:^{
        //            //            jxt_showAlertTwoButton(@"提示", @"确认提交司机失约", @"取消", ^(NSInteger buttonIndex) {
        //            //
        //            //            }, @"确定", ^(NSInteger buttonIndex) {
        //            //                [weakSelf DriverSyData];
        //            //            });
        //            [weakSelf DriverSyData];
        //        }];
        return _cancleView;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{//头视图
    if (section==2) {
        return 0;
    }
    return 20;
}
//头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * stringCell = @"TCHBanJOrderDetailHeaderCell";
        TCHBanJOrderDetailHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_detailArr.count) {
            cell.model = _detailArr[indexPath.section];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        static NSString * stringCell = @"AdressCell";
        AdressCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.startPosition.text = [NSString stringWithFormat:@"%@",self.model.owner_address];
        cell.endPosition.text = [NSString stringWithFormat:@"%@",self.model.owner_send_address];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        TCHBanJModel * model;
        if (_detailArr.count) {
            model = _detailArr[0];
        }
        NSString * status = [NSString stringWithFormat:@"%@",_model.cust_orderstatus];
        if (![status isEqualToString:@"0"]) {
            self.mapView = [[MAMapView alloc] initWithFrame:cell.BGmap.bounds];
            self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.mapView setZoomLevel:13 animated:NO];
            
            self.mapView.delegate = self;
            
            [cell.BGmap addSubview:self.mapView];
            
            if (self.mapGpsArr.count>0) {
                if (self.mapGpsArr.count%2) {
                    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[self.mapGpsArr[(self.mapGpsArr.count-1)/2] objectForKey:@"lattitude"] floatValue], [[self.mapGpsArr[(self.mapGpsArr.count-1)/2] objectForKey:@"longitude"] floatValue]) animated:YES];
                }else{
                    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[self.mapGpsArr[self.mapGpsArr.count/2] objectForKey:@"lattitude"] floatValue], [[self.mapGpsArr[self.mapGpsArr.count/2] objectForKey:@"longitude"] floatValue]) animated:YES];
                }
                
                [self.mapView addOverlays:self.lines];
                
                [self addAnnotationWithCooordinate:CLLocationCoordinate2DMake([[self.mapGpsArr[0] objectForKey:@"lattitude"] floatValue], [[self.mapGpsArr[0] objectForKey:@"longitude"] floatValue]) tag:@"1100"];
                [self addAnnotationWithCooordinate:CLLocationCoordinate2DMake([[self.mapGpsArr[self.mapGpsArr.count-1] objectForKey:@"lattitude"] floatValue], [[self.mapGpsArr[self.mapGpsArr.count-1] objectForKey:@"longitude"] floatValue]) tag:@"1101"];
            }
        }
        return cell;
    }else if (indexPath.section == 2){
        static NSString * stringCell = @"ExNeedCell";
        ExNeedCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (indexPath.row==0) {
            cell.hide.hidden = YES;
        }else{
            cell.hide.hidden = NO;
        }
        cell.typeLabel.textColor = UIColorFromRGB(0x555555);
        cell.typeLabel.font = [UIFont systemFontOfSize:15];
        cell.contentLabel.textColor = UIColorFromRGB(0x555555);
        cell.contentLabel.font = [UIFont systemFontOfSize:15];
        cell.typeLabel.text = _needContentArray[indexPath.row];
        if ([_needArray[indexPath.row] isEqualToString:@"0"]) {
            cell.contentLabel.text = @"免费";
        }else if ([_needArray[indexPath.row] isEqualToString:@"备注"]){
            TCHBanJModel * model;
            model = _detailArr[0];
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",model.owner_note];
        }
        else{
            cell.contentLabel.text = [NSString stringWithFormat:@"%.2f元",[_needArray[indexPath.row] floatValue]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 4){
        static NSString * stringCell = @"TotalPriceCell";
        TotalPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.priceLab.text = [NSString stringWithFormat:@"%.2f",[self.model.owner_totalprice floatValue]];
        cell.price.borderStyle =  UITextBorderStyleNone;
        cell.price.backgroundColor = [UIColor clearColor];
        cell.price.userInteractionEnabled = NO;
        cell.yuan.text = @"元";
        cell.gongLi.text = [NSString stringWithFormat:@"%.2f公里",[self.model.total_mileage floatValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        //未接单
        TCHBanJModel * model;
        if (_detailArr.count) {
            model = _detailArr[0];
        }
        NSString * driver_custId = [NSString stringWithFormat:@"%@",model.driver_custid];
        if ([[Command convertNull:driver_custId] isEqualToString:@""]||[model.driver_custid intValue] == 0) {
            static NSString * stringCell = @"DriveInfoCell";
            DriveInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            //接单
            static NSString * stringCell = @"DriverOrderInfoCell";
            DriverOrderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
            }
            TCHBanJModel * model;
            if (_detailArr.count) {
                model = _detailArr[0];
                cell.driverName.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.driver_name]];
                NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.driver_phone]];
                [tncString addAttribute:NSUnderlineStyleAttributeName
                                  value:@(NSUnderlineStyleSingle)
                                  range:(NSRange){0,[tncString length]}];
                //此时如果设置字体颜色要这样
                [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]  range:NSMakeRange(0,[tncString length])];
                
                //设置下划线颜色...
                [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor blueColor] range:(NSRange){0,[tncString length]}];
                [cell.driverPhone setAttributedTitle:tncString forState:UIControlStateNormal];
                [cell.driverPhone addTarget:self action:@selector(driverPhone:) forControlEvents:UIControlEventTouchUpInside];
                cell.driverstar.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@星评分",model.cust_star]];
                cell.drivernum.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"交易%@笔",model.cust_num]];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    
}
- (void)driverPhone:(UIButton *)but{
    TCHBanJModel * model;
    model = _detailArr[0];
    NSString *phone = [NSString stringWithFormat:@"拨打司机电话：%@",model.driver_phone];
    jxt_showAlertTwoButton(@"提示", phone, @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",model.driver_phone]]];
    });
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
            annotationView.userInteractionEnabled = NO;
        }
        
        annotationView.portrait = [UIImage imageNamed:@"GPSHD"];
        if ([annotation.title isEqualToString:@"1100"]) {
            annotationView.name     = @"起点";
        }else{
            TCHBanJModel * model;
            if (_detailArr.count) {
                model = _detailArr[0];
            }
            NSString * status = [NSString stringWithFormat:@"%@",_model.cust_orderstatus];
            if ([status isEqualToString:@"2"]) {
                annotationView.name     = @"终点";
            }else{
                annotationView.name     = @"进行中";
            }
            
        }
        
        
        return annotationView;
    }
    
    return nil;
}
//取消订单确认弹窗
-(UIView *)cancelView{
    if (_pcancelView == nil) {
        _pcancelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW-40, UIScreenH/3)];
        //        _pcancelView.layer.cornerRadius = 60.f;
        //        _pcancelView.layer.masksToBounds = YES;
        UILabel * cancelLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, 10, _pcancelView.width-20, 30*MYWIDTH)];
        cancelLabel.text = @"取消订单";
        cancelLabel.textColor = MYColor;
        [_pcancelView addSubview:cancelLabel];
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, cancelLabel.bottom +5*MYWIDTH,_pcancelView.width, 1)];
        line.backgroundColor = MYColor;
        [_pcancelView addSubview:line];
        //        UIImageView * pointImagev1 = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, line.bottom +22*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH)];
        //        pointImagev1.image = [UIImage imageNamed:@"点"];
        //        [_pcancelView addSubview:pointImagev1];
        UILabel * note1Label = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, line.bottom +20*MYWIDTH, cancelLabel.width, 20*MYWIDTH)];
        note1Label.text = [NSString stringWithFormat:@"%@",@"◎ 司机接单前及接单三分钟内可免费取消"];
        note1Label.textColor = UIColorFromRGB(0x484848);
        note1Label.font = [UIFont systemFontOfSize:14*MYWIDTH];
        [_pcancelView addSubview:note1Label];
        //        UIImageView * pointImagev2 = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, note1Label.bottom +12*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH)];
        //        pointImagev2.image = [UIImage imageNamed:@"点"];
        //        [_pcancelView addSubview:pointImagev2];
        UILabel * note2Label = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, note1Label.bottom +10*MYWIDTH, note1Label.width, 20*MYWIDTH)];
        note2Label.text = [NSString stringWithFormat:@"◎ 司机接单三分钟后取消,将扣您%@%%的费用",fee];
        note2Label.textColor = UIColorFromRGB(0x484848);
        note2Label.font = [UIFont systemFontOfSize:14*MYWIDTH];
        [_pcancelView addSubview:note2Label];
        UIButton * continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        continueBtn.frame = CGRectMake(20, _pcancelView.height-60, (_pcancelView.width-60)/2, 40*MYWIDTH);
        [continueBtn setTitle:@"继续订单" forState:UIControlStateNormal];
        [continueBtn addTarget:self action:@selector(continueBtnCliked) forControlEvents:UIControlEventTouchUpInside];
        continueBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [continueBtn setBackgroundColor:MYColor];
        continueBtn.layer.cornerRadius = 8.f;
        continueBtn.layer.masksToBounds = YES;
        [_pcancelView addSubview:continueBtn];
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(continueBtn.right+20, _pcancelView.height-60, (_pcancelView.width-60)/2, 40*MYWIDTH);
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnCliked) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        cancelBtn.layer.cornerRadius = 8.f;
        cancelBtn.layer.masksToBounds = YES;
        [_pcancelView addSubview:cancelBtn];
    }
    return _pcancelView;
}
-(void)quitPage{
    [SMAlert hide:NO];
    _cancleView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)continueBtnCliked{
    [SMAlert hide:NO];
}
-(void)cancelBtnCliked{
    [SMAlert hide:NO];
    [self cancelOrderData];
}
- (void)textViewDidChange:(UITextView *)textView

{
    
    if (textView.text.length == 0 )
        
    {
        
        _placeHolderLabel.text = @"请输入您的宝贵意见!";
        
    }
    
    else
        
    {
        
        _placeHolderLabel.text = @"";
        
    }
    
}
-(void)exitRemarkPage{
    [SMAlert hide:NO];
    _cancleView.hidden = YES;
    TCHBanJModel * model = _detailArr[0];
    model.cust_orderstatus = @"2";
    [_tableview reloadData];
}
#pragma remark -- 星星评价
- (void)starsControl:(CDZStarsControl *)starsControl didChangeScore:(CGFloat)score{
    //    self.label.text = [NSString stringWithFormat:@"%.1f",score];
    starScore = [NSString stringWithFormat:@"%.f",score];
    NSLog(@"星星的分数%@",starScore);
}

#pragma mark -- 懒加载
- (CDZStarsControl *)starsControl{
    if (!_starsControl) {
        
        _starsControl = [CDZStarsControl.alloc initWithFrame:CGRectMake(30*MYWIDTH, 30*MYWIDTH, starView.width - 60*MYWIDTH , 35*MYWIDTH) stars:5 starSize:CGSizeMake(35*MYWIDTH, 35*MYWIDTH) noramlStarImage:[UIImage imageNamed:@"11.2"] highlightedStarImage:[UIImage imageNamed:@"11.1"]];
        _starsControl.delegate = self;
        _starsControl.allowFraction = NO;
        _starsControl.score = 5.0f;
    }
    return _starsControl;
}
-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn.frame = CGRectMake(_starsControl.right, 10*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH);
        [_exitBtn setImage:[UIImage imageNamed:@"关闭_1"] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(exitRemarkPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
    
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        UIView *baiview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 64)];
        if (statusbarHeight>20) {
            baiview.frame = CGRectMake(0, 0, UIScreenW, 88);
        }
        baiview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:baiview];
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, baiview.bottom, UIScreenW, UIScreenH) style:UITableViewStyleGrouped];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-34);
            
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        _tableview.scrollsToTop = YES;
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableview;
    
}
-(UITextView *)inputTV{
    if (!_inputTV) {
        _inputTV = [[UITextView alloc] initWithFrame:CGRectMake(20*MYWIDTH, self.starsControl.bottom+15*MYWIDTH, starView.width-40*MYWIDTH, starView.height/2)];
        _inputTV.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _inputTV.layer.cornerRadius = 8.f;
        _inputTV.layer.borderWidth = 1.0f;
        _inputTV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _inputTV.delegate = self;
        _inputTV.backgroundColor = [UIColor clearColor];
        _inputTV.textColor = [UIColor blackColor];
        [starView addSubview:_inputTV];
        _inputTV.text = @"";
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*MYWIDTH, 5*MYWIDTH,starView.width-40*MYWIDTH, 20*MYWIDTH)];
        _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        _placeHolderLabel.font = [UIFont systemFontOfSize:17*MYWIDTH];
        _placeHolderLabel.text = @"请输入您的宝贵意见!";
        [_inputTV addSubview:_placeHolderLabel];
        //给键盘加一个view收起键盘
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 30)];
        [topView setBarStyle:UIBarStyleBlack];
        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
        [topView setItems:buttonsArray];
        [_inputTV setInputAccessoryView:topView];
        
    }
    return _inputTV;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.frame = CGRectMake(_inputTV.centerX-70*MYWIDTH, starView.height-60*MYWIDTH, 140*MYWIDTH, 40*MYWIDTH);
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        [_commitBtn setBackgroundColor:MYColor];
        [_commitBtn addTarget:self action:@selector(CommitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.cornerRadius = 8.f;
        _commitBtn.layer.masksToBounds = YES;
        
    }
    return _commitBtn;
}

-(void)dismissKeyBoard
{
    [_inputTV resignFirstResponder];
}
//支付方式弹框
- (void)setSMAlertWithView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, kScreenWidth-60*MYWIDTH, 250*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<4; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 50*MYWIDTH+50*MYWIDTH*i, bgview.width-60*MYWIDTH, 1)];
        xian.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
        [bgview addSubview:xian];
    }
    NSArray *imageArr = @[@"单选_选中",@"单选_未选中",@"单选_未选中",@"单选_未选中",@"单选_未选中"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45*MYWIDTH, 15*MYWIDTH+i*50*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr[i]];
        [bgview addSubview:imageview];
    }
    NSArray *imageArr1 = @[@"未标题-5.1",@"未标题-5.2",@"未标题-5.3",@"线下支付",@"周结支付"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/3, 10*MYWIDTH+i*50*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr1[i]];
        [bgview addSubview:imageview];
    }
    NSArray *titleArr = @[@"支付宝支付",@"微信支付",@"余额支付",@"线下支付",@"周结"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, 10*MYWIDTH+i*50*MYWIDTH, 200, 30*MYWIDTH)];
        lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        lab.textColor = UIColorFromRGBValueValue(0x333333);
        [bgview addSubview:lab];
    }
    for (int i=0; i<5; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, i*50*MYWIDTH, bgview.width, 50*MYWIDTH)];
        but.tag = 550+i;
        [but addTarget:self action:@selector(zhifuButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:but];
    }
    [SMAlert showCustomView:bgview];
    [SMAlert hideCompletion:^{
        
    }];
}
- (void)setSMAlertWithView1{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, kScreenWidth-60*MYWIDTH, 200*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<3; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 50*MYWIDTH+50*MYWIDTH*i, bgview.width-60*MYWIDTH, 1)];
        xian.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
        [bgview addSubview:xian];
    }
    NSArray *imageArr = @[@"单选_选中",@"单选_未选中",@"单选_未选中",@"单选_未选中"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45*MYWIDTH, 15*MYWIDTH+i*50*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr[i]];
        [bgview addSubview:imageview];
    }
    NSArray *imageArr1 = @[@"未标题-5.1",@"未标题-5.2",@"未标题-5.3",@"线下支付"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/3, 10*MYWIDTH+i*50*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr1[i]];
        [bgview addSubview:imageview];
    }
    NSArray *titleArr = @[@"支付宝支付",@"微信支付",@"余额支付",@"线下支付"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, 10*MYWIDTH+i*50*MYWIDTH, 200, 30*MYWIDTH)];
        lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        lab.textColor = UIColorFromRGBValueValue(0x333333);
        [bgview addSubview:lab];
    }
    for (int i=0; i<4; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, i*50*MYWIDTH, bgview.width, 50*MYWIDTH)];
        but.tag = 550+i;
        [but addTarget:self action:@selector(zhifuButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:but];
    }
    [SMAlert showCustomView:bgview];
    [SMAlert hideCompletion:^{
        
    }];
}
- (void)zhifuButClicked:(UIButton *)button{
    [SMAlert hide:NO];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    TCHBanJModel * model = _detailArr[0];
    if (button.tag == 550) {//支付宝
        jxt_showAlertTwoButton(@"提示", @"您确定使用支付宝支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            
            [Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:model.owner_totalprice orderId:[NSString stringWithFormat:@"%@_%@",model.uuid,[user objectForKey:USERID]] notice:@"1"];
            
            //jxt_showAlertTitle(@"正在开发中");
            
        });
        
        
    }else if (button.tag == 551){//微信支付
        jxt_showAlertTwoButton(@"提示", @"您确定使用微信支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            [Paydetail wxname:@"货滴充值" titile:@"货滴充值" price:model.owner_totalprice orderId:[NSString stringWithFormat:@"%@_%@",model.uuid,[user objectForKey:USERID]] notice:@"1"];
            //jxt_showAlertTitle(@"正在开发中");
            
        });
        
        
    }else if (button.tag == 552){//余额支付
        jxt_showAlertTwoButton(@"提示", @"您确定使用余额支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            //验证密码
            NSString *passwordURLStr = @"/mbtwz/logisticssendwz?action=checkZhiFuPassword";
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:passwordURLStr Parameters:nil FinishedLogin:^(id responseObject) {
                
                NSString* str = [[NSString alloc]initWithData:responseObject encoding:kCFStringEncodingUTF8];
                if ([str rangeOfString:@"false"].location!=NSNotFound) {
                    jxt_showAlertTwoButton(@"温馨提示", @"请到：个人中心-设置-安全中心-设置支付密码中进行设置", @"确定", ^(NSInteger buttonIndex) {
                        ReplacePayPswVC* vc = [[ReplacePayPswVC alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }, @"取消", ^(NSInteger buttonIndex) {
                        
                    });
                }else{
                    [self createUI];
                    [self pushApplyCase];
                }
            }];
        });
    }else if (button.tag == 553){//线下支付
        jxt_showAlertTwoButton(@"提示", @"您确定使用线下支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            [self shipperBalancePay_kyunderline:@"3"];
        });
    }else if (button.tag == 554){//周结支付
        jxt_showAlertTwoButton(@"提示", @"您确定使用周结支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            [self shipperBalancePay_kyunderline:@"4"];
        });
    }
    
}
#pragma mark UI的设置
-(void)createUI{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0, UIScreenW,UIScreenH);
    backBtn.backgroundColor = [UIColor cyanColor];
    backBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    backBtn.alpha = 0.2;
    [window addSubview:backBtn];
    
    
    applyInputView = [[UIView alloc]initWithFrame:CGRectMake(25*MYWIDTH, (UIScreenH-175*MYWIDTH)/2, UIScreenW-50*MYWIDTH, 175*MYWIDTH)];
    applyInputView.alpha = 0;
    applyInputView.backgroundColor = [UIColor whiteColor];
    applyInputView.layer.cornerRadius = 10.f;
    applyInputView.clipsToBounds = NO;
    [window addSubview:applyInputView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, 10*MYWIDTH, UIScreenW-40, 18*MYWIDTH)];
    title.text = @"余额支付";
    title.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    [applyInputView addSubview:title];
    
    UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(0, title.bottom+10*MYWIDTH, applyInputView.width, 1)];
    lines.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [applyInputView addSubview:lines];
    UILabel * tfLabel = [[UILabel alloc]initWithFrame:CGRectMake(24*MYWIDTH, lines.bottom+15*MYWIDTH, applyInputView.width-48*MYWIDTH, 42*MYWIDTH)];
    tfLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tfLabel.userInteractionEnabled = YES;
    [applyInputView addSubview:tfLabel];
    jkTextField = [[UITextField alloc]initWithFrame:CGRectMake(10*MYWIDTH, 8*MYWIDTH, tfLabel.width-20*MYWIDTH,30*MYWIDTH)];
    jkTextField.delegate = self;
    jkTextField.textColor = [UIColor blackColor];
    jkTextField.placeholder = @"输入支付密码";
    jkTextField.secureTextEntry = YES;
    jkTextField.textAlignment = NSTextAlignmentCenter;
    jkTextField.font = [UIFont systemFontOfSize:14.0f*MYWIDTH];
    [tfLabel addSubview:jkTextField];
    [Command placeholderColor:jkTextField str:jkTextField.placeholder color:UIColorFromRGBValueValue(0x333333)];
    
    CGFloat btnWidth = (applyInputView.width-60*MYWIDTH)/2;
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(20*MYWIDTH, tfLabel.bottom+25*MYWIDTH, btnWidth, 35*MYWIDTH)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    [sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundColor:MYColor];
    sureButton.layer.cornerRadius = 6.f;
    sureButton.clipsToBounds = YES;
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyInputView addSubview:sureButton];
    
    UIButton *canleButton = [[UIButton alloc]initWithFrame:CGRectMake(sureButton.right+20*MYWIDTH, tfLabel.bottom+25*MYWIDTH, btnWidth, 35*MYWIDTH)];
    [canleButton setTitle:@"取消" forState:UIControlStateNormal];
    [canleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [canleButton setBackgroundColor:UIColorFromRGB(0xCDCDCD)];
    canleButton.titleLabel.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    canleButton.layer.cornerRadius = 6.f;
    canleButton.clipsToBounds = YES;
    [canleButton addTarget:self action:@selector(canle) forControlEvents:UIControlEventTouchUpInside];
    [applyInputView addSubview:canleButton];
}
#pragma mark 取消
-(void)canle{
    [applyInputView removeFromSuperview];
    [backBtn removeFromSuperview];
}

#pragma mark 确定
-(void)sure{
    [jkTextField resignFirstResponder];
    
    if ([jkTextField.text isEqualToString:@""]) {
        jxt_showToastTitle(@"密码不能为空", 1);
    }else{
        TCHBanJModel * model = _detailArr[0];
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"ordertype\":\"0\",\"zhifuprice\":\"%@\",\"uuid\":\"%@\",\"paypassword\":\"%@\"}",model.owner_totalprice,model.uuid,jkTextField.text]};
        
        NSLog(@"%@",params);
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=shipperBalancePay" Parameters:params FinishedLogin:^(id responseObject) {
            NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"余额支付状态%@",str);
            if([str rangeOfString:@"true"].location!=NSNotFound) {
                [SMAlert hide:NO];
                [backBtn removeFromSuperview];
                [applyInputView removeFromSuperview];
                [self paySuccess];
            }else{
                NSString *str1 = [str substringFromIndex:1];
                
                NSString *str2 = [str1 substringToIndex:str1.length-1];
                jxt_showAlertOneButton(@"提示", str2, @"确定", ^(NSInteger buttonIndex) {
                });
            }
            
        }];
        
    }
}
-(void)shipperBalancePay_kyunderline:(NSString*)pay_method{
    TCHBanJModel * model = _detailArr[0];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"ordertype\":\"0\",\"zhifuprice\":\"%@\",\"uuid\":\"%@\",\"pay_method\":\"%@\"}",model.owner_totalprice,model.uuid,pay_method]};
    
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/logisticssendwz?action=shipperBalancePay_underline" Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"支付状态%@",str);
        if([str rangeOfString:@"true"].location!=NSNotFound) {
            [self paySuccess];
        }else{
            NSString *str1 = [str substringFromIndex:1];
            
            NSString *str2 = [str1 substringToIndex:str1.length-1];
            jxt_showAlertOneButton(@"提示", str2, @"确定", ^(NSInteger buttonIndex) {
            });
        }
    }];
}
- (void)paySuccess{
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 230*MYWIDTH, 200*MYWIDTH)];
    imageview.userInteractionEnabled = YES;
    imageview.image = [UIImage imageNamed:@"订单提交成功"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.height/2, imageview.width, 30*MYWIDTH)];
    lab.text = @"订单支付成功";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = UIColorFromRGB(0x333333);
    [imageview addSubview:lab];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, lab.bottom+5*MYWIDTH, imageview.width, 30*MYWIDTH)];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"前去开始订单"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:MYColor  range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:MYColor range:(NSRange){0,[tncString length]}];
    [but setAttributedTitle:tncString forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but addTarget:self action:@selector(fahuodanButClicked) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:but];
    
    [SMAlert showCustomView:imageview];
    [SMAlert hideCompletion:^{
        
        TongChBanOrderDetail *tongVc = [[TongChBanOrderDetail alloc]init];
        tongVc.orderStr = self.model.owner_orderno;
        tongVc.custid = self.model.driver_custid;
        [self.navigationController pushViewController:tongVc animated:YES];
        
    }];
}
-(void)fahuodanButClicked{
    [SMAlert hide:NO];
    TongChBanOrderDetail *tongVc = [[TongChBanOrderDetail alloc]init];
    tongVc.orderStr = self.model.owner_orderno;
    tongVc.custid = self.model.driver_custid;
    [self.navigationController pushViewController:tongVc animated:YES];
}
#pragma mark 弹出申请框
-(void)pushApplyCase{
    
    [UIView animateWithDuration:0.36f animations:^{
        
        backBtn.alpha = 0.48;
        applyInputView.alpha = 1;
        
    }completion:^(BOOL finished) {
        
    }];
}
- (void)getLoadDataBaseAliPayTrue:(NSNotification *)notice{
    NSLog(@"支付结果》》》》%@",notice.userInfo);
    /*
     {
     result = "{"alipay_trade_app_pay_response":{"code":"10000","msg":"Success","app_id":"2016020201135575","auth_app_id":"2016020201135575","charset":"utf-8","timestamp":"2017-09-11 12:07:04","total_amount":"0.01","trade_no":"2017091121001004730285476459","seller_id":"2088911120626880","out_trade_no":"a259a638a2494216bdad-62"},"sign":"avQ9kA4WQR8XqkDbFUPtNgNtSDV79dKGYo4xfxNClRdXolGr5zvDaRS+3zpECgGK9bQIP1/kkTb/T27S3F7JUxd65aMkMarWECIlu31KYqUBso1HQoIInEh+zU/UzWlQWDQgqlI7bXbAmiSnR5mpXWhiT4k0TrqXoa8UH3WZwLI=","sign_type":"RSA"}";
     resultStatus = "9000";
     memo = ""
     }
     
     {
     result = "";
     resultStatus = "6001";
     memo = "用户中途取消"
     }
     */
    if (notice.userInfo) {
        if ([[notice.userInfo objectForKey:@"resultStatus"] intValue] == 9000 ) {
            [SMAlert hide:NO];
            [self paySuccess];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:[notice.userInfo objectForKey:@"memo"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}
- (void)getLoadDataBaseWXPayTrue:(NSNotification *)notice{
    [SMAlert hide:NO];
    [self paySuccess];
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
