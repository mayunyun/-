//
//  WuLiuSJRZViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WuLiuSJRZViewController.h"
#import "WuLiuSJRZViewCell.h"
#import "WuLiuSJRZPhoneCell.h"
#import "WuLiuSjrzIngViewController.h"
@interface WuLiuSJRZViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)NSMutableDictionary *dataDic;

@end

@implementation WuLiuSJRZViewController
{
    UIButton *foodBut;
    NSString * yzmCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLab.text = @"实名认证";
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.imageArr = [[NSMutableArray alloc]init];
    self.dataDic = [[NSMutableDictionary alloc]init];
    for (int i=0; i<6; i++) {
        UIImage *image = [[UIImage alloc]init];
        image = [UIImage imageNamed:@"tianjiashili"];
        [self.imageArr addObject:image];
        
    }
    [self.dataDic setValue:@"" forKey:@"driver_name"];
    [self.dataDic setValue:@"" forKey:@"driver_phone"];
    [self.dataDic setValue:@"" forKey:@"driver_car_number"];
    [self.dataDic setValue:@"" forKey:@"driver_checkno"];

    self.navigationItem.titleView = titleView;
    
    [self tableview];
    
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, UIScreenH-64) style:UITableViewStyleGrouped];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 88, UIScreenW, UIScreenH-88);
            
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIView *foodview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 130*MYWIDTH)];
        _tableview.tableFooterView = foodview;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
        tapGestureRecognizer.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        [_tableview addGestureRecognizer:tapGestureRecognizer];
        foodBut = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH, 30*MYWIDTH, UIScreenW-30*MYWIDTH, 50*MYWIDTH)];
        [foodBut setBackgroundColor:MYColor];
        [foodBut setTitle:@"确认提交" forState:UIControlStateNormal];
        foodBut.layer.cornerRadius = 8;
        [foodBut addTarget:self action:@selector(foodButClick) forControlEvents:UIControlEventTouchUpInside];
        [foodview addSubview:foodBut];
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0||UIScreenW==320) {
        return 233;
    }
    
    return 240*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * stringCell = @"WuLiuSJRZViewCell";
        WuLiuSJRZViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameField.delegate = self;
        cell.carPField.delegate = self;
        cell.phoneField.delegate = self;
        cell.yzmField.delegate = self;
        cell.nameField.layer.cornerRadius = 16.f;
        cell.nameField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.nameField.layer.borderWidth = 1.0f;
        cell.nameField.layer.masksToBounds = YES;
        cell.carPField.layer.cornerRadius = 16.f;
        cell.carPField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.carPField.layer.borderWidth = 1.0f;
        cell.carPField.layer.masksToBounds = YES;
        cell.phoneField.layer.cornerRadius = 16.f;
        cell.phoneField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.phoneField.layer.borderWidth = 1.0f;
        cell.phoneField.layer.masksToBounds = YES;
        cell.yzmField.layer.cornerRadius = 16.f;
        cell.yzmField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.yzmField.layer.borderWidth = 1.0f;
        cell.yzmField.layer.masksToBounds = YES;
        NSLog(@">>>>>>%@",_dataDic);
        cell.nameField.text = [self.dataDic objectForKey:@"driver_name"];
        cell.phoneField.text = [self.dataDic objectForKey:@"driver_phone"];
        cell.carPField.text = [self.dataDic objectForKey:@"driver_car_number"];
        cell.yzmField.text = [self.dataDic objectForKey:@"driver_checkno"];
        [cell setYzmCodeBlock:^(NSString * yzmcode) {
            yzmCode = yzmcode;
        }];
        return cell;
        
    }else{
        static NSString * stringCell = @"WuLiuSJRZPhoneCell";
        WuLiuSJRZPhoneCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        [cell setUpData:indexPath.section];
        NSLog(@"%@  %zd",self.imageArr,indexPath.section);

        UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapClick:)];
        cell.oneImage.tag = 1101;//
        [cell.oneImage addGestureRecognizer:tap1];
        cell.oneImage.image = self.imageArr[0];

        UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapClick:)];
        cell.twoImage.tag = 1102;
        [cell.twoImage addGestureRecognizer:tap2];
        cell.twoImage.image = self.imageArr[1];

        
        UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapClick:)];
        cell.threeImage.tag = 1103;
        [cell.threeImage addGestureRecognizer:tap3];
        cell.threeImage.image = self.imageArr[2];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{//头视图
    return 10;

}
//头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)foodButClick{
    NSArray *nuer = @[@"1",@"2",@"3"];
    NSString *nuerStr;
    NSMutableArray *imageArr1 = [[NSMutableArray alloc]init];
    if ([[self.dataDic objectForKey:@"driver_name"] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写您的姓名", 1);
        return;
    }else if([[self.dataDic objectForKey:@"driver_car_number"] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写您的身份证号", 1);
        return;
    }
//    else if(![Command checkCarID:[self.dataDic objectForKey:@"driver_car_number"]]) {
//        jxt_showToastTitle(@"请填写正确的车牌号", 1);
//        return;
//    }
    else if([[self.dataDic objectForKey:@"driver_phone"] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写您的手机号", 1);
        return;
    }else if([[self.dataDic objectForKey:@"driver_checkno"] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写验证码", 1);
        return;
    }else if(![[self.dataDic objectForKey:@"driver_checkno"] isEqualToString:yzmCode]) {
        jxt_showToastTitle(@"请填写正确验证码", 1);
        return;
    }

    else if([self.imageArr[0] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
        jxt_showToastTitle(@"请上传身份证正面照", 1);
        return;
    }
    else if([self.imageArr[1] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
        jxt_showToastTitle(@"请上传身份证反面照", 1);
        return;
    }
    else if([self.imageArr[2] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
        jxt_showToastTitle(@"请上传手持身份证照", 1);
        return;
    }
    for (int i=0; i<6; i++) {
        if(![self.imageArr[i] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
            nuerStr = [NSString stringWithFormat:@"%@,%@",nuerStr,nuer[i]];
            [imageArr1 addObject:self.imageArr[i]];
        }
    }
    
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"custname\":\"%@\",\"custcall\":\"%@\",\"custidcard\":\"%@\"}",[self.dataDic objectForKey:@"driver_name"],[self.dataDic objectForKey:@"driver_phone"],[self.dataDic objectForKey:@"driver_car_number"]]};
    
    NSLog(@"%@",params);
    
    
    NSString *URLStr = @"/mbtwz/logisticssendwz?action=insertOwnerCertification";

    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        if ([[dic objectForKey:@"flag"] intValue]==300) {
            

            jxt_showAlertOneButton(@"提示", @"基本信息提交失败", @"确定", ^(NSInteger buttonIndex) {
            });
        }else{
            NSString *str1 = [[dic objectForKey:@"response"][0] objectForKey:@"id"];
            //NSString *str1 = [str substringFromIndex:1];
            //图片标识（1：身份证正面照，2：身份证反面照，3：手持身份证件照）
            [self requestPortal:nil img:imageArr1 idStr:str1 driver_img_type:[nuerStr substringFromIndex:7]];

        }

    }];
}

- (void)imgViewTapClick:(UITapGestureRecognizer*)tap{
    UIActionSheet* sheet = [[UIActionSheet alloc
                             ]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册里选择照片", @"现在就拍一张", nil];
    UIImageView *image = (UIImageView *)[tap view];
    sheet.tag = image.tag-1000;
    [sheet showInView:self.view];
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
        picker.view.tag = tager-101;
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
    picker.view.tag = tager-101;
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
        [self.imageArr replaceObjectAtIndex:picker.view.tag withObject:image];

        [_tableview reloadData];
    }
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //DLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestPortal:(NSData*)imgData img:(NSArray*)img idStr:(NSString *)idStr driver_img_type:(NSString *)driver_img_type{
    //NSData 转 Base64
    //    NSString* imgStr = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //        NSLog(@"上传图片的请求imgStr%@",imgStr);
#pragma mark 上传图片的请求
    //    [_headerBtn setImage:img forState:UIControlStateNormal];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",_Environment_Domain,@"/mbtwz/logisticssendwz?action=insertOCUploadImg"];
    NSDictionary* params = @{@"ownerid":idStr,
                             @"driver_img_type":driver_img_type};
    
    [NetWorkManagerTwo uploadPicturesWithURL:urlStr parameters:params images:img progress:^(float progress) {
    
    } success:^(id responseObject, id data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"上传返回%@",dic);
        
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            foodBut.hidden = YES;
            [self setWithSeccessView];

        }else{
            foodBut.hidden = NO;
            jxt_showToastTitle(@"提交失败", 1);
         }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)setWithSeccessView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:NO];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
    
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 220*MYWIDTH, 220*MYWIDTH)];
    imageview.userInteractionEnabled = YES;
    imageview.image = [UIImage imageNamed:@"提交认证成功"];
    

    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(60*MYWIDTH, 165*MYWIDTH, 100*MYWIDTH, 35*MYWIDTH)];
    [but setTitle:@"确定" forState:UIControlStateNormal];
    [but setTitleColor:MYColor forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    but.backgroundColor = [UIColor whiteColor];
    but.layer.masksToBounds = YES;
    but.layer.cornerRadius = 5;
    but.layer.borderColor = MYColor.CGColor;//设置边框颜色
    but.layer.borderWidth = 1;//设置边缘宽度
    [but addTarget:self action:@selector(butHideClick) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:but];
    [SMAlert showCustomView:imageview];

}
- (void)butHideClick{
    [SMAlert hide:NO];
    WuLiuSjrzIngViewController *sjrz = [[WuLiuSjrzIngViewController alloc]init];
    [self.navigationController pushViewController:sjrz animated:YES];
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
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    WuLiuSJRZViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    if (textField==cell.nameField) {
        [self.dataDic setValue:textField.text forKey:@"driver_name"];
    }else if (textField==cell.carPField){
        [self.dataDic setValue:textField.text forKey:@"driver_car_number"];
    }else if (textField==cell.phoneField){
        [self.dataDic setValue:textField.text forKey:@"driver_phone"];
    }else if (textField==cell.yzmField){
        [self.dataDic setValue:textField.text forKey:@"driver_checkno"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    WuLiuSJRZViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    if (textField==cell.nameField) {
        [self.dataDic setValue:textField.text forKey:@"driver_name"];
    }else if (textField==cell.carPField){
        [self.dataDic setValue:textField.text forKey:@"driver_car_number"];
    }else if (textField==cell.phoneField){
        [self.dataDic setValue:textField.text forKey:@"driver_phone"];
    }else if (textField==cell.yzmField){
        [self.dataDic setValue:textField.text forKey:@"driver_checkno"];
    }
    return [textField resignFirstResponder];
}
//取消键盘的响应
-(void)hideKeyBoard{
    [_tableview endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backToLastViewController:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
