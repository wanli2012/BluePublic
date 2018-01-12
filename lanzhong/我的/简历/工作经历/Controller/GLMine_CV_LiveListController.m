//
//  GLMine_CV_LiveListController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_LiveListController.h"
#import "GLMine_CV_WorkCell.h"
#import "GLMine_CV_AddWorkLiveController.h"//添加工作经历
#import "GLMine_CV_DetailModel.h"

@interface GLMine_CV_LiveListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray <GLMine_CV_live *>*models;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@end


@implementation GLMine_CV_LiveListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"工作经历";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_WorkCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_WorkCell"];
    
    self.addBtn.layer.cornerRadius = 5.f;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"GLMine_CV_BaseInfoNotification" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self isHiddenAddBtn];
}
- (void)isHiddenAddBtn{
    if (self.models.count >= 3) {
        self.addBtn.hidden = YES;
        self.signLabel.hidden = YES;
        self.noticeLabel.hidden = YES;
    }else{
        self.addBtn.hidden = NO;
        self.signLabel.hidden = NO;
        self.noticeLabel.hidden = NO;
    }
    
}

- (void)refresh{
    
    [self postRequest];
}

- (void)postRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCV_WORKLIST_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                [self.models removeAllObjects];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLMine_CV_live *model = [GLMine_CV_live mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
                [self isHiddenAddBtn];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
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


- (IBAction)addWorkLife:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_CV_AddWorkLiveController *addVC = [[GLMine_CV_AddWorkLiveController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_CV_WorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_WorkCell"];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    cell.arrowImageV.hidden = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    return self.tableView.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    GLMine_CV_AddWorkLiveController *addVC = [[GLMine_CV_AddWorkLiveController alloc] init];
    addVC.model = self.models[indexPath.row];
    addVC.type = 1;
    [self.navigationController pushViewController:addVC animated:YES];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该经历？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
            
            GLMine_CV_live *model = self.models[indexPath.row];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [UserModel defaultUser].token;
            dict[@"uid"] = [UserModel defaultUser].uid;
            dict[@"live_id"] = model.live_id;
            
            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:kCV_DEL_WORKLIFE_URL paramDic:dict finish:^(id responseObject) {
                
                [_loadV removeloadview];
                
                if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                    
                    [self.models removeObjectAtIndex:indexPath.row];
                    
                    [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GLMine_CV_BaseInfoNotification" object:nil];
                    
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                }
                
            } enError:^(NSError *error) {
                [_loadV removeloadview];
            }];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
