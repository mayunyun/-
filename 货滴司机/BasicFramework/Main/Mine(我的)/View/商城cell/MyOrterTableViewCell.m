//
//  MyOrterTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyOrterTableViewCell.h"
#import "MYYOrterClassTableViewCell.h"
@interface MyOrterTableViewCell ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
}

@end
@implementation MyOrterTableViewCell

{
    MYYMyOrderModel *_model;
}

- (void)configModel:(MYYMyOrderModel *)model{
    _model = model;
    _hejiLab.textAlignment = NSTextAlignmentRight;
    _deleteBut.hidden = YES;
    switch ([model.orderstatus intValue]) {//0待付款 1 待发货 2 待收货 3待评价 4订单完成
        case 0:{
            _ordelState.text = @"待付款";
            _ordelState.textColor = UIColorFromRGB(0xd0121b);
            _hejiLab.textAlignment = NSTextAlignmentLeft;
            _deleteBut.hidden = NO;

            break;
        }
        case 1:{
            _ordelState.text = @"待发货";
            _ordelState.textColor = UIColorFromRGB(0xff9400);
            break;
        }
        case 2:{
            _ordelState.text = @"待收货";
            _ordelState.textColor = UIColorFromRGB(0xffcc00);
            break;
        }
//        case 3:{
//            _ordelState.text = @"待评价";
//
//            break;
//        }
        case 4:{
            _ordelState.text = @"已完成";
            _ordelState.textColor = UIColorFromRGB(0x20ab12);
            break;
        }
        case -1:{
            _ordelState.text = @"已取消";
            break;
        }
        default:{
            

        }
            break;
    }
    [_deleteBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _ordernoLab.text = [NSString stringWithFormat:@"订单号：%@",model.orderno];
    
    _numLab.text = [NSString stringWithFormat:@"共计商品%@件",model.totalcount];
    _numLab.width = 100*MYWIDTH;
    if ([model.type intValue]==2) {
        _hejiLab.text = [NSString stringWithFormat:@"合计:%@积分",model.totalmoney];
        [self changeTextColor:_hejiLab Txt:_hejiLab.text changeTxt:[NSString stringWithFormat:@"%@",model.totalmoney]];
    }else{
        _hejiLab.text = [NSString stringWithFormat:@"合计:%.2f元 %@积分",[model.totalmoney floatValue],model.totaljifen];
        [self changeTextColor:_hejiLab Txt:_hejiLab.text changeTxt:[NSString stringWithFormat:@"%.2f元 %@积分",[model.totalmoney floatValue],model.totaljifen]];
    }

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
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#c30e21"] range:NSMakeRange(location, length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 3*90) style:UITableViewStylePlain];
        _tbView.userInteractionEnabled = NO;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.bounces = NO;
        _tbView.delegate = self;
        _tbView.rowHeight = 90;
        _tbView.dataSource = self;
        [self.bgView addSubview:_tbView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.bgView setFrame:CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, 90*_prolistArr.count)];
    self.bgHeight.constant = 90*_prolistArr.count;
    [_tbView setFrame:CGRectMake(0, 0, UIScreenW, _prolistArr.count*90)];
    [_tbView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!IsEmptyValue(_prolistArr)) {
        return _prolistArr.count;
    }
    return 0;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYYOrterClassTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MYYOrterClassTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MYYOrterClassTableViewCell" owner:self options:nil].firstObject;
    }
    
    MYYMyOrderClassModer* model = _prolistArr[indexPath.row];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",_Environment_Domain,model.folder,model.autoname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",model.proname];
    cell.typeLab.text = [NSString stringWithFormat:@"型号:%@",model.specification];
    cell.numLab.text = [NSString stringWithFormat:@"数量%@件",model.count];
    cell.priceLab.text = [NSString stringWithFormat:@"%.2f元  %@积分",[model.price floatValue],model.price_jf];
    if ([_model.type intValue]==2) {
        cell.priceLab.text = [NSString stringWithFormat:@"%@积分",model.price];
    }
    [cell setNeedsLayout];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
