//
//  DiscoverController.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DiscoverController.h"
#import "DiscoverCell.h"
#import "DiscoverData.h"

@interface DiscoverController ()

/** 下拉菜单 */
@property (nonatomic, strong) FFDropDownMenuView *dropdownMenu;


@property(nonatomic,strong) NSMutableArray *modelArray;

@end

@implementation DiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:NavBarItemColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"发布2"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController:)];
    [self.navigationItem.rightBarButtonItem setTintColor:NavBarItemColor];
    
    self.navigationItem.title = @"圈子";
    
    /** 初始化下拉菜单 */
    [self setupDropDownMenu];
    
    //注册discoverCell
    [self.tableView registerClass:[DiscoverCell class] forCellReuseIdentifier:NSStringFromClass([DiscoverCell class])];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self createModelsWithCount:10];

}
-(void)loadNewData{
    [self.modelArray removeAllObjects];
    
    [self createModelsWithCount:10];
    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];

}
- (void)createModelsWithCount:(NSInteger)count
{
    if(_modelArray==nil)
    {
        _modelArray = [[NSMutableArray alloc]init];
    }
    
    
    
    NSArray *iconImageNamesArray=@[@"icon0.jpg",
                                   @"icon1.jpg",
                                   @"icon2.jpg",
                                   @"icon3.jpg",
                                   @"icon4.jpg"];
    NSArray *nameArray = @[@"黄英",
                           @"莫顿",
                           @"王小姐",
                           @"SKHuang",
                           @"Kim"];
    NSArray *timeArray = @[@"13:08",
                           @"2014-09-13",
                           @"2015-08-25",
                           @"一个月前",
                           @"昨天",
                           @"15:56"];
    
    NSArray *readArray = @[@"阅读:20",
                           @"阅读:13",
                           @"阅读:32",
                           @"阅读:54",
                           @"阅读:22332"];
    NSArray *textArray = @[@"最近小学生又开始狂了，把戏一天比一天多！一个个能得都快上天了！会三种语言的本公举此时此刻怎能逊色！从来就没有在怕的我跟你讲！you know？",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"【今天，怀念人民的好总理】他把所有的心装进心里，他把所有的爱握在手中，他把所有的伤痛藏在身上，他把所有的生命归还世界。他，就是这样的人。50多年革命生涯，26年总理任期，他鞠躬尽瘁；他离去，身后没子女也没财产，却有十里长街百万群众洒泪送别！今天，#周总理辞世40周年#，我们永远怀念您！",
                           @"关注我的朋友都长啥样啊，我先即兴测验一下：长发的转发，短发的评论，光头的点赞…快！",
                           @"本來想安安靜靜做個美男紙集齊九宮格自拍給你們..但可能是太安靜了..最後也是失敗了..好睏呀"
                           ];
    
    NSArray *locationArray =@[@"广东省广州市白云区黄石东路3",
                              @"上海市闵行区吴宝路848号",
                              @"中国广东佛山",
                              @"天河公园",
                              @"广东省广州市白云区沙涌北涌南街79号",];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];
    
    NSArray *zanArray=@[@"icon0.jpg",
                        @"icon1.jpg",
                        @"icon2.jpg",
                        @"icon3.jpg",
                        @"icon4.jpg"];
    
    
    NSArray *articleTitleArray = @[
                                   @"<瑞法12日游>精品25人小团 2月1日团期立减2500元 带你体验欧洲之纯净旅程 一价全",
                                   @"2月1日团期立减2500元 带你体验欧洲之纯净旅程 一价全",
                                   @"<瑞法期立减2500元 带你体验12日游>精品25人小团 2月1日团期立减2500元 带你体验欧洲之纯净旅程 一价全",
                                   @"<瑞法12日游>精品25人小团 2月1日团期立减2500元 带你体验欧洲之纯净旅程 一价全"];
    
    //根据传进来的数字创建对应的模型个数
    for(int i=0;i<count;i++)
    {
        int iconNameIndex = arc4random_uniform(5);
        int nameIndex = arc4random_uniform(5);
        int timeIndex = arc4random_uniform(6);
        int readIndex = arc4random_uniform(5);
        int textIndex =arc4random_uniform(5);
        int locationIndex =arc4random_uniform(5);
        int articleTitleIndex= arc4random_uniform(4);
        
        DiscoverData *data = [DiscoverData new];
        data.icon = iconImageNamesArray[iconNameIndex];
        data.name=nameArray[nameIndex];
        data.read=readArray[readIndex];
        data.time=timeArray[timeIndex];
        data.text=textArray[textIndex];
        data.articleTitle = articleTitleArray[articleTitleIndex];
        data.location = locationArray[locationIndex];
        int random = arc4random_uniform(10);
        NSMutableArray *temp = [NSMutableArray array];
        for(int i=0;i<random;i++)
        {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
            
        }
        if(temp.count)
        {
            data.picturesArray = [temp copy];
        }
        
        
        
        //模拟点赞人数
        int random2 = arc4random_uniform(5);
        NSMutableArray *temp2 = [NSMutableArray array];
        for(int i=0;i<random2;i++)
        {
            int random2Index = arc4random_uniform(4);
            [temp2 addObject:zanArray[random2Index]];
        }
        
        if(temp2.count)
        {
            data.zanArray  =[temp2 copy];
        }
        
        [self.modelArray  addObject:data];
        
    }
    
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Class currentClass = [DiscoverCell class];
    DiscoverCell *cell = nil;
    DiscoverData *data = self.modelArray[indexPath.row];
    
    //        if(data.picturesArray.count>3)
    //        {
    //            currentClass = [SKYoujiCell class];
    //        }
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    
    
    cell.data = data;
    
    return cell;
    
    
    
    //
}

#pragma mark 点击cell对应的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark 返回cell对应的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/** 初始化下拉菜单 */
- (void)setupDropDownMenu {
    NSArray *modelsArray = [self getMenuModelsArray];
    
    self.dropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:FFDefaultFloat eachItemHeight:FFDefaultFloat menuRightMargin:FFDefaultFloat triangleRightMargin:FFDefaultFloat];
    
//    //如果有需要，可以设置代理（非必须）
//    self.dropdownMenu.delegate = self;
    
    self.dropdownMenu.ifShouldScroll = NO;
    
    [self.dropdownMenu setup];
}

/** 获取菜单模型数组 */
- (NSArray *)getMenuModelsArray {
    __weak typeof(self) weakSelf = self;
    
    //菜单模型0
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"我要发布" menuItemIconName:@"发布.png"  menuBlock:^{
        NSLog(@"我要发布");
    }];
    
    
    //菜单模型1
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"我的评论" menuItemIconName:@"评论白.png" menuBlock:^{
        NSLog(@"我要评论");
    }];
    
    NSArray *menuModelArr = @[menuModel0, menuModel1];
    return menuModelArr;
}

/** 显示下拉菜单 */

- (void)rightToLastViewController:(UIButton *)button{
    [self.dropdownMenu showMenu];

}

- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
