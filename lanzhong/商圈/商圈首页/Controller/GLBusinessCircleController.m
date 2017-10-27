//
//  GLBusinessCircleController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusinessCircleController.h"
#import "GLBusiniessCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "GLBusinessCircle_MenuScreeningView.h"
#import "GLBusiness_DetailController.h"//项目详情
#import "GLBusinessCircleModel.h"
#import "GLBusinessAdModel.h"//广告Model

#import "JZAlbumViewController.h"

@interface GLBusinessCircleController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) GLBusinessCircle_MenuScreeningView *menuScreeningView;  //条件选择器

@property (nonatomic, strong)GLCircle_item_screenModel *categoryModel;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@property (nonatomic, copy)NSString *trade_id;
@property (nonatomic, copy)NSString *man;
@property (nonatomic, copy)NSString *stop;

@property (nonatomic, strong)NSMutableArray *adModels;

@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏

@end

@implementation GLBusinessCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.headerView.height = 200;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiniessCell" bundle:nil] forCellReuseIdentifier:@"GLBusiniessCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    self.stop = @"3";
     __weak __typeof(self) weakSelf = self;
    
    [self.headerView addSubview:self.cycleScrollView];
    self.menuScreeningView.block = ^(NSInteger itemIndex,NSInteger index){
        switch (itemIndex) {
            case 0:
            {
                weakSelf.trade_id = weakSelf.categoryModel.trade[index].trade_id;
            }
                break;
            case 1:
            {
                weakSelf.man = weakSelf.categoryModel.man[index].trade_id;
            }
                break;
            case 2:
            {
               weakSelf.stop = weakSelf.categoryModel.stop[index].trade_id;
            }
                break;
                
            default:
                break;
        }
        
        [weakSelf postRequest:YES];
    };

    [self.headerView addSubview:self.menuScreeningView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];
        [weakSelf postRequest_Category];
        [weakSelf postAdData];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf postRequest:NO];
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    [self postRequest:YES];
    [self postRequest_Category];
    [self postAdData];
    
}

- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
        
    }else{
        self.page ++ ;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"page"] = @(self.page);
    dic[@"trade_id"] = self.trade_id;
    dic[@"man"] = self.man;
    dic[@"stop"] = self.stop;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:kCIRCLE_HOME_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if (isRefresh) {
            [self.models removeAllObjects];
        }
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dict in responseObject[@"data"]) {
                    GLCircle_item_dataModel *model = [GLCircle_item_dataModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }
            }
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
        
    }];
}

- (void)postRequest_Category {

    [NetworkManager requestPOSTWithURLStr:kCIRCLE_FITER_URL paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                self.categoryModel = [GLCircle_item_screenModel mj_objectWithKeyValues:responseObject[@"data"]];
                
                NSMutableArray *arrM = [NSMutableArray array];
                NSMutableArray *arrM2 = [NSMutableArray array];
                NSMutableArray *arrM3 = [NSMutableArray array];
                
                for (GLCircle_itemScreen_manModel *manModel in self.categoryModel.trade) {
                    [arrM addObject:manModel.trade_name];
                }
                for (GLCircle_itemScreen_manModel *manModel in self.categoryModel.man) {
                    [arrM2 addObject:manModel.trade_name];
                }
                for (GLCircle_itemScreen_manModel *manModel in self.categoryModel.stop) {
                    [arrM3 addObject:manModel.trade_name];
                }
                
                self.menuScreeningView.dataArr1 = arrM;
                self.menuScreeningView.dataArr2 = arrM2;
                self.menuScreeningView.dataArr3 = arrM3;
            }
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
//        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
//       
//        [self.tableView reloadData];
    }];
}

//请求广告数据
- (void)postAdData{
    
    [NetworkManager requestPOSTWithURLStr:kBANNER_LIST_URL paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                [self.adModels removeAllObjects];
                
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLBusinessAdModel *model = [GLBusinessAdModel mj_objectWithKeyValues:dic];
                    [self.adModels addObject:model];
                    
                    NSString *imageurl = [NSString stringWithFormat:@"%@?imageView2/1/w/%f/h/150",model.must_banner,kSCREEN_WIDTH];
                    [arrM addObject:imageurl];
                }
                
                self.cycleScrollView.imageURLStringsGroup = arrM;
            }
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
//        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        
//        [self.tableView reloadData];
    }];
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - SDCycleScrollViewDelegate 点击看大图
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = index;//这个参数表示当前图片的index，默认是0
    jzAlbumVC.imgArr = [self.cycleScrollView.imageURLStringsGroup copy];//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.models.count == 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBusiniessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiniessCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 155;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCircle_item_dataModel *model = self.models[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_DetailController *detailVC = [[GLBusiness_DetailController alloc] init];
    detailVC.item_id = model.item_id;
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - 懒加载
-(GLBusinessCircle_MenuScreeningView*)menuScreeningView{
    
    if (!_menuScreeningView) {
        _menuScreeningView = [[GLBusinessCircle_MenuScreeningView alloc] initWithFrame:CGRectMake(0, 0,kSCREEN_WIDTH , 50) WithTitles:@[@"行业",@"官方发布",@"筹款中"]];
        _menuScreeningView.backgroundColor = [UIColor whiteColor];
    }
    
    return _menuScreeningView;
    
}

- (SDCycleScrollView *)cycleScrollView{
    
    if (!_cycleScrollView) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 50, kSCREEN_WIDTH, 150)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];
        
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor redColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        
        _cycleScrollView.localizationImageNamesGroup = @[LUNBO_PlaceHolder,LUNBO_PlaceHolder,LUNBO_PlaceHolder,LUNBO_PlaceHolder];
    }
    
    return _cycleScrollView;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSMutableArray *)adModels{
    if (!_adModels) {
        _adModels = [NSMutableArray array];
    }
    return _adModels;
}

- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 170, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 49 - 150);
        
    }
    return _nodataV;
}

@end
