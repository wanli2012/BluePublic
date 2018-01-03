//
//  GLTrainListController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/12/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLTrainListController.h"
#import "GLTrainListCell.h"
#import "GLTrainListModel.h"
#import "GLTrainDetailController.h"
#import "GLTrain_SignUpController.h"

@interface GLTrainListController ()<UITableViewDelegate,UITableViewDataSource,GLTrainListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLTrainListController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"培训";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLTrainListCell" bundle:nil] forCellReuseIdentifier:@"GLTrainListCell"];
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
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
        [self.models removeAllObjects];
    }else{
        self.page ++ ;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"page"] = @(self.page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kTrain_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                if (isRefresh) {
                    [self.models removeAllObjects];
                }
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLTrainListModel * model = [GLTrainListModel mj_objectWithKeyValues:dic];

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

#pragma mark - 报名
- (void)signUp:(NSInteger)index{
    
    GLTrainListModel *model = self.models[index];
    self.hidesBottomBarWhenPushed = YES;
    GLTrain_SignUpController *signVC = [[GLTrain_SignUpController alloc] init];
    signVC.train_id = model.train_id;
    [self.navigationController pushViewController:signVC animated:YES];
    
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
    
    GLTrainListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLTrainListCell"];
    
    GLTrainListModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    GLTrainListModel *model = self.models[indexPath.row];
    
    GLTrainDetailController *detailVC = [[GLTrainDetailController alloc] init];
    detailVC.train_id = model.train_id;
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
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 40 - 10);
        
    }
    return _nodataV;
}

@end
