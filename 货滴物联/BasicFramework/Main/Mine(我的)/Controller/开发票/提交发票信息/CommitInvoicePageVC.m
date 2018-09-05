//
//  CommitInvoicePageVC.m
//  BasicFramework
//
//  Created by 钱龙 on 2018/3/1.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "CommitInvoicePageVC.h"
#import "CommitInvoiceBottomView.h"
#import "ShoppingCartSectionHeaderView.h"
#import "InvoiceTypeCell.h"
#import "InvoiceDetailCell.h"
#import "InfoMationCell.h"
#import "InvoiceCompanyCell.h"
#import "InvoiceHistoryVC.h"
#import "InvoiceVC.h"
@interface CommitInvoicePageVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) CommitInvoiceBottomView *bottomView;
@property (nonatomic,strong)NSString * flag;

@end

@implementation CommitInvoicePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"按行程开票";
    _flag = @"1";
    [self setUpUI];
    
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
- (void)setUpUI
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:[self bottomView]];
    
    __weak CommitInvoicePageVC *weakSelf = self;
    [_bottomView setCommitBtnBlock:^{
        if ([weakSelf.flag isEqualToString:@"1"]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:2];
            InvoiceDetailCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            InfoMationCell * infoCell = [weakSelf.tableView cellForRowAtIndexPath:index];
            NSLog(@"-----%@-----%@",cell.taitouTf.text,cell.taitouTf);
            if ([cell.taitouTf.text isEqualToString:@""]) {
                jxt_showToastTitle(@"发票抬头不能为空", 1);
                return ;
            }
            if ([cell.shuihaoTf.text isEqualToString:@""]) {
                jxt_showToastTitle(@"发票税号不能为空", 1);
                return ;
            }
            if ([cell.addressTf.text isEqualToString:@""]) {
                jxt_showToastTitle(@"发票地址不能为空", 1);
                return ;
            }
            if ([cell.phoneTf.text isEqualToString:@""]) {
                jxt_showToastTitle(@"联系电话不能为空", 1);
                return ;
            }
            if (![Command isMobileNumber:cell.phoneTf.text]) {
                jxt_showToastTitle(@"请填写正确的手机号码", 1);
                return;
            }
            if ([cell.kaihuhangTf.text isEqualToString:@""]) {
                jxt_showToastTitle(@"银行卡号不能为空", 1);
                return ;
            }
            if ([infoCell.emailTf.text isEqualToString:@""]) {
                jxt_showToastTitle(@"邮箱不能为空", 1);
                return ;
            }
            if (![Command isValidateEmail:infoCell.emailTf.text]) {
                jxt_showToastTitle(@"邮箱格式不正确", 1);
                return;
            }
            [weakSelf requestData:cell.taitouTf.text invoicecontent:cell.contentTf.text invoiceaddress:cell.addressTf.text invoicephone:cell.phoneTf.text bankaccount:cell.kaihuhangTf.text email:infoCell.emailTf.text note:cell.noteTf.text invoicetype:@"0"];
        }else{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:2];
            InvoiceCompanyCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            InfoMationCell * infoCell = [weakSelf.tableView cellForRowAtIndexPath:index];
            if ([cell.taitouTf.text isEqualToString:@""]) {
                jxt_showToastTitle(@"发票抬头不能为空", 1);
                return ;
            }
            if ([infoCell.emailTf.text isEqualToString:@""]) {
                jxt_showToastTitle(@"邮箱不能为空", 1);
                return ;
            }
            if (![Command isValidateEmail:infoCell.emailTf.text]) {
                jxt_showToastTitle(@"邮箱格式不正确", 1);
                return;
            }
            [weakSelf requestData:cell.taitouTf.text invoicecontent:@"" invoiceaddress:@"" invoicephone:@"" bankaccount:@"" email:infoCell.emailTf.text note:cell.noteTf.text invoicetype:@"1"];
        
        }
        
    }];
    
    
    
}
-(void)requestData:(NSString *)invoicetaitou invoicecontent:(NSString *)invoicecontent invoiceaddress:(NSString *)invoiceaddress invoicephone:(NSString *)invoicephone bankaccount:(NSString *)bankaccount email:(NSString *)email note:(NSString *)note invoicetype:(NSString *)invoicetype{
    NSString* urlstr = @"/invoice?action=addInvoice";
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setValue:[NSString stringWithFormat:@"%@",invoicetype] forKey:@"invoicetype"];
    [param setValue:[NSString stringWithFormat:@"%@",invoicetaitou] forKey:@"invoicetaitou"];
    [param setValue:[NSString stringWithFormat:@"%@",invoicecontent] forKey:@"invoicecontent"];
    [param setValue:[NSString stringWithFormat:@"%@",self.invoicemoney] forKey:@"invoicemoney"];
    [param setValue:[NSString stringWithFormat:@"%@",invoiceaddress] forKey:@"invoiceaddress"];
    [param setValue:[NSString stringWithFormat:@"%@",invoicephone] forKey:@"invoicephone"];
    [param setValue:[NSString stringWithFormat:@"%@",bankaccount] forKey:@"bankaccount"];
    [param setValue:[NSString stringWithFormat:@"%@",email] forKey:@"email"];
    [param setValue:[NSString stringWithFormat:@"%@",note] forKey:@"note"];
    [param setValue:[NSString stringWithFormat:@"%@",self.ordertype] forKey:@"typeorder"];
    [param setValue:[NSString stringWithFormat:@"%@",self.orderids] forKey:@"orderids"];
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:param]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:KCparams FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"提交失败", 1);
        }else{
            [self updateInterface];
        }
        
    }];
}
-(void)updateInterface{
    NSString* urlstr = @"/invoice?action=updateOrderStatus";
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setValue:[NSString stringWithFormat:@"%@",self.ordertype] forKey:@"typeorder"];
    [param setValue:[NSString stringWithFormat:@"%@",self.orderids] forKey:@"orderids"];
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:param]};//
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:KCparams FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"提交成功,请到开票历史查看!", 1);
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[InvoiceVC class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }else{
            
        }
    }];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *const cellID = @"InvoiceTypeCell";
        InvoiceTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:nil options:nil]lastObject];
        }
        cell.bgview.layer.cornerRadius = 4.f;
        cell.bgview.layer.masksToBounds = YES;
        cell.bgview.layer.borderWidth = 1.f;
        cell.bgview.layer.borderColor = UIColorFromRGB(0xCE3D59).CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (indexPath.section == 1){
        
        if ([_flag isEqualToString:@"1"]) {
            
            static NSString *const cellID = @"InvoiceDetailCell";
            InvoiceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:nil options:nil]lastObject];
            }
            [cell.personBtn addTarget:self action:@selector(personBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.priceTf.text = [NSString stringWithFormat:@"%@元",self.invoicemoney];
            [self changeTextfont:cell.priceTf Txt:cell.priceTf.text changeTxt:[NSString stringWithFormat:@"%@",self.invoicemoney]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            static NSString *const cellID = @"InvoiceCompanyCell";
            InvoiceCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:nil options:nil]lastObject];
            }
            [cell.companyBtn addTarget:self action:@selector(companyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
             cell.priceTf.text = [NSString stringWithFormat:@"%@元",self.invoicemoney];
            [self changeTextfont:cell.priceTf Txt:cell.priceTf.text changeTxt:[NSString stringWithFormat:@"%@",self.invoicemoney]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    
    }else{
        static NSString *const cellID = @"InfoMationCell";
        InfoMationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:nil options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    }else if (indexPath.section == 1){
        if ([_flag isEqualToString:@"1"]) {
            return 340;
        }
        return 200;
    }else{
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
//设置自定义的sectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *identifier = @"ShoppingCartViewController_cell_header";
    ShoppingCartSectionHeaderView *hearderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!hearderView) {
        hearderView = [[ShoppingCartSectionHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    hearderView.section = section;
    if (section == 0) {
        [hearderView setInfo:@"请选择发票类型"];
    }else if (section == 1){
        [hearderView setInfo:@"发票详情"];
    }else{
        [hearderView setInfo:@"收件信息"];
    }
    return hearderView;
}
//设置自定义的sectionFooter,去除sectionFooter
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - set/get
- (CommitInvoiceBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[CommitInvoiceBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44-kIPhoneXBottomHeight, kScreenWidth, 44)];
    }
    return _bottomView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight-44-kIPhoneXBottomHeight-NavBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        UIView * foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 50*MYWIDTH)];
        foot.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = foot;
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
-(void)personBtnClicked{
    _flag = @"2";
    [_tableView reloadData];
}
-(void)companyBtnClicked{
    _flag = @"1";
    [_tableView reloadData];
}
#pragma mark - 改变某字符串颜色
//
- (void)changeTextfont:(UITextField *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(location, length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14*MYWIDTH] range:NSMakeRange(location, length)];
        
        //赋值
        label.attributedText = str1;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

@end
