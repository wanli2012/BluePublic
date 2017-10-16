//
//  GLMine_WalletExchangeController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_WalletExchangeController.h"
#import "GLMine_WalletDetailCell.h"

@interface GLMine_WalletExchangeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *models;
@property (nonatomic,assign)NSInteger page;
@end

@implementation GLMine_WalletExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];

    //    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_WalletDetailCell" bundle:nil] forCellReuseIdentifier:@"GLMine_WalletDetailCell"];

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
        
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"page"] = [NSString stringWithFormat:@"%ld",(long)_page];
    dict[@"back_status"] = [NSString stringWithFormat:@"%ld",(long)_page];
//    
//    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//    [NetworkManager requestPOSTWithURLStr:kBACK_LIST_URL paramDic:dict finish:^(id responseObject) {
//        
//        [_loadV removeloadview];
//        [self endRefresh];
//        
//        if ([responseObject[@"code"] integerValue] == 1) {
//            
//            [self.models removeAllObjects];
//            
//            for (NSDictionary *dict in responseObject[@"data"]) {
//                
//                GLEncourageModel *model = [GLEncourageModel mj_objectWithKeyValues:dict];
//                model.timeStr = dict[@"time"];
//                
//                [_models addObject:model];
//            }
//            _beanSum = [responseObject[@"count"] floatValue];
//        }else if([responseObject[@"code"] integerValue] == 3){
//            if (_models.count != 0) {
//                
//                [MBProgressHUD showError:@"已经没有更多数据了"];
//            }else{
//                [MBProgressHUD showError:responseObject[@"message"]];
//            }
//            _beanSum = [responseObject[@"count"] floatValue];
//        }else{
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//        
//        //赋值
//        if (self.retureValue) {
//            if (_beanSum > 10000) {
//                
//                self.retureValue([NSString stringWithFormat:@"%.2f万",_beanSum/10000]);
//            }else{
//                
//                self.retureValue([NSString stringWithFormat:@"%.2f",_beanSum]);
//            }
//        }
//        _beanSum = 0;
//        
//        [self.tableView reloadData];
//        
//    } enError:^(NSError *error) {
//        //赋值
//        if (self.retureValue) {
//            self.retureValue(@"0");
//        }
//        
//        [_loadV removeloadview];
//        [self endRefresh];
//        self.nodataV.hidden = NO;
//    }];
}
-(UITableView*)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-124)];
        
    }
    return _tableView;
}

- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (self.models.count <= 0 ) {
//        self.nodataV.hidden = NO;
//    }else{
//        self.nodataV.hidden = YES;
//    }
    
    return 7;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_WalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_WalletDetailCell"];
//    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
    topView.backgroundColor = [UIColor whiteColor];
    UIView *topView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kSCREEN_WIDTH, 5)];
    topView2.backgroundColor = [UIColor groupTableViewBackgroundColor];

    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topView2.frame) + 10, 20, 20)];
    imageV.backgroundColor = [UIColor redColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 10, imageV.y, kSCREEN_WIDTH - 50, 20)];
    label.text = @"2017.02";

    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor blackColor];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(label.x, 39, kSCREEN_WIDTH - 50, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (section != 0) {
        
        view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 50);
        [view addSubview:topView];
        [view addSubview:topView2];
    }
    
    [view addSubview:imageV];
    [view addSubview:label];
    [view addSubview:lineView];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        return 40;
    }else{
        return 50;
    }
}

@end
