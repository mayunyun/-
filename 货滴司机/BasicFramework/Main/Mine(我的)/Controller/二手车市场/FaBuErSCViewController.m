//
//  FaBuErSCViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/7/20.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "FaBuErSCViewController.h"
#import "FabuTableViewCell.h"
#import "HomeMapViewC.h"
#import "NSDate+BRAdd.h"

@interface FaBuErSCViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *imageArr;

@property (nonatomic,strong)NSString *provinceStr;
@property (nonatomic,strong)NSString *cityStr;
@property (nonatomic,strong)NSString *areaStr;
@end

@implementation FaBuErSCViewController
{
    UIView *_goodsalicteView;
    UIButton *_goodsBut;
    NSArray *_carTypeArr;
    NSArray *_brandnameArr;
    NSString *_car_type_id;
    NSString *_car_brand_id;

    int i;
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+statusbarHeight, kScreenWidth, kScreenHeight-statusbarHeight-44)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 8*MYWIDTH)];
        head.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableview.tableHeaderView = head;
        
        UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 150*MYWIDTH)];
        footview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableview.tableFooterView = footview;
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, UIScreenW, 30*MYWIDTH)];
        lab.backgroundColor = [UIColor whiteColor];
        lab.text = @"    图片列表：点击加号上传爱车图片";
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = UIColorFromRGB(0x333333);
        [footview addSubview:lab];
        
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, lab.bottom+1, UIScreenW, 120*MYWIDTH)];
        back.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [footview addSubview:back];
        
        for (int i=0; i<3; i++) {
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/3*i+(UIScreenW/3-80*MYWIDTH)/2, 20*MYWIDTH, 80*MYWIDTH, 80*MYWIDTH)];
            [but setImage:self.imageArr[i] forState:UIControlStateNormal];
            but.tag = 330+i;
            [but addTarget:self action:@selector(butimageClick:) forControlEvents:UIControlEventTouchUpInside];
            [back addSubview:but];
        }
        
        [_tableview registerClass:[FabuTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FabuTableViewCell class])];
        
    }
    return _tableview;
    
}
- (void)butimageClick:(UIButton *)but{
    UIActionSheet* sheet = [[UIActionSheet alloc
                             ]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册里选择照片", @"现在就拍一张", nil];
    
    sheet.tag = but.tag-100;
    [sheet showInView:self.view];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];
    _imageArr = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        UIImage *image = [[UIImage alloc]init];
        image = [UIImage imageNamed:@"tianjiashili"];
        [self.imageArr addObject:image];
    }
    i=0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLab.text = @"二手车发布";
    titleLab.textColor = [UIColor redColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    UIButton *button = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(UIScreenW - 70, 10, 50, 40);
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = right;
    
    [self loadNewsearchKuaiyunCartype];
    [self selectPubSechancarBrand];
    
    self.navigationItem.titleView = titleView;
    [_dataArr addObject:@""];
    [_dataArr addObject:@"请选择"];
    [_dataArr addObject:@"请选择"];
    [_dataArr addObject:@""];
    [_dataArr addObject:@""];
    [_dataArr addObject:@"请选择看车地址"];
    [_dataArr addObject:@"请选择注册年份"];
    [_dataArr addObject:@""];
    [_dataArr addObject:@""];
    [_dataArr addObject:@""];
    [_dataArr addObject:@""];
    [self tableview];
    
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
- (void)addNext{
    for (int i=0; i<_dataArr.count; i++) {
        if (i!=10) {
            if ([_dataArr[i] isEqualToString:@""]) {
                jxt_showToastTitle(@"请完善信息", 1);
                return;
            }
        }
        
    }
    NSMutableArray *imageArr1 = [[NSMutableArray alloc]init];
    
    for (int i=0; i<3; i++) {
        if(![self.imageArr[i] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
            [imageArr1 addObject:self.imageArr[i]];
        }
    }
    if (imageArr1.count==0) {
        jxt_showToastTitle(@"请上传至少一张爱车图片", 1);
        return;
    }
    NSString *XWURLStr = @"/mbtwz/secondhandcar?action=addSelfSecondhandcar";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"table\":\"huodi_second_hand_car\",\"title\":\"%@\",\"car_type_id\":\"%@\",\"car_type_name\":\"%@\",\"car_brand_id\":\"%@\",\"car_brand_name\":\"%@\",\"model_number\":\"%@\",\"price\":\"%@\",\"watch_car_add\":\"%@\",\"registered_year\":\"%@\",\"kilometre\":\"%@\",\"contacts\":\"%@\",\"contact_number\":\"%@\",\"province_id\":\"\",\"province\":\"%@\",\"city_id\":\"\",\"city\":\"%@\",\"county_id\":\"\",\"county\":\"%@\",\"region\":\"%@\",\"describe\":\"%@\"}",_dataArr[0],_car_type_id,_dataArr[1],_car_brand_id,_dataArr[2],_dataArr[3],_dataArr[4],_dataArr[5],_dataArr[6],_dataArr[7],_dataArr[8],_dataArr[9],_provinceStr,_cityStr,_areaStr,_dataArr[5],_dataArr[10]]};
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:XWURLStr Parameters:params FinishedLogin:^(id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            [self insertSHcarUpImg:[[dic objectForKey:@"response"][0] objectForKey:@"secondhandcarid"]];
        }else{
            jxt_showToastTitle(@"操作失败", 1);
        }
        
        
    }];
}
- (void)insertSHcarUpImg:(NSString *)strid{
    NSMutableArray *imageArr1 = [[NSMutableArray alloc]init];

    for (int i=0; i<3; i++) {
        if(![self.imageArr[i] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
            [imageArr1 addObject:self.imageArr[i]];
        }
    }
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",_Environment_Domain,@"/mbtwz/secondhandcar?action=insertSHcarUpImg"];
    NSDictionary* params = @{@"secondhandcarid":strid};
    
    [NetWorkManagerTwo uploadPicturesWithURL:urlStr parameters:params images:imageArr1 progress:^(float progress) {
        
    } success:^(id responseObject, id data) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            jxt_showToastTitle(@"提交成功", 1);

        }else{
            jxt_showToastTitle(@"操作失败", 1);
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==10) {
        return 90*MYWIDTH;
    }
    return 40*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [FabuTableViewCell class];
    FabuTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSArray *data = @[@"标题:",@"车型:",@"品牌:",@"车型号:",@"价格:",@"看车地址:",@"注册年份:",@"公里数:",@"联系人:",@"联系电话:",@"描述:"];
    NSArray *data1 = @[@"请输入标题",@"不限",@"不限",@"请输入车型号",@"请输入价格",@"请输入看车地址",@"请输入注册年份",@"请输入公里数",@"请输入联系人",@"请输入联系电话",@"请输入描述"];

    [cell setdata:data[indexPath.row] other:_dataArr[indexPath.row] placeholder:data1[indexPath.row] IndexPath:indexPath];
    cell.button.tag = indexPath.row;
    [cell.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.otherView.tag = 500+indexPath.row;
    cell.otherView.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)buttonClick:(UIButton *)but{
    switch (but.tag) {
        case 1:{
            i=0;
            [self goodsTypeButClick];
            break;
        }
        case 2:{
            i=1;
            [self goodsTypeButClick];
            break;
        }
        case 5:{
            HomeMapViewC *map = [[HomeMapViewC alloc]init];
            [map setQidianBlock:^(NSString *strQD,NSString* province,NSString* city,NSString* area) {
                [_dataArr replaceObjectAtIndex:5 withObject:strQD];
                _provinceStr = province;
                _cityStr = city;
                _areaStr = area;
                [_tableview reloadData];
            }];
            [self.navigationController pushViewController:map animated:YES];
            break;
        }
        case 6:{

            [BRDatePickerView showDatePickerWithTitle:@"注册年份" dateType:UIDatePickerModeDate defaultSelValue:@"" minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                [_dataArr replaceObjectAtIndex:6 withObject:selectValue];
                [_tableview reloadData];
                
            }];
            break;
        }
        default:
            break;
    }
}
//货物类型弹框
- (void)goodsTypeButClick{
    _goodsalicteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _goodsalicteView.backgroundColor = [UIColor clearColor];
    [kWindow addSubview:_goodsalicteView];
    
    UIView *baiBgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
    baiBgView.backgroundColor = [UIColor whiteColor];
    [_goodsalicteView addSubview:baiBgView];
    
    UIButton *cencleBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60*MYWIDTH, 50*MYWIDTH)];
    [cencleBut setTitle:@"取消" forState:UIControlStateNormal];
    [cencleBut setTitleColor:UIColorFromRGBValueValue(0x666666) forState:UIControlStateNormal];
    cencleBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [cencleBut addTarget:self action:@selector(goodsCencelClick) forControlEvents:UIControlEventTouchUpInside];
    [baiBgView addSubview:cencleBut];
    
    UIButton *quedingBut = [[UIButton alloc]initWithFrame:CGRectMake(baiBgView.width-60*MYWIDTH, 0, 60*MYWIDTH, 50*MYWIDTH)];
    [quedingBut setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBut setTitleColor:MYColor forState:UIControlStateNormal];
    quedingBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [quedingBut addTarget:self action:@selector(CargoodsTypeClick) forControlEvents:UIControlEventTouchUpInside];
    [baiBgView addSubview:quedingBut];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50*MYWIDTH)];
    titleLab.text = @"选择车型";
    if (i==1) {
        titleLab.text = @"选择品牌";
    }
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    [baiBgView addSubview:titleLab];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 50*MYWIDTH, kScreenWidth, 1)];
    xian.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
    [baiBgView addSubview:xian];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (i==1) {
        for (NSDictionary *dic in _brandnameArr ) {
            [arr addObject:[dic objectForKey:@"brandname"]];
        }
    }else{
        for (NSDictionary *dic in _carTypeArr) {
            [arr addObject:[dic objectForKey:@"cartypename"]];
        }
    }
    
    
    float w = (kScreenWidth-75*MYWIDTH)/4;
    float dowe = 0;
    for (int i=0; i<arr.count; i++) {
        UIButton *But = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH+i%4*(w+15*MYWIDTH), xian.bottom + 20*MYWIDTH+i/4*55*MYWIDTH, w, 35*MYWIDTH)];
        [But setTitle:arr[i] forState:UIControlStateNormal];
        [But setTitle:arr[i] forState:UIControlStateSelected];
        [But setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [But setBackgroundColor:[UIColor whiteColor]];
        But.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        But.layer.cornerRadius = 3.0;
        But.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;//设置边框颜色
        But.layer.borderWidth = 0.5f;//设置边框颜色
        But.tag = 1255+i;
        [But addTarget:self action:@selector(goodsButClick:) forControlEvents:UIControlEventTouchUpInside];
        [baiBgView addSubview:But];
        
        if (i==arr.count-1) {
            dowe = But.bottom;
        }
    }
    
   
    
    baiBgView.frame = CGRectMake(0, kScreenHeight-dowe-25, kScreenWidth, dowe+25);
    
    UIButton *toumingBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-baiBgView.height)];
    [toumingBut addTarget:self action:@selector(goodsCencelClick) forControlEvents:UIControlEventTouchUpInside];
    [toumingBut setBackgroundColor:[UIColor blackColor]];
    toumingBut.alpha = 0.5;
    [_goodsalicteView addSubview:toumingBut];
}
- (void)goodsButClick:(UIButton *)but{
    
    [_goodsBut setBackgroundColor:[UIColor whiteColor]];
    _goodsBut.layer.borderColor = UIColorFromRGBValueValue(0x888888).CGColor;
    [_goodsBut setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [but setBackgroundColor:MYColor];
    but.layer.borderColor = MYColor.CGColor;
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _goodsBut = but;
}
- (void)goodsCencelClick{
    [_goodsalicteView removeFromSuperview];
}
- (void)CargoodsTypeClick{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (i==1) {
        for (NSDictionary *dic in _brandnameArr ) {
            [arr addObject:[dic objectForKey:@"brandname"]];
        }
    }else{
        for (NSDictionary *dic in _carTypeArr) {
            [arr addObject:[dic objectForKey:@"cartypename"]];
        }
    }
    
    for (int y=0; y<arr.count; y++) {
        UIButton *but = [_goodsalicteView viewWithTag:1255+y];
        
        if ([but.titleLabel.text isEqual:_goodsBut.titleLabel.text]){
            if (i==1) {
                _car_brand_id = [NSString stringWithFormat:@"%@",[_brandnameArr[y] objectForKey:@"id"]];
            }else{
                _car_type_id = [NSString stringWithFormat:@"%@",[_carTypeArr[y] objectForKey:@"id"]];
            }
        }
    }
    [_goodsalicteView removeFromSuperview];
    [_dataArr replaceObjectAtIndex:i+1 withObject:_goodsBut.titleLabel.text];
    
    [_tableview reloadData];
}
- (void)loadNewsearchKuaiyunCartype
{
    // 车型选择 查询接口
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=searchKuaiyunCartype";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        _carTypeArr = [[NSArray alloc]init];
        _carTypeArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
    }];
}
- (void)selectPubSechancarBrand
{
    // 车型选择 查询接口
    NSString *URLStr = @"/mbtwz/secondhandcar?action=selectPubSechancarBrand";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            _brandnameArr = [[NSArray alloc]initWithArray:[dic objectForKey:@"response"]];
        }
    }];
}
//以下两个代理方法可以防止键盘遮挡textview
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //这里的offset的大小是控制着呼出键盘的时候view上移多少。比如上移20，就给offset赋值-20，以此类推。也可以根据屏幕高度的不同做一个if判断。
    
    float offset = 0.0f;
    
    offset = -40;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset, width, height);
    if (textField.tag-500>6) {
        rect = CGRectMake(0.0f, offset-(textField.tag-500)*10, width, height);

    }else if(textField.tag-500<4) {
        rect = CGRectMake(0.0f, 0, width, height);
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}
//完成编辑的时候下移回来（只要把offset重新设为0就行了）
- (void)textFieldDidEndEditing:(UITextField *)textField{
    float offset = 0.0f;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
    [_dataArr replaceObjectAtIndex:textField.tag-500 withObject:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_dataArr replaceObjectAtIndex:textField.tag-500 withObject:textField.text];
    return [textField resignFirstResponder];
}
//取消键盘的响应
-(void)hideKeyBoard{
    [_tableview endEditing:YES];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (0 == buttonIndex) {
        [self LocalPhoto:actionSheet.tag];
    } else if (1 == buttonIndex) {
        [self takePhoto:actionSheet.tag];
    }
    
}

//开始拍照
-(void)takePhoto:(NSInteger)tager
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.view.tag = tager-100;
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        // DLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
//打开本地相册
-(void)LocalPhoto:(NSInteger)tager
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.view.tag = tager-100;
    NSLog(@"%zd",tager-1);
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"%zd",picker.view.tag);
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp)
        {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"%ld   %@",picker.view.tag-130,self.imageArr);
        [self.imageArr replaceObjectAtIndex:picker.view.tag-130 withObject:image];
        for (int i=0; i<3; i++) {
            UIButton *but = [self.view viewWithTag:330+i];
            [but setImage:self.imageArr[i] forState:UIControlStateNormal];
        }
    }
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //DLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
