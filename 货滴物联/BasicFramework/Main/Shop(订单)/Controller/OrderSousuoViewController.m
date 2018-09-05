//
//  OrderSousuoViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/2/28.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "OrderSousuoViewController.h"
#import "OrderViewController.h"
@interface OrderSousuoViewController ()

@end

@implementation OrderSousuoViewController{
    NSString *_createtime;
    NSString *_ordertype;
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"订单搜索";
    _page = 0;
    [self.timeBut setTitle:@"请选择时间" forState:UIControlStateNormal];
    [self.timeBut setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _createtime = @"";
    [self.typeBut setTitle:@"同城小件单" forState:UIControlStateNormal];
    _ordertype = @"0";
    [self.typeBut setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self placeholderColor:self.orderonField str:self.orderonField.placeholder color:UIColorFromRGB(0x333333)];
    [self placeholderColor:self.nameField str:self.nameField.placeholder color:UIColorFromRGB(0x333333)];
    [self placeholderColor:self.phoneField str:self.phoneField.placeholder color:UIColorFromRGB(0x333333)];

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
- (IBAction)sousuoButClick:(UIButton *)sender {
    
    NSString *url = @"/mbtwz/logisticssendwz?action=searchOrderByParam";
    NSDictionary * dic =@{@"orderno":self.orderonField.text,
                          @"link_name":self.nameField.text,
                          @"link_phone":self.phoneField.text,
                          @"createtime":_createtime,
                          @"ordertype":_ordertype
                          };
    //NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8",@"data":[Command dictionaryToJson:dic]};
    NSDictionary* params = @{@"data":[Command dictionaryToJson:dic]};

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:params FinishedLogin:^(id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"搜索订单%@",array);
        if (array.count) {
            
            OrderViewController *orderVc = [[OrderViewController alloc]init];
            orderVc.params = params;
            orderVc.typeStr = _ordertype;
            [self.navigationController pushViewController:orderVc animated:YES];
        }else{
            jxt_showAlertTitle(@"暂无搜索结果");
        }
        
    }];
}
- (IBAction)timeClick:(UIButton *)sender {
    __weak typeof(UIButton*) weakBtn = sender;
    [BRDatePickerView showDatePickerWithTitle:@"订单时间" dateType:UIDatePickerModeDate defaultSelValue:nil minDateStr:@"" maxDateStr:[Command currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
        
        [weakBtn setTitle:selectValue forState:UIControlStateNormal];
        _createtime = selectValue;
    }];
}
- (IBAction)typeClick:(UIButton *)sender {
    //    // 自定义多列字符串
    
    __weak typeof(self) weakSelf = self;
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:@[@"同城小件单",@"同城搬家单",@"货滴快运单"] defaultSelValue:weakSelf isAutoSelect:NO resultBlock:^(id selectValue) {
        
        NSString *timeStr = [NSString stringWithFormat:@"%@",selectValue];
        [sender setTitle:timeStr forState:UIControlStateNormal];
        if ([timeStr isEqualToString:@"同城小件单"]) {
            _ordertype = @"0";
        }else if ([timeStr isEqualToString:@"同城搬家单"]){
            _ordertype = @"1";
        }else{
            _ordertype = @"2";
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)placeholderColor:(UITextField*)textField str:(NSString*)holderText color:(UIColor*)color{
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:color
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"PingFangSC-Regular" size:13]
                        range:NSMakeRange(0, holderText.length)];
    textField.attributedPlaceholder = placeholder;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
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
