//
//  CarDropDown.h
//  MaiBaTe
//
//  Created by LONG on 2017/9/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>



@class CarDropDown;
@protocol CarDropDownDelegate
- (void) carDropDownDelegateMethod: (CarDropDown *) sender index:(NSInteger)index;
@end

@interface CarDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}
@property (nonatomic, retain) id <CarDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSString *)direction;

@end
