//
//  GLMine_PendingEvaluateController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PendingEvaluateController.h"
#import "GLMine_PendingEvaluateCell.h"
#import "GLMine_EvaluatingController.h"//去评论界面
#import "GLMine_EvaluateController.h"


@interface GLMine_PendingEvaluateController ()<GLMine_PendingEvaluateCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;

@end

@implementation GLMine_PendingEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_PendingEvaluateCell" bundle:nil] forCellReuseIdentifier:@"GLMine_PendingEvaluateCell"];
    
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
    dic[@"type"] = @"0";//评论状态 1已评论 0未评论
    dic[@"page"] = @(self.page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kGOODS_COMMENT_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMine_EvaluateModel * model = [GLMine_EvaluateModel mj_objectWithKeyValues:dic];
                    
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

#pragma mark - GLMine_PendingEvaluateCellDelegate
- (void)goToEvaluate:(NSInteger)index{
    
    GLMine_EvaluateController *vc = [self viewController];
    vc.hidesBottomBarWhenPushed = YES;
    
    GLMine_EvaluatingController *evaluateVC = [[GLMine_EvaluatingController alloc] init];
    evaluateVC.model = self.models[index];
    __weak __typeof(self) weakSelf = self;
    evaluateVC.block = ^(){
        [weakSelf postRequest:YES];
    };
    
    [vc.navigationController pushViewController:evaluateVC animated:YES];
}

- (GLMine_EvaluateController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (GLMine_EvaluateController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_PendingEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_PendingEvaluateCell"];
    cell.commentView.hidden  = YES;
    cell.index = indexPath.row;
    cell.model = self.models[indexPath.row];
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}




@end
