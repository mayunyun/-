//
//  WuLiuSJRZPhoneCell.h
//  MaiBaTe
//
//  Created by LONG on 2018/1/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WuLiuSJRZPhoneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *oneLab;
@property (weak, nonatomic) IBOutlet UILabel *twoLab;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UIImageView *oneImage;
@property (weak, nonatomic) IBOutlet UIImageView *twoImage;
@property (weak, nonatomic) IBOutlet UIImageView *threeImage;
@property (weak, nonatomic) IBOutlet UIButton *shiOneBut;
@property (weak, nonatomic) IBOutlet UIButton *shiTwoBut;
@property (weak, nonatomic) IBOutlet UIButton *shiThreeBut;

- (void)setUpData:(NSInteger)numer;
@property(nonatomic,assign)NSInteger numer;
@end
