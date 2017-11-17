//
//  GLMine_Wallet_Exchange_InReviewController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Wallet_Exchange_InReviewController.h"

#import "GLMine_WalletDetailCell.h"
#import "GLMine_Wallet_ExchangeModel.h"

@interface GLMine_Wallet_Exchange_InReviewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLMine_Wallet_Exchange_InReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    dict[@"back_status"] = @"2";//兑换状态0审核失败 1审核成功 2未审核
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kBACK_LIST_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            for (NSDictionary *dic in responseObject[@"data"] ) {
                
                GLMine_Wallet_ExchangeModel *model = [GLMine_Wallet_ExchangeModel mj_objectWithKeyValues:dic];
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
    cell.model = self.models[indexPath.row];
    cell.reasonLabel.hidden = YES;
    cell.actuallyGetLabel.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
//
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
//    imageV.backgroundColor = [UIColor redColor];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 10, imageV.y, kSCREEN_WIDTH - 50, 20)];
//    label.text = @"2017.02";
//    label.font = [UIFont systemFontOfSize:17];
//    label.textColor = [UIColor blackColor];
//
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(label.x, view.height - 1, kSCREEN_WIDTH - 50, 1)];
//    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
//    topView.backgroundColor = [UIColor whiteColor];
//    UIView *topView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kSCREEN_WIDTH, 5)];
//    topView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
//
//    if (section != 0) {
//        view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 50);
//        [view addSubview:topView];
//        [view addSubview:topView2];
//    }
//
//    [view addSubview:imageV];
//    [view addSubview:label];
//    [view addSubview:lineView];
//
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(section == 0){
//
//        return 40;
//    }else{
//        return 50;
//    }
//}
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
