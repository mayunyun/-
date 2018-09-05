//
//  ShunFengViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/8/21.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "ShunFengViewController.h"
#import "ShunFengTableViewCell.h"
#import "DWTagView.h"
#import "ShunFengDetailsViewController.h"
#import "FreeRideListModel.h"
#import "DWTagView.h"
#import "HomeKuaiYunVC.h"
@interface ShunFengViewController ()<UITableViewDelegate,UITableViewDataSource,DWTagViewDelegate, DWTagViewDataSource>
{
    NSInteger _page;
    UIButton *_oneBut;
    UIButton *_twoBut;
    
    DWTagView *_typeview;
    NSString*_type1;
    NSString*_type2;
    UIView *_bgView;
    NSString *_sprovince;
    NSString *_scity;
    NSString *_scounty;
    NSString *_eprovince;
    NSString *_ecity;
    NSString *_ecounty;
    UIView *_alicteView;
    NSMutableArray *_arr;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation ShunFengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
     if ([[Command convertNull:self.sfcsprovince] isEqualToString:@""]) {
         _sprovince = [user objectForKey:PROVINCE];
     }else{
         _sprovince = self.sfcsprovince;
     }
    _scity =  [Command convertNull:self.sfcscity];
    _scounty = [Command convertNull:self.sfcscounty];
    _eprovince = [Command convertNull:self.sfceprovince];
    _ecity = [Command convertNull:self.sfcecity];
    _ecounty = [Command convertNull:self.sfcecounty];
    _type1 = @"1";
    _type2 = @"1";
    
    _arr = [[NSMutableArray alloc]init];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, statusbarHeight+44, UIScreenW, 35)];
    //    if (statusbarHeight>20) {
    //        header.frame = CGRectMake(0, 88, UIScreenW, 35);
    //    }
    header.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.view addSubview:header];
    _oneBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, UIScreenW/2-0.5, 34)];
    [_oneBut addTarget:self action:@selector(oneClick) forControlEvents:UIControlEventTouchUpInside];
    if (![[Command convertNull:self.sfcscounty] isEqualToString:@""]) {
        [_oneBut setTitle:_scounty forState:UIControlStateNormal];
    }else if (![[Command convertNull:self.sfcscity] isEqualToString:@""]){
        [_oneBut setTitle:_scity forState:UIControlStateNormal];
    }else{
        [_oneBut setTitle:_sprovince forState:UIControlStateNormal];
    }
    [_oneBut setImage:[UIImage imageNamed:@"ssx_jt"] forState:UIControlStateNormal];
    [self setmodelBut:_oneBut];
    [_oneBut setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _oneBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [header addSubview:_oneBut];
    _twoBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/2+0.5, 0.5, UIScreenW/2-1, 34)];
    [_twoBut addTarget:self action:@selector(twoClick) forControlEvents:UIControlEventTouchUpInside];
    if (![[Command convertNull:self.sfcecounty] isEqualToString:@""]) {
        [_twoBut setTitle:_ecounty forState:UIControlStateNormal];
    }else if (![[Command convertNull:self.sfcecity] isEqualToString:@""]){
        [_twoBut setTitle:_ecity forState:UIControlStateNormal];
    }else if (![[Command convertNull:self.sfceprovince] isEqualToString:@""]){
        [_twoBut setTitle:_eprovince forState:UIControlStateNormal];
    }else{
        [_twoBut setTitle:@"目的地" forState:UIControlStateNormal];
    }
    [_twoBut setImage:[UIImage imageNamed:@"ssx_jt"] forState:UIControlStateNormal];
    [self setmodelBut:_twoBut];
    [_twoBut setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _twoBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [header addSubview:_twoBut];
    
    self.dataArr = [[NSMutableArray alloc]init];
    _page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"货滴顺风车";
    [self tableview];
    [self loadData];
}
- (void)oneClick{
    if ([_type2 isEqualToString:@"1"]&&_bgView) {
        if ([_type1 isEqualToString:@"2"]) {
            _scity = @"";
            _scounty = @"";
            [self loadNewData];
        }else if([_type1 isEqualToString:@"3"]){
            _scounty = @"";
            [self loadNewData];
        }
        [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bgView removeFromSuperview];
        _bgView = nil;
        return;
    }
    [_oneBut setTitleColor:MYColor forState:UIControlStateNormal];
    [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bgView removeFromSuperview];
    [_alicteView removeFromSuperview];
    _bgView = nil;
    _alicteView = nil;
    _type1 = @"1";
    _type2 = @"1";
    NSString *URLStr = @"/mbtwz/address?action=loadProvince";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        _arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"城市地址%@",_arr);
        NSDictionary *dic = @{@"areaname":@"全国"};
        [_arr insertObject:dic atIndex:0];
        if (_arr.count) {
            [self creatUI];
            
        }
        
    }];
}
- (void)twoClick{
    if ([_type2 isEqualToString:@"2"]&&_bgView) {
        if ([_type1 isEqualToString:@"2"]) {
            _ecity = @"";
            _ecounty = @"";
            [self loadNewData];
        }else if([_type1 isEqualToString:@"3"]){
            _ecounty = @"";
            [self loadNewData];
        }
        [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bgView removeFromSuperview];
        _bgView = nil;
        return;
    }
    [_twoBut setTitleColor:MYColor forState:UIControlStateNormal];
    [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bgView removeFromSuperview];
    [_alicteView removeFromSuperview];
    _bgView = nil;
    _alicteView = nil;
    _type1 = @"1";
    _type2 = @"2";
    NSString *URLStr = @"/mbtwz/address?action=loadProvince";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        _arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"城市地址%@",_arr);
        NSDictionary *dic = @{@"areaname":@"全国"};
        [_arr insertObject:dic atIndex:0];
        if (_arr.count) {
            [self creatUI];
            
        }
        
    }];
}
- (void)creatUI{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+statusbarHeight+44, UIScreenW, UIScreenH)];
    //    if (statusbarHeight>20) {
    //        _bgView.frame = CGRectMake(0, 88+35, UIScreenW, UIScreenH);
    //    }
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
        if ([_type2 isEqualToString:@"1"]) {
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全国"]) {
                _sprovince = @"";
                _scity = @"";
                _scounty = @"";
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
        }else if ([_type2 isEqualToString:@"2"]){
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全国"]) {
                _eprovince = @"";
                _ecity = @"";
                _ecounty = @"";
                [_twoBut setTitle:@"全国" forState:UIControlStateNormal];
                [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self loadNewData];
                [_bgView removeFromSuperview];
                _bgView = nil;
            }else{
                _eprovince = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_twoBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [self setmodelBut:_twoBut];
        }
        
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
        if ([_type2 isEqualToString:@"1"]) {
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全省"]) {
                _scity = @"";
                _scounty = @"";
                [_oneBut setTitle:_sprovince forState:UIControlStateNormal];
                [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self loadNewData];
                [_bgView removeFromSuperview];
                _bgView = nil;
            }else{
                _scity = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_oneBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [self setmodelBut:_oneBut];
        }else if ([_type2 isEqualToString:@"2"]){
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全省"]) {
                _ecity = @"";
                _ecounty = @"";
                [_twoBut setTitle:_eprovince forState:UIControlStateNormal];
                [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self loadNewData];
                [_bgView removeFromSuperview];
                _bgView = nil;
            }else{
                _ecity = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_twoBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [self setmodelBut:_twoBut];
        }
        
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
        if ([_type2 isEqualToString:@"1"]) {
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全市"]) {
                _scounty = @"";
                [_oneBut setTitle:_scity forState:UIControlStateNormal];
            }else{
                _scounty = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_oneBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [_oneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setmodelBut:_oneBut];
        }else if ([_type2 isEqualToString:@"2"]){
            if ([[_arr[index] objectForKey:@"areaname"] isEqualToString:@"全市"]) {
                _ecounty = @"";
                [_twoBut setTitle:_ecity forState:UIControlStateNormal];
            }else{
                _ecounty = [NSString stringWithFormat:@"%@",[_arr[index] objectForKey:@"areaname"]];
                [_twoBut setTitle:[_arr[index] objectForKey:@"areaname"] forState:UIControlStateNormal];
            }
            [_twoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setmodelBut:_twoBut];
        }
        [self loadNewData];
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    
}

- (void)setmodelBut:(UIButton *)modelButton{
    // 交换button中title和image的位置
    CGFloat labelWidth = modelButton.titleLabel.intrinsicContentSize.width; //注意不能直接使用titleLabel.frame.size.width,原因为有时候获取到0值
    CGFloat imageWidth = modelButton.imageView.frame.size.width;
    CGFloat space = 4.f; //定义两个元素交换后的间距
    modelButton.titleEdgeInsets = UIEdgeInsetsMake(0, - imageWidth - space,0,imageWidth + space);
    modelButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space, 0,  -labelWidth - space);
    
}
//下拉刷新
- (void)loadNewData{
    [self.dataArr removeAllObjects];
    _page = 1;
    [self loadData];
    [_tableview.mj_header endRefreshing];
    
}
- (void)addUpData{
    _page++;
    [self loadData];
    [_tableview.mj_footer endRefreshing];
}
#pragma 在这里面请求数据
- (void)loadData
{
//    if ([_use_car_typeStr isEqualToString:@"2"]) {
//        _use_car_typeStr = @"";
//    }
//    //

    NSString *URLStr = @"/mbtwz/freeride?action=searchFreeRideList";
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8",@"params":[NSString stringWithFormat:@"{\"sprovince\":\"%@\",\"scity\":\"%@\",\"scounty\":\"%@\",\"eprovince\":\"%@\",\"ecity\":\"%@\",\"ecounty\":\"%@\"}",_sprovince,_scity,_scounty,_eprovince,_ecity,_ecounty]};
    NSLog(@"参数==%@",params);

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"zulin%@",diction);
        NSDictionary* response = diction[@"response"];
        if ([[response objectForKey:@"rows"] count]) {
            for (NSDictionary *dic in [response objectForKey:@"rows"]) {
                //建立模型
                FreeRideListModel *model=[[FreeRideListModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [self.dataArr addObject:model];
            }
        }

        [self.tableview reloadData];



    }];
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 35+statusbarHeight+44, UIScreenW, UIScreenH-35-statusbarHeight-44)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addUpData)];
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * stringCell = @"ShunFengTableViewCell";
    ShunFengTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
    }
    if (!IsEmptyValue(self.dataArr)) {
        cell.model = self.dataArr[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.didButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.didButton.tag = 1000+indexPath.row;
    [cell.didButton addTarget:self action:@selector(didButClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShunFengDetailsViewController *deta = [[ShunFengDetailsViewController alloc]init];
    FreeRideListModel* model = self.dataArr[indexPath.row];
    deta.idStr = [NSString stringWithFormat:@"%@",model.Id];
    deta.orderid = self.orderid;
    [self.navigationController pushViewController:deta animated:YES];
}
- (void)didButClick:(UIButton*)sender{
   
    jxt_showAlertTwoButton(@"提示", @"确认使用该顺风车吗", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        FreeRideListModel* model = self.dataArr[sender.tag - 1000];
        if ([[Command convertNull:self.orderid] isEqualToString:@""]) {
            
            //检测是否在此顺风车下发布过订单
            NSString *URLStr = @"/mbtwz/freeride?action=checkJoinFreeRideOne";
            
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"frid\":\"%@\"}",model.Id]};
            
            
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
                NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"zulin%@",diction);
                if ([diction[@"flag"] integerValue] == 200) {
                    [Command isloginRequest:^(bool str) {
                        if (str) {
                            HomeKuaiYunVC *kuaiyun = [[HomeKuaiYunVC alloc]init];
                            kuaiyun.hidesBottomBarWhenPushed = YES;
                            kuaiyun.type = @"1";
                            kuaiyun.idStr = [NSString stringWithFormat:@"%@",model.Id];
                            kuaiyun.sprovince = [NSString stringWithFormat:@"%@",model.sprovince];
                            kuaiyun.scity = [NSString stringWithFormat:@"%@",model.scity];
                            kuaiyun.scounty = [NSString stringWithFormat:@"%@",model.scounty];
                            kuaiyun.eprovince = [NSString stringWithFormat:@"%@",model.eprovince];
                            kuaiyun.ecity = [NSString stringWithFormat:@"%@",model.ecity];
                            kuaiyun.ecounty = [NSString stringWithFormat:@"%@",model.ecounty];
                            
                            kuaiyun.Qlocation = CLLocationCoordinate2DMake([model.slatitude floatValue], [model.slongitude floatValue]);
                            kuaiyun.Zlocation = CLLocationCoordinate2DMake([model.elatitude floatValue], [model.elongitude floatValue]);
                            [self.navigationController pushViewController:kuaiyun animated:YES];
                        }else{
                            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                                
                            }, @"前往", ^(NSInteger buttonIndex) {
                                LoginVC* vc = [[LoginVC alloc]init];
                                vc.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:vc animated:YES];
                            });
                        }
                    }];
                }else{
                    
                    jxt_showAlertTwoButton(@"您在此顺风车下已发布过订单", @"是否继续发布订单", @"取消", ^(NSInteger buttonIndex) {
                        
                    }, @"继续", ^(NSInteger buttonIndex) {
                        [Command isloginRequest:^(bool str) {
                            if (str) {
                                HomeKuaiYunVC *kuaiyun = [[HomeKuaiYunVC alloc]init];
                                kuaiyun.hidesBottomBarWhenPushed = YES;
                                kuaiyun.type = @"1";
                                kuaiyun.idStr = [NSString stringWithFormat:@"%@",model.Id];
                                kuaiyun.sprovince = [NSString stringWithFormat:@"%@",model.sprovince];
                                kuaiyun.scity = [NSString stringWithFormat:@"%@",model.scity];
                                kuaiyun.scounty = [NSString stringWithFormat:@"%@",model.scounty];
                                kuaiyun.eprovince = [NSString stringWithFormat:@"%@",model.eprovince];
                                kuaiyun.ecity = [NSString stringWithFormat:@"%@",model.ecity];
                                kuaiyun.ecounty = [NSString stringWithFormat:@"%@",model.ecounty];
                                
                                kuaiyun.Qlocation = CLLocationCoordinate2DMake([model.slatitude floatValue], [model.slongitude floatValue]);
                                kuaiyun.Zlocation = CLLocationCoordinate2DMake([model.elatitude floatValue], [model.elongitude floatValue]);
                                [self.navigationController pushViewController:kuaiyun animated:YES];
                            }else{
                                jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                                    
                                }, @"前往", ^(NSInteger buttonIndex) {
                                    LoginVC* vc = [[LoginVC alloc]init];
                                    vc.hidesBottomBarWhenPushed = YES;
                                    [self.navigationController pushViewController:vc animated:YES];
                                });
                            }
                        }];
                    });
                }
                
            }];
            
        }
        else{
            NSString *URLStr = @"/mbtwz/freeride?action=joinFreeRideOne";
            
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderid\":\"%@\",\"frid\":\"%@\"}",self.orderid,model.Id]};
            NSLog(@"参数==%@",params);
            
            [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
                NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"zulin%@",diction);
                if ([diction[@"flag"] integerValue] == 200) {
                    jxt_showAlertOneButton(@"提示", [NSString stringWithFormat:@"%@",diction[@"msg"]], @"确定", ^(NSInteger buttonIndex) {
                        
                    });
                }else{
                    jxt_showAlertOneButton(@"提示", [NSString stringWithFormat:@"%@",diction[@"msg"]], @"确定", ^(NSInteger buttonIndex) {
                        
                    });
                }
                
            }];
        }
    });
    
    

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
