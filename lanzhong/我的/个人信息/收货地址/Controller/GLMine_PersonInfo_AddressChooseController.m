//
//  GLMine_PersonInfo_AddressChooseController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfo_AddressChooseController.h"
#import "GLMine_PersonInfo_AddressCell.h"
#import "GLMine_AddressAddController.h"//新增收货地址
#import "GLMine_AddressModel.h"
#import "GLConfirmOrderController.h"//下单界面

@interface GLMine_PersonInfo_AddressChooseController ()<GLMine_PersonInfo_AddressCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;

@end

@implementation GLMine_PersonInfo_AddressChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"收货地址";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_PersonInfo_AddressCell" bundle:nil] forCellReuseIdentifier:@"GLMine_PersonInfo_AddressCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"refreshReceivingAddress" object:nil];;
    
    //kMYADDRESSLIST_URL
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];
        
    }];
    
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        [weakSelf postRequest:NO];
//        
//    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
//    self.tableView.mj_footer = footer;
    self.page = 1;
    [self postRequest:YES];
    
    
}
- (void)updateData{
    [self postRequest:YES];
}

- (void)postRequest:(BOOL)isRefresh{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"page"] = @(1);
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kMYADDRESSLIST_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLMine_AddressModel *model = [GLMine_AddressModel mj_objectWithKeyValues:dic];
                    
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
//    [self.tableView.mj_footer endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
//添加收货地址
- (IBAction)addAD:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_AddressAddController *addressVC = [[GLMine_AddressAddController alloc] init];
    addressVC.isEdit = NO;
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

#pragma mark - GLMine_PersonInfo_AddressCellDelegate

- (void)editAddress:(NSInteger)index{

    self.hidesBottomBarWhenPushed = YES;
    GLMine_AddressAddController *addressVC = [[GLMine_AddressAddController alloc] init];
    addressVC.isEdit = YES;
    addressVC.model = self.models[index];
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_PersonInfo_AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_PersonInfo_AddressCell"];
    
    cell.model = self.models[indexPath.row];
    
    cell.index = indexPath.row;
    
    cell.delegate = self;
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"选中一个地址");
    
//    LBMineCentermodifyAdressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GLMine_AddressModel *model = self.models[indexPath.row];
    
    NSArray *vcsArray = [self.navigationController viewControllers];
    NSInteger vcCount = vcsArray.count;
    UIViewController *lastVC = vcsArray[vcCount-2];//最后一个vc是自己，倒数第二个是上一个控制器。
    
    if([lastVC isKindOfClass:[GLConfirmOrderController class]]){
        
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@",model.province_name,model.city_name,model.area_name,model.address];
        
        self.block(model.collect_name,model.phone,address,model.address_id);
        [self.navigationController popViewControllerAnimated:YES];
        
    }

    
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
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该商品？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
            
            GLMine_AddressModel *model = self.models[indexPath.row];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [UserModel defaultUser].token;
            dict[@"uid"] = [UserModel defaultUser].uid;
            dict[@"address_id"] = model.address_id;
            
            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:kDEL_ADDRESS_URL paramDic:dict finish:^(id responseObject) {
                
                [_loadV removeloadview];
                
                if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                    
                    [self.models removeObjectAtIndex:indexPath.row];
         
                    [MBProgressHUD showError:responseObject[@"message"]];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
