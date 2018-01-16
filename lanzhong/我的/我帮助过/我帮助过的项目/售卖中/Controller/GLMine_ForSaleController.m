//
//  GLMine_ForSaleController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/10.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ForSaleController.h"
#import "GLMine_ParticipateCell.h"
#import "GLMine_ParticpateModel.h"
#import "GLMine_SalePublishController.h"
#import "GLBusiness_DetailForSaleController.h"

@interface GLMine_ForSaleController ()<GLMine_ParticipateCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLMine_ForSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ParticipateCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ParticipateCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf updateData:YES];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateData:NO];
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    [self updateData:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"Sale_PublishNotification" object:nil];
    
}

/**
 刷新数据
 */
- (void)refresh{
    [self updateData:YES];
}

/**
 结束刷新动画
 */
- (void)endRefresh {
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
}

/**
 更新数据
 
 @param status 是否是下拉刷新状态
 */
- (void)updateData:(BOOL)status {
    
    if (status) {
        _page = 1;
        [self.models removeAllObjects];
        
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"type"] = @"2";
    dict[@"page"] = [NSString stringWithFormat:@"%ld",(long)_page];
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kMine_HelpList paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            for (NSDictionary *dic in responseObject[@"data"] ) {
                
                GLMine_ParticpateModel *model = [GLMine_ParticpateModel mj_objectWithKeyValues:dic];
                model.type = @"2";
                [self.models addObject:model];
            }
            
        }else if ([responseObject[@"code"] integerValue] == PAGE_ERROR_CODE){
            if (self.models.count != 0) {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - GLMine_ParticipateCellDelegate 操作
- (void)sell:(NSInteger)index{
    GLMine_ParticpateModel *model = self.models[index];
    self.hidesBottomBarWhenPushed = YES;

    GLMine_SalePublishController *sellVC = [[GLMine_SalePublishController alloc] init];
    sellVC.model = model;
    sellVC.type = 2;
    [self.navigationController pushViewController:sellVC animated:YES];

}

#pragma  UITableviewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.models.count== 0) {
        
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_ParticipateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ParticipateCell"];
    cell.model = self.models[indexPath.row];
    
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_ParticpateModel *model = self.models[indexPath.row];
    GLBusiness_DetailForSaleController *detailVC = [[GLBusiness_DetailForSaleController alloc] init];
    detailVC.attorn_id = model.invest_id;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - 懒加载

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}

- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 40);
        
    }
    return _nodataV;
}

@end
