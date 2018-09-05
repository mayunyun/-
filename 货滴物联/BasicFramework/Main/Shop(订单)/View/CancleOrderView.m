//
//  CancleOrderView.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CancleOrderView.h"

@implementation CancleOrderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView{
    static NSString *headerID = @"CancleOrderView";
    CancleOrderView *cancleOrderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (cancleOrderView == nil) {
        
        cancleOrderView = [[CancleOrderView alloc]initWithReuseIdentifier:headerID];
        
    }
    
    return cancleOrderView;
}
-(void)setStatus:(NSArray *)status{
    _status = status;
    NSArray *arr = [[NSArray alloc]init];
    if (_status.count>2) {
        arr = _status[2];
    }
    if (([[NSString stringWithFormat:@"%@",_status[0]] isEqualToString:@"0"]&&[[NSString stringWithFormat:@"%@",_status[1]] isEqualToString:@"0"])||[arr count]>0) {//等待接货 显示开始按钮
        _startbut.hidden = NO;
        _canclebut.hidden = NO;
        _driverSybut.hidden = NO;
        _startbut.frame = CGRectMake(20, 30, SCREEN_WIDTH-40, 50);
        _canclebut.frame = CGRectMake(20,_startbut.bottom+10, SCREEN_WIDTH-40, 50);
        _endbut.hidden = YES;
    }else if ([[NSString stringWithFormat:@"%@",_status[0]] isEqualToString:@"0"]&&[[NSString stringWithFormat:@"%@",_status[1]] isEqualToString:@"-2"]&&arr.count==0){//等待接货 不显示开始
        _startbut.hidden = YES;
        _driverSybut.hidden = YES;
        _canclebut.hidden = NO;
        _endbut.hidden = YES;
        _startbut.frame = CGRectMake(20, 30, SCREEN_WIDTH-40, 50);
        _canclebut.frame = CGRectMake(20,_startbut.bottom+10, SCREEN_WIDTH-40, 50);
        
    }else if ([[NSString stringWithFormat:@"%@",_status[0]] isEqualToString:@"1"]){//服务开始 显示结束
        _startbut.hidden = YES;
        _canclebut.hidden = YES;
        _driverSybut.hidden = YES;
        _endbut.hidden = NO;
        _endbut.frame = CGRectMake(20, 30, SCREEN_WIDTH-40, 50);
    }else{//已取消 已完成
        
        _endbut.hidden = YES;
        _startbut.hidden = YES;
        _canclebut.hidden = YES;
        _driverSybut.hidden = YES;
        
    }
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        //结束订单
        _endbut = [UIButton buttonWithType:UIButtonTypeCustom];
        _endbut.frame = CGRectMake(20, 30, SCREEN_WIDTH-40, 50);
        [_endbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_endbut setTitle:@"结束订单" forState:UIControlStateNormal];
        _endbut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_endbut setBackgroundColor:UIColorFromRGB(0xFE5100)];
        [_endbut addTarget:self action:@selector(endClicked) forControlEvents:UIControlEventTouchUpInside];
        _endbut.layer.cornerRadius = 8.f;
        _endbut.layer.masksToBounds = YES;
        [self addSubview:_endbut];
        //开始订单
        _startbut = [UIButton buttonWithType:UIButtonTypeCustom];
        _startbut.frame = CGRectMake(20, 30, SCREEN_WIDTH-40, 50);
        [_startbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startbut setTitle:@"开始订单" forState:UIControlStateNormal];
        _startbut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_startbut setBackgroundColor:UIColorFromRGB(0xFFB500)];
        [_startbut addTarget:self action:@selector(startClicked) forControlEvents:UIControlEventTouchUpInside];
        _startbut.layer.cornerRadius = 8.f;
        _startbut.layer.masksToBounds = YES;
        [self addSubview:_startbut];
        //取消订单
        _canclebut = [UIButton buttonWithType:UIButtonTypeCustom];
        _canclebut.frame = CGRectMake(20, _startbut.bottom+15, SCREEN_WIDTH-40, 50);
        [_canclebut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_canclebut setTitle:@"取消订单" forState:UIControlStateNormal];
        _canclebut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_canclebut setBackgroundColor:[UIColor lightGrayColor]];
        [_canclebut addTarget:self action:@selector(cancleClicked) forControlEvents:UIControlEventTouchUpInside];
        _canclebut.layer.cornerRadius = 8.f; 
        _canclebut.layer.masksToBounds = YES;
        [self addSubview:_canclebut];
        //司机失约
//        _driverSybut = [UIButton buttonWithType:UIButtonTypeCustom];
//        _driverSybut.frame = CGRectMake(20, _canclebut.bottom+10, SCREEN_WIDTH-40, 50);
//        [_driverSybut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_driverSybut setTitle:@"司机失约" forState:UIControlStateNormal];
//        _driverSybut.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_driverSybut setBackgroundColor:UIColorFromRGB(0xeb6202)];
//        [_driverSybut addTarget:self action:@selector(driverSyClicked) forControlEvents:UIControlEventTouchUpInside];
//        _driverSybut.layer.cornerRadius = 8.f;
//        _driverSybut.layer.masksToBounds = YES;
//        [self addSubview:_driverSybut];
        
    }
    return self;
}
-(void)driverSyClicked{
    if (_driverSyBlock) {
        self.driverSyBlock();
    }
}
-(void)cancleClicked{
    if (_cancleBtnBlock) {
        self.cancleBtnBlock();
    }
}
-(void)startClicked{
    if (_startBtnBlock) {
        self.startBtnBlock();
    }
}
-(void)endClicked{
    if (_endBtnBlock) {
        self.endBtnBlock();
    }
}
@end
