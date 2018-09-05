//
//  MyErSCshopViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/7/20.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "MyErSCshopViewController.h"
#import "ErSCCollectionViewCell.h"
#import "ErSCModel.h"
#import "ErSCshopDateViewController.h"
@interface MyErSCshopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray* _DataArray;
}
@property(nonatomic,strong)UICollectionView *collection;

@end

@implementation MyErSCshopViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dataRequest];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLab.text = @"我的二手车";
    titleLab.textColor = [UIColor redColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    
    [self creatUI];
}
- (void)dataRequest{
    _DataArray = [[NSMutableArray alloc]init];
    NSString *URLStr = @"/mbtwz/secondhandcar?action=searchSelfSecondhandcar";
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:nil FinishedLogin:^(id responseObject) {
        
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            
            for (NSDictionary* dict in [dic objectForKey:@"response"]) {
                ErSCModel* model = [[ErSCModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_DataArray addObject:model];
            }
        }
        [_collection reloadData];
    }];
    
}
- (void)creatUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize =CGSizeMake(UIScreenW, UIScreenH);
    //layout.minimumInteritemSpacing = 0; //列间距
    //layout.minimumLineSpacing = 0;//行间距
    _collection =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH) collectionViewLayout:layout];
    
    _collection.delegate =self;
    _collection.dataSource =self;
    _collection.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:_collection];
    
    [_collection registerNib:[UINib nibWithNibName:@"ErSCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ErSCCollectionViewCell"];

    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, statusbarHeight+44)];
    topview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topview];
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"ErSCCollectionViewCell";
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"ErSCCollectionViewCell" bundle: [NSBundle mainBundle]];
    [_collection registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    ErSCCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //[self framAdd:cell];
    
    ErSCModel* model;
    if (_DataArray.count!=0) {
        model = _DataArray[indexPath.row];
    }
    model.title = [Command convertNull:model.title];
    model.price = [Command convertNull:model.price];
    model.car_type_name = [Command convertNull:model.car_type_name];
    
    cell.titleLabel.text = nil;
    cell.imgView.image = nil;
    cell.priceLabel.text = nil;
    cell.otherLab.text = nil;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
    cell.priceLabel.textColor = UIColorFromRGB(0xFF0000);
    cell.otherLab.textColor = UIColorFromRGB(0x666666);
    cell.otherLab.text = [NSString stringWithFormat:@" %@",model.car_type_name];
    
    
    NSString* url = _Environment_Domain;
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",url,model.twoscarpic]);
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",url,model.twoscarpic]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //400*kScreen_Width/714
    return CGSizeMake(UIScreenW/2-20*MYWIDTH, (UIScreenW/2-20*MYWIDTH)*4/3-10*MYWIDTH);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth,1);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10*MYWIDTH, 10*MYWIDTH, 10*MYWIDTH, 10*MYWIDTH);
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return _DataArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ErSCModel* model = _DataArray[indexPath.row];
    
    ErSCshopDateViewController *ersc = [[ErSCshopDateViewController alloc]init];
    ersc.selectid = model.id;
    ersc.push = @"1";
    [self.navigationController pushViewController:ersc animated:YES];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
