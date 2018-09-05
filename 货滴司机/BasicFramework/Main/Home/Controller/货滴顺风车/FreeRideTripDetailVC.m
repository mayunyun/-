//
//  FreeRideTripDetailVC.m
//  BasicFramework
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "FreeRideTripDetailVC.h"
#import "FreeRideTripDetailCell.h"

@interface FreeRideTripDetailVC()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _dataArr;
    NSDictionary *_dict;
    UIButton* nextBtn;
}
@property (nonatomic,strong)UITableView* tbView;
@end

@implementation FreeRideTripDetailVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"货滴顺风车详情";
    _dataArr = [[NSMutableArray alloc]init];
    [self dataRequest];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50);
    [nextBtn setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"取 消 行 程" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
}
//查询接口
- (void)dataRequest{
    
    
    
    NSDictionary* params = @{@"id":_id};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:params]};//

    NSString *url = @"/mbtwz/freeride?action=selectSelfFreeRideDet";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        _dict = [[dic objectForKey:@"response"][0] objectForKey:@"freerideDet"];
        _dataArr = [[dic objectForKey:@"response"][0] objectForKey:@"freerideJoin"];
        
        [self tbView];
        
    }];
    
    
}
- (UITableView*)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, statusbarHeight+44, kScreenWidth, kScreenHeight - statusbarHeight-44-50) style:UITableViewStylePlain];
        if ([[_dict objectForKey:@"state"] intValue]==0) {
            _tbView.frame = CGRectMake(0, statusbarHeight+44, kScreenWidth, kScreenHeight - statusbarHeight-44);
            nextBtn.hidden = YES;
        }
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tbView];
        _tbView.tableHeaderView = [self tableHeaderViewUI];
        
    }
    return _tbView;
}

- (UIView*)tableHeaderViewUI{
    NSMutableArray *rightArr = [[NSMutableArray alloc]init];
    [rightArr addObject:[NSString stringWithFormat:@"%@%@%@",[_dict objectForKey:@"sprovince"],[_dict objectForKey:@"scity"],[_dict objectForKey:@"scounty"]]];
    [rightArr addObject:[NSString stringWithFormat:@"%@%@%@",[_dict objectForKey:@"eprovince"],[_dict objectForKey:@"ecity"],[_dict objectForKey:@"ecounty"]]];
    [rightArr addObject:[NSString stringWithFormat:@"%@",[_dict objectForKey:@"waytocitysshow"]]];
    [rightArr addObject:[NSString stringWithFormat:@"%@米",[_dict objectForKey:@"totalvehicle"]]];
    [rightArr addObject:[NSString stringWithFormat:@"%@米",[_dict objectForKey:@"availablevehicle"]]];
    [rightArr addObject:[NSString stringWithFormat:@"%@",[_dict objectForKey:@"deptime"]]];
    [rightArr addObject:[NSString stringWithFormat:@"%@",[_dict objectForKey:@"cretime"]]];

    NSArray* imageArray = @[@"起点",@"终点",@"途径",@"总车长",@"总车长",@"行程发布时间",@"行程发布时间"];
    NSArray* titleArray = @[@"起点",@"终点",@"途径",@"总车长",@"可用车长",@"出发时间",@"行程发布时间"];
    UIView* baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20+imageArray.count*45+70)];
    baseView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    UIView* sView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 45*7)];
    sView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:sView];

    for (int i=0; i < imageArray.count; i++) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, i*45, kScreenWidth, 45)];
        view.backgroundColor = [UIColor clearColor];
        [sView addSubview:view];
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [view addSubview:line];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
        imageView.tag = 1000+i;
        if (i < imageArray.count) {
            [imageView setImage:[UIImage imageNamed:imageArray[i]]];
        }
        [view addSubview:imageView];
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 10, imageView.top - 5, 100, imageView.height + 10)];
        if (i < titleArray.count) {
            titleLabel.text = titleArray[i];
        }
        titleLabel.font = [UIFont systemFontOfSize:16];
        [view addSubview:titleLabel];
        CGFloat fontF = 14;
        UIColor* mycolor = UIColorFromRGB(0x333333);
        UILabel* rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 0, kScreenWidth - 10 - titleLabel.right, 44)];
        rightLabel.tag =  2000+i;
        rightLabel.textColor = mycolor;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:fontF];
        if (i < rightArr.count) {
            rightLabel.text = rightArr[i];
        }
        [view addSubview:rightLabel];
        
        
    }
    return baseView;
}

- (void)nextClick:(UIButton*)sender{
    
    jxt_showAlertTwoButton(@"提示", @"您确定取消行程吗？", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        NSDictionary* params = @{@"frid":_id};
        NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:params]};//
        
        NSString *url = @"/mbtwz/freeride?action=cancelFreeRideTrip";
        
        [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:KCparams FinishedLogin:^(id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if ([[dic objectForKey:@"flag"] intValue]==200) {
                jxt_showAlertOneButton(@"提示", @"行程取消成功", @"确定", ^(NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                jxt_showAlertOneButton(@"提示", [NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]], @"确定", ^(NSInteger buttonIndex) {
                    
                });
            }
            
        }];
    });
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArr.count) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 44)];
    label.text = @"用车货主信息";
    label.font = [UIFont systemFontOfSize:16];
    [view addSubview:label];
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    return view;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FreeRideTripDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FreeRideTripDetailCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FreeRideTripDetailCell" owner:self options:nil]firstObject];
    }
    if (_dataArr.count) {
        NSDictionary *dic = _dataArr[indexPath.section];
        cell.name.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"custname"]];
        cell.phone.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"consignorphone"]];
        NSString *image = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,[dic objectForKey:@"folder"],[dic objectForKey:@"autoname"]];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    return cell;
}

@end
