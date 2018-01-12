//
//  GLMine_PendingPayOrderController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PendingPayOrderController.h"
#import "LBMyOrderListTableViewCell.h"

#import "LBMyOrdersHeaderView.h"
#import "LBMyOrdersModel.h"
#import "GLMine_RicePayController.h"
#import "GLMine_MyOrderController.h"

@interface GLMine_PendingPayOrderController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@property (assign, nonatomic)NSInteger deleteRow;//删除下标

@end

@implementation GLMine_PendingPayOrderController

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
    dic[@"type"] = @"1";
    
    [NetworkManager requestPOSTWithURLStr:kMYORDER_LIST_URL paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                LBMyOrdersModel *ordersMdel = [LBMyOrdersModel mj_objectWithKeyValues:dic];
                ordersMdel.isExpanded = NO;
                [self.dataarr addObject:ordersMdel];
            }
            
            [self.tableView reloadData];
            
            
        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){
            
            if (self.dataarr.count != 0) {
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
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
/**
 *  获取父视图的控制器
 *
 *  @return 父视图的控制器
 */
- (GLMine_MyOrderController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[GLMine_MyOrderController class]]) {
            return (GLMine_MyOrderController *)nextResponder;
        }
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    __weak __typeof(self) weakSelf = self;
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
    [headerview.payBt setTitle:@"去支付" forState:UIControlStateNormal];
    
    headerview.totalPriceLabel.hidden = NO;
    headerview.totalPriceLabel.text = [NSString stringWithFormat:@"需付款:%@",sectionModel.pay_money];
    headerview.totalPriceLabel.textAlignment = NSTextAlignmentRight;
    headerview.totalPriceLabel.textColor = [UIColor lightGrayColor];
    
    headerview.DeleteBt.hidden = NO;
    [headerview.DeleteBt setTitle:@"取消订单" forState:UIControlStateNormal];
    
    //支付
    headerview.returnPayBt = ^(NSInteger index){

        LBMyOrdersModel *model = weakSelf.dataarr[index];
        
        [weakSelf viewController].hidesBottomBarWhenPushed = YES;
        
        GLMine_RicePayController *payVC = [[GLMine_RicePayController alloc] init];
        payVC.order_id = model.order_id;
        payVC.order_sn = model.order_num;
        payVC.orderPrice = model.pay_money;
        payVC.orders_Price = model.pay_money;
        payVC.signIndex = 1;
        
        payVC.block = ^(){
            [self.dataarr removeObjectAtIndex:index];
            [tableView reloadData];
        };
        
        [[weakSelf viewController].navigationController pushViewController:payVC animated:YES];
    };
    
    //取消订单
    headerview.returnDeleteBt = ^(NSInteger index){

        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要取消该订单吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            LBMyOrdersModel *model = weakSelf.dataarr[section];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"token"] = [UserModel defaultUser].token;
            dic[@"uid"] = [UserModel defaultUser].uid;
            dic[@"order_id"] = model.order_id;
            
            _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
            [NetworkManager requestPOSTWithURLStr:kORDER_CANCEL_URL paramDic:dic finish:^(id responseObject) {
                [_loadV removeloadview];
                
                if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                    
                    [self.dataarr removeObjectAtIndex:section];
                    
                    [tableView reloadData];
                }
                
                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            } enError:^(NSError *error) {
                [_loadV removeloadview];
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
        }];
        
        [alertVC addAction:cancel];
        [alertVC addAction:ok];
        [weakSelf presentViewController:alertVC animated:YES completion:nil];

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
