//
//  GLBusiness_FundTrendController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_FundTrendController.h"
#import "GLBusiness_FundTrendCell.h"
#import "GLBusiness_FundTrendModel.h"
#import "GLBusiness_AddFundTrendController.h"//添加资金动向

@interface GLBusiness_FundTrendController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLBusiness_FundTrendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资金动向";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_FundTrendCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_FundTrendCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
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
    [self postRequest:YES];
    
    if (self.signIndex == 1) {
        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 60, 44)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//左对齐
        [button setImage:[UIImage imageNamed:@"circle_add"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0 ,0, 0, 10)];
        // 让返回按钮内容继续向左边偏移10
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);
        
        button.backgroundColor = [UIColor clearColor];
        
        [button addTarget:self action:@selector(addFundTrend) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
       
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refeshData) name:@"AddFundTrendNotification" object:nil];
    
}

- (void)refeshData{
    [self postRequest:YES];
}
- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
        [self.models removeAllObjects];
    }else{
        self.page ++ ;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"item_id"] = self.item_id;
    dic[@"page"] = @(self.page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCIRCLE_FUNDTREND_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLBusiness_FundTrendModel * model = [GLBusiness_FundTrendModel mj_objectWithKeyValues:dic];
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
- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)addFundTrend {
    
    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_AddFundTrendController *addVC = [[GLBusiness_AddFundTrendController alloc] init];
    addVC.item_id = self.item_id;
    [self.navigationController pushViewController:addVC animated:YES];
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
    
    GLBusiness_FundTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_FundTrendCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    if (indexPath.row == 0) {
        
        cell.topImageV.hidden = YES;
        cell.bottomImageV.hidden = NO;
        
    }else if(indexPath.row == self.models.count-1){
        
        cell.topImageV.hidden = NO;
        cell.bottomImageV.hidden = YES;
    }else {
        cell.topImageV.hidden = NO;
        cell.bottomImageV.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
//    label.text = @"项目支出明细";
//    label.font = [UIFont systemFontOfSize:14];
//    label.textColor = [UIColor darkGrayColor];
//    
//    [view addSubview:label];
//    return view;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
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
@end
