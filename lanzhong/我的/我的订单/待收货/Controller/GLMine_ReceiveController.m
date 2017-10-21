//
//  GLMine_ReceiveController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ReceiveController.h"
#import "LBMyOrderListTableViewCell.h"
#import "LBMyOrdersHeaderView.h"
#import "LBMyOrdersModel.h"
#import "GLMall_LogisticsController.h"//物流跟踪

@interface GLMine_ReceiveController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@property (assign, nonatomic)NSInteger deleteRow;//删除下标

@end

@implementation GLMine_ReceiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBMyOrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMyOrderListTableViewCell"];
    _page = 1;
    [self.tableView addSubview:self.nodataV];
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerrefresh];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    
    // 设置文字
    
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    [self initdatasource];
    
}

-(void)initdatasource{
    
    [self.dataarr removeAllObjects];
    //type:订单状态(0订单异常1 已下单,未付款2 已付款,待发货3 已发货,待验收4 已验收,订单完成5 交易失败6取消订单
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"page"] = @(self.page);
    dic[@"type"] = @"3";
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kMYORDER_LIST_URL paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                LBMyOrdersModel *ordersMdel=[LBMyOrdersModel mj_objectWithKeyValues:dic];
                ordersMdel.isExpanded = NO;
                [self.dataarr addObject:ordersMdel];
            }
     
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
    [self initdatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    [self initdatasource];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataarr.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    
    return self.dataarr.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    LBMyOrdersModel *model=self.dataarr[section];
    return model.isExpanded?model.order_goods.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMyOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMyOrderListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.index = indexPath.row;
    
    LBMyOrdersModel *model= (LBMyOrdersModel*)self.dataarr[indexPath.section];
    
    cell.myorderlistModel = model.order_goods[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    LBMineCenterOrderDetailViewController *vc=[[LBMineCenterOrderDetailViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 100;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LBMyOrdersModel *sectionModel = self.dataarr[section];
    
    LBMyOrdersHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBMyOrdersHeaderView"];
    
    if (!headerview) {
        headerview = [[LBMyOrdersHeaderView alloc] initWithReuseIdentifier:@"LBMyOrdersHeaderView"];
    }
    
    sectionModel.section = section;
    headerview.sectionModel = sectionModel;
    headerview.expandCallback = ^(BOOL isExpanded) {
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    headerview.payBt.hidden = NO;
    headerview.cancelBt.hidden = NO;
    [headerview.payBt setTitle:@"确认收货" forState:UIControlStateNormal];
    [headerview.cancelBt setTitle:@"查看物流" forState:UIControlStateNormal];
    
    __weak __typeof(self) weakSelf = self;
    headerview.returnPayBt = ^(NSInteger index){

        LBMyOrdersModel *model = weakSelf.dataarr[index];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"order_id"] = model.order_id;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kRECIPIENT_URL paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                
                [self.dataarr removeObjectAtIndex:section];
        
                [tableView reloadData];

            }
            [MBProgressHUD showError:responseObject[@"message"]];
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];
    };
    
    headerview.returnCancelBt = ^(NSInteger index){
      
        LBMyOrdersModel *model = weakSelf.dataarr[index];
        self.hidesBottomBarWhenPushed = YES;
        GLMall_LogisticsController *vc =[[GLMall_LogisticsController alloc]init];
        vc.order_id = model.send_num;
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    return headerview;
}

-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    return _dataarr;
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}

@end
