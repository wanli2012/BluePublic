//
//  GLMine_WalletCardChooseController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_WalletCardChooseController.h"
#import "GLMine_WalletCardChooseCell.h"
#import "GLMine_AddCardController.h"

@interface GLMine_WalletCardChooseController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)GLMine_WalletModel *model;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_WalletCardChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addBtn.layer.cornerRadius = 5.f;
    self.navigationItem.title = @"选择银行卡";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_WalletCardChooseCell" bundle:nil] forCellReuseIdentifier:@"GLMine_WalletCardChooseCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRequest) name:@"addCardNotification" object:nil];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest];
        
    }];
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;

    [self postRequest];
}

- (void)postRequest{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kBACK_DATA_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            [self.models removeAllObjects];
            self.model = [GLMine_WalletModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            for (Wallet_back_info *infoModel in self.model.back_info) {
                [self.models addObject:infoModel];
            }

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
    
}

- (IBAction)addCard:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLMine_AddCardController *addVC = [[GLMine_AddCardController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_WalletCardChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_WalletCardChooseCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_WalletCardChooseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Wallet_back_info *model = self.models[indexPath.row];
    self.block(cell.bankNameLabel.text,cell.bankNumLabel.text,model.bank_id);
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - 删除银行卡
/**
 *  只要实现了这个方法，左滑出现按钮的功能就有了
 (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak __typeof(self) weakSelf = self;
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        Wallet_back_info *model = self.models[indexPath.row];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"bank_id"] = model.bank_id;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kDEL_CARD_URL paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBankCardNotification" object:nil userInfo:nil];
                
                [weakSelf.models removeObjectAtIndex:indexPath.row];
                
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [SVProgressHUD showSuccessWithStatus:@"删除银行卡成功!"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            

        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];

    }];
    
    return @[action1];
}

- (void)deleteCard:(NSString *)bank_id index:(NSInteger)index {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"bank_id"] = bank_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kDEL_CARD_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBankCardNotification" object:nil userInfo:nil];
            
            [self.models removeObjectAtIndex:index];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:index];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [SVProgressHUD showSuccessWithStatus:@"删除银行卡成功!"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
@end
