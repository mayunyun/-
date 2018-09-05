//
//  EditInfoPageVC.m
//  BasicFramework
//
//  Created by 钱龙 on 2018/2/27.
//  Copyright © 2018年 Rainy. All rights reserved.
//
#import "EditInfoPageVC.h"
#import "NIDropDown.h"
#import "NSDate+BRAdd.h"
#import "NetWorkManagerTwo.h"

@interface EditInfoPageVC ()<NIDropDownDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView *statusBarView;
    UIScrollView* _bgScroView;
    UIImageView *_headview;         //头像
    UITextField* _nameField;        //昵称
    UIButton* _sexBtn;              //性别
    UIButton* _birthBtn;            //出生年月
    UITextField *emailField;
    UITextField *QQField;
    UITextField *WXField;
    UIButton* _yearBtn;             //生肖
    UIButton* _monthBtn;            //星座
    UITextField* _workField;        //职业
    UITextField* _cityField;        //城市
    UIButton* _improtBtn;           //收入水平
    UITextView* _carinformation;
    UIButton* _okBtn;
    NIDropDown *dropDown;
    BOOL _isClick;
    NSArray* _importArr;
}

@end

@implementation EditInfoPageVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
    UIImage *image = [UIImage imageNamed:@"iconfont-touming"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    //    [self.navigationController setNavigationBa rHidden:YES animated:NO];
    
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [statusBarView removeFromSuperview];
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    if (statusbarHeight>20) {
        statusBarView.frame = CGRectMake(0, -44,    self.view.bounds.size.width, 44);
    }
    statusBarView.backgroundColor = color;
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isClick = NO;
    _importArr = @[@"3-5万/年",@"5-8万/年",@"8-11万/年",@"11-15万/年",@"15以上"];
    [self creatUI];
    
}

- (void)creatUI{
    _bgScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -44, UIScreenW, UIScreenH)];
    _bgScroView.bounces = NO;
    _bgScroView.contentSize = CGSizeMake(UIScreenW, 800*MYWIDTH);
    _bgScroView.backgroundColor = UIColorFromRGB(MYBack);
    _bgScroView.showsVerticalScrollIndicator = NO;
    _bgScroView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScroView];
    //----------头
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 180*MYWIDTH)];
    bgimage.userInteractionEnabled = YES;
    bgimage.backgroundColor = [UIColor whiteColor];
    [_bgScroView addSubview:bgimage];
    
    UIImageView *headviewBG = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-55*MYWIDTH, bgimage.height/2-65*MYWIDTH, 110*MYWIDTH, 110*MYWIDTH)];
    headviewBG.image = [UIImage imageNamed:@"默认头像BG"];
    headviewBG.layer.masksToBounds = YES;
    headviewBG.userInteractionEnabled = YES;
    headviewBG.layer.cornerRadius = headviewBG.width/2;
    [bgimage addSubview:headviewBG];
    
    _headview = [[UIImageView alloc]initWithFrame:CGRectMake(12*MYWIDTH, 12*MYWIDTH, 86*MYWIDTH, 86*MYWIDTH)];
    _headview.image = [UIImage imageNamed:@"默认头像"];
//    NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,self.model.folder,self.model.autoname];
//    NSLog(@"%@",image);
//
//    [_headview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",image]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _headview.layer.masksToBounds = YES;
    _headview.userInteractionEnabled = NO;
    _headview.layer.cornerRadius = _headview.width/2;
    [headviewBG addSubview:_headview];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapClick:)];
    [_headview addGestureRecognizer:tap];
    
//    UIButton* eidtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    eidtBtn.frame = CGRectMake(UIScreenW-35, 15, 20, 20);
//    [eidtBtn setBackgroundImage:[UIImage imageNamed:@"个人信息编辑"] forState:UIControlStateNormal];
//    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:eidtBtn];
//    self.navigationItem.rightBarButtonItem = left;
//    [eidtBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //-----------第一个cell
    UIImageView* upView = [[UIImageView alloc]initWithFrame:CGRectMake(0, bgimage.bottom+15, UIScreenW, 160*MYWIDTH)];
    upView.backgroundColor = [UIColor whiteColor];
    upView.userInteractionEnabled = YES;
    [_bgScroView addSubview:upView];
    //昵称
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, 10*MYWIDTH, 60*MYWIDTH, 30*MYWIDTH)];
    nameLabel.text = @"昵称";
    nameLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [upView addSubview:nameLabel];
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, upView.width - nameLabel.right - 30*MYWIDTH, nameLabel.height)];
    _nameField.font = [UIFont systemFontOfSize:14*MYWIDTH];
    _nameField.backgroundColor = [UIColor clearColor];
    _nameField.textAlignment = NSTextAlignmentRight;
    [upView addSubview:_nameField];
    UILabel * line1 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, _nameField.bottom+2*MYWIDTH, SCREEN_WIDTH-20*MYWIDTH, 1)];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [upView addSubview:line1];
    //性别
    UILabel* sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+20, nameLabel.width, nameLabel.height)];
    sexLabel.text = @"性别";
    sexLabel.font = nameLabel.font;
    [upView addSubview:sexLabel];
    _sexBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _sexBtn.frame = CGRectMake(SCREEN_WIDTH-80*MYWIDTH, sexLabel.top, 60*MYWIDTH, sexLabel.height);
    [_sexBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _sexBtn.tag = 1001;
    _sexBtn.backgroundColor = [UIColor clearColor];
    _sexBtn.titleLabel.font = _nameField.font;
    [upView addSubview:_sexBtn];
    UILabel * line2 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, _sexBtn.bottom+2*MYWIDTH, SCREEN_WIDTH-20*MYWIDTH, 1)];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [upView addSubview:line2];
    [_sexBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addDownImgView:_sexBtn];
    
    //出生年月
    UILabel* birthLabel = [[UILabel alloc]initWithFrame:CGRectMake(sexLabel.left, sexLabel.bottom+20, sexLabel.width, sexLabel.height)];
    birthLabel.text = @"出生年月";
    birthLabel.font = sexLabel.font;
    [upView addSubview:birthLabel];
    _birthBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _birthBtn.frame = CGRectMake(SCREEN_WIDTH-140*MYWIDTH, birthLabel.top, 120*MYWIDTH, birthLabel.height);
    _birthBtn.backgroundColor = [UIColor clearColor];
    _birthBtn.titleLabel.font = _nameField.font;
    [_birthBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [upView addSubview:_birthBtn];
    [_birthBtn addTarget:self action:@selector(birthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addDownImgView:_birthBtn];
    //----------------第二个cell
    UIImageView* downView = [[UIImageView alloc]initWithFrame:CGRectMake(upView.left, upView.bottom+15*MYWIDTH, upView.width, 320*MYWIDTH)];
    downView.userInteractionEnabled = YES;
    downView.backgroundColor = [UIColor whiteColor];
    [_bgScroView addSubview:downView];
    
    UILabel* jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.top, nameLabel.width, nameLabel.height)];
    jobLabel.text = @"职业";
    jobLabel.font = nameLabel.font;
    [downView addSubview:jobLabel];
    _workField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160*MYWIDTH, jobLabel.top, 150*MYWIDTH, jobLabel.height)];
    _workField.backgroundColor = [UIColor clearColor];
    _workField.placeholder = @"请填写您的职业";
    _workField.font = _nameField.font;
    _workField.textAlignment = NSTextAlignmentRight;
    [downView addSubview:_workField];
    UILabel * line3 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, _workField.bottom+2*MYWIDTH, SCREEN_WIDTH-20*MYWIDTH, 1)];
    line3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [downView addSubview:line3];
    
    UILabel* emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(jobLabel.left, jobLabel.bottom+20, jobLabel.width, jobLabel.height)];
    emailLabel.text = @"邮箱";
    emailLabel.font = nameLabel.font;
    [downView addSubview:emailLabel];
    emailField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160*MYWIDTH, emailLabel.top, _workField.width, emailLabel.height)];
    emailField.userInteractionEnabled = NO;
    emailField.text = [NSString stringWithFormat:@"%@",self.model.email];
    emailField.backgroundColor = [UIColor clearColor];
    emailField.placeholder = @"请填写您的邮箱";
    emailField.font = _nameField.font;
    emailField.textAlignment = NSTextAlignmentRight;
    [downView addSubview:emailField];
    UILabel * line4 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, emailField.bottom+2*MYWIDTH, SCREEN_WIDTH-20*MYWIDTH, 1)];
    line4.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [downView addSubview:line4];
    
    UILabel* QQLabel = [[UILabel alloc]initWithFrame:CGRectMake(emailLabel.left, emailLabel.bottom+20, emailLabel.width, emailLabel.height)];
    QQLabel.text = @"QQ";
    QQLabel.font = nameLabel.font;
    [downView addSubview:QQLabel];
    QQField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160*MYWIDTH, QQLabel.top, emailField.width, QQLabel.height)];
    QQField.userInteractionEnabled = NO;
    QQField.text = [NSString stringWithFormat:@"%@",self.model.qq];
    QQField.backgroundColor = [UIColor clearColor];
    QQField.font = _nameField.font;
    QQField.placeholder = @"请填写您的QQ账号";
    QQField.textAlignment = NSTextAlignmentRight;
    [downView addSubview:QQField];
    UILabel * line5 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, QQField.bottom+2*MYWIDTH, SCREEN_WIDTH-20*MYWIDTH, 1)];
    line5.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [downView addSubview:line5];
    
    UILabel* WXLabel = [[UILabel alloc]initWithFrame:CGRectMake(QQLabel.left, QQLabel.bottom+20, QQLabel.width, QQLabel.height)];
    WXLabel.text = @"微信";
    WXLabel.font = nameLabel.font;
    [downView addSubview:WXLabel];
    WXField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160*MYWIDTH, WXLabel.top, QQField.width, WXLabel.height)];
    WXField.userInteractionEnabled = NO;
    WXField.text = [NSString stringWithFormat:@"%@",self.model.wechat];
    WXField.backgroundColor = [UIColor clearColor];
    WXField.placeholder = @"请填写您的微信账号";
    WXField.font = _nameField.font;
    WXField.textAlignment = NSTextAlignmentRight;
    [downView addSubview:WXField];
    UILabel * line6 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, WXField.bottom+2*MYWIDTH, SCREEN_WIDTH-20*MYWIDTH, 1)];
    line6.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [downView addSubview:line6];
    UILabel* cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(WXLabel.left, WXLabel.bottom+20, WXLabel.width, WXLabel.height)];;
    cityLabel.font = jobLabel.font;
    cityLabel.text = @"城市";
    [downView addSubview:cityLabel];
    _cityField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160*MYWIDTH, cityLabel.top, WXField.width, cityLabel.height)];
    _cityField.backgroundColor = [UIColor clearColor];
    _cityField.font = _nameField.font;
    _cityField.placeholder = @"请填写您的所在城市";
    _cityField.textAlignment = NSTextAlignmentRight;
    [downView addSubview:_cityField];
    UILabel * line7 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, _cityField.bottom+2*MYWIDTH, SCREEN_WIDTH-20*MYWIDTH, 1)];
    line7.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [downView addSubview:line7];
    UILabel* importLabel = [[UILabel alloc]initWithFrame:CGRectMake(cityLabel.left, cityLabel.bottom+20, cityLabel.width, cityLabel.height)];
    importLabel.font = cityLabel.font;
    importLabel.text = @"收入水平";
    [downView addSubview:importLabel];
    _improtBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _improtBtn.frame = CGRectMake(SCREEN_WIDTH-160*MYWIDTH, importLabel.top, _cityField.width, importLabel.height);
    _improtBtn.tag = 1002;
    [_improtBtn setTitle:@"" forState:UIControlStateNormal];
    [_improtBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _improtBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _improtBtn.titleLabel.font = _birthBtn.titleLabel.font;
    [downView addSubview:_improtBtn];
    [self addDownImgView:_improtBtn];
    [_improtBtn addTarget:self action:@selector(importBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _okBtn.frame = CGRectMake(0, UIScreenH-44, UIScreenW, 44);
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_okBtn setBackgroundColor:UIColorFromRGB(0xD60000)];
    [self.view addSubview:_okBtn];
    [_okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self loadNew];
    [self isEnableClick:NO];
    
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
- (void)addDownImgView:(UIButton*)btn {
    UIImageView* sexdownimgView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.width - 40, 10, 20, btn.height - 10*2)];
    sexdownimgView.image = [UIImage imageNamed:@"个人信息下拉"];
    //  sexdownimgView.backgroundColor = [UIColor redColor];
    [btn addSubview:sexdownimgView];
}
- (void)importBtnClick:(UIButton*)sender{
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    if(dropDown == nil) {
        CGFloat f = 100;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :_importArr :arrImage :@"up"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void)sexBtnClick:(UIButton*)sender{
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    NSArray* sexArr = @[@"男",@"女"];
    if(dropDown == nil) {
        CGFloat f = 80;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :sexArr :arrImage :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void)birthBtnClick:(UIButton*)sender{
    __weak typeof(UIButton*) weakBtn = sender;
//    __weak typeof(self) weakSelf = self;
    [BRDatePickerView showDatePickerWithTitle:@"出生年月" dateType:UIDatePickerModeDate defaultSelValue:weakBtn.titleLabel.text minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
        [weakBtn setTitle:selectValue forState:UIControlStateNormal];
        
    }];
}
- (void)okBtnClick:(UIButton*)sender{
    _isClick = !_isClick;
    if (_isClick) {
        [self isEnableClick:YES];
        [_okBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_okBtn setBackgroundColor:[UIColor grayColor]];
    }else{
        [self updateCustomerRequest];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender index:(NSInteger)index{
    [self rel];
    
    //    _orderselectFlag = [NSString stringWithFormat:@"%li",(long)index];
    //    NSLog(@"点击了那个id%@",_orderstatuIdArray[index]);
    //    _orderselect = YES;
}
-(void)rel{
    dropDown = nil;
}
- (void)isEnableClick:(BOOL)isClick{
    
    _nameField.userInteractionEnabled = isClick;
    _sexBtn.userInteractionEnabled = isClick;
    _birthBtn.userInteractionEnabled = isClick;
    _workField.userInteractionEnabled = isClick;
    emailField.userInteractionEnabled = isClick;
    QQField.userInteractionEnabled = isClick;
    WXField.userInteractionEnabled = isClick;
    _cityField.userInteractionEnabled = isClick;
    _improtBtn.userInteractionEnabled = isClick;
    _carinformation.userInteractionEnabled = isClick;
    _headview.userInteractionEnabled = isClick;
}

- (void)loadNew{
    _nameField.text = [NSString stringWithFormat:@"%@",self.model.custname];
    NSString* sex;
    if ([self.model.sex integerValue] == 0) {
        sex = @"男";
    }else{
        sex = @"女";
    }
    [_sexBtn setTitle:sex forState:UIControlStateNormal];
    NSLog(@"出生日期%@",self.model.birthday);
    [_birthBtn setTitle:self.model.birthday forState:UIControlStateNormal];
//    NSArray *array = [_birthBtn.titleLabel.text componentsSeparatedByString:@"-"];
    _workField.text = self.model.occupation;
    _cityField.text = self.model.addressdetail;
    NSInteger i = [self.model.incomelevel intValue];
    [_improtBtn setTitle:_importArr[i] forState:UIControlStateNormal];
    _carinformation.text = self.model.vehicle_information;
    
    if (![[NSString stringWithFormat:@"%@",self.model.autoname] isEqualToString:@"(null)"]) {
        NSString *image = [NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,self.model.folder,self.model.autoname];
        NSLog(@"%@",image);
        [_headview sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
}

- (void)updateCustomerRequest{
    /*
     客户信息修改  /mbtwz/wxcustomer?action=updatecustomer    "+callback1
     参数：custname昵称   sex性别 ,birthday生日,occupation职业,addressdetail城市, incomelevel 收入放在data中
     */
    _nameField.text = [Command convertNull:_nameField.text];
    NSString* sex;
    if ([_sexBtn.titleLabel.text isEqualToString:@"男"]) {
        sex = @"0";
    }else if([_sexBtn.titleLabel.text isEqualToString:@"女"]){
        sex = @"1";
    }
    NSString* improtBtnid;
    for (int i = 0; i <_importArr.count; i++) {
        if ([_improtBtn.titleLabel.text isEqualToString:_importArr[i]]) {
            improtBtnid = [NSString stringWithFormat:@"%d",i];
        }
    }
    
    _birthBtn.titleLabel.text = [Command convertNull:_birthBtn.titleLabel.text];
    _workField.text = [Command convertNull:_workField.text];
    _cityField.text = [Command convertNull:_cityField.text];
    _improtBtn.titleLabel.text = [Command convertNull:_improtBtn.titleLabel.text];
    NSString* urlstr = @"/mbtwz/wxcustomer?action=updatecustomer";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"custname\":\"%@\",\"sex\":\"%@\",\"birthday\":\"%@\",\"occupation\":\"%@\",\"addressdetail\":\"%@\",\"incomelevel\":\"%@\"}",_nameField.text,sex,_birthBtn.titleLabel.text,_workField.text,_cityField.text,improtBtnid]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:urlstr Parameters:params FinishedLogin:^(id responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"个人信息修改成功", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"个人信息修改失败", 1);
        }
        
    }];
}
- (void)imgViewTapClick:(UITapGestureRecognizer*)tap{
    UIActionSheet* sheet = [[UIActionSheet alloc
                             ]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册里选择照片", @"现在就拍一张", nil];
    sheet.tag = 1001;
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //头像
    if (actionSheet.tag == 1001) {
        if (0 == buttonIndex) {
            [self LocalPhoto];
        } else if (1 == buttonIndex) {
            [self takePhoto];
        }
    }
    
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
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
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
        
        //修改图片的大小为90*90
        image = [self thumbnailImage:CGSizeMake(90.0, 90.0) withImage:image];
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        [self requestPortal:data img:image];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//修改头像大小
- (UIImage*)thumbnailImage:(CGSize)targetSize withImage:(UIImage*)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width * screenScale;
    CGFloat targetHeight = targetSize.height * screenScale;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //DLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestPortal:(NSData*)imgData img:(UIImage*)img {
    //NSData 转 Base64
    //    NSString* imgStr = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //        NSLog(@"上传图片的请求imgStr%@",imgStr);
#pragma mark 上传图片的请求
    //    [_headerBtn setImage:img forState:UIControlStateNormal];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",_Environment_Domain,@"/mbtwz/wxcustomer?action=uploadCustomerImage"];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *str = [formatter stringFromDate:[NSDate date]];
//    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    [NetWorkManagerTwo uploadPicturesWithURL:urlStr parameters:nil images:@[img] progress:^(float progress) {
        
    } success:^(id responseObject, id data) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"上传头像返回%@",str);
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            _headview.image = img;
            jxt_showToastTitle(@"头像上传成功", 1);

        }
    } failure:^(NSError *error) {
        
    }];
}

//字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
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
