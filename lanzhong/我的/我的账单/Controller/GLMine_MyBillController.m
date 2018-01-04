//
//  GLMine_MyBillController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/3.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyBillController.h"
#import "GLMine_BillModel.h"
#import "GLMine_BillCell.h"
#import "GLMine_BillCollectionCell.h"

@interface GLMine_MyBillController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UIView *maskView;
@property (nonatomic, strong)UIView *filterView;
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)NSMutableArray *filterModels;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@property (nonatomic, strong)UIButton *filterBtn;
@property (nonatomic, assign)NSInteger type;//筛选类型

@end

@implementation GLMine_MyBillController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_BillCell" bundle:nil] forCellReuseIdentifier:@"GLMine_BillCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLMine_BillCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GLMine_BillCollectionCell"];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];
        
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
    
    self.page = 1;
    self.filterBtn.selected = NO;
    [self postRequest:YES];

    self.type = 0;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

/**
 设置导航栏 title以及右键
 */
- (void)setNav{
    
    self.navigationItem.title = @"我的账单";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//左对齐
    [button setImage:[UIImage imageNamed:@"downarr"] forState:UIControlStateNormal];
    
    GLMine_Bill_FilterModel *model = self.filterModels[0];
    [button setTitle:model.name forState:UIControlStateNormal];
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
    
    [button horizontalCenterTitleAndImage:5];
    
    self.filterBtn = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.filterBtn];

}

#pragma mark - 筛选
/**
 筛选
 */
-(void)filter{

    __weak __typeof(self) weakSelf = self;
    self.filterBtn.selected = !self.filterBtn.selected;
    
    if (self.filterBtn.isSelected) {
        [self.view addSubview:self.maskView];
        [self.view addSubview:self.filterView];
        weakSelf.maskView.alpha = 1;
        weakSelf.filterBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        
        [UIView animateWithDuration:0.3 animations:^{
            if(self.filterModels.count > 0){
                
                weakSelf.filterView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, ((self.filterModels.count - 1)/4 + 1) * 50 + 20);
                weakSelf.collectionView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, ((self.filterModels.count - 1)/4 + 1) * 50 + 20);
            }else{
                
                weakSelf.filterView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 50);
                weakSelf.collectionView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 50);
            }

        }];
        
    }else{
    
        weakSelf.filterBtn.imageView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.filterView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0);
            weakSelf.collectionView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0);

            weakSelf.maskView.alpha = 0;
            
        }completion:^(BOOL finished) {

            [weakSelf.filterView removeFromSuperview];
            [weakSelf.maskView removeFromSuperview];
        }];
    }

        GLMine_Bill_FilterModel *model = self.filterModels[self.type];
        [self.filterBtn setTitle:model.name forState:UIControlStateNormal];
        [self.filterBtn horizontalCenterTitleAndImage:5];

    
}

/**
 请求数据
 
 @param isRefresh 是否是下拉刷新
 */
- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
    }else{
        self.page ++ ;
    }
    [self models];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//
//    dic[@"token"] = [UserModel defaultUser].token;
//    dic[@"uid"] = [UserModel defaultUser].uid;
//    dic[@"state"] = @"1";//项目运行状态 1待审核(审核中) 2审核失败 3审核成功（审核成功认定为筹款中）4筹款停止 5筹款失败 6筹款完成 7项目进行 8项目暂停 9项目失败 10项目完成
//    dic[@"page"] = @(self.page);
//
//    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//    [NetworkManager requestPOSTWithURLStr:kMINE_MYPROJECT_URL paramDic:dic finish:^(id responseObject) {
//
//        [_loadV removeloadview];
//        [self endRefresh];
//
//        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
//            if([responseObject[@"data"] count] != 0){
//
//                //                for (NSDictionary *dic in responseObject[@"data"]) {
//                //                    GLMine_IntegralModel * model = [GLMine_IntegralModel mj_objectWithKeyValues:dic];
//                //
//                //                    [self.models addObject:model];
//                //                }
//            }
//        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){
//
//            if (self.models.count != 0) {
//
//                [MBProgressHUD showError:responseObject[@"message"]];
//            }
//
//        }else{
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//
//
//        [self.tableView reloadData];
//
//    } enError:^(NSError *error) {
//        [_loadV removeloadview];
//        [self endRefresh];
//        [self.tableView reloadData];
//    }];
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.models.count== 0) {
        
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_BillCell"];
    
    GLMine_BillModel *model = self.models[indexPath.row];
    
    cell.model = model;
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.filterModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_BillCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLMine_BillCollectionCell" forIndexPath:indexPath];
    
    cell.model = self.filterModels[indexPath.row];
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kSCREEN_WIDTH - 20)/4, 50);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i = 0 ;i < self.filterModels.count ; i ++) {
        
        GLMine_Bill_FilterModel *model = self.filterModels[i];
        if(i == indexPath.row){
            
            model.isSelect = YES;
            self.type = indexPath.row;
        }else{
            
            model.isSelect = NO;
        }
        
    }
    
    
    [self.collectionView reloadData];
    [self filter];
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
        for (int i = 0; i < 8; i ++) {
            GLMine_BillModel *model = [[GLMine_BillModel alloc] init];
            model.name = [NSString stringWithFormat:@"项目%d",i];
            model.date = [NSString stringWithFormat:@"2017-09-0%d",i];
            model.income = [NSString stringWithFormat:@"20%d",i];
            
            [_models addObject:model];
        }
    }
    return _models;
}

- (NSMutableArray *)filterModels{
    if (!_filterModels) {
        _filterModels = [NSMutableArray array];
        
        NSArray *arr = @[@"商品购买",@"项目赔付",@"项目收益",@"项目转让",@"筹款赔付",@"兑换",@"充值"];
        for (int i = 0; i < 7; i ++) {
            GLMine_Bill_FilterModel *model = [[GLMine_Bill_FilterModel alloc] init];
            model.name = arr[i];
            if (i == 0) {
                model.isSelect = YES;
            }else{
                model.isSelect = NO;
            }
            
            [_filterModels addObject:model];
        }
    }
    return _filterModels;
}

- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        
    }
    return _nodataV;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        _maskView.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filter)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)filterView{
    if (!_filterView) {
        _filterView = [[UIView alloc] init];
        _filterView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0);
        _filterView.backgroundColor = [UIColor redColor];
        [_filterView addSubview:self.collectionView];
    }
    return _filterView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}

@end
