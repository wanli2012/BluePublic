//
//  GLHomeController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeController.h"
#import "GLHomeCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

#import "GLPay_ChooseController.h"//支付选择
#import "GLHome_CasesController.h"//经典案例
#import "GLHomeModel.h"//首页模型
#import "GLMine_MyMessage_NoticeController.h"//公告列表
#import "GLBusiness_DetailController.h"//项目详情
#import "GLBusiness_CertificationController.h"//web广告页
#import "GLTrainListController.h"

@interface GLHomeController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{
    NSInteger _selectedSegmentIndex;//显示 0:创客 1:爱心
}

@property (weak, nonatomic) IBOutlet UIImageView *adImageV;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIView *noticeLayerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;//项目类型选择
@property (weak, nonatomic) IBOutlet UISegmentedControl *supportTypeSegment;//扶持类型选择

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *middleViewLayerView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

//切换要用到的控件
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@property (nonatomic, strong)GLHomeModel *model;
@property (nonatomic, strong)GLHome_adModel *adModel;//广告模型
@property (nonatomic, strong) NSMutableArray *bannerArr;//banner模型数组
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NodataView *nodataV;

@property (strong, nonatomic)NSString *app_Version;//当前版本号
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstrait;//tableview顶部约束
@property (nonatomic, assign)NSInteger typeIndex;//类型 1创客经典案列 2爱心经典案列

@end

@implementation GLHomeController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUI];
    
    
    [self.headerView addSubview:self.cycleScrollView];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHomeCell" bundle:nil] forCellReuseIdentifier:@"GLHomeCell"];

    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest];
        [weakSelf postAD];
        
    }];
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    self.typeIndex = 1;
    [self postRequest];//请求数据
    [self postAD];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    _app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    [self Postpath:GET_VERSION];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;

    }
    
    if(kSCREEN_HEIGHT == 812){
        self.tableViewTopConstrait.constant = 44;
    }else{
        self.tableViewTopConstrait.constant = 20;
    }
}

#pragma mark - 界面设置
- (void)setUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
    _selectedSegmentIndex = 0;
    self.headerView.height = 450;
    self.segment.selectedSegmentIndex = 0;
    
    self.noticeView.layer.cornerRadius = 5.f;
    self.noticeLayerView.layer.cornerRadius = 5.f;
    
    self.noticeLayerView.layer.shadowOpacity = 0.1f;
    self.noticeLayerView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.noticeLayerView.layer.shadowRadius = 1.f;
    
    self.middleView.layer.cornerRadius = 5.f;
    self.middleViewLayerView.layer.cornerRadius = 5.f;
    self.middleViewLayerView.layer.shadowOpacity = 0.1f;
    self.middleViewLayerView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.middleViewLayerView.layer.shadowRadius = 1.f;
}

#pragma mark - 请求数据
//- (void)postRequestWithTyep:(NSInteger)type andSupportType:(NSInteger)supprotType{
- (void)postRequest{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"typess"] = @(self.typeIndex);
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kHOME_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        self.model = nil;
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            self.model = [GLHomeModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            self.noticeLabel.text = self.model.new_notice.title;
            
            [self swithToHidden:_selectedSegmentIndex];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

#pragma mark - 请求广告数据
- (void)postAD{
    
    [NetworkManager requestPOSTWithURLStr:kindex_banner paramDic:@{} finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                [self.bannerArr removeAllObjects];
                
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLHome_bannerModel *model = [GLHome_bannerModel mj_objectWithKeyValues:dic];
                    [self.bannerArr addObject:model];
                    
                    NSString *s = [NSString stringWithFormat:@"%.0f",kSCREEN_WIDTH - 30];
                    NSInteger w = [s integerValue];
                    
                    NSString *imageurl = [NSString stringWithFormat:@"%@?imageView2/1/w/%zd/h/120",model.banner,w];
                    [arrM addObject:imageurl];
                }
                self.cycleScrollView.imageURLStringsGroup = arrM;
            }
            
        }else{
            self.cycleScrollView.localizationImageNamesGroup = @[LUNBO_PlaceHolder];
            
        }
     
     [self.tableView reloadData];

    } enError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 查看更多
- (IBAction)more:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLHome_CasesController *caseVC = [[GLHome_CasesController alloc] init];
    [self.navigationController pushViewController:caseVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

//#pragma mark - 广告
//- (IBAction)ad:(id)sender {
//
//    self.hidesBottomBarWhenPushed = YES;
//    GLBusiness_CertificationController *cerVC = [[GLBusiness_CertificationController alloc] init];
//    cerVC.navTitle = @"详情";
//    cerVC.url = [NSString stringWithFormat:@"%@",Home_Banner_URL];
//    [self.navigationController pushViewController:cerVC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//
//}

#pragma mark - 公告
- (IBAction)notice:(id)sender {
  
    self.hidesBottomBarWhenPushed = YES;
    GLMine_MyMessage_NoticeController *myMessageVC = [[GLMine_MyMessage_NoticeController alloc] init];
    myMessageVC.signIndex = 1;
    [self.navigationController pushViewController:myMessageVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 培训
- (IBAction)train:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLTrainListController *trainVC = [[GLTrainListController alloc] init];
    [self.navigationController pushViewController:trainVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - 切换数据显示
- (IBAction)switchSelected:(id)sender {
    
    UISegmentedControl* control = (UISegmentedControl*)sender;
    _selectedSegmentIndex = control.selectedSegmentIndex;
    [self swithToHidden:_selectedSegmentIndex];
    self.typeIndex = 0;
    self.typeIndex = _selectedSegmentIndex + 1;
    [self postRequest];
}

- (void)swithToHidden:(NSInteger)index {
    
    if(self.model.c_man_num.length == 0){
        self.model.c_man_num = @"0";
    }
    if(self.model.c_item_num.length == 0){
        self.model.c_item_num = @"0";
    }
    if(self.model.c_over_num.length == 0){
        self.model.c_over_num = @"0";
    }
    if(self.model.ai_over_num.length == 0){
        self.model.ai_over_num = @"0";
    }
    if(self.model.ai_man_num.length == 0){
        self.model.ai_man_num = @"0";
    }
    if(self.model.ai_item_num.length == 0){
        self.model.ai_item_num = @"0";
    }
    
    switch (index) {
        case 0:
        {
            double c_over_num = [self.model.c_over_num doubleValue];
            
            self.titleLabel.text = @"创客大数据";
            self.label.text = @"创客";
            self.label2.text = @"创客项目";
            self.label3.text = @"创客基金";
            
            self.label4.text = [NSString stringWithFormat:@"%@人",self.model.c_man_num];
            self.label5.text = [NSString stringWithFormat:@"%@个",self.model.c_item_num];
            self.label6.text = [NSString stringWithFormat:@"%.2f元",c_over_num];
            
            self.supportTypeSegment.hidden = NO;
            self.headerView.height = 450;
            
        }
            break;
        case 1:
        {

            double ai_over_num = [self.model.ai_over_num doubleValue];
            self.titleLabel.text = @"爱心大数据";
            self.label.text = @"互助人数";
            self.label2.text = @"互助项目";
            self.label3.text = @"爱心基金";
            self.label4.text = [NSString stringWithFormat:@"%@人",self.model.ai_man_num];
            self.label5.text = [NSString stringWithFormat:@"%@个",self.model.ai_item_num ];
            self.label6.text = [NSString stringWithFormat:@"%.2f元",ai_over_num ];
            
            self.supportTypeSegment.hidden = YES;
            self.headerView.height = 400;
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - SDCycleScrollViewDelegate 点击看大图
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_CertificationController *aboutVC = [[GLBusiness_CertificationController alloc] init];
    GLHome_bannerModel *model = self.bannerArr[index];
    NSString *url = [NSString stringWithFormat:@"%@%@",Banner_data_URL,model.type];
    aboutVC.url = url;
    aboutVC.navTitle = model.banner_title;
    [self.navigationController pushViewController:aboutVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

#pragma mark - 检查是否有更新
-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue] > 0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
    }];
}

-(void)receiveData:(id)sender{
    
    NSString  *Newversion = [NSString stringWithFormat:@"%@",sender[@"version"]];
    
    if (![_app_Version isEqualToString:Newversion]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新提示"
                                                            message:@"发现新版本,是否更新 ?"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"立即更新", nil];
        
        [alertView show];
    }
}

#pragma mark ----- UIAlertviewdelegete
//下载
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOAD_URL] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.model.groom_item.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHomeCell"];
    cell.selectionStyle = 0;
    cell.model = self.model.groom_item[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;

    GLBusiness_DetailController *detailVC = [[GLBusiness_DetailController alloc] init];
    detailVC.item_id = self.model.groom_item[indexPath.row].item_id;
    [self.navigationController pushViewController:detailVC animated:YES];

    self.hidesBottomBarWhenPushed = NO;
}

- (SDCycleScrollView *)cycleScrollView{
    
    if (!_cycleScrollView) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 230, kSCREEN_WIDTH - 15 * 2, 120)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];
        
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor redColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        
        _cycleScrollView.localizationImageNamesGroup = @[LUNBO_PlaceHolder,LUNBO_PlaceHolder];
        _cycleScrollView.layer.cornerRadius = 5.f;
        _cycleScrollView.clipsToBounds = YES;
    }
    
    return _cycleScrollView;
}

- (GLHomeModel *)model{
    if (!_model) {
        _model = [[GLHomeModel alloc] init];
    }
    return _model;
}

- (NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

@end
