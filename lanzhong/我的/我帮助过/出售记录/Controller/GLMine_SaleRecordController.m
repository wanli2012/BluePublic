//
//  GLMine_SaleRecordController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/5.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SaleRecordController.h"
#import "GLMine_SaleRecordCell.h"
#import "QQPopMenuView.h"

@interface GLMine_SaleRecordController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@property (nonatomic, strong)UIButton *filterBtn;
@property (nonatomic, assign)NSInteger type;//筛选类型

@property (nonatomic, strong)NSArray *modelsNew;

@end

@implementation GLMine_SaleRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_SaleRecordCell" bundle:nil] forCellReuseIdentifier:@"GLMine_SaleRecordCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"QQPopMenuNotification" object:nil];
    
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
    self.type = 2;
    self.filterBtn.selected = NO;
    [self postRequest:YES];
    
    
//    [self analyseHDCData];
    
}

/**
 设置导航栏
 */
- (void)setNav{
    self.navigationItem.title = @"出售记录";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//左对齐
    [button setImage:[UIImage imageNamed:@"downarr"] forState:UIControlStateNormal];
    [button setTitle:@"出售" forState:UIControlStateNormal];
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
- (void)filter {
    
    __weak __typeof(self) weakSelf = self;
    self.filterBtn.selected = !self.filterBtn.selected;
    
    if (self.filterBtn.isSelected) {
        weakSelf.filterBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        weakSelf.filterBtn.imageView.transform = CGAffineTransformIdentity;
    }
    
    NSArray *arr = @[
//                     @{@"title":@"全部",@"imageName":@""},
                     @{@"title":@"出售",@"imageName":@""},
                     @{@"title":@"收购",@"imageName":@""}];
    
    QQPopMenuView *popview = [[QQPopMenuView alloc] initWithItems:arr width:130 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width - 30, 64 + 5) action:^(NSInteger index) {
        
        weakSelf.type = index + 2;
        [weakSelf.filterBtn setTitle:arr[index][@"title"] forState:UIControlStateNormal];
        [weakSelf.filterBtn horizontalCenterTitleAndImage:5];
        [weakSelf postRequest:YES];
        
    }];
    
    [popview show];
}

/**
 筛选列表消失时
 */
- (void)dismiss{
    self.filterBtn.selected = !self.filterBtn.selected;
    
    if (self.filterBtn.isSelected) {
        self.filterBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        self.filterBtn.imageView.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - 请求数据
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
    dic[@"type"] = @(self.type);//查询类型 1全部 2出售 3收购
    dic[@"page"] = @(self.page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kBuy_History_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if (isRefresh) {
            [self.models removeAllObjects];
        }
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMine_SaleRecordModel * model = [GLMine_SaleRecordModel mj_objectWithKeyValues:dic];
                    
                    model.type = self.type;
                    
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
        
        [self analyseHDCData];//数据重新排序
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
    }];
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
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
                GLMine_SaleRecordModel *model = [preModelArr objectAtIndex:0];
                
                NSString *modelTime = [formattime formateTimeOfDate4:model.time];
                //取出当前元素,根据date比较,如果相同则添加到同一个组中;如果不相同,说明不是同一个组的
                GLMine_SaleRecordModel *currentModel = [sortedArr objectAtIndex:i];
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

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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
    
    GLMine_SaleRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_SaleRecordCell"];
    NSArray *arr = self.modelsNew[indexPath.section];
    GLMine_SaleRecordModel *model = arr[indexPath.row];
    cell.model = model;
    cell.selectionStyle = 0;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV;
    GLMine_SaleRecordModel *model = self.modelsNew[section][0];
    
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

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        //
        //        for (int i = 0; i < 9; i ++) {
        //
        //            GLMine_SaleRecordModel *model = [[GLMine_SaleRecordModel alloc] init];
        //            model.title = [NSString stringWithFormat:@"项目%d",i];
        //            model.person = [NSString stringWithFormat:@"磊哥%d",i];
        //            model.income = [NSString stringWithFormat:@"203%i",i];
        //            model.date = [NSString stringWithFormat:@"2017-09-%d",i];
        //            [_models addObject:model];
        //        }
        //
        //        for (int i = 0; i < 9; i ++) {
        //            GLMine_SaleRecordModel *model = [[GLMine_SaleRecordModel alloc] init];
        //            model.title = [NSString stringWithFormat:@"项目%d",i];
        //            model.person = [NSString stringWithFormat:@"磊哥%d",i];
        //            model.income = [NSString stringWithFormat:@"203%i",i];
        //            model.date = [NSString stringWithFormat:@"2017-10-%d",i];
        //            [_models addObject:model];
        //        }
        //
        //        for (int i = 0; i < 9; i ++) {
        //
        //            GLMine_SaleRecordModel *model = [[GLMine_SaleRecordModel alloc] init];
        //            model.title = [NSString stringWithFormat:@"项目%d",i];
        //            model.person = [NSString stringWithFormat:@"磊哥%d",i];
        //            model.income = [NSString stringWithFormat:@"203%i",i];
        //            model.date = [NSString stringWithFormat:@"2017-11-%d",i];
        //            [_models addObject:model];
        //
        //        }
    }
    return _models;
}

- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        
    }
    return _nodataV;
}

- (NSArray *)modelsNew{
    if (!_modelsNew) {
        _modelsNew = [[NSArray alloc] init];
    }
    return _modelsNew;
}

@end
