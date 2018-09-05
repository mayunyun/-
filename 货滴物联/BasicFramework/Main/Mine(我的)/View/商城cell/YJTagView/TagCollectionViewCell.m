//
//  TagCollectionViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TagCollectionViewCell.h"

@implementation TagCollectionViewCell

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
//    CGSize size = [content boundingRectWithSize:CGSizeMake(maxWidth-20, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:style} context:nil].size;
    
    if (numer==5) {
        return CGSizeMake((maxWidth)/numer, cellHeight);
    }
    return CGSizeMake((maxWidth-50*MYWIDTH)/3, cellHeight);
}
@end
