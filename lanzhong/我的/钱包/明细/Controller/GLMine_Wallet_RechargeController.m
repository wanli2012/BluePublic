//
//  GLMine_Wallet_RechargeController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Wallet_RechargeController.h"
#import "GLMine_WalletDetailCell.h"
#import "GLMine_Wallet_RechargeModel.h"

@interface GLMine_Wallet_RechargeController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLMine_Wallet_RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"充值明细";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_WalletDetailCell" bundle:nil] forCellReuseIdentifier:@"GLMine_WalletDetailCell"];
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
}
- (void)endRefresh {
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
}
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
    dict[@"page"] = [NSString stringWithFormat:@"%ld",(long)_page];
    dict[@"back_status"] = @"1";//兑换状态0审核失败 1审核成功 2未审核
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kRECHARGE_LIST_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            for (NSDictionary *dic in responseObject[@"data"] ) {
                
                GLMine_Wallet_RechargeModel *model = [GLMine_Wallet_RechargeModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
                
            }
            
        }else{
            if (self.models.count != 0) {
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
        
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma  UITableviewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.models.count == 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.models.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_WalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_WalletDetailCell"];
    cell.rechargeModel = self.models[indexPath.row];
    cell.reasonLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
