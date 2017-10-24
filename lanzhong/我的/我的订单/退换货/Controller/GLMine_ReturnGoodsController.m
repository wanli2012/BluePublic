//
//  GLMine_ReturnGoodsController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ReturnGoodsController.h"
#import "GLMine_ReturnGoodsCell.h"
#import "GLMine_ReturnGoodsModel.h"

@interface GLMine_ReturnGoodsController ()<GLMine_ReturnGoodsCellDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLMine_ReturnGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"退换货";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ReturnGoodsCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ReturnGoodsCell"];
    
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
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"page"] = @(self.page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kREFUNDS_LIST_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMine_ReturnGoodsModel * model = [GLMine_ReturnGoodsModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
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

#pragma mark - GLMine_ReturnGoodsCell
- (void)returnGoods:(NSInteger)index{
    
    GLMine_ReturnGoodsModel *model = self.models[index];
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"退货" message:@"请输入退货物流(快递)编号" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入退货物流(快递)编号";
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(alertVC.textFields.lastObject.text ){
            
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"token"] = [UserModel defaultUser].token;
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"refunds_id"] = model.refunds_id;
        dic[@"og_id"] = model.og_id;
        dic[@"refunds_send"] = alertVC.textFields.lastObject.text;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
        [NetworkManager requestPOSTWithURLStr:kREFUND_INFO_URL paramDic:dic finish:^(id responseObject) {
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [MBProgressHUD showError:responseObject[@"message"]];
                model.refunds_state = @"4";
                
                [self.tableView reloadData];
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        }];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [weakSelf presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
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
    
    GLMine_ReturnGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ReturnGoodsCell"];
    cell.selectionStyle = 0;
    cell.index = indexPath.row;
    cell.model = self.models[indexPath.row];
    cell.delegate = self;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    self.hidesBottomBarWhenPushed = NO;
    
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}

@end
