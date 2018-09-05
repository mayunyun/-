//
//  JiFenShopViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JiFenShopViewController.h"
#import "IconsCollectionViewCell.h"
#import "DetailsViewController.h"
#import "ShopCarViewController.h"
#import "LoginVC.h"

@interface JiFenShopViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    int _numer;
}
@property (nonatomic ,strong)UICollectionView *IconsCollectionView;
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)NSMutableArray *idArr;

@end

@implementation JiFenShopViewController

- (UICollectionView *)IconsCollectionView{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 10;//行间距
    flowLayout.minimumLineSpacing = 10;//列间距
    if (_IconsCollectionView == nil) {
        _IconsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH) collectionViewLayout:flowLayout];
        //隐藏滑块
        _IconsCollectionView.showsVerticalScrollIndicator = NO;
        _IconsCollectionView.showsHorizontalScrollIndicator = NO;
        
        _IconsCollectionView.backgroundColor = [UIColor whiteColor];
        _IconsCollectionView.dataSource = self;
        _IconsCollectionView.delegate = self;
        //注册单元格
        [_IconsCollectionView registerNib:[UINib nibWithNibName:@"IconsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"IconsCollectionViewCellID"];
        [_IconsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];  //  一定要设置
        
        [self.view addSubview:_IconsCollectionView];
    }
    return _IconsCollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"积分商城";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"购物车-商城"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController)];
    [self.navigationItem.rightBarButtonItem setTintColor:MYColor];
    self.dataArr = [[NSMutableArray alloc]init];
    
    [self IconsCollectionView];
    [self loadNewData];
}
- (void)loadNewData{

    NSString *URLStr = @"/mbtwz/scshop?action=getAllProductType";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        
        NSArray* Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        _idArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dicId in Arr) {
            if ([[dicId objectForKey:@"id"] isEqualToString:@"552"]) {
                [_idArr addObject:[dicId objectForKey:@"id"]];
            }
        }
        NSLog(@">>>>>>>%@",Arr);
        
        if (_idArr.count) {
            _numer = 0;
            [self AllProductData];
        }
    
        
    }];
}

- (void)AllProductData{
    
    NSString *URLStr = @"/mbtwz/scshop?action=getAllProduct";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\",\"appstatus\":\"0\"}",_idArr[_numer]]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSArray* Array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"xilie%@",Array);
        if (Array.count) {
            NSMutableArray *data = [[NSMutableArray alloc]init];
            for (NSDictionary *diction in Array) {
                //建立模型
                ShopAddrModel *model=[[ShopAddrModel alloc]init];
                [model setValuesForKeysWithDictionary:diction];
                //追加数据
                model.type = @"2";
                [data addObject:model];
            }
            [self.dataArr addObject:data];
            _numer++;
            if (_numer == _idArr.count) {
                [_IconsCollectionView reloadData];
            }else{
                [self AllProductData];
            }
        }
        
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}
//调整Item的位置 使Item不紧挨着屏幕
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //在原有基础上进行调整 上 左 下 右
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(UIScreenW/2-15, UIScreenW/2-15);
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"IconsCollectionViewCellID";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"IconsCollectionViewCell" bundle: [NSBundle mainBundle]];
    [_IconsCollectionView registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    IconsCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = UIColorFromRGBValueValue(0x666666).CGColor;//设置边框颜色
    cell.layer.borderWidth = 1.0f;//设置边框
    if (self.dataArr.count) {
        ShopAddrModel *model = self.dataArr[indexPath.section][indexPath.row];
        [cell setData:model];
    }
    return cell;
}


//创建头视图
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind
//                                 atIndexPath:(NSIndexPath *)indexPath {
//
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//    UILabel *headLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 50*MYWIDTH)];
//    if (self.dataArr.count) {
//        if (self.dataArr[indexPath.section]) {
//            ShopAddrModel *model = self.dataArr[indexPath.section][0];
//            headLab.text = [NSString stringWithFormat:@"%@",model.protypename];
//        }
//    }
//    headLab.textAlignment = NSTextAlignmentCenter;
//    headLab.font = [UIFont systemFontOfSize:13];
//    headLab.textColor = UIColorFromRGB(0x333333);
//    headLab.backgroundColor = UIColorFromRGB(0xEEEEEE);
//    [headerView addSubview:headLab];
//    return headerView;
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(UIScreenW, 50*MYWIDTH);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *detailsVc = [[DetailsViewController alloc]init];
    
    if (_idArr.count) {
        for (int i = 0; i < _idArr.count; i++)
        {
            if (indexPath.section==i) {
                if (self.dataArr.count) {
                    ShopAddrModel *model = self.dataArr[indexPath.section][indexPath.row];
                    detailsVc.id = model.id;
                }
                detailsVc.type = @"2";
                [self.navigationController pushViewController:detailsVc animated:YES];
            }
        }
    }
    
}
- (void)rightToLastViewController{
    [Command isloginRequest:^(bool str) {
        if (str) {
            ShopCarViewController * vc = [[ShopCarViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginVC* vc = [[LoginVC alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
}

@end
