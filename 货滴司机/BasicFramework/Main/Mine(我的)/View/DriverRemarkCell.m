//
//  DriverRemarkCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DriverRemarkCell.h"

@implementation DriverRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDicinfo:(NSDictionary *)dicinfo{
    /**
     createtime = "2018-01-09 16:05:17";
     custid = 95;
     "driver_fraction" = 4;
     driverid = 30;
     id = 48;
     note = "\U9ed8\U8ba4\U597d\U8bc46";
     **/
    _dicinfo = dicinfo;
    NSString * content =_dicinfo[@"note"];
    NSInteger  score = [_dicinfo[@"driver_fraction"] integerValue];
    NSString * creattime = [NSString stringWithFormat:@"%@",_dicinfo[@"createtime"]];
    NSString * s = [self removeLastOneChar:creattime];
    self.cotent.text = content;
    self.time.text = s;
    _xingxingView = [[WQLStarView alloc]initWithFrame:CGRectMake(0,10, UIScreenW-180, 20) withTotalStar:5 withTotalPoint:5 starSpace:2];
    _xingxingView.starAliment = StarAlimentDefault;
    _xingxingView.commentPoint = score;
    [self.starView addSubview:_xingxingView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSString*) removeLastOneChar:(NSString*)origin
{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-3)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}
@end
