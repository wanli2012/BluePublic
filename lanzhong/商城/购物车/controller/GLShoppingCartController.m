//
//  GLShoppingCartController.m
//  PublicSharing
//
//  Created by 龚磊 on 2017/3/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLShoppingCartController.h"
#import "GLShoppingCell.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBSetFillet.h"
#import "GLConfirmOrderController.h"//下单界面

#import "BaseNavigationViewController.h"
#import "GLLoginController.h"

@interface GLShoppingCartController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearingBtn;

@property (nonatomic, assign)BOOL isSelectedRightBtn;

@property (nonatomic, strong)NSMutableArray *selectArr;

@property (nonatomic, strong)UIButton *rightBtn;

//@property (nonatomic, assign)CGFloat totalPrice;

@property (nonatomic, assign)NSInteger totalNum;

@property (nonatomic, strong)NSMutableArray *models;
@property (weak, nonatomic) IBOutlet UILabel *navaTitle;
@property (weak, nonatomic) IBOutlet UIButton *seleteAllBtn;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NodataView *nodataV;

@end

static NSString *ID = @"GLShoppingCell";
@implementation GLShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLShoppingCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
     [self.clearingBtn addTarget:self action:@selector(clearingMore:) forControlEvents:UIControlEventTouchUpInside];

    [self.seleteAllBtn horizontalCenterTitleAndImageRight:10.f];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计:¥ 0"];
   
    [self postRequest];
    
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)postRequest {
    //kMYCART_URL
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kMYCART_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLShoppingCartModel *model = [GLShoppingCartModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
            }
        }else if([responseObject[@"code"] integerValue] == OVERDUE_CODE){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            
            [UserModel defaultUser].loginstatus = NO;
            [usermodelachivar achive];
            
            GLLoginController *loginVC = [[GLLoginController alloc] init];
            loginVC.sign = 1;
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nav animated:YES completion:nil];
            
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
#pragma mark - 去结算
- (void)clearingMore:(UIButton *)sender{

    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *tempArr2 = [NSMutableArray array];
    NSMutableArray *tempArr4 = [NSMutableArray array];
    
    for (int i = 0; i < self.models.count; i ++) {
        GLShoppingCartModel *model = self.models[i];
        if (model.isSelect) {
            
            [tempArr addObject:model.goods_id];
            [tempArr2 addObject:model.num];
            [tempArr4 addObject:model.spec_id];
            
        }
    }
    
    if (tempArr.count == 0) {

        [SVProgressHUD showErrorWithStatus:@"还未选择商品"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLConfirmOrderController *orderVC = [[GLConfirmOrderController alloc] init];
    
    orderVC.goods_id = [tempArr componentsJoinedByString:@","];;
    orderVC.goods_count = [tempArr2 componentsJoinedByString:@","];
    orderVC.goods_spec = [tempArr4 componentsJoinedByString:@","];
    if(tempArr.count == 1){
        
        orderVC.orderType = 2;
    }else{
        
        orderVC.orderType = 0;
    }
    
    [self.navigationController pushViewController:orderVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

#pragma mark - 全选
- (IBAction)selectAll:(UIButton*)sender {
    
    if(self.models.count == 0){
        //[MBProgressHUD showError:@"暂无可选商品"];
        return;
    }
    sender.selected = !sender.selected;
    float  num = 0;
    [self.selectArr removeAllObjects];
    
    if (sender.selected) {
        for (int i = 0; i < self.models.count; i++) {
            GLShoppingCartModel *model = self.models[i];
            model.isSelect = YES;
            num = num + [model.marketprice floatValue] * [model.num floatValue];

        }
        [self.seleteAllBtn setImage:[UIImage imageNamed:@"mine_choice"] forState:UIControlStateNormal];
    }else{
        [self.seleteAllBtn setImage:[UIImage imageNamed:@"nochoice1"] forState:UIControlStateNormal];
        [self.selectArr removeAllObjects];
        
        if (self.models.count == 0) {
            
            return;
        }
        for (int i = 0; i < self.models.count; i++) {
            GLShoppingCartModel *model = self.models[i];
            model.isSelect = NO;
        }
    }
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
    
    [self.tableView reloadData];
}

#pragma mark - 选中,取消选中
- (void)changeStatus:(NSInteger)index {
    
     [self.selectArr removeAllObjects];
    
    BOOL  b = NO;
    float  num = 0;
    
    for (int i = 0; i < self.models.count; i++) {
        GLShoppingCartModel *model = self.models[i];
        
        if (model.isSelect == NO) {
            b = YES;
            
        }else{
            num = num + [model.marketprice floatValue] * [model.num floatValue];
            [self.selectArr addObject:model];
        }
    }
    
    if (b == YES) {
        
        self.seleteAllBtn.selected = NO;
        [self.seleteAllBtn setImage:[UIImage imageNamed:@"nochoice1"] forState:UIControlStateNormal];
    }else{
        
        self.seleteAllBtn.selected = YES;
        [self.seleteAllBtn setImage:[UIImage imageNamed:@"mine_choice"] forState:UIControlStateNormal];
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)updateTitleNum {
    
    if (self.isMainVC == NO) {
        self.navaTitle.text = [NSString stringWithFormat:@"购物车"];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"购物车"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self updateTitleNum];
    
}

#pragma  UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.models.count == 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.models.count == 0 ? 0:self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    cell.model = self.models.count == 0 ? nil:self.models[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLShoppingCartModel *model = self.models[indexPath.row];
    model.isSelect = !model.isSelect;
    [self changeStatus:indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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

#pragma mark - 进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该商品？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            GLShoppingCartModel *model = self.models[indexPath.row];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [UserModel defaultUser].token;
            dict[@"uid"] = [UserModel defaultUser].uid;
            dict[@"cart_id"] = model.cart_id;
            
            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:kDEL_CARTGOODS_URL paramDic:dict finish:^(id responseObject) {
                
                [_loadV removeloadview];
                
                if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                    
                    [self.models removeObjectAtIndex:indexPath.row];
                    
                    BOOL  b = NO;
                    float  num = 0;
                    
                    for (int i = 0; i < self.models.count; i++) {
                        GLShoppingCartModel *model = self.models[i];
                        
                        if (model.isSelect == NO) {
                            b = YES;
                        }else{
                            num = num + [model.marketprice floatValue] * [model.num floatValue];
                        }
                    }
                    
                    if (b == NO) {
                        
                        self.seleteAllBtn.selected = NO;
                        [self.seleteAllBtn setImage:[UIImage imageNamed:@"nochoice1"] forState:UIControlStateNormal];
                    }else{
                        
                        self.seleteAllBtn.selected = YES;
                        [self.seleteAllBtn setImage:[UIImage imageNamed:@"mine_choice"] forState:UIControlStateNormal];
                    }
                    
        
                    [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.clearingBtn.layer.borderWidth = 1.0;
    self.clearingBtn.layer.borderColor = YYSRGBColor(0, 92, 254, 1).CGColor;
    self.clearingBtn.layer.cornerRadius = 4;
    self.clearingBtn.clipsToBounds = YES;
    
}

- (NSMutableArray *)selectArr {
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}
- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 150);
        
    }
    return _nodataV;
}

@end
