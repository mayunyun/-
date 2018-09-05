//
//  CarDropDown.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarDropDown.h"

#import "QuartzCore/QuartzCore.h"

@interface CarDropDown ()<UITextFieldDelegate>
{
    UITextField *_textfield;
}
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSMutableArray *rangelist;
@end

@implementation CarDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;
@synthesize animationDirection;

- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSString *)direction {
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        self.rangelist = [[NSMutableArray alloc]init];;

        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        //        table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor grayColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_textfield == nil) {
        _textfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 35)];//- 50
        _textfield.delegate = self;
        _textfield.layer.borderColor = [[UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1] CGColor];
        _textfield.layer.borderWidth = 0.5f;
        _textfield.layer.cornerRadius = 15.0f;
        _textfield.backgroundColor = [UIColor whiteColor];
        _textfield.placeholder = @"请输入汽车车型";
        _textfield.textColor = UIColorFromRGB(0x333333);
        _textfield.font = [UIFont systemFontOfSize:14];
        _textfield.textAlignment = NSTextAlignmentCenter;
        [Command placeholderColor:_textfield str:_textfield.placeholder color:UIColorFromRGB(0x555555)];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 35)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:_textfield];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.rangelist.count) {
        return self.rangelist.count;
    }
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (self.rangelist.count) {
        cell.textLabel.text =[self.rangelist objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
    }

    
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    
   
    [self myDelegate:indexPath.row];
}

- (void) myDelegate:(NSInteger)index {
    [self.delegate carDropDownDelegateMethod:self index:index];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    [self rangeStr:textField.text];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * resultStr = [textField.text stringByAppendingString:string];
    [self rangeStr:resultStr];

    return YES;
}

- (void)rangeStr:(NSString *)str{
    NSLog(@"%@",str);
    [self.rangelist removeAllObjects];
    for (NSString *strAR in self.list) {
        NSRange range = [strAR rangeOfString:str];
        if (range.location != NSNotFound){
            [self.rangelist addObject:strAR];
        }
    }
    [table reloadData];
}
    
@end
