//
//  BasicMainVC.m
//  BasicFramework
//
//  Created by Rainy on 2017/1/17.
//  Copyright © 2017年 Rainy. All rights reserved.
//


#define backIMG [UIImage imageNamed:@"back"]

#import "BasicMainVC.h"

@interface BasicMainVC ()


@end

@implementation BasicMainVC
//=============================================================================
//在相应控制器关闭手势返回
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//}
//-(void)backAction{
//    
//    [self.myAlertView show];
//}
//=============================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //打开手势返回
    if (self.navigationController != nil && self.navigationController.viewControllers.count > 1) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:backIMG style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        [self.navigationItem.leftBarButtonItem setTintColor:NavBarItemColor];
    }
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarTitleButtonTarget:(id)target action:(SEL)action text:(NSString*)str{
    
    NSDictionary* atrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize size1 =  [str boundingRectWithSize:CGSizeMake(UIScreenW - 20.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
    NSLog(@"size.width=%f, size.height=%f", size1.width, size1.height);
    UIButton* rightBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBarBtn.frame = CGRectMake(0, 0, size1.width, 30);
    [rightBarBtn setTitle:str forState:UIControlStateNormal];
    [rightBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = right;
}
#pragma mark - removeKeyboardNotification
- (void)removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}
#pragma mark - addNotifications
-(void)addNotifications
{
    
    
    [kNotificationCenter addObserver:self
                            selector:@selector(keyboardWillShow:)
                                name:UIKeyboardWillShowNotification
                              object:nil];
    
    [kNotificationCenter addObserver:self
                            selector:@selector(keyboardDidShow:)
                                name:UIKeyboardDidShowNotification
                              object:nil];
    
    [kNotificationCenter addObserver:self
                            selector:@selector(keyboardWillHide:)
                                name:UIKeyboardWillHideNotification
                              object:nil];
}
#pragma mark - UIKeyboard - Notification
-(void)keyboardDidShow:(NSNotification *)aNotification
{
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyboarHeight = keyboardRect.size.height;
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.keyboarHeight = 0;
}


- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    
//    1.#define定义的常量
//    kCATransitionFade   交叉淡化过渡
//    kCATransitionMoveIn 新视图移到旧视图上面
//    kCATransitionPush   新视图把旧视图推出去
//    kCATransitionReveal 将旧视图移开,显示下面的新视图
//
//    2.用字符串表示 动画类型
//    pageCurl            向上翻一页
//    pageUnCurl          向下翻一页
//    rippleEffect        滴水效果
//    suckEffect          收缩效果，如一块布被抽走
//    cube                立方体效果
//    oglFlip             上下翻转效果
//
//
//    示例：
//    CATransition *animation=[CATransition animation];
//    animation.delegate=self;
//    animation.duration=1.0f;
//    animation.timingFunction=UIViewAnimationCurveEaseInOut;
//    animation.type=kCATransitionMoveIn;
//    animation.subtype=kCATransitionFromTop;
//
//    [myView.layer addAnimation:animation forKey:@"move in"];
    
    //创建动画
    CATransition * transition = [CATransition animation];
    
    //设置动画类型
    //transition.type = @"rippleEffect";
    [transition setType:kCATransitionPush];
    //动画出现类型
    //transition.subtype = @"fromCenter";
    [transition setSubtype:kCATransitionFromRight];
    //动画时间
    transition.duration = 0.3;
    
    //移除当前window的layer层的动画
    [self.view.window.layer removeAllAnimations];
    
    //将定制好的动画添加到当前控制器window的layer层
    //[self.view.window.layer addAnimation:transition forKey:nil];
    //自定义动画 需要关闭系统动画
    [super presentViewController:viewControllerToPresent animated:NO completion:completion];
}
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    //也可加动画
    [super dismissViewControllerAnimated:flag completion:completion];
}



//改textField中placeholderColor
- (void)placeholderColor:(UITextField*)textField str:(NSString*)holderText color:(UIColor*)color{
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:color
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"PingFangSC-Regular" size:13*MYWIDTH]
                        range:NSMakeRange(0, holderText.length)];
    textField.attributedPlaceholder = placeholder;
}
-(void)dealloc
{
    [kNotificationCenter removeObserver:self];
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
