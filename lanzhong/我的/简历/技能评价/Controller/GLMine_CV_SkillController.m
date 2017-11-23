//
//  GLMine_CV_SkillController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_SkillController.h"
#import "GLMine_CV_SkillDetailCell.h"
#import "GLMine_CV_DetailModel.h"
#import "GLMine_CV_AddSkillController.h"//添加技能评价

@interface GLMine_CV_SkillController ()<GLMine_CV_SkillDetailCellDelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray <GLMine_CV_skill *>*models;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@end

@implementation GLMine_CV_SkillController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"技能评价";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_SkillDetailCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_SkillDetailCell"];
    
    [self postRequest];
    
    self.addBtn.layer.cornerRadius = 5.f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"GLMine_CV_BaseInfoNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self isHiddenAddBtn];
}

- (void)isHiddenAddBtn{
    if (self.models.count >= 3) {
        self.addBtn.hidden = YES;
        self.noticeLabel.hidden = YES;
        self.signLabel.hidden = YES;
    }else{
        self.addBtn.hidden = NO;
        self.noticeLabel.hidden = NO;
        self.signLabel.hidden = NO;
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
    [NetworkManager requestPOSTWithURLStr:kCV_SKILL_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                [self.models removeAllObjects];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLMine_CV_skill *model = [GLMine_CV_skill mj_objectWithKeyValues:dic];
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

        [self.tableView reloadData];
    }];
}

#pragma mark - 添加技能
- (IBAction)addSkill:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_CV_AddSkillController *addVC = [[GLMine_CV_AddSkillController alloc] init];
    addVC.type = 0;
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark - GLMine_CV_SkillDetailCellDelegate
- (void)edit:(NSInteger)index{
    self.hidesBottomBarWhenPushed = YES;
    GLMine_CV_AddSkillController *addVC = [[GLMine_CV_AddSkillController alloc] init];
    addVC.model = self.models[index];
    addVC.type = [self.models[index].skill_id integerValue];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_CV_SkillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_SkillDetailCell"];
    cell.model = self.models[indexPath.row];
    cell.index = indexPath.row;
    cell.delegete = self;
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
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
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该技能？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
            
            GLMine_CV_skill *model = self.models[indexPath.row];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [UserModel defaultUser].token;
            dict[@"uid"] = [UserModel defaultUser].uid;
            dict[@"skill_id"] = model.skill_id;
            
            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:kCV_DEL_SKILL_URL paramDic:dict finish:^(id responseObject) {
                
                [_loadV removeloadview];
                
                if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                    
                    [self.models removeObjectAtIndex:indexPath.row];
                    
                    [MBProgressHUD showError:responseObject[@"message"]];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GLMine_CV_BaseInfoNotification" object:nil];
                    
                }else{
                    
                    [MBProgressHUD showError:responseObject[@"message"]];
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
