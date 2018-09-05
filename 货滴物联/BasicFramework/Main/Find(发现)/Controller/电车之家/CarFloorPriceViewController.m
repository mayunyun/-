//
//  CarFloorPriceViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarFloorPriceViewController.h"
#import "CarGroupModel.h"
#import "CarDropDown.h"
@interface CarFloorPriceViewController ()<CarDropDownDelegate,UITextFieldDelegate>
{
    UITextField* _firstField;
    UITextField* _secondField;
    UITextField* _cityField;

    NSMutableArray* _carGroupArray;
    CarDropDown *dropDown;
    
    NSString *_groupid;
}
@end

@implementation CarFloorPriceViewController
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    UIImage *image = [UIImage imageNamed:@"NarBg"];
//    [self.navigationController.navigationBar setBackgroundImage:image
//                                                  forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//    
//}
//
//
////视图将要消失时取消隐藏
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"询底价";
    _carGroupArray = [[NSMutableArray alloc]init];
    [self searchCarData];
    [self creatUI];
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
    
    UIScrollView* bgsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgsView.contentSize = CGSizeMake(kScreenWidth, 550*GMYWIDTH);
    bgsView.showsVerticalScrollIndicator = NO;
    bgsView.showsHorizontalScrollIndicator = NO;
    bgsView.bounces = NO;
    bgsView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.view addSubview:bgsView];
    UIView *bai = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, NavBarHeight)];
    bai.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bai];
    UIImageView* upView = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 40*GMYWIDTH, bgsView.width - 30*GMYWIDTH, 290*GMYWIDTH)];
    upView.userInteractionEnabled = YES;
    upView.backgroundColor = [UIColor whiteColor];
    upView.layer.masksToBounds = YES;
    upView.layer.cornerRadius = 10;
    [bgsView addSubview:upView];

    UILabel* typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 25*GMYWIDTH, 90*GMYWIDTH, 35*GMYWIDTH)];
    typeLabel.text = @"选择车型";
    typeLabel.textColor = UIColorFromRGB(0x333333);
    typeLabel.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    [upView addSubview:typeLabel];
    UIButton* qusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    qusBtn.frame = CGRectMake(typeLabel.right, typeLabel.top, upView.width - typeLabel.left*2 - typeLabel.width, typeLabel.height);
    [qusBtn setTitle:@"选择您要查询的车型" forState:UIControlStateNormal];
    [qusBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    qusBtn.titleLabel.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    [upView addSubview:qusBtn];
    [self layerView:qusBtn];
    [qusBtn addTarget:self action:@selector(qusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* downView = [[UIImageView alloc]initWithFrame:CGRectMake(qusBtn.width - 30*GMYWIDTH, (qusBtn.height - 10*GMYWIDTH)/2, 14*GMYWIDTH, 10*GMYWIDTH)];
    downView.image = [UIImage imageNamed:@"形状-12"];
    [qusBtn addSubview:downView];
    
    UILabel* cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel.left, typeLabel.bottom+30*GMYWIDTH, typeLabel.width, typeLabel.height)];
    cityLabel.text = @"上牌城市";
    cityLabel.textColor = typeLabel.textColor;
    cityLabel.font = typeLabel.font;
    [upView addSubview:cityLabel];
    _cityField = [[UITextField alloc]initWithFrame:CGRectMake(qusBtn.left, cityLabel.top, qusBtn.width, typeLabel.height)];
    _cityField.delegate = self;
    _cityField.placeholder = @"请填写上牌城市";
    _cityField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13*MYWIDTH];
    _cityField.textAlignment = NSTextAlignmentCenter;
    _cityField.textColor = UIColorFromRGB(0x333333);
    [upView addSubview:_cityField];
    [Command placeholderColor:_cityField str:_cityField.placeholder color:UIColorFromRGB(0x666666)];
    [self layerView:_cityField];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cityLabel.bottom+25*MYWIDTH, upView.width, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(MYLine);
    [upView addSubview:lineView];
    
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel.left, lineView.bottom+25*GMYWIDTH, typeLabel.width, typeLabel.height)];
    nameLabel.textColor = typeLabel.textColor;
    nameLabel.text=@"姓名";
    nameLabel.font = typeLabel.font;
    [upView addSubview:nameLabel];
    _firstField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, upView.width - nameLabel.left*2 - nameLabel.width , nameLabel.height)];
    _firstField.delegate = self;
    _firstField.placeholder = @"请填写您的姓名";
    _firstField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13*MYWIDTH];
    _firstField.textAlignment = NSTextAlignmentCenter;
    _firstField.textColor = UIColorFromRGB(0x333333);
    [upView addSubview:_firstField];
    [Command placeholderColor:_firstField str:_firstField.placeholder color:UIColorFromRGB(0x666666)];
    [self layerView:_firstField];
    
    UILabel* phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+30*GMYWIDTH, nameLabel.width, nameLabel.height)];
    phoneLabel.text = @"手机号";
    phoneLabel.textColor = typeLabel.textColor;
    phoneLabel.font = typeLabel.font;
    [upView addSubview:phoneLabel];
    _secondField = [[UITextField alloc]initWithFrame:CGRectMake(phoneLabel.right, phoneLabel.top, qusBtn.width, typeLabel.height)];
    _secondField.delegate = self;
    _secondField.placeholder = @"请填写您的联系方式";
    _secondField.textAlignment = NSTextAlignmentCenter;
    _secondField.textColor = UIColorFromRGB(0x333333);
    _secondField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13*MYWIDTH];
    [upView addSubview:_secondField];
    [Command placeholderColor:_secondField str:_secondField.placeholder color:UIColorFromRGB(0x666666)];
    [self layerView:_secondField];
    
    UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake(upView.left, upView.bottom+40*GMYWIDTH, kScreenWidth - upView.left*2, 40*GMYWIDTH);
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setBackgroundColor:MYColor forState:UIControlStateNormal];
    okBtn.layer.cornerRadius = 5;
    [bgsView addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void)layerView:(UIView*)qusBtn{
    qusBtn.layer.borderWidth = 0.5;
    qusBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    qusBtn.layer.masksToBounds = YES;
    qusBtn.layer.cornerRadius = qusBtn.height*0.5;
}

- (void)qusBtnClick:(UIButton*)sender{

    if(dropDown == nil) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (CarGroupModel *model in _carGroupArray) {
            [arr addObject:model.groupname];
        }
        CGFloat f = 200*MYWIDTH;
        dropDown = [[CarDropDown alloc]showDropDown:sender :&f :arr :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
}
- (void) carDropDownDelegateMethod: (CarDropDown *) sender index:(NSInteger)index{
    [self rel];
    
    NSLog(@"点击了那个id%zd",index);
    CarGroupModel *model = _carGroupArray[index];
    _groupid = [NSString stringWithFormat:@"%@",model.id];
    
}
-(void)rel{
    dropDown = nil;
}

- (void)okBtnClick:(UIButton*)sender{
    if (IsEmptyValue(_groupid)) {
        jxt_showToastTitle(@"请选择车辆类型", 1);
        return;
    }
    if (IsEmptyValue(_cityField.text)) {
        jxt_showToastTitle(@"请填写上牌城市", 1);
        return;
    }if (IsEmptyValue(_firstField.text)) {
        jxt_showToastTitle(@"请填写您的姓名", 1);
        return;
    }if (IsEmptyValue(_secondField.text)) {
        jxt_showToastTitle(@"请填写您的联系方式", 1);
        return;
    }
    if ([_secondField.text length]!=11) {
        jxt_showToastTitle(@"手机号格式不正确", 1);
        return;
    }
    NSString* urlstr = @"/mbtwz/CarHome?action=addCarRecord";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"groupid\":\"%@\",\"cityname\":\"%@\",\"custname\":\"%@\",\"custphone\":\"%@\"}",_groupid,_cityField.text,_firstField.text,_secondField.text]};

    NSLog(@"%@",params);
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showAlertOneButton(@"提示", @"提交成功", @"确定", ^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            });
            [self.navigationController popoverPresentationController];
        }else{
            jxt_showAlertOneButton(@"提示", @"提交失败", @"确定", ^(NSInteger buttonIndex) {
                
            });
        }
    }];
}

//请求车型
- (void)searchCarData{
///mbtwz/CarHome?action=searchModels
    NSString* urlstr = @"/mbtwz/CarHome?action=searchModels";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:nil FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (int i = 0; i<array.count; i++) {
            CarGroupModel* model = [[CarGroupModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [_carGroupArray addObject:model];
        }
    }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _secondField) {
        if ([_secondField.text length]!=0) {
            if ([_secondField.text length]!=11) {
                jxt_showToastTitle(@"手机号格式不正确", 1);
            }
        }
    }
    
}

@end
