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
                [self.tableView reloadData];
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
