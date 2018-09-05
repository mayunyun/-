//
//  xiaoxiViewController.m
//  BasicFramework
//
//  Created by LONG on 2018/6/22.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "xiaoxiViewController.h"
#import "xiaoxiTableViewCell.h"
#import "xiaoxiModel.h"
#import "xiaoxiDetalViewController.h"
@interface xiaoxiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    NSMutableArray* _dataArray;
    NSMutableArray* _selectArray;
    NSMutableIndexSet* _indexSetToDel;
    BOOL _isdelectBtn;
    UIView *_bgview;
}

@property (nonatomic,strong)UITableView* tbView;
@end

@implementation xiaoxiViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dataRequest];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _indexSetToDel = [[NSMutableIndexSet alloc]init];
    _page = 1;

    [self creatUI];
}

- (void)creatUI{
    
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"管理"];
    self.title = @"消息";
    [self tbView];
    
    _bgview = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenH-60*MYWIDTH, UIScreenW, 60*MYWIDTH)];
    _bgview.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.view addSubview:_bgview];
    
    UIButton * selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllBtn.frame = CGRectMake(10, 10*MYWIDTH, 60*MYWIDTH, 40*MYWIDTH);
    [selectAllBtn setImage:[UIImage imageNamed:@"shanchuweixuan"] forState:UIControlStateNormal];
    [selectAllBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectedAll:) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:selectAllBtn];
    
    UIButton * deleleAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleleAllBtn.frame = CGRectMake(UIScreenW-90*MYWIDTH, 10*MYWIDTH, 80*MYWIDTH, 40*MYWIDTH);
    deleleAllBtn.backgroundColor = [UIColor redColor];
    deleleAllBtn.layer.cornerRadius = 20*MYWIDTH;
    [deleleAllBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleleAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleleAllBtn addTarget:self action:@selector(deleleAllBtnAll) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:deleleAllBtn];
    
    _bgview.hidden = YES;

}
- (void)selectedAll:(UIButton *)but{
    
    if (!but.selected) {
        but.selected = YES;
        [but setImage:[UIImage imageNamed:@"shanchuxuanze"] forState:UIControlStateNormal];

        for (int i=0; i<_dataArray.count; i++) {
            xiaoxiModel* model = _dataArray[i];
            model.isselect = @"1";
            [_selectArray addObject:model];
            [_indexSetToDel addIndex:i];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [_tbView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            
        }

    }else{
        but.selected = NO;
        [but setImage:[UIImage imageNamed:@"shanchuweixuan"] forState:UIControlStateNormal];

        for (int i=0; i<_dataArray.count; i++) {
            xiaoxiModel* model = _dataArray[i];
            model.isselect = @"0";
            [_selectArray removeObject:model];
            [_indexSetToDel removeIndex:i];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [_tbView deselectRowAtIndexPath:indexPath animated:NO];
            
        }
        
        

    }
    
    
}
- (void)deleleAllBtnAll{
    jxt_showAlertTwoButton(@"提示", @"确定要删除选中的消息", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        [self delproductbrowerRequest];
    });
    
}
- (void)rightBarClick:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"管理"]) {
        _isdelectBtn = YES;
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [_tbView setEditing:YES animated:YES];
        [_indexSetToDel removeAllIndexes];//清空上次推出管理状态之前选中的那些行（下标）
        _bgview.hidden = NO;
    }else{
        _isdelectBtn = NO;
        [sender setTitle:@"管理" forState:UIControlStateNormal];
        [_tbView setEditing:NO animated:YES];
#pragma mark删除接口
//        if (_selectArray.count!=0) {
//            [self delproductbrowerRequest];
//        }
        _bgview.hidden = YES;
    }
    [_tbView reloadData];
}

- (UITableView*)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, statusbarHeight+44, UIScreenW, UIScreenH-60*MYWIDTH) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.showsVerticalScrollIndicator = NO;
        _tbView.showsHorizontalScrollIndicator = NO;
        _tbView.rowHeight = 80;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.backgroundColor = UIColorFromRGB(0xEFEFEF);
        [self.view addSubview:_tbView];
        //    //隐藏多余cell
        _tbView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //下拉刷新
        _tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            if (!IsEmptyValue(_dataArray)) {
                [_dataArray removeAllObjects];
            }
            [self dataRequest];
            [_tbView.mj_header endRefreshing];
            
        }];
        //
        _tbView.mj_header.automaticallyChangeAlpha = YES;
        //
        _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _page ++;
            [self dataRequest];
            [_tbView.mj_footer endRefreshing];
        }];
    }
    return _tbView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *heaview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 1)];
    heaview.backgroundColor = UIColorFromRGB(0xEFEFEF);
    return heaview;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    xiaoxiTableViewCell* mycell = [tableView dequeueReusableCellWithIdentifier:@"xiaoxiTableViewCell"];
    if (!mycell) {
        mycell = [[[NSBundle mainBundle]loadNibNamed:@"xiaoxiTableViewCell" owner:self options:nil]firstObject];
    }
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            xiaoxiModel* model = _dataArray[indexPath.section];
            mycell.model = model;

        }

        return mycell;
    }
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;//表示多选状态
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_tbView.editing) {
        //是管理状态，记录选中的行号做数组下标
        xiaoxiModel* model = _dataArray[indexPath.section];
        model.isselect = @"1";
        [_selectArray addObject:model];
        [_indexSetToDel addIndex:indexPath.section];
//        if (_selectArray.count) {
//            [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"删除"];
//        }else{
//            [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"完成"];
//        }
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        xiaoxiDetalViewController *details = [[xiaoxiDetalViewController alloc]init];
        xiaoxiModel* model = _dataArray[indexPath.section];
        details.model = model;
        details.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:details animated:YES];
        
    }
}

//协议中取消选中tableView中某行时被调用
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_tbView.editing) {
        //把之前选中的行号扔掉
        xiaoxiModel* model = _dataArray[indexPath.section];
        model.isselect = @"0";
        [_selectArray removeObject:model];
        [_indexSetToDel removeIndex:indexPath.section];
//        if (_selectArray.count) {
//            [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"删除"];
//        }else{
//            [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"完成"];
//        }
    }
}

//查询接口
- (void)dataRequest{
    /*
     collect?action=searchCollection
     */
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:@"0" forKey:@"type"];
    
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20",@"params":[Command dictionaryToJson:param]};
    
    NSString *url = @"/mbtwz/sendusermsg?action=searchUserMsgList";
    
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:url Parameters:params FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (_page == 1) {
            [_dataArray removeAllObjects];
        }
        NSArray *arr = [[NSArray alloc]initWithArray: dic[@"response"][@"rows"]];
        self.title = [NSString stringWithFormat:@"消息(%@)",dic[@"response"][@"total"]];

        for (NSDictionary* dict in arr) {
            xiaoxiModel* model = [[xiaoxiModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArray addObject:model];
        }
        [_tbView reloadData];
        
    }];
    
    
}

//删除接口
- (void)delproductbrowerRequest{
    /*
     /mbtwz/sendusermsg?action=deleteUserMsg
     */
    NSMutableString* idstr = [[NSMutableString alloc]init];
    //列出NSIndexSet的值
    for (int i = 0 ; i < _selectArray.count ;i ++)  {
        xiaoxiModel* model = _selectArray[i];
        [idstr appendString:[NSString stringWithFormat:@"%@,",model.id]];
    }
    NSString* idsstr = idstr;
    NSRange range = {0,idsstr.length - 1};
    if (idsstr.length!=0) {
        idsstr = [idsstr substringWithRange:range];
    }
    NSDictionary* parmas = @{@"data":[NSString stringWithFormat:@"{\"selectid\":\"%@\"}",idsstr]};
    [[RequestTool sharedRequestTool].userRequestTool loginWithUrl:@"/mbtwz/sendusermsg?action=deleteUserMsg" Parameters:parmas FinishedLogin:^(id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            [_dataArray removeObjectsAtIndexes:_indexSetToDel];
            self.title = [NSString stringWithFormat:@"消息(%lu)",_dataArray.count];

        }else{
            jxt_showAlertTitle(@"删除失败");
        }
        [_selectArray removeAllObjects];
        [_indexSetToDel removeAllIndexes];//清空集合
        [_tbView reloadData];
        [_tbView setEditing:NO animated:YES];
        _bgview.hidden = YES;
        [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"管理"];

    }];
    
    
     
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
