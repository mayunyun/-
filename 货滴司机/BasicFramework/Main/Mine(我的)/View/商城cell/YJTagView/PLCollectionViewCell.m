//
//  PLCollectionViewCell.m
//  BasicFramework
//
//  Created by LONG on 2018/6/21.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "PLCollectionViewCell.h"

@implementation PLCollectionViewCell
- (void)setContent:(NSString *)content
{
    _content = content;
    [_tagLabel setText:content];
    [_tagLabel setBackgroundColor:[UIColor whiteColor]];
}

+ (CGSize) getSizeWithContent:(NSString *) content maxWidth:(CGFloat)maxWidth customHeight:(CGFloat)cellHeight numer:(int)numer
{
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize size = [content boundingRectWithSize:CGSizeMake(maxWidth-20, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:style} context:nil].size;
    return CGSizeMake(size.width+20, cellHeight);
//    if (numer==3) {
//        return CGSizeMake((maxWidth-50*MYWIDTH)/numer, cellHeight);
//    }
//    return CGSizeMake((maxWidth)/numer, cellHeight);
}

@end
