//
//  GLHome_CasesController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_CasesController.h"
#import "GLHomeCell.h"
#import "GLHomeModel.h"
#import "GLBusiness_DetailController.h"

@interface GLHome_CasesController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLHome_CasesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"经典案例";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHomeCell" bundle:nil] forCellReuseIdentifier:@"GLHomeCell"];
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
    
    [self postRequest:YES];
    
}

- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
    }else{
        self.page ++ ;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = @(self.page);
       
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kHOME_ALL_CLASSIC_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                if (isRefresh) {
                    [self.models removeAllObjects];
                }
                
                for (NSDictionary *dict in responseObject[@"data"]) {
                    GLHome_groom_itemModel *model = [GLHome_groom_itemModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }
            }
           
        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){
            
            if (self.models.count != 0) {
                
                [MBProgressHUD showError:responseObject[@"message"]];
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
- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
    GLHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHomeCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    GLHome_groom_itemModel *model = self.models[indexPath.row];
    GLBusiness_DetailController *detailVC = [[GLBusiness_DetailController alloc] init];
    detailVC.item_id = model.item_id;
    [self.navigationController pushViewController:detailVC animated:YES];

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
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        
    }
    return _nodataV;
}
@end
