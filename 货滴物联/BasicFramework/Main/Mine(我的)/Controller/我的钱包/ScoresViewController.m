//
//  ScoresViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ScoresViewController.h"
#import "ScoresTableViewCell.h"
#import "ScoresModel.h"
@interface ScoresViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation ScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"积分";
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];

    [self setScoresUIView];
    [self tableview];
    [self loadNew];
}
#pragma 在这里面请求数据
- (void)loadNew
{
    [_dataArr removeAllObjects];
    //最新动态
    NSString *URLStr = @"/mbtwz/wallet?action=getCustScoreList&callback";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"我的积分%@",array);
        //建立模型
        for (NSDictionary*dic in array ) {
            ScoresModel *model=[[ScoresModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [self.dataArr addObject:model];
        }
        [self.tableview reloadData];

        
    }];
    
    
    
}
- (void)setScoresUIView{
    
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavBarHeight, UIScreenW, 180*MYWIDTH)];
    bgimage.image = [UIImage imageNamed:@"积分页"];
    
    [self.view addSubview:bgimage];
    UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(25*MYWIDTH, bgimage.height/4, 150*MYWIDTH, 25*MYWIDTH)];
    title.text = @"当前积分:";
    title.textAlignment = NSTextAlignmentLeft;
    title.textColor = UIColorFromRGB(0xffffff);
    title.font = [UIFont systemFontOfSize:15];
    [bgimage addSubview:title];
    
    UILabel *headtitle  = [[UILabel alloc]initWithFrame:CGRectMake(25*MYWIDTH, bgimage.height/2, UIScreenW-50*MYWIDTH, 40)];
    headtitle.textAlignment = NSTextAlignmentRight;
    if ([[NSString stringWithFormat:@"%@",_model.scores] isEqualToString:@"(null)"]) {
        headtitle.text = @"0";
    }else{
        headtitle.text = [NSString stringWithFormat:@"%.2f",[_model.scores floatValue]];
    }
    headtitle.textColor = UIColorFromRGB(0x333333);
    headtitle.font = [UIFont systemFontOfSize:30];
    [bgimage addSubview:headtitle];
    
    UILabel *mingxi = [[UILabel alloc]initWithFrame:CGRectMake(0, bgimage.bottom, UIScreenW, 45*MYWIDTH)];
    mingxi.text = @"  明细";
    mingxi.font = [UIFont systemFontOfSize:13];
    mingxi.backgroundColor = [UIColor whiteColor];
    mingxi.textColor = UIColorFromRGB(0x333333);
//    [self.view addSubview:mingxi];
    
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight+180*MYWIDTH, kScreenWidth, UIScreenH-NavBarHeight-180*MYWIDTH)];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 20)];
        _tableview.tableHeaderView = head;
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 20)];

        _tableview.tableFooterView = food;
        [_tableview registerNib:[UINib nibWithNibName:@"ScoresTableViewCell" bundle:nil] forCellReuseIdentifier:@"ScoresTableViewCell"];
    }
    return _tableview;
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ScoresTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ScoresTableViewCell"];
    if (!cell) {
        cell=[[ScoresTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScoresTableViewCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //圆角
    cell.bgView.frame = CGRectMake(15, 0, UIScreenW-30, 49);
    UIBezierPath *maskPath;
    if (indexPath.row == 0) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bgView.bounds byRoundingCorners:UIRectCornerTopRight |UIRectCornerTopLeft cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.bgView.layer.mask = maskLayer;
    }else if (indexPath.row == _dataArr.count-1){
        maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bgView.bounds byRoundingCorners:UIRectCornerBottomRight |UIRectCornerBottomLeft cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.bgView.layer.mask = maskLayer;
    }
    ScoresModel *model = _dataArr[indexPath.row];
    [cell setData:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    NSLog(@"%ld",indexPath.row);
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
