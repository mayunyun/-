//
//  mainCollectionViewCell.h
//  BasicFramework
//
//  Created by LONG on 2018/6/6.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleview;
- (void)setdataimage:(NSString *)image title:(NSString *)title;
@end
