//
//  GLPay_CompletedController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPay_CompletedController.h"
#import "GLPublish_ReviewCell.h"
#import "GLPay_CompletedModel.h"
#import "GLBusiness_DetailController.h"

@interface GLPay_CompletedController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLPay_CompletedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkBtn.layer.cornerRadius = 5.f;
    self.navigationItem.title = @"支付成功";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLPublish_ReviewCell" bundle:nil] forCellReuseIdentifier:@"GLPublish_ReviewCell"];
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];
    }];

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    [self postRequest:YES];
}

- (void)postRequest:(BOOL)isRefresh{

    [self.models removeAllObjects];
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kSUPPORT_SUCCESS_URL paramDic:@{} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            for (NSDictionary * dic in responseObject[@"data"]) {
                
                GLPay_CompletedModel *model = [GLPay_CompletedModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
            }
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLPublish_ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLPublish_ReviewCell"];
    cell.payModel = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

//查看项目
- (IBAction)checkOut:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_DetailController *detailVC = [[GLBusiness_DetailController alloc] init];
    detailVC.item_id = self.item_id;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
@end
