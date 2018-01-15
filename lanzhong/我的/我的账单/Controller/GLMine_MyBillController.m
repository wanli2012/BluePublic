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
@property (nonatomic, strong)NSArray *modelsNew;

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
    self.type = 1;
    self.filterBtn.selected = NO;
    
    [self postRequest:YES];
    
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

        GLMine_Bill_FilterModel *model = self.filterModels[self.type - 1];
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

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"type"] = @(self.type);//类型 1商品购买 2项目赔付 3项目收益 4项目转让 5.兑换 6.充值
    dic[@"page"] = @(self.page);

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kMine_BillList_URL paramDic:dic finish:^(id responseObject) {

        [_loadV removeloadview];
        [self endRefresh];
        
        if (isRefresh) {
            [self.models removeAllObjects];
        }

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){

                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMine_BillModel * model = [GLMine_BillModel mj_objectWithKeyValues:dic];
                    model.type = [NSString stringWithFormat:@"%zd",self.type];
                    [self.models addObject:model];
                }
            }
        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){

            if (self.models.count != 0) {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }

        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }

        [self analyseHDCData];
        [self.tableView reloadData];

    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
         [self analyseHDCData];
        [self.tableView reloadData];
    }];
}

#pragma mark - 判断分组数，并且按上传时间和检查时间降序排列
-(void)analyseHDCData{
    
    //1.数组内部元素排序
    NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
    NSArray *sortedArr = [self.models sortedArrayUsingDescriptors:sortDesc];
    
    //2.对数组进行分组，按date,创建组数组,组数组中的每一个元素是一个数组
    NSMutableArray *groupArray = [NSMutableArray array];
    NSMutableArray *currentArray = [NSMutableArray array];
    
    if (sortedArr.count != 0) {
        
        //因为肯定有一个元素返回,先添加一个
        [currentArray addObject:sortedArr[0]];
        [groupArray addObject:currentArray];
        
        //如果不止一个,才要动态添加
        if(sortedArr.count >1){
            for (int i =1; i < sortedArr.count; i++) {
                
                // 先取出组数组中，上一个数组的第一个元素
                NSMutableArray *preModelArr = [groupArray objectAtIndex:groupArray.count - 1];
                GLMine_BillModel *model = [preModelArr objectAtIndex:0];
                
                NSString *modelTime = [formattime formateTimeOfDate4:model.time];
                //取出当前元素,根据date比较,如果相同则添加到同一个组中;如果不相同,说明不是同一个组的
                GLMine_BillModel *currentModel = [sortedArr objectAtIndex:i];
                NSString *currentModelTime = [formattime formateTimeOfDate4:currentModel.time];
                
                
                NSString *lastMonth = [modelTime substringToIndex:7];
                NSString *month = [currentModelTime substringToIndex:7];
                
                if ([month isEqualToString:lastMonth]) {
                    [currentArray addObject:currentModel];
                }else{
                    // 如果不相同,说明有新的一组,那么创建一个元素数组,并添加到组数组groupArr
                    currentArray = [NSMutableArray array];
                    [currentArray addObject:currentModel];
                    [groupArray addObject:currentArray];
                }
            }
        }
        
    }
    // 3、遍历对每一组进行排序
    
    self.modelsNew = [NSArray arrayWithArray:groupArray];
    [self.tableView reloadData];
    
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.modelsNew.count== 0) {
        
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.modelsNew.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.modelsNew[section];
    
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    GLMine_BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_BillCell"];
    
    NSArray *arr = self.modelsNew[indexPath.section];
    GLMine_BillModel *model = arr[indexPath.row];
    cell.model = model;
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV;
    GLMine_BillModel *model = self.modelsNew[section][0];
    
    CGFloat headerHeight = 50;
    
    if (headerV == nil) {
        headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
        headerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIImageView *picImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, (headerHeight - 17)/2, 17, 17)];
        picImageV.image = [UIImage imageNamed:@"nochoicecalendar"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(picImageV.frame) + 10, 0, 100, headerHeight)];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = [[formattime formateTimeOfDate4:model.time] substringToIndex:7];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight, kSCREEN_WIDTH, 1)];
        lineV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [headerV addSubview:picImageV];
        [headerV addSubview:label];
        [headerV addSubview:lineV];
    }
    return headerV;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
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
            self.type = indexPath.row + 1;
        }else{
            
            model.isSelect = NO;
        }
    }
    
    [self.collectionView reloadData];
    [self filter];
    [self postRequest:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSMutableArray *)filterModels{
    if (!_filterModels) {
        _filterModels = [NSMutableArray array];
        
        NSArray *arr = @[@"商品购买",@"项目赔付",@"项目收益",@"项目转让",@"兑换",@"充值"];
        for (int i = 0; i < arr.count; i ++) {
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
