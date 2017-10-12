//
//  GLBusiness_Detail_heartCommentController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_Detail_heartCommentController.h"
#import "GLBusiness_DetailCommentCell.h"
#import "GLBusiness_DetailModel.h"

@interface GLBusiness_Detail_heartCommentController ()<UITableViewDelegate,UITableViewDataSource,GLBusiness_DetailCommentCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;

@property (nonatomic, copy)NSString *replyName;

@end

@implementation GLBusiness_Detail_heartCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"更多评论";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_DetailCommentCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_DetailCommentCell"];
    
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
    
    self.item_id = @"36";
    
    dic[@"item_id"] = self.item_id;
    dic[@"page"] = @(self.page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCIRCLE_MORECOMMENT_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dic in responseObject[@"data"][@"invest_list"]) {
                    GLBusiness_CommentModel * model = [GLBusiness_CommentModel mj_objectWithKeyValues:dic];
                    model.linkman = responseObject[@"data"][@"linkman"];
                    [self.models addObject:model];
                }
                
//                self.replyName = responseObject[@"data"][@"linkman"];
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

#pragma mark - GLBusiness_DetailCommentCellDelegate
- (void)personInfo{
    NSLog(@"个人信息");
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLBusiness_DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_DetailCommentCell"];
    cell.model = self.models[indexPath.row];
//    cell.replyName = self.replyName;
    cell.selectionStyle = 0;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    
    
    return tableView.rowHeight;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
