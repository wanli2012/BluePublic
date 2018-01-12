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
#import "GLHomePageNoticeView.h"

@interface GLMine_CompletedOrderController ()<LBMyOrderListTableViewCellDelegete>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@property (assign, nonatomic)NSInteger deleteRow;//删除下标

@property (nonatomic, strong)UIView  *maskV;//遮罩
@property (nonatomic, strong)GLHomePageNoticeView *noticeView;//

@property (nonatomic, assign)NSInteger returnGoodsIndex;
@property (nonatomic, assign)NSInteger returnGoodsSectionIndex;

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
            
        }else if ([responseObject[@"code"] integerValue] == PAGE_ERROR_CODE){
            
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

#pragma mark - LBMyOrderListTableViewCellDelegete
- (void)applyForReturn:(NSInteger)index section:(NSInteger)section{
    
    [self initInterDataSorceinfomessage];//弹出退货须知
    
    self.returnGoodsIndex = index;
    self.returnGoodsSectionIndex = section;
    
}

- (void)sureReturnGoods{
    [self dismiss];
    
    LBMyOrdersModel *sectionModel = self.dataarr[self.returnGoodsSectionIndex];
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"退货理由" message:@"你确定要申请退款吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入退货原因(50字内)";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(alertVC.textFields.lastObject.text.length == 0){
            [SVProgressHUD showErrorWithStatus:@"请输入退货原因"];
            return ;
        }
        
        if(alertVC.textFields.lastObject.text.length >100){
            [SVProgressHUD showErrorWithStatus:@"退货原因需要50字内"];
            return ;
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"token"] = [UserModel defaultUser].token;
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"goods_id"] = sectionModel.order_goods[self.returnGoodsIndex].goods_id;
        dic[@"order_id"] = sectionModel.order_id;
        dic[@"og_id"] = sectionModel.order_goods[self.returnGoodsIndex].og_id;
        dic[@"refunds_reason"] = alertVC.textFields.lastObject.text;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
        [NetworkManager requestPOSTWithURLStr:kAPPLY_RETURN_URL paramDic:dic finish:^(id responseObject) {
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
                sectionModel.order_goods[self.returnGoodsIndex].refunds_state = @"1";
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:self.returnGoodsIndex];
                [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [weakSelf presentViewController:alertVC animated:YES completion:nil];
    

}
#pragma mark ----公告
-(void)initInterDataSorceinfomessage{
    
    CGFloat contentViewH = kSCREEN_HEIGHT / 2;
    CGFloat contentViewW = kSCREEN_WIDTH - 40;
    CGFloat contentViewX = 20;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskV];
    [window addSubview:self.noticeView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:Return_Goods_URL]];
    [self.noticeView.webView loadRequest:request];
    self.noticeView.frame = CGRectMake(contentViewX, (kSCREEN_HEIGHT - contentViewH)/2, contentViewW, contentViewH);
    //缩放
    self.noticeView.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
    self.noticeView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.noticeView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.noticeView.alpha = 1;
    }];
    
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.noticeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.noticeView.alpha = 0;
        self.maskV.alpha = 0;
    } completion:^(BOOL finished) {
        self.noticeView.center = CGPointMake(kSCREEN_WIDTH - 30,30);
        [self.noticeView removeFromSuperview];
        [self.maskV removeFromSuperview];
        self.noticeView = nil;
        self.maskV = nil;

    }];
}

//#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//}


#pragma mark - UITableViewDelegate
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
    cell.section = indexPath.section;
    cell.delegete = self;
    LBMyOrdersModel *model= (LBMyOrdersModel*)self.dataarr[indexPath.section];
    cell.applyReturnBtn.hidden = NO;
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
    
    __weak __typeof(self) weakSelf = self;

    sectionModel.section = section;
    headerview.sectionModel = sectionModel;
    headerview.expandCallback = ^(BOOL isExpanded) {
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };

    headerview.DeleteBt.hidden = NO;

    [headerview.DeleteBt setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
    headerview.DeleteBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

    headerview.returnDeleteBt = ^(NSInteger index){

        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要删除该订单吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"token"] = [UserModel defaultUser].token;
            dic[@"uid"] = [UserModel defaultUser].uid;
            dic[@"order_id"] = sectionModel.order_id;
            
            _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
            [NetworkManager requestPOSTWithURLStr:kDEL_ORDER_URL paramDic:dic finish:^(id responseObject) {
                [_loadV removeloadview];
                
                if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                    
                    [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
                    
                    if(weakSelf.dataarr.count <= 0){
                        [weakSelf.tableView reloadData];
                        return ;
                    }
                    
                    [weakSelf.dataarr removeObjectAtIndex:index];
                    [tableView reloadData];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                }
            } enError:^(NSError *error) {
                [_loadV removeloadview];
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
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
- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _maskV.backgroundColor = [UIColor blackColor];
        _maskV.alpha = 0.3;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismiss)];
        [_maskV addGestureRecognizer:tap];
        
    }
    return _maskV;
}

- (GLHomePageNoticeView *)noticeView{
    if (!_noticeView) {
        
        _noticeView = [[NSBundle mainBundle] loadNibNamed:@"GLHomePageNoticeView" owner:nil options:nil].lastObject;
        
        _noticeView.contentViewW.constant = kSCREEN_WIDTH - 40;
        _noticeView.contentViewH.constant = kSCREEN_HEIGHT / 2 - 40;
        _noticeView.layer.cornerRadius = 5;
        _noticeView.layer.masksToBounds = YES;
        [_noticeView.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_noticeView.sureBtn addTarget:self action:@selector(sureReturnGoods) forControlEvents:UIControlEventTouchUpInside];
        
        _noticeView.titleLabel.text = @"兑换须知";
        //设置webView
        _noticeView.webView.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH - 40, 0);
        _noticeView.webView.scalesPageToFit = YES;
        _noticeView.webView.autoresizesSubviews = NO;
        _noticeView.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        _noticeView.webView.scrollView.bounces = NO;
        
        _noticeView.webView.backgroundColor = [UIColor clearColor];
        _noticeView.webView.opaque = NO;
        
    }
    return _noticeView;
}
@end
