//
//  CarDetailViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarDetailViewController.h"
#import "CollectionDetailHeaderView.h"
#import "CarDetailTitleTableViewCell.h"
#import "CarDetailModel.h"
@interface CarDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CollectionHeadDetailDelegate,UIWebViewDelegate>
{
    UIScrollView* _bgSView;
    UIWebView* _webView;
    CGFloat _documentHeight;
    int Size_i;
}
@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)NSMutableArray *sizeArr;

@property(nonatomic,strong)CollectionDetailHeaderView *collectionView;
@end

@implementation CarDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"iconfont-touming"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    //self.automaticallyAdjustsScrollViewInsets = NO; //autolayout 自适应关闭
    self.navigationItem.title = @"";
    _dataArr = [[NSMutableArray alloc]init];
    _imgArray = [[NSMutableArray alloc]init];
    _sizeArr = [[NSMutableArray alloc]init];
    Size_i = 0;
    [self tableview];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, 1)];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    [self detailDataRequest];
    
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -NavBarHeight, kScreenWidth, kScreenHeight+NavBarHeight)];
//        if (statusbarHeight>20) {
//            _tableview.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88);
//        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_tableview];
        
        _collectionView = [[CollectionDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 220*MYWIDTH)];
        _collectionView.delegate = self;
        _collectionView.viewController = self;
        _collectionView.idStr = _idStr;
        [_collectionView dataHeadView];
        _tableview.tableHeaderView = _collectionView;
        
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _tableview.tableFooterView = food;

        [_tableview registerClass:[CarDetailTitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CarDetailTitleTableViewCell class])];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableview;
    
}

- (void)loadNewData{
    [_tableview.mj_header endRefreshing];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2+_dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_dataArr.count && section==2) {
        CarDetailModel* model = _dataArr[0];
        if (IsEmptyValue(model.note)) {
            return 0;
        }
    }
    if (_dataArr.count) {
        return 10*GMYWIDTH;
    }else{
        return 0;
    }
    return 10*GMYWIDTH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&&indexPath.row == 0) {
        return 120*GMYWIDTH;
    }else if (indexPath.section == _dataArr.count+1&&indexPath.row == 0){
        return _webView.frame.size.height;
    }else if (indexPath.section <= _dataArr.count&&indexPath.row == 0){
        if (_sizeArr.count>0) {
            NSDictionary *dic = _sizeArr[indexPath.section-1];
            if ([[dic objectForKey:@"w"] floatValue] == 0) {
                return 0;
            }
            return (kScreenWidth/[[dic objectForKey:@"w"] floatValue])*[[dic objectForKey:@"h"] floatValue];
        }
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        Class MainTitleClass = [CarDetailTitleTableViewCell class];
        CarDetailTitleTableViewCell *cell = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainTitleClass)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        if (!IsEmptyValue(_dataArr)) {
            cell.dataArr = _dataArr;
        }
        [cell setData];
        return cell;
    }
    if (indexPath.section == 1+_dataArr.count&&indexPath.row == 0) {
        static NSString* cellID = @"cellID";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell.contentView addSubview:_webView];
        return cell;
    }
    

    static NSString* cellID = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell) {
        if (_dataArr.count>0) {
            CarDetailModel* model = _dataArr[indexPath.section-1];
            NSString *image = [NSString stringWithFormat:@"%@/%@%@",_Environment_Domain,model.folder,model.autoname];
            UIImageView *BGimageView = [[UIImageView alloc]init];
            [BGimageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGSize size = image.size;
                CGFloat W = size.width;
                CGFloat H = size.height;
                NSLog(@"%@, w = %f,h = %f",imageURL,W,H);
                NSDictionary *dic = @{@"w":[NSString stringWithFormat:@"%.2f",W],@"h":[NSString stringWithFormat:@"%.2f",H]};
                [_sizeArr addObject:dic];
                if (W!=0) {
                    BGimageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth/W*H);
                }
                [cell addSubview:BGimageView];
                if (Size_i == _dataArr.count-1) {
                    [_tableview reloadData];
                }
                Size_i++;
            }];
            
        }

    }
    
    return cell;
}
- (void)detailDataRequest{
    NSString *URLStr = @"/mbtwz/CarHome?action=getCarDetailDown";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_idStr]};
    NSLog(@"%@",params);
    [_dataArr removeAllObjects];
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:URLStr Parameters:params FinishedLogin:^(id responseObject) {
        
        NSArray* Arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"详情列表%@",Arr);
        
        if (!IsEmptyValue(Arr)) {
            for (NSDictionary* dict in Arr) {
                CarDetailModel* model = [[CarDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArr addObject:model];
            }
            
        }

        NSLog(@"_dataArr%@",_dataArr);
        //在此处加载webView的原因是：不能在tableViewcell中加载网页那样会造成因为cellForRowAtIndexPath和webViewDidFinishLoad代理互相调用引起的内存泄漏。
        NSString* linkCss = @"<style type=\"text/css\"> img {"
        "width:100%;"
        "height:auto;"
        "}"
        "</style>";
        if (!IsEmptyValue(_dataArr)) {
            CarDetailModel* model = _dataArr[0];
            if (!IsEmptyValue(model.note)) {
                NSLog(@"model.note%@",model.note);
                [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",model.note,linkCss] baseURL:[NSURL URLWithString:_Environment_Domain]];
            }else{
                _webView.height = 0;
            }
        }
        
        if (self.dataArr.count>0) {
//            [self.tableview dismissNoView];
            [self.tableview reloadData];
            
        }else{
            [self.tableview reloadData];
//            [self.tableview showNoView:nil image:nil certer:CGPointZero];
        }
        
    }];

}
// 根据图片url获取图片尺寸
-(void)getImageSizeWithURL:(id)imageURL numer:(int)count
{
    UIImageView *v1 = [[UIImageView alloc]init];
    NSLog(@"%@",imageURL);

    [v1 sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGSize size = image.size;
        CGFloat W = size.width;
        CGFloat H = size.height;
        NSLog(@"%@, w = %f,h = %f",imageURL,W,H);
        NSDictionary *dic = @{@"w":[NSString stringWithFormat:@"%.2f",W],@"h":[NSString stringWithFormat:@"%.2f",H]};
        [_sizeArr addObject:dic];
        if (Size_i == count-1) {
            [_tableview reloadData];
        }
        Size_i++;
}];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth,oldheight;"
     "var maxwidth=300;"// 图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    CGFloat documentHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"webView的高度-----%f",documentHeight);
    _documentHeight = documentHeight;
    //    [_tbView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    _webView.frame = CGRectMake(_webView.frame.origin.x,_webView.frame.origin.y, kScreenWidth, documentHeight);
    [_tableview reloadData];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    NSLog(@"didFailLoadWithError===%@", error);
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    CGFloat sectionHeaderHeight = 64;
// if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//
//        scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//
//        scrollView.contentInset = UIEdgeInsetsMake(54, 0, 0, 0);
//
//    }
//    
//}

@end
