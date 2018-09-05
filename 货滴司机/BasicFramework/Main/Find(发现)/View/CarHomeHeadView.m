//
//  CarHomeHeadView.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarHomeHeadView.h"
#import "CarBrandModel.h"
@implementation CarHomeHeadView{
    int _totalloc;
    NSMutableArray *_idArr;
    NSMutableArray *_titleArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
      
        [self createUI];
        [self dataHeadView:nil];
    }
    return self;
}
-(void)dataHeadView:(NSMutableArray *)data{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 12*MYWIDTH, kScreenWidth, 186*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgview];
    
    UILabel *strlab = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 100, 30*MYWIDTH)];
    strlab.text = @"热门品牌";
    strlab.font = [UIFont systemFontOfSize:12];
    strlab.textColor = UIColorFromRGB(0x333333);
    [bgview addSubview:strlab];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 30*MYWIDTH, kScreenWidth-30*MYWIDTH, 0.5)];
    xian.backgroundColor = UIColorFromRGB(MYLine);
    [bgview addSubview:xian];
    
    
    
    _titleArr = [[NSMutableArray alloc]init];
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    _idArr = [[NSMutableArray alloc]init];

    for (CarBrandModel *model in data) {
        [_titleArr addObject:model.brandname];
        [_idArr addObject:model.id];
        NSString *strurl = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,model.folder,model.autoname];
        [imageArr addObject:strurl];
    }
    //
    _totalloc=5;
    CGFloat appvieww=40*MYWIDTH;
    CGFloat appviewh=40*MYWIDTH;
    
    for (int i = 0; i<[_titleArr count]; i++) {
        
        CGFloat appviewx = (kScreenWidth/_totalloc)/2 - appvieww/2 + (kScreenWidth/_totalloc) * (i%_totalloc);
        CGFloat appviewy =30*MYWIDTH + 10*MYWIDTH + 75*MYWIDTH * (i/_totalloc);
        //
        
        UIImageView *butimage = [[UIImageView alloc]initWithFrame:CGRectMake(appviewx, appviewy, appvieww, appviewh)];
        [butimage sd_setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];

        butimage.tag = i+10;
        butimage.userInteractionEnabled = YES;
        [bgview addSubview:butimage];
        
        
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
        [butimage addGestureRecognizer:tapRecognizer];
        //
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(appviewx+appvieww/2-(kScreenWidth/_totalloc)/2, appviewy+appviewh, kScreenWidth/_totalloc, 25)];
        but.tag = i;
        [but setTitle:_titleArr[i] forState:UIControlStateNormal];
        but.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        but.titleLabel.font = [UIFont systemFontOfSize:12*MYWIDTH];
        [but setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
        [but addTarget:self action:@selector(Classbut:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:but];
        if (i == 9) {
            return;
        }
    }
    if (data.count >5) {
        bgview.frame = CGRectMake(0, 12*MYWIDTH, kScreenWidth, 186*MYWIDTH);
    }else if (data.count>0){
        bgview.frame = CGRectMake(0, 12*MYWIDTH, kScreenWidth, 78*MYWIDTH);
    }else{
        [bgview removeFromSuperview];
    }
}
-(void)createUI{
    
    
    
   
}

- (void)Classbut:(UIButton *)but{
    [self.delegate CarHomeHeadViewBtnHaveString:_titleArr[but.tag] idStr:_idArr[but.tag]];
}
- (void)SingleTap:(UITapGestureRecognizer*)recognizer  {
    [self.delegate CarHomeHeadViewBtnHaveString:_titleArr[recognizer.view.tag-10] idStr:_idArr[recognizer.view.tag-10]];
    
    
}
@end
