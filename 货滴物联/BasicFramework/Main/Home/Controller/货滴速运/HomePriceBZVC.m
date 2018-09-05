//
//  HomePriceBZVC.m
//  BasicFramework
//
//  Created by LONG on 2018/1/31.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "HomePriceBZVC.h"

@interface HomePriceBZVC ()

@end

@implementation HomePriceBZVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView * titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"收费标准"]];
    titleImageView.frame = CGRectMake(0, 0, 100, 20);
    self.navigationItem.titleView = titleImageView;
    float wi = (UIScreenW-32-3)/5;
    switch (_bzPrice.count) {
        case 0:{
            UIView *bai = [[UIView alloc]initWithFrame:CGRectMake(16, 105, UIScreenW, 100)];
            bai.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bai];
            break;
        }
        case 1:{
            _price1.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[0] objectForKey:@"during_time"]];
            _weight1.text = [NSString stringWithFormat:@"%@",[_bzPrice[0] objectForKey:@"timename"]];
            _weight1.textColor = [UIColor whiteColor];
            
            UIView *bai = [[UIView alloc]initWithFrame:CGRectMake(wi+16+1, 105, UIScreenW, 100)];
            bai.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bai];
            break;
        }
        case 2:{
            _price1.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[0] objectForKey:@"during_time"]];
            _weight1.text = [NSString stringWithFormat:@"%@",[_bzPrice[0] objectForKey:@"timename"]];
            _weight1.textColor = [UIColor whiteColor];
            
            _price2.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[1] objectForKey:@"during_time"]];
            _weight2.text = [NSString stringWithFormat:@"%@",[_bzPrice[1] objectForKey:@"timename"]];
            _weight2.textColor = [UIColor whiteColor];
            
            UIView *bai = [[UIView alloc]initWithFrame:CGRectMake(wi*2+16+1.5, 105, UIScreenW, 100)];
            bai.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bai];
            break;
        }
        case 3:{
            _price1.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[0] objectForKey:@"during_time"]];
            _weight1.text = [NSString stringWithFormat:@"%@",[_bzPrice[0] objectForKey:@"timename"]];
            _weight1.textColor = [UIColor whiteColor];
            
            _price2.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[1] objectForKey:@"during_time"]];
            _weight2.text = [NSString stringWithFormat:@"%@",[_bzPrice[1] objectForKey:@"timename"]];
            _weight2.textColor = [UIColor whiteColor];
            
            _price3.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[2] objectForKey:@"during_time"]];
            _weight3.text = [NSString stringWithFormat:@"%@",[_bzPrice[2] objectForKey:@"timename"]];
            _weight3.textColor = [UIColor whiteColor];
            
            UIView *bai = [[UIView alloc]initWithFrame:CGRectMake(wi*3+16+2, 105, UIScreenW, 100)];
            bai.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bai];
            break;
        }
        case 4:{
            _price1.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[0] objectForKey:@"during_time"]];
            _weight1.text = [NSString stringWithFormat:@"%@",[_bzPrice[0] objectForKey:@"timename"]];
            _weight1.textColor = [UIColor whiteColor];
            
            _price2.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[1] objectForKey:@"during_time"]];
            _weight2.text = [NSString stringWithFormat:@"%@",[_bzPrice[1] objectForKey:@"timename"]];
            _weight2.textColor = [UIColor whiteColor];
            
            _price3.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[2] objectForKey:@"during_time"]];
            _weight3.text = [NSString stringWithFormat:@"%@",[_bzPrice[2] objectForKey:@"timename"]];
            _weight3.textColor = [UIColor whiteColor];
            
            _price4.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[3] objectForKey:@"during_time"]];
            _weight4.text = [NSString stringWithFormat:@"%@",[_bzPrice[3] objectForKey:@"timename"]];
            _weight4.textColor = [UIColor whiteColor];
            
            UIView *bai = [[UIView alloc]initWithFrame:CGRectMake(wi*4+16+2.5, 105, UIScreenW, 100)];
            bai.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bai];
            break;
        }
        case 5:{
            _price1.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[0] objectForKey:@"during_time"]];
            _weight1.text = [NSString stringWithFormat:@"%@",[_bzPrice[0] objectForKey:@"timename"]];
            _weight1.textColor = [UIColor whiteColor];
            
            _price2.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[1] objectForKey:@"during_time"]];
            _weight2.text = [NSString stringWithFormat:@"%@",[_bzPrice[1] objectForKey:@"timename"]];
            _weight2.textColor = [UIColor whiteColor];
            
            _price3.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[2] objectForKey:@"during_time"]];
            _weight3.text = [NSString stringWithFormat:@"%@",[_bzPrice[2] objectForKey:@"timename"]];
            _weight3.textColor = [UIColor whiteColor];
            
            _price4.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[3] objectForKey:@"during_time"]];
            _weight4.text = [NSString stringWithFormat:@"%@",[_bzPrice[3] objectForKey:@"timename"]];
            _weight4.textColor = [UIColor whiteColor];
            
            _price5.text = [NSString stringWithFormat:@"￥%@",[_bzPrice[4] objectForKey:@"during_time"]];
            _weight5.text = [NSString stringWithFormat:@"%@",[_bzPrice[4] objectForKey:@"timename"]];
            _weight5.textColor = [UIColor whiteColor];
            break;
        }
        default:
            break;
    }
    
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
