//
//  PLCollectionViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/6/21.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy) NSString *content;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

+ (CGSize) getSizeWithContent:(NSString *) content maxWidth:(CGFloat)maxWidth customHeight:(CGFloat)cellHeight numer:(int)numer;
@end
