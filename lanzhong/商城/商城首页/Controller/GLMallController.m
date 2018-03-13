//
//  GLMallController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMallController.h"
#import "GLClassifyCell.h"
#import "GLMall_DetailController.h"
#import "LBSetFillet.h"
#import "MenuScreeningView.h"
#import "GLShoppingCartController.h"
#import "GLMall_IntegralDetailController.h"


#define sizeScaleimageH  (285.0/349.0)
@interface GLMallController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectioview;
@property (nonatomic, strong) MenuScreeningView *menuScreeningView;  //条件选择器

@property (nonatomic, strong)GLMall_categoryModel *categoryModel;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;

@property (nonatomic, copy)NSString *cate_id;
@property (nonatomic, copy)NSString *order_money;
@property (nonatomic, copy)NSString *order_salenum;
@property (nonatomic, copy)NSString *goods_type;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstrait;

@end

static NSString *ID = @"GLClassifyCell";

@implementation GLMallController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    [self initializationCollection];//初始化
    [self.collectioview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self.view addSubview:self.menuScreeningView];
    
    __weak __typeof(self) weakSelf = self;
    self.menuScreeningView.block = ^(NSInteger itemIndex,NSInteger firstIndex,NSInteger index2){
        switch (itemIndex) {
            case 0:
            {
                weakSelf.cate_id = weakSelf.categoryModel.cate[firstIndex].cate_id;
                
//                NSString *cateName = weakSelf.categoryModel.cate[firstIndex].catename;
//                weakSelf.menuScreeningView.titles = @[];
                
                
            }
                break;
            case 1:
            {
                weakSelf.order_money = weakSelf.categoryModel.money[firstIndex].cate_id;
                weakSelf.order_salenum = nil;
            }
                break;
            case 2:
            {
                weakSelf.order_salenum = weakSelf.categoryModel.salenum[firstIndex].cate_id;
                weakSelf.order_money = nil;
            }
                break;
            case 3:
            {
                weakSelf.goods_type = weakSelf.categoryModel.goods_type[firstIndex].cate_id;
            }
                break;
                
            default:
                break;
        }
        
        [weakSelf postRequest:YES];
    };
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];
        [weakSelf postRequest_Category];
        
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf postRequest:NO];
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.collectioview.mj_header = header;
    self.collectioview.mj_footer = footer;
    
    self.order_money = @"1";
    self.order_salenum = @"2";
    
    [self postRequest:YES];
    [self postRequest_Category];

    if (@available(iOS 11.0, *)) {
        self.collectioview.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
        
    }
    if(kSCREEN_HEIGHT == 812){
        self.collectionViewConstrait.constant = 94;
    }else{
        self.collectionViewConstrait.constant = 70;
    }
    
}

- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
       
    }else{
        self.page ++ ;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = @(self.page);
    dic[@"cate_id"] = self.cate_id;
    
    dic[@"order_money"] = self.order_money;
    dic[@"order_salenum"] = self.order_salenum;
    dic[@"goods_type"] = self.goods_type;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kMALL_HOME_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if (isRefresh) {
            [self.models removeAllObjects];
        }
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if (![[NSString stringWithFormat:@"%@",responseObject[@"data"]] isEqualToString:@""]) {
                
                if([responseObject[@"data"] count] != 0){
                    
                    for (NSDictionary *dict in responseObject[@"data"]) {
                        GLMallModel *model = [GLMallModel mj_objectWithKeyValues:dict];
                        [self.models addObject:model];
                    }
                }
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.collectioview reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.collectioview reloadData];
    }];
}

- (void)postRequest_Category {
    
    [NetworkManager requestPOSTWithURLStr:kMALL_FITER_URL paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                self.categoryModel = [GLMall_categoryModel mj_objectWithKeyValues:responseObject[@"data"]];
                
                NSMutableArray *dataArr = [NSMutableArray array];
                NSMutableArray *arrM = [NSMutableArray array];
                NSMutableArray *arrM2 = [NSMutableArray array];
                NSMutableArray *arrM3 = [NSMutableArray array];
                NSMutableArray *arrM4 = [NSMutableArray array];
                
                for (GLmall_goods_detailsModel *cate in self.categoryModel.cate) {
                    [arrM addObject:cate.catename];
                }
                for (GLmall_goods_detailsModel *money in self.categoryModel.money) {
                    [arrM2 addObject:money.catename];
                }
                for (GLmall_goods_detailsModel *sale in self.categoryModel.salenum) {
                    [arrM3 addObject:sale.catename];
                }
                for (GLmall_goods_detailsModel *goods_type in self.categoryModel.goods_type) {
                    [arrM4 addObject:goods_type.catename];
                }
                
                [dataArr addObject:arrM];
                [dataArr addObject:arrM2];
                [dataArr addObject:arrM3];
                [dataArr addObject:arrM4];
                
                self.menuScreeningView.dataArr = dataArr;
            }
            
        }else{
            
           [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.collectioview reloadData];
        
    } enError:^(NSError *error) {
        
        [self.collectioview reloadData];
        
    }];
    
}

- (void)endRefresh {
    
    [self.collectioview.mj_header endRefreshing];
    [self.collectioview.mj_footer endRefreshing];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.layer.mask = [LBSetFillet setFilletRoundedRect:cell.bounds cornerRadii:CGSizeMake(4, 4)];
    
    cell.model = self.models[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMallModel *model = self.models[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    
    if([self.goods_type integerValue] == 2){
        GLMall_IntegralDetailController *vc =[[GLMall_IntegralDetailController alloc]init];
        vc.goods_id = model.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        GLMall_DetailController *vc =[[GLMall_DetailController alloc]init];
        vc.goods_id = model.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    self.hidesBottomBarWhenPushed = NO;
    
}

-(void)initializationCollection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kSCREEN_WIDTH - 30) /2 - 0.5,((kSCREEN_WIDTH - 30) /2 - 0.5) * sizeScaleimageH + 65);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectioview.collectionViewLayout = layout;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 懒加载

-(MenuScreeningView*)menuScreeningView{

    if (!_menuScreeningView) {
        CGFloat y = 0.0f;
        if(kSCREEN_HEIGHT == 812){
            y = 44;
        }else{
            y = 20;
        }
        
        _menuScreeningView = [[MenuScreeningView alloc] initWithFrame:CGRectMake(0, y,kSCREEN_WIDTH , 50) WithTitles:@[@"分类",@"金额",@"销量",@"商品类型"]];
         _menuScreeningView.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _menuScreeningView;
}


- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
