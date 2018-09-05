//
//  ShopCarTableViewCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShopCarTableViewCell.h"

@implementation ShopCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
// 改变滑动删除按钮样式
- (void)layoutSubviews {
    [super layoutSubviews];

    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            CGRect cRect = subView.frame;
            cRect.size.height = self.contentView.frame.size.height - 20;
            cRect.origin.y = self.contentView.frame.origin.y+16;
            subView.frame = cRect;
            
            UIView *confirmView=(UIView *)[subView.subviews firstObject];
            // 改背景颜色
            confirmView.backgroundColor=[UIColor colorWithRed:254/255.0 green:85/255.0 blue:46/255.0 alpha:1];
            for(UIView *sub in confirmView.subviews){
                if([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]){
                    UILabel *deleteLabel=(UILabel *)sub;
                    // 改删除按钮的字体
                    deleteLabel.font=[UIFont boldSystemFontOfSize:15];
                    // 改删除按钮的文字
                    deleteLabel.text=@"删除";
                }
            }
            break;
        }
    }

}
- (void)setBookModel:(SABookModel *)bookModel{
    _bookModel = bookModel;
    self.bgView.layer.cornerRadius = 3.0f;
    NSString *image = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,bookModel.folder,bookModel.autoname];
    NSLog(@"%@",image);
    self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
    self.productName.text = [NSString stringWithFormat:@"%@",bookModel.proname];
    if ([bookModel.type integerValue]==2) {
        self.price.text = [NSString stringWithFormat:@"%@积分",bookModel.price];
        [self changeTextColor:self.price Txt:self.price.text changeTxt:[NSString stringWithFormat:@"%@",bookModel.price]];

    }else{
        self.price.text = [NSString stringWithFormat:@"%.2f元  %@积分",[bookModel.price floatValue],bookModel.price_jf];
        [self changeTextColor:self.price Txt:self.price.text changeTxt:[NSString stringWithFormat:@"%.2f元  %@积分",[bookModel.price floatValue],bookModel.price_jf]];

    }
    self.price.textColor = UIColorFromRGB(0xffb400);
    self.productDescribtion.text = [NSString stringWithFormat:@"型号:%@",bookModel.fitcar];
    // 根据count决定countLabel显示文字
    self.countTf.text = [NSString stringWithFormat:@"%d",bookModel.count];
    self.countTf.enabled = NO;
    // 根据count决定减号按钮是否能够被点击（如果不写这一行代码，会出现cell复用)
//    if (bookModel.selectState == NO) {
//        self.downBtn.enabled = NO;
//        self.upBtn.enabled = NO;
//        self.bigDownBtn.enabled = NO;
//        self.bigUpBtn.enabled = NO;
//        //self.downBtn.enabled = (bookModel.count > 0);
//    }
}
//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffb400"] range:NSMakeRange(location, length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}
- (IBAction)downBtnClicked:(id)sender {
    self.bookModel.count--;
    self.countTf.text = [NSString stringWithFormat:@"%d",self.bookModel.count];
    //当商品数量小于2件的时候 减按钮不能点击
    if (self.bookModel.count < 2) {
        self.bigDownBtn.enabled = NO;
        self.downBtn.enabled = NO;
        self.countTf.text = [NSString stringWithFormat:@"%d",1];
    }
    if (_downBtnClickBlock) {
        self.downBtnClickBlock();
    }
}
- (IBAction)upBtnClicked:(id)sender {
    self.bookModel.count++;
    
    self.countTf.text = [NSString stringWithFormat:@"%d",self.bookModel.count];
    self.downBtn.enabled = YES;
    self.bigDownBtn.enabled = YES;
    if (_upBtnClickBlock) {
        self.upBtnClickBlock();
    }
}
- (IBAction)delBtnClicked:(id)sender {
    if (_delBtnClickBlock) {
        self.delBtnClickBlock();
    }
}
- (IBAction)selectBtnClicked:(id)sender {
    if (_selectBtnClickBlock) {
        self.selectBtnClickBlock();
    }
}

@end
