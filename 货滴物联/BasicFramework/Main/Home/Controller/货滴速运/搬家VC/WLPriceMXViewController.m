//
//  WLPriceMXViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/12/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WLPriceMXViewController.h"
#import "WLPriceBZViewController.h"

@interface WLPriceMXViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *zongPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *zongMileageLab;
@property (weak, nonatomic) IBOutlet UILabel *starting_Price;

@end

@implementation WLPriceMXViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    titleLab.text = @"价格明细";
    titleLab.textColor = UIColorFromRGBValueValue(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLab;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"查看收费标准"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:MYColor  range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:MYColor range:(NSRange){0,[tncString length]}];
    [_priceBut setAttributedTitle:tncString forState:UIControlStateNormal];
    
    NSString *imageStr = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,self.model.folder,self.model.autoname];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
    
    self.zongPriceLab.text = [NSString stringWithFormat:@"￥%.2f",[self.zongPrice floatValue]];
    self.zongMileageLab.text = [NSString stringWithFormat:@"总里程%@公里",self.zongMileage];
    self.starting_Price.text = [NSString stringWithFormat:@"%@起步价:￥%@",self.model.car_type,self.model.starting_price];

}
- (IBAction)setWithPriceButClick:(UIButton *)sender {
    WLPriceBZViewController *priceBZ = [[WLPriceBZViewController alloc]init];
    [self.navigationController pushViewController:priceBZ animated:YES];
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
