//
//  GLMall_LogisticsController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_LogisticsController.h"
#import "GLBusiness_FundTrendCell.h"
#import "GLMall_LogisticsModel.h"

@interface GLMall_LogisticsController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)GLMall_LogisticsModel *model;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation GLMall_LogisticsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"物流跟踪";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_FundTrendCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_FundTrendCell"];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];
        
    }];

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    self.page = 1;
    [self postRequest:YES];
    
}

- (void)postRequest:(BOOL)isRefresh{
    
    self.model = nil;
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    
    NSDictionary  *dic =  @{@"type":@"auto",@"number":self.order_id};
    
    [manager.requestSerializer setValue:@"APPCODE f92896288a5949088c46c166af190b2c" forHTTPHeaderField:@"Authorization"];
    
    [manager GET:@"http://jisukdcx.market.alicloudapi.com/express/query" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [_loadV removeloadview];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.model = [GLMall_LogisticsModel mj_objectWithKeyValues:dic[@"result"]];
        self.numberLabel.text = [NSString stringWithFormat:@"    订单编号:%@",self.model.number];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_loadV removeloadview];
        [self.tableView reloadData];
       
        [SVProgressHUD showErrorWithStatus:@"订单单号异常,联系平台"];
    }];
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBusiness_FundTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_FundTrendCell"];
    
    if (indexPath.row == 0) {
        
        cell.topImageV.hidden = YES;
        cell.bottomImageV.hidden = NO;
        
    }else if(indexPath.row == self.model.list.count - 1){
        
        cell.topImageV.hidden = NO;
        cell.bottomImageV.hidden = YES;
        
    }else{
        
        cell.topImageV.hidden = NO;
        cell.bottomImageV.hidden = NO;
    }
    
    cell.selectionStyle = 0;
    cell.logisticsmodel = self.model.list[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 33;
    return tableView.rowHeight;
}

@end
