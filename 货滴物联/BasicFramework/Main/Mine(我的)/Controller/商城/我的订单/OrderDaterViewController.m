//
//  OrderDaterViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OrderDaterViewController.h"
#import "ShopOrderTableViewCell.h"
#import "MYYMyOrderModel.h"
#import "MYYMyOrderClassModer.h"
@interface OrderDaterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_YuENumer;//余额
    NSString *_orderId;//订单号
    
}
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) MYYMyOrderModel *Ordermodel;
@end

@implementation OrderDaterViewController

{
    
    UILabel        *_monlab;
    NSMutableArray* _dataArray;//订单商品
    
}
- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight  = 1.0;
        [_tableView registerNib:[UINib nibWithNibName:@"ShopOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopOrderTableViewCell"];
        [self.view addSubview:_tableView];
        
        UIView *viewal = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenH-45, UIScreenW, 45)];
        viewal.backgroundColor = [UIColor clearColor];
        [self.view addSubview:viewal];
        
        UIButton *monBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW - 120, 0, 100, 30)];
        monBut.clipsToBounds=YES;
        monBut.layer.cornerRadius=15;
        [monBut setTitle:@"确认收货"forState:UIControlStateNormal];
        monBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [monBut setBackgroundColor:MYColor];
        [monBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [monBut addTarget:self action:@selector(butwhihGo:) forControlEvents:UIControlEventTouchUpInside];
        [viewal addSubview:monBut];
        _tableView.tableFooterView = viewal;
    }
    return _tableView;
}
- (void)viewDidLoad {
    _dataArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    [self TableView];
    [self dataRequest];
    
}

//地址
- (UIView *)addressView{
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 80)];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(45, 15, 100, 20)];
    name.text = [NSString stringWithFormat:@"收货人：%@",@""];
    if (!IsEmptyValue(_Ordermodel.custname)) {
        name.text = [NSString stringWithFormat:@"收货人：%@",_Ordermodel.shcustname];
    }
    name.font = [UIFont systemFontOfSize:14];
    name.textColor = UIColorFromRGB(0x333333);
    CGSize maximumLabelSize = CGSizeMake(100, 20);
    CGSize expectSize = [name sizeThatFits:maximumLabelSize];
    name.frame = CGRectMake(40, 16, expectSize.width, expectSize.height);
    [view addSubview:name];
    
    UILabel *phonelab = [[UILabel alloc]initWithFrame:CGRectMake(name.size.width+55, 15, 100, 20)];
    phonelab.text = [NSString stringWithFormat:@"%@",@""];
    if (!IsEmptyValue(_Ordermodel.custphone)) {
        phonelab.text = [NSString stringWithFormat:@"%@",_Ordermodel.shphone];
    }
    phonelab.font = [UIFont systemFontOfSize:14];
    phonelab.textColor = UIColorFromRGB(0x333333);
    [view addSubview:phonelab];
    
    UILabel *addressLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 35, UIScreenW-80, 40)];
    addressLab.text = @"收货地址:";
    if (!IsEmptyValue(_Ordermodel.custaddress)) {
        addressLab.text = [NSString stringWithFormat:@"收货地址:   %@",_Ordermodel.custaddress];
    }
    addressLab.font = [UIFont systemFontOfSize:12];
    addressLab.numberOfLines = 0;
    addressLab.textColor = UIColorFromRGB(0x666666);
    [view addSubview:addressLab];
    
    UIImageView *xian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 78, UIScreenW, 2)];
    xian.image = [UIImage imageNamed:@"组"];
    [view addSubview:xian];
    
    return view;
}

- (UIView *)xiaojiView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 50*MYWIDTH)];
    view.backgroundColor = [UIColor whiteColor];
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0*MYWIDTH, 80, 30*MYWIDTH)];
//    lab.text = @"运费";
//    lab.font = [UIFont systemFontOfSize:12];
//    lab.textColor = UIColorFromRGB(0x333333);
//    [view addSubview:lab];
//
//    UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(15, 30*MYWIDTH, UIScreenW-30, 1*MYWIDTH)];
//    xian.backgroundColor = UIColorFromRGB(MYLine);
//    [view addSubview:xian];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 50*MYWIDTH)];
    lab1.text = @"总计";
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.textColor = UIColorFromRGB(0x333333);
    [view addSubview:lab1];
    
//    UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW-90, 0*MYWIDTH, 80, 30*MYWIDTH)];
//    pay.text = [NSString stringWithFormat:@"￥%d",0];
//    pay.font = [UIFont systemFontOfSize:12];
//    pay.textAlignment = NSTextAlignmentRight;
//    pay.textColor = UIColorFromRGB(0x333333);
//    [view addSubview:pay];
    
    UILabel *pay1 = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW-320, 0, 310, 50*MYWIDTH)];
    pay1.text = [NSString stringWithFormat:@"￥%.2f  %@积分",[_Ordermodel.totalmoney floatValue],_Ordermodel.totaljifen];
    if ([_Ordermodel.type intValue]==2) {
        pay1.text = [NSString stringWithFormat:@"%@积分",_Ordermodel.totalmoney];
    }
    pay1.font = [UIFont systemFontOfSize:14];
    pay1.textAlignment = NSTextAlignmentRight;
    pay1.textColor = MYColor;
    [view addSubview:pay1];
    
    return view;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return _dataArray.count+2;
        
    }else if (section == 1){
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15*MYWIDTH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == _dataArray.count+1) {
            return 40*MYWIDTH;
        }else{
            return 140*MYWIDTH;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 40*MYWIDTH;
        }else{
            return 90*MYWIDTH;
        }
    }
    return 70*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"dingwei.png"];
            cell.textLabel.text = @"收货地址";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 39*MYWIDTH, UIScreenW, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
        }else{
            [cell.contentView addSubview:[self addressView]];
        }
    }else if (indexPath.section == 2){
        cell.contentView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [cell.contentView addSubview:[self xiaojiView]];
    }else{
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"订单.png"];
            cell.textLabel.text = @"商品列表";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            
            UILabel *numer = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW-190, 0, 180, 40*MYWIDTH)];
            numer.text = @"";
            switch ([_Ordermodel.orderstatus intValue]) {
                case 0:
                    numer.text = @"待支付";
                    break;
                case 1:
                    numer.text = @"待发货";
                    break;
                case 2:
                    numer.text = @"待收货";
                    break;
                case 4:
                    numer.text = @"已完成";
                    break;
                default:
                    break;
            }
            numer.font = [UIFont systemFontOfSize:12];
            numer.textAlignment = NSTextAlignmentRight;
            numer.textColor = UIColorFromRGB(0x888888);
            [cell.contentView addSubview:numer];
            
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 39*MYWIDTH, UIScreenW, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
        }
        else if (indexPath.row == _dataArray.count+1){
            UILabel *bianhao = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 180, 40*MYWIDTH)];
            bianhao.text = [NSString stringWithFormat:@"订单编号:%@",@""];
            if (!IsEmptyValue(_Ordermodel.orderno)) {
                bianhao.text = [NSString stringWithFormat:@"订单编号:   %@",_Ordermodel.orderno];
            }
            bianhao.font = [UIFont systemFontOfSize:12];
            bianhao.textColor = UIColorFromRGB(0x888888);
            [cell.contentView addSubview:bianhao];
            
            UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW-190, 0, 180, 40*MYWIDTH)];
            time.text = [NSString stringWithFormat:@"%@",@""];
            if (!IsEmptyValue(_Ordermodel.createtime)) {
                time.text = [NSString stringWithFormat:@"%@",_Ordermodel.createtime];
            }
            time.font = [UIFont systemFontOfSize:12];
            time.textAlignment = NSTextAlignmentRight;
            time.textColor = UIColorFromRGB(0x888888);
            [cell.contentView addSubview:time];
        }
        else{
            ShopOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopOrderTableViewCell" forIndexPath:indexPath];
            if (!IsEmptyValue(_dataArray)) {
                NSLog(@"%@",_dataArray);
                MYYMyOrderClassModer *model = _dataArray[indexPath.row-1];
                [cell.imgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,model.folder,model.autoname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
                cell.titleLab.text = [NSString stringWithFormat:@"%@",model.proname];
                cell.otherLab.text = [NSString stringWithFormat:@"%@",model.productdes];
                cell.color.text = [NSString stringWithFormat:@"%@",model.color];
                cell.typeLab.text = [NSString stringWithFormat:@"适合车型:%@",model.specification];
                cell.priceLab.text = [NSString stringWithFormat:@"￥%.2f  %@积分",[model.price floatValue],model.price_jf];
                if ([_Ordermodel.type intValue]==2) {
                    cell.priceLab.text = [NSString stringWithFormat:@"%@积分",model.price];
                }
                cell.numerLab.text = [NSString stringWithFormat:@"x%@",model.count];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 10)];
    header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return header;
}


- (void)dataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_idstr]};
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/scshop?action=getOneOrder" Parameters:params FinishedLogin:^(id responseObject) {

        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",array);
        if (!IsEmptyValue(array)) {
            _Ordermodel=[[MYYMyOrderModel alloc]init];
            [_Ordermodel setValuesForKeysWithDictionary:array[0]];
            
            if ([_Ordermodel.orderstatus intValue]!=2) {
                _tableView.tableFooterView = nil;
            }
            [self dataOrder:_Ordermodel.id];
        }
        
    }];
}
- (void)dataOrder:(NSString *)strid{
    
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"orderid\":\"%@\"}",strid]};
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/scshop?action=getOrderProList" Parameters:params FinishedLogin:^(id responseObject) {

        NSArray* array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",array);
        if (!IsEmptyValue(array)) {
            for (NSDictionary*dic in array) {
                MYYMyOrderClassModer *model=[[MYYMyOrderClassModer alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_dataArray addObject:model];
                _orderId = [NSString stringWithFormat:@"%@",model.orderno];
                
            }
        }
        [_tableView reloadData];
        
    }];
}

//支付订单
#pragma mark 确认收货
- (void)butwhihGo:(UIButton *)but{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"orderid\":\"%@\"}",_idstr]};
    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/scshop?action=updateOrder_4" Parameters:params FinishedLogin:^(id responseObject) {

        NSString* str = [[NSString alloc]initWithData:responseObject encoding:kCFStringEncodingUTF8];
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"确认收货操作失败", 1);
        }else{
            jxt_showAlertOneButton(@"提示", @"收货成功", @"确定", ^(NSInteger buttonIndex) {
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"orderUpData" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    
        
    }];
}
@end

