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

@interface GLPublish_ProjectInProgressController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;

@end

@implementation GLPublish_ProjectInProgressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLPublish_ProjectCell" bundle:nil] forCellReuseIdentifier:@"GLPublish_ProjectCell"];
    
    
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLPublish_ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLPublish_ProjectCell"];
    cell.model = self.models[indexPath.row];
    

    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}


@end
