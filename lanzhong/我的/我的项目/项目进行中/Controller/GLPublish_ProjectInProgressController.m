//
//  GLPublish_ProjectInProgressController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_ProjectInProgressController.h"
#import "GLPublish_ProjectCell.h"
#import "GLPublish_InReViewModel.h"
#import "GLBusiness_Detail_heartCommentController.h"
#import "GLBusiness_FundTrendController.h"//资金动向列表
#import "GLMine_MyProjectController.h"

@interface GLPublish_ProjectInProgressController ()<GLPublish_ProjectCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLPublish_ProjectInProgressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLPublish_ProjectCell" bundle:nil] forCellReuseIdentifier:@"GLPublish_ProjectCell"];
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

- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
        [self.models removeAllObjects];
    }else{
        self.page ++ ;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"state"] = @"7";//项目运行状态 1待审核(审核中) 2审核失败 3审核成功（审核成功认定为筹款中）4筹款停止 5筹款失败 6筹款完成 7项目进行 8项目暂停 9项目失败 10项目完成
    dic[@"page"] = @(self.page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kMINE_MYPROJECT_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLPublish_InReViewModel * model = [GLPublish_InReViewModel mj_objectWithKeyValues:dic];
                    
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

#pragma mark - GLPublish_ProjectCellDelegate
- (void)surportList:(NSInteger)index{
    
    GLPublish_InReViewModel *model = self.models[index];
    [self viewController].hidesBottomBarWhenPushed = YES;
    GLBusiness_Detail_heartCommentController *listVC = [[GLBusiness_Detail_heartCommentController alloc] init];
    listVC.item_id = model.item_id;
    listVC.signIndex = 1;
    [[self viewController].navigationController pushViewController:listVC animated:YES];

}

- (void)fundList:(NSInteger)index{
    
    GLPublish_InReViewModel *model = self.models[index];
    [self viewController].hidesBottomBarWhenPushed = YES;
    GLBusiness_FundTrendController *fundVC = [[GLBusiness_FundTrendController alloc] init];
    fundVC.signIndex = 1;
    fundVC.item_id = model.item_id;
    [[self viewController].navigationController pushViewController:fundVC animated:YES];
}

/**
 *  获取父视图的控制器
 *
 *  @return 父视图的控制器
 */
- (GLMine_MyProjectController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[GLMine_MyProjectController class]]) {
            return (GLMine_MyProjectController *)nextResponder;
        }
    }
    return nil;
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
    
    GLPublish_ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLPublish_ProjectCell"];
    cell.model = self.models[indexPath.row];
    cell.suportListBtn.hidden = NO;

    cell.selectionStyle = 0;
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

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
