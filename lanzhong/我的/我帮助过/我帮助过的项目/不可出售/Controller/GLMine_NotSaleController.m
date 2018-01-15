//
//  GLMine_NotSaleController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/10.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_NotSaleController.h"
#import "GLMine_NotSaleCell.h"
#import "GLMine_NotSaleModel.h"
#import "GLMine_ParticpateModel.h"
#import "GLBusiness_DetailController.h"

@interface GLMine_NotSaleController ()<UITableViewDataSource,UITableViewDelegate,GLMine_NotSaleCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLMine_NotSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_NotSaleCell" bundle:nil] forCellReuseIdentifier:@"GLMine_NotSaleCell"];
    
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
    }else{
        _page ++;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"type"] = @"1";
    dict[@"page"] = [NSString stringWithFormat:@"%ld",(long)_page];

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kMine_HelpList paramDic:dict finish:^(id responseObject) {

        [_loadV removeloadview];
        [self endRefresh];

        if (status) {
            [self.models removeAllObjects];
        }

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {

            for (NSDictionary *dic in responseObject[@"data"] ) {
                GLMine_NotSaleModel *model = [GLMine_NotSaleModel mj_objectWithKeyValues:dic];

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

#pragma mark - GLMine_NotSaleCellDelegate  资金明细
- (void)moneyDetail:(NSInteger)index{
    NSLog(@"资金明细");
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_NotSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_NotSaleCell" forIndexPath:indexPath];
    
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_ParticpateModel *model = self.models[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_DetailController *detailVC = [[GLBusiness_DetailController alloc] init];
    detailVC.item_id = model.item_id;
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
