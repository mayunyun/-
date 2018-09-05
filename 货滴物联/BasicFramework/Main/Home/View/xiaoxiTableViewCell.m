//
//  xiaoxiTableViewCell.m
//  BasicFramework
//
//  Created by LONG on 2018/6/22.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "xiaoxiTableViewCell.h"

@implementation xiaoxiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.imgview.layer.cornerRadius = 5;
    self.imgview.clipsToBounds = YES;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLab.text = [NSString stringWithFormat:@"%@",_model.title];
    self.otherLab.text = [NSString stringWithFormat:@"%@",_model.content];
    self.timeLab.text = [NSString stringWithFormat:@"%@",_model.create_time];

    if ([_model.issee intValue]==0){
        self.dianjiview.hidden = NO;
    }else {
        self.dianjiview.hidden = YES;
    }
    //通知消息
    if ([_model.mark intValue]==0){
        if ([_model.issee intValue]==0){
            self.imgview.image = [UIImage imageNamed:@"tongzhiweidu2"];
        }else {
            self.imgview.image = [UIImage imageNamed:@"tongzhiyidu"];
        }
        //物流消息
    }else if ([_model.mark intValue]==1){
        if ([_model.issee intValue]==0){
            self.imgview.image = [UIImage imageNamed:@"jiaoyiweidu"];
        }else {
            self.imgview.image = [UIImage imageNamed:@"jiaoyiyidu"];
        }
        //商城消息
    }else if ([_model.mark intValue]==2){
        if ([_model.issee intValue]==0){
            self.imgview.image = [UIImage imageNamed:@"tongzhiweidu2"];
        }else {
            self.imgview.image = [UIImage imageNamed:@"tongzhiweidu2"];
        }
        //互动消息
    }else if ([_model.mark intValue]==3){
        if ([_model.issee intValue]==0){
            self.imgview.image = [UIImage imageNamed:@"hudongweidu"];
        }else {
            self.imgview.image = [UIImage imageNamed:@"hudongweiyidu"];
        }
    }
   
    
    
}
@end
