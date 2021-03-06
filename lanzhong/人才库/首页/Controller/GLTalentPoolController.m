//
//  GLTalentPoolController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLTalentPoolController.h"
#import "GLBusiniessCell.h"
#import "GLBusinessCircle_MenuScreeningView.h"
#import "GLTalentPoolCell.h"
#import "GLTalentPoolModel.h"
#import "GLPublish_CityModel.h"
#import "GLTalent_CVModel.h"//简历模型
#import "GLMine_CV_PreviewController.h"

@interface GLTalentPoolController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GLBusinessCircle_MenuScreeningView *menuScreeningView;  //条件选择器
@property (nonatomic, assign)BOOL HideNavagation;//是否需要恢复自定义导航栏

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@property (nonatomic, strong)GLTalentPoolModel *categoryModel;
@property (nonatomic, strong)NSMutableArray *cvModels;

@property (nonatomic, strong)NSMutableArray <GLPublish_CityModel *>*cityModels;//城市数据源
@property (nonatomic, copy)NSString *provinceId;//省份id
@property (nonatomic, copy)NSString *cityId;//城市id
@property (nonatomic, copy)NSString *money;//期望薪资
@property (nonatomic, copy)NSString *duty;//期望职业
@property (nonatomic, copy)NSString *work;//期望工作年限
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstrait;

@end

@implementation GLTalentPoolController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.menuScreeningView];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLTalentPoolCell" bundle:nil] forCellReuseIdentifier:@"GLTalentPoolCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
    
    self.menuScreeningView.block = ^(NSInteger itemIndex,NSInteger firstIndex,NSInteger index){
        switch (itemIndex) {
            case 0:
            {
                weakSelf.provinceId = weakSelf.cityModels[firstIndex].province_code;
                weakSelf.cityId = weakSelf.cityModels[firstIndex].city[index].city_code;
            }
                break;
            case 1:
            {
                weakSelf.work = weakSelf.categoryModel.work[firstIndex].name;
            }
                break;
            case 2:
            {
                weakSelf.money = weakSelf.categoryModel.money[firstIndex].name;
            }
                break;
            case 3:
            {
                weakSelf.duty = weakSelf.categoryModel.duty[firstIndex].name;
            }
                break;
                
            default:
                break;
        }
        if ([weakSelf.money isEqualToString:@"不限"]) {
            weakSelf.money = @"";
        }
        if ([weakSelf.duty isEqualToString:@"不限"]) {
            weakSelf.duty = @"";
        }
        if ([weakSelf.work isEqualToString:@"不限"]) {
            weakSelf.work = @"";
        }
        
        [weakSelf postCV_List:YES];
    };
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self postCategory];
        [self postCityList];
        [self postCV_List:YES];
        [self postRefreshRequest];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf postCV_List:NO];
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;

    [self postCategory];
    [self postCityList];
    [self postCV_List:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"GLMine_CVNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRefreshRequest) name:@"supportNotification" object:nil];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
       
    }
    if(kSCREEN_HEIGHT == 812){
        self.tableViewTopConstrait.constant = 94;
    }else{
        self.tableViewTopConstrait.constant = 70;
    }

}

- (void)refresh{
    
    [self postCV_List:YES];
}

#pragma mark - 刷新状态
-(void)postRefreshRequest {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    [NetworkManager requestPOSTWithURLStr:kREFRESH_URL paramDic:dict finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            [UserModel defaultUser].address = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"address"]];
            [UserModel defaultUser].area = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"area"]];
            [UserModel defaultUser].city = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"city"]];
            [UserModel defaultUser].del = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"del"]];
            [UserModel defaultUser].g_id = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"g_id"]];
            [UserModel defaultUser].g_name = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"g_name"]];
            [UserModel defaultUser].idcard = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"idcard"]];
            [UserModel defaultUser].invest_count = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"invest_count"]];
            [UserModel defaultUser].is_help = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"is_help"]];
            [UserModel defaultUser].item_count = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"item_count"]];
            [UserModel defaultUser].nickname = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"nickname"]];
            [UserModel defaultUser].phone = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"phone"]];
            [UserModel defaultUser].province = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"province"]];
            [UserModel defaultUser].real_state = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"real_state"]];
            [UserModel defaultUser].real_time = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"real_time"]];
            [UserModel defaultUser].token = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"token"]];
            [UserModel defaultUser].truename = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"truename"]];
            [UserModel defaultUser].uid = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"uid"]];
            [UserModel defaultUser].umark = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"umark"]];
            [UserModel defaultUser].umoney = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"umoney"]];
            [UserModel defaultUser].uname = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"uname"]];
            [UserModel defaultUser].user_pic = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"user_pic"]];
            [UserModel defaultUser].user_server = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"user_server"]];
            [UserModel defaultUser].item_money = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"item_money"]];
     
            [usermodelachivar achive];
  
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
    }];
}
#pragma mark - 请求简历列表
- (void)postCV_List:(BOOL)status {
    
    if (status) {
        self.page = 1;
        
    }else{
        self.page ++;
    }
    
    if ([self.money isEqualToString:@"不限"]) {
        self.money = @"";  
    }
    if ([self.duty isEqualToString:@"不限"]) {
        self.duty = @"";
    }
    if ([self.work isEqualToString:@"不限"]) {
        self.work = @"";
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"page"] = @(self.page);
    dic[@"province"] = self.provinceId;
    dic[@"city"] = self.cityId;
    dic[@"money"] = self.money;
    dic[@"duty"] = self.duty;
    dic[@"work"] = self.work;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCV_LIST_URL paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        
        if (status) {
            [self.cvModels removeAllObjects];
        }
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLTalent_CVModel *model = [GLTalent_CVModel mj_objectWithKeyValues:dic];
                    [self.cvModels addObject:model];
                }
            }
        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){
            
            if (self.cvModels.count != 0) {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];

    }];
}
#pragma mark - 请求城市
- (void)postCityList {
    
    [NetworkManager requestPOSTWithURLStr:kCITYLIST_URL paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                [self.cityModels removeAllObjects];
                
                GLPublish_CityModel *model0 = [[GLPublish_CityModel alloc] init];
                model0.province_name = @"不限";
                
                [self.cityModels addObject:model0];
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLPublish_CityModel *model = [GLPublish_CityModel mj_objectWithKeyValues:dic];
                    [self.cityModels addObject:model];
                }
                
                for (GLPublish_CityModel *model in self.cityModels)
                {
                    GLPublish_City *city = [[GLPublish_City alloc] init];
                    city.city_name = @"不限";
                    
                    NSMutableArray *array = [NSMutableArray array];
                    [array addObject:city];
                    [array addObjectsFromArray:model.city];
                    
                    model.city = array;
                }
                
                self.menuScreeningView.dataArr1 = self.cityModels;
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
    }];
}

#pragma mark - 分类请求
- (void)postCategory {
    [NetworkManager requestPOSTWithURLStr:kCV_CLASSIFY_URL paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                self.categoryModel = [GLTalentPoolModel mj_objectWithKeyValues:responseObject[@"data"]];
                
                NSMutableArray *arrM = [NSMutableArray array];
                NSMutableArray *arrM2 = [NSMutableArray array];
                NSMutableArray *arrM3 = [NSMutableArray array];
                
                for (GLTalentPool_Category *work in self.categoryModel.work) {
                    [arrM3 addObject:work.name];
                }
                for (GLTalentPool_Category *money in self.categoryModel.money) {
                    [arrM addObject:money.name];
                }
                for (GLTalentPool_Category *duty in self.categoryModel.duty) {
                    [arrM2 addObject:duty.name];
                }
                
                self.menuScreeningView.dataArr2 = arrM3;
                self.menuScreeningView.dataArr3 = arrM;
                self.menuScreeningView.dataArr4 = arrM2;
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
    }];

}
- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self postRefreshRequest];//刷新状态
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    if (self.cvModels.count == 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.cvModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLTalentPoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLTalentPoolCell"];
    cell.selectionStyle = 0;
    cell.model = self.cvModels[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[UserModel defaultUser].is_help integerValue] == 0) {//是否已捐助  0否  1是
        [SVProgressHUD showErrorWithStatus:@"你还未支持过任何项目,不能查看简历详情"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_CV_PreviewController *previewVC = [[GLMine_CV_PreviewController alloc] init];
    GLTalent_CVModel *model = self.cvModels[indexPath.row];
    previewVC.resume_id = model.resume_id;
    [self.navigationController pushViewController:previewVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 懒加载
-(GLBusinessCircle_MenuScreeningView*)menuScreeningView{
    
    if (!_menuScreeningView) {
        CGFloat y = 0.0f;
        if(kSCREEN_HEIGHT == 812){
            y = 44;
        }else{
            y = 20;
        }
        _menuScreeningView = [[GLBusinessCircle_MenuScreeningView alloc] initWithFrame:CGRectMake(0, y,kSCREEN_WIDTH , 50) WithTitles:@[@"城市",@"年限",@"薪资",@"行业"]];
        _menuScreeningView.backgroundColor = [UIColor whiteColor];
    }
    
    return _menuScreeningView;
}
- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 50 - 49);
        
    }
    return _nodataV;
}

- (NSMutableArray *)cityModels{
    if (!_cityModels) {
        _cityModels = [NSMutableArray array];
    }
    return _cityModels;
}
- (NSMutableArray *)cvModels{
    if (!_cvModels) {
        _cvModels = [NSMutableArray array];
    }
    return _cvModels;
}

@end
