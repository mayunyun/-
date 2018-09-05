//
//  CoreViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CoreViewController.h"
#import <AVFoundation/AVFoundation.h>
//#import <AudioToolbox/AudioToolbox.h>
#import "CoreTitleViewViewController.h"

@interface CoreViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    int line_tag;
    UIView *highlightView;
    
    BOOL isLightOn;
    AVCaptureDevice *device;
    
    UIImagePickerController *_myPicker;

}
@property BOOL isLightOn;

@end

@implementation CoreViewController
@synthesize isLightOn;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


//视图将要消失时关闭手电筒
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (isLightOn) {
        [self turnOffLed:YES];
    }

}
/**
 *  @author Whde
 *
 *  viewDidLoad
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self instanceDevice];
    [self upAVCaptureDevice];
}
- (void)upAVCaptureDevice{
    //AVCaptureDevice代表抽象的硬件设备
    // 找到一个合适的AVCaptureDevice
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch]) {//判断是否有闪光灯
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备没有闪光灯，不能提供手电筒功能" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alter show];
    }
    
    isLightOn = NO;
}
//
- (void)deviceClicked:(UIButton *)but{
    isLightOn = 1-isLightOn;
    if (isLightOn) {
        [self turnOnLed:YES];
        but.selected = YES;
    }else{
        [self turnOffLed:YES];
        but.selected = NO;
    }
}
//打开手电筒
-(void) turnOnLed:(bool)update
{
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOn];
    [device unlockForConfiguration];
}

//关闭手电筒
-(void) turnOffLed:(bool)update
{
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOff];
    [device unlockForConfiguration];
}

/**
 *  @author Whde
 *
 *  配置相机属性
 */
- (void)instanceDevice{
    
    line_tag = 1872637;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView];
    
    [session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始捕获
    [session startRunning];
}

/**
 *  @author Whde
 *
 *  监听扫码状态-修改扫描动画
 *
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        
        
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}

/**
 *  @author Whde
 *
 *  获取扫码结果
 *
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        //提示音
        NSString * pathString = [[ NSBundle mainBundle ] pathForResource:@"提示音" ofType:@"mp3" ];
        static SystemSoundID shake_sound_male_id = 0;
        if(pathString)
        { //注册声音到系统
            AudioServicesCreateSystemSoundID(( __bridge CFURLRef)[NSURL fileURLWithPath:pathString], &shake_sound_male_id);
        }
        AudioServicesPlaySystemSound (shake_sound_male_id);
        //输出扫描字符串
        NSString *data = metadataObject.stringValue;
        NSLog(@"%@",data);
        [self alertMetadataObjectData:data];
    }
}
/**
 *  @author Whde
 *
 *  处理扫码抢号
 *
 */
- (void)alertMetadataObjectData:(NSString *)data{
    
    if ([self isUrl:data]) {
        [self selfRemoveFromSuperview];

        NSString *url;

        if (data.length>4 && [[data substringToIndex:4] isEqualToString:@"www."]) {
            
            url = [NSString stringWithFormat:@"http://%@",data];
            
        }else{
            
            url = data;
            
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        
        CoreTitleViewViewController *titleVIew = [[CoreTitleViewViewController alloc]init];

        titleVIew.strl = data;
        [self presentViewController:titleVIew animated:YES completion:nil];

    }

}


- (BOOL)isUrl:(NSString *)urlStr

{
    
    if(self == nil)
        
        return NO;
    
    NSString *url;
    
    if (urlStr.length>4 && [[urlStr substringToIndex:4] isEqualToString:@"www."]) {
        
        url = [NSString stringWithFormat:@"http://%@",urlStr];
        
    }else{
        
        url = urlStr;
        
    }
    
    NSString *emailRegex = @"[a-zA-z]+://.*";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    

    return [emailTest evaluateWithObject:url];
}
/**
 *  @author Whde
 *
 *  未识别(其他)的二维码提示点击"好",继续扫码
 *
 */
- (void)alertViewCancel:(UIAlertView *)alertView {
    [session startRunning];
}

/**
 *  @author Whde
 *
 *  didReceiveMemoryWarning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  @author Whde
 *
 *  创建扫码页面
 */
- (void)setOverlayPickerView
{
    //左侧的view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenW/2-130*MYWIDTH, UIScreenH)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    //右侧的view
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenW/2+130*MYWIDTH, 0, UIScreenW/2-130*MYWIDTH, UIScreenH)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //最上部view
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenW/2-130*MYWIDTH, 0, 260*MYWIDTH, UIScreenH/2-UIScreenW/2)];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, upView.bottom-60, UIScreenW, 60)];
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor whiteColor];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:13];
    msg.text = @"将二维码/条码对准取景框,即可自动扫描";
    [self.view addSubview:msg];
    
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenW/2-130*MYWIDTH, upView.bottom, 260*MYWIDTH, 260*MYWIDTH)];
    centerView.image = [UIImage imageNamed:@"扫描框.png"];
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenW/2-130*MYWIDTH, CGRectGetMaxY(upView.frame), 260*MYWIDTH, 2)];
    line.tag = line_tag;
    line.image = [UIImage imageNamed:@"扫描线.png"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    
    
    //底部view
    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenW/2-130*MYWIDTH, centerView.bottom, 260*MYWIDTH, UIScreenH-centerView.bottom)];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    
    
    //手电筒
    UIButton *devicebtn = [[UIButton alloc]init];
    [devicebtn setFrame:CGRectMake(UIScreenW/2-30*MYWIDTH, CGRectGetMinY(downView.frame)+20, 60*MYWIDTH, 60*MYWIDTH)];
    [devicebtn setImage:[UIImage imageNamed:@"手电筒"] forState:UIControlStateNormal];
    [devicebtn setImage:[UIImage imageNamed:@"手电筒亮"] forState:UIControlStateSelected];
    [devicebtn addTarget:self action:@selector(deviceClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:devicebtn];
    //页面返回按钮
    CGRect leftFrame;
    leftFrame = CGRectMake(0, 10+NavBarHeight-64, 120, 60);
    UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame =leftFrame;
    [leftButton addTarget:self action:@selector(dismissOverlayView:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"  扫描二维码" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    
    CGRect rightFrame;
    rightFrame = CGRectMake(UIScreenW-58, 10+NavBarHeight-64, 60, 60);
    UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame =rightFrame;
    [rightButton addTarget:self action:@selector(xiangceView:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"相册"] forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    
    
}

//
- (void)xiangceView:(UIButton *)but{
    NSLog(@"支持图库");
    _myPicker = [[UIImagePickerController alloc] init];
    _myPicker.delegate = self;
    _myPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _myPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _myPicker.allowsEditing = YES;
    [self presentViewController:_myPicker animated:YES completion:nil];
    NSLog(@"选择相册");
}
#pragma mark imagePicker代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //取消选取图片
    [self dismissViewControllerAnimated:YES completion:^{
        // NSLog(@"取消选取图片");
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //[_myPicker dismissViewControllerAnimated:YES completion:nil];
    //获取选中的照片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //初始化  将类型设置为二维码
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(image)]];
        //判断是否有数据（即是否是二维码）
        if (features.count >= 1) {
            //取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            //通过对话框的形式呈现
            [self alertMetadataObjectData:scannedResult];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"这不是一个二维码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

}

/**
 *  @author Whde
 *
 *  添加扫码动画
 */
- (void)addAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    line.hidden = NO;
    CABasicAnimation *animation = [CoreViewController moveYTime:2 fromY:[NSNumber numberWithFloat:5] toY:[NSNumber numberWithFloat:255*MYWIDTH] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}


/**
 *  @author Whde
 *
 *  去除扫码动画
 */
- (void)removeAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    [line.layer removeAnimationForKey:@"LineAnimation"];
    line.hidden = YES;
}

/**
 *  @author Whde
 *
 *  扫码取消button方法
 *
 */
- (void)dismissOverlayView:(id)sender{
    
    [self selfRemoveFromSuperview];
}

/**
 *  @author Whde
 *
 *  从父视图中移出
 */
- (void)selfRemoveFromSuperview{
    
    
    [session removeObserver:self forKeyPath:@"running" context:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.view.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.view removeFromSuperview];
//        [self removeFromParentViewController];
//    }];
}

/*!
 *  <#Description#>
 *  @param didReceiveBlock <#didReceiveBlock description#>
 */
- (void)setDidReceiveBlock:(QRCodeDidReceiveBlock)didReceiveBlock {
    _didReceiveBlock = [didReceiveBlock copy];
}


@end
