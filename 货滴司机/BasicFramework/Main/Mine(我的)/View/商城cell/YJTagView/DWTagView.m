//
//  DWTagView.m
//  MaiBaTe
//
//  Created by LONG on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DWTagView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "TagCollectionViewCell.h"

static CGFloat kDefaultCellHeight = 30;

@interface DWTagView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation DWTagView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.collectionView];
        self.cellHeight = kDefaultCellHeight;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        self.backgroundColor = [UIColor whiteColor];
        self.cellHeight = kDefaultCellHeight;
    }
    return self;
}

#pragma mark - Layout
/** 适应布局变换 */
- (void) layoutSubviews
{
    [super layoutSubviews];

    UICollectionViewLeftAlignedLayout *layout = (UICollectionViewLeftAlignedLayout *)_collectionView.collectionViewLayout;
    [layout invalidateLayout];
    layout.minimumLineSpacing = 15*MYWIDTH;//设置最小行间距
    
    layout.minimumInteritemSpacing = 15*MYWIDTH;//item间距(最小值)
    
    
    _collectionView.frame = self.bounds;
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
    CGFloat height = _collectionView.collectionViewLayout.collectionViewContentSize.height;
    if (height != 0 && height != self.bounds.size.height) {
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
        _collectionView.frame = self.bounds;
        if ([self.delegate respondsToSelector:@selector(DWtagView:heightUpdated:)]) {
            [self.delegate DWtagView:self heightUpdated:height];
        }
    }

}

- (CGSize)intrinsicContentSize
{
    NSLog(@"height---%f",_collectionView.collectionViewLayout.collectionViewContentSize.height);
    return _collectionView.collectionViewLayout.collectionViewContentSize;
}

#pragma mark - Actions

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource DWnumOfItemstagView:self];
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.content = [self.dataSource DWtagView:self titleForItemAtIndex:indexPath.row];
    if (self.themeColor) {
        cell.tagLabel.textColor = UIColorFromRGB(0x333333);
        cell.tagLabel.tag = indexPath.row+300;
        cell.tagLabel.layer.cornerRadius = 5;
        cell.tagLabel.layer.masksToBounds = YES;
        cell.tagLabel.layer.borderWidth = 1;
        cell.tagLabel.layer.borderColor = [UIColorFromRGB(MYLine) CGColor];
    }
    //CGFloat cornerRadius = self.tagCornerRadius;
    //cell.backgroundView = [self drawConnerView:cornerRadius rect:cell.bounds backgroudColor:cell.backgroundColor borderColor:UIColorFromRGB(MYLine)];
    return cell;
}

#pragma mark - UI_Style
/** 绘画圆角 解决卡顿*/
-(UIView *)drawConnerView:(CGFloat)cornerRadius rect:(CGRect)frame backgroudColor:(UIColor *)backgroud_color borderColor:(UIColor *)borderColor{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectInset(frame, 0, 0);
    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), cornerRadius);
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds), cornerRadius);
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMinX(bounds), CGRectGetMinY(bounds), cornerRadius);
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMinX(bounds), CGRectGetMaxY(bounds), cornerRadius);
    layer.path = pathRef;
    CFRelease(pathRef);
    layer.strokeColor = [borderColor CGColor];
    layer.fillColor = backgroud_color.CGColor;
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    roundView.layer.cornerRadius = 5;
    return roundView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:self.collectionView]) {
        for (int i=0; i<[self.dataSource DWnumOfItemstagView:self]; i++) {
            UILabel *lab = (UILabel *)[self viewWithTag:i+300];
            lab.textColor = UIColorFromRGB(0x333333);
            lab.backgroundColor = UIColorFromRGB(0xFFFFFF);

            NSLog(@"%d  %zd",i,indexPath.row);
            if (i==indexPath.row) {
                lab.textColor = UIColorFromRGB(0xFFFFFF);
                lab.backgroundColor = MYColor;
            }
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(DWtagView:didSelectedItemAtIndex:)]) {
        [self.delegate DWtagView:self didSelectedItemAtIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TagCollectionViewCell getSizeWithContent:[self.dataSource DWtagView:self titleForItemAtIndex:indexPath.row] maxWidth:_collectionView.frame.size.width customHeight:self.cellHeight numer:self.numer];
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10*MYWIDTH, 5, 10*MYWIDTH);
}
#pragma mark - Lazy loading

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:[[UICollectionViewLeftAlignedLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    }
    return _collectionView;
}


@end
