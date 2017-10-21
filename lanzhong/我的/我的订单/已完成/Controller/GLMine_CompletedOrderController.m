//
//  GLMine_CompletedOrderController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CompletedOrderController.h"
#import "LBMyOrderListTableViewCell.h"

#import "LBMyOrdersHeaderView.h"
#import "LBMyOrdersModel.h"

@interface GLMine_CompletedOrderController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@property (assign, nonatomic)NSInteger deleteRow;//删除下标

@end

@implementation GLMine_CompletedOrderController
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
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    
    //type:订单状态(0订单异常1 已下单,未付款2 已付款,待发货3 已发货,待验收4 已验收,订单完成5 交易失败6取消订单
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"page"] = @(self.page);
    dic[@"type"] = @"4";
    
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
            
            [self.tableView reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            if (self.dataarr.count != 0) {
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
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
    
    return 70;
    
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

    headerview.DeleteBt.hidden = NO;

    [headerview.DeleteBt setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
    headerview.DeleteBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    headerview.returnDeleteBt = ^(NSInteger index){
        
        NSLog(@"删除%zd",index);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"token"] = [UserModel defaultUser].token;
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"order_id"] = sectionModel.order_id;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
        [NetworkManager requestPOSTWithURLStr:kDEL_ORDER_URL paramDic:dic finish:^(id responseObject) {
            [_loadV removeloadview];

            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {

                [MBProgressHUD showError:responseObject[@"message"]];
                
                if(self.dataarr.count <= 0){
                    [self.tableView reloadData];
                    return ;
                }
                
                [self.dataarr removeObjectAtIndex:index];
                [tableView reloadData];
                
//                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
//                [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
            
        }];

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
