//
//  GLBusiness_DetailController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailController.h"
#import "GLBusiness_DetailCommentCell.h"
#import "GLBusiness_DetailProjectCell.h"
#import "GLBusiness_ChooseCell.h"//资金动向和官方认证
#import "GLBusiness_CertificationController.h"//官方认证
#import "GLBusiness_LoveListController.h"
#import "GLBusiness_FundTrendController.h"//资金动向
#import "GLBusiness_DetailModel.h"
#import "GLBusiness_RelevalteFileController.h"//相关文件
#import "GLBusiness_CertificationController.h"//webView

#import "GLBusiness_Detail_heartCommentController.h"//更多评论

#import "GLPay_ChooseController.h"//选择支付界面

#import <UShareUI/UShareUI.h>
#import "JZAlbumViewController.h"

@interface GLBusiness_DetailController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,GLBusiness_ChooseCellDelegate,GLBusiness_DetailCommentCellDelegate,GLBusiness_DetailProjectCellDelegate>
{
    CGRect _rect;
}

@property (weak, nonatomic) IBOutlet UILabel *projectTitleLabel;//项目标题Label
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;//项目图
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;//发起人名
@property (weak, nonatomic) IBOutlet UILabel *targetMoneyLabel;//目标金额
@property (weak, nonatomic) IBOutlet UILabel *raisedLabel;//已筹金额
@property (weak, nonatomic) IBOutlet UIView *bgProgressView;//进度条背景
@property (weak, nonatomic) IBOutlet UIView *progressView;//进度条
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressLeftConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;
@property (weak, nonatomic) IBOutlet UIView *progressSignView;//百分比 球
@property (weak, nonatomic) IBOutlet UILabel *listNumLabel;//榜单人数
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;//百分比
@property (weak, nonatomic) IBOutlet UILabel *needTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *supportBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *middleViewLayerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV3;

@property (nonatomic, strong)GLBusiness_DetailModel *model;
@property (nonatomic, strong)LoadWaitView *loadV;

@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏

@end

@implementation GLBusiness_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_DetailCommentCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_DetailCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_DetailProjectCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_DetailProjectCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_ChooseCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_ChooseCell"];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    [self postRequest:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"supportNotification" object:nil];
}

/**
 接到通知刷新数据
 */
-(void)refresh{
    
    [self postRequest:YES];
}

#pragma mark - 请求数据

/**
 请求数据

 @param isRefresh 是否是下拉刷新
 */
- (void)postRequest:(BOOL)isRefresh{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"item_id"] = self.item_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCIRCLE_DETAIL_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
        
                self.model = [GLBusiness_DetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self headerViewFuzhi];
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

/**
 为头视图赋值
 */
- (void)headerViewFuzhi {
    
    if (self.model.user_info_pic.length == 0) {
        self.imageV.image = [UIImage imageNamed:PicHolderImage];
    }else{
        NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",self.model.user_info_pic];
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    }
    
    self.projectTitleLabel.text = [NSString stringWithFormat:@"项目:%@",self.model.title];
    self.personNameLabel.text = [NSString stringWithFormat:@"负责人:%@",self.model.linkman];
    self.targetMoneyLabel.text = [NSString stringWithFormat:@"%@元",self.model.admin_money];
    self.raisedLabel.text = [NSString stringWithFormat:@"%@元",self.model.draw_money];
    self.listNumLabel.text = [NSString stringWithFormat:@"榜单:%@人",self.model.invest_count];
    
    if (self.model.invest_10.count >= 1) {
        
        NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",self.model.invest_10[0].must_user_pic];
        [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        self.iconImageV.hidden = NO;
        self.iconImageV2.hidden = YES;
        self.iconImageV3.hidden = YES;
        if (self.model.invest_10.count >= 2) {
            
            NSString *imageStr1 = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",self.model.invest_10[1].must_user_pic];
            [self.iconImageV2 sd_setImageWithURL:[NSURL URLWithString:imageStr1] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
            self.iconImageV.hidden = NO;
            self.iconImageV2.hidden = NO;
            self.iconImageV3.hidden = YES;
            if (self.model.invest_10.count >= 3) {
                NSString *imageStr2 = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",self.model.invest_10[2].must_user_pic];
                [self.iconImageV3 sd_setImageWithURL:[NSURL URLWithString:imageStr2] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
                self.iconImageV.hidden = NO;
                self.iconImageV2.hidden = NO;
                self.iconImageV3.hidden = NO;
            }
        }
    }
   
    CGFloat ratio;
    if ([self.model.admin_money floatValue] == 0) {
        ratio = 0.f;
    }else{
        ratio = [self.model.draw_money floatValue]/[self.model.admin_money floatValue];
    }

    self.progressViewWidth.constant = self.bgProgressView.width * ratio;
    self.progressLeftConstrait.constant = self.bgProgressView.width * ratio;
    if (ratio == 1.0) {
        self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",ratio * 100];
    }else{
        
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",ratio * 100];
    }

    //获取当前日期0点0分的时间戳
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *now = [dateFormatter dateFromString:strDate];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];

    //算出天数
    NSInteger dayCount = [self getTheCountOfTwoDaysWithBeginDate:timeSp endDate:self.model.need_time];

    switch ([self.model.state integerValue]) {
        case 3:
        {
            if(dayCount != -1){
                self.needTimeLabel.text = [NSString stringWithFormat:@"剩余时间%zd天",dayCount];
            }else{
                self.needTimeLabel.text = [NSString stringWithFormat:@"筹款已截止"];
            }
        }
            break;
        case 6://6筹款完成
        {
            self.needTimeLabel.text = [NSString stringWithFormat:@"筹款完成"];
        }
            break;
        case 7:
        {
            self.needTimeLabel.text = [NSString stringWithFormat:@"项目进行中"];
        }
            break;
        case 10:
        {
            self.needTimeLabel.text = [NSString stringWithFormat:@"项目完成"];
        }
            break;
            
        default:
            break;
    }

    if([self.model.state integerValue] == 3 && dayCount != -1 && ratio < 1.0){
        
        self.supportBtn.enabled = YES;
        self.supportBtn.backgroundColor = MAIN_COLOR;
        
    }else{
        
        self.supportBtn.enabled = NO;
        self.supportBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

/**任意两天相差天数*/
- (NSInteger)getTheCountOfTwoDaysWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate{
    
    NSTimeInterval begin = [beginDate doubleValue];
    NSTimeInterval end = [endDate doubleValue];
    
    if (begin >= end) {
        return -1;
    }
    
    NSInteger dayCount = (end - begin)/(24 * 60 * 60);
    if(dayCount == 0){
        return -1;
    }
    
    return dayCount;
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 设置UI界面
- (void)setUI{
    
    self.view.backgroundColor = [UIColor brownColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"项目详情";
    self.imageV.layer.cornerRadius = self.imageV.height/2;
    self.supportBtn.layer.cornerRadius = 5.f;
    
    self.headerView.height = 295;
    self.progressSignView.layer.cornerRadius = self.progressSignView.height/2;
    self.progressSignView.layer.borderColor = YYSRGBColor(0, 125, 254, 1).CGColor;
    self.progressSignView.layer.borderWidth = 0.5f;
    
    self.middleView.layer.cornerRadius = 5.f;
    self.middleViewLayerView.layer.cornerRadius = 5.f;
    self.middleViewLayerView.layer.shadowOpacity = 0.1f;
    self.middleViewLayerView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.middleViewLayerView.layer.shadowRadius = 2.f;
    
    self.iconImageV.layer.cornerRadius = self.iconImageV.height/2;
    self.iconImageV2.layer.cornerRadius = self.iconImageV2.height/2;
    self.iconImageV3.layer.cornerRadius = self.iconImageV3.height/2;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 查看大图
- (IBAction)checkBigImageV:(id)sender {
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = 0;//这个参数表示当前图片的index，默认是0
    if (self.model.user_info_pic.length == 0) {
        UIImage *image = [UIImage imageNamed:@"logo"];
        jzAlbumVC.imgArr = [NSMutableArray arrayWithArray:@[image]];
    }else{
        
        jzAlbumVC.imgArr = [NSMutableArray arrayWithArray:@[self.model.user_info_pic]];//图片数组，可以是url，也可以是UIImage
    }
    
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
    
}

#pragma mark - 支持
- (IBAction)support:(id)sender {
    
    if ([UserModel defaultUser].loginstatus == NO) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLPay_ChooseController *payVC = [[GLPay_ChooseController alloc] init];
    payVC.item_id = self.item_id;
    [self.navigationController pushViewController:payVC animated:YES];

}

#pragma mark - 爱心贡献榜
- (IBAction)contributionList:(id)sender {
    if(self.model.invest_10.count == 0){
        [SVProgressHUD showErrorWithStatus:@"暂无人支持"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_LoveListController *lovelistVC = [[GLBusiness_LoveListController alloc] init];
    lovelistVC.dataSourceArr = self.model.invest_10;
    [self.navigationController pushViewController:lovelistVC animated:YES];
    
}
#pragma mark - 分享
- (IBAction)share:(id)sender {

    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        [self shareWebPageToPlatformType:platformType];
        
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UIImage *thumbURL = [UIImage imageNamed:@"ios-template-1024"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"蓝众创客项目分享" descr:@"项目具体详情" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@",Share_Project_URL,self.item_id];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }

    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    
    _rect = CGRectMake(0, 0, kSCREEN_WIDTH, newFrame.size.height + 10);
    
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:1 inSection:0]; //刷新第0段第2行
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - 点击查看大图 GLBusiness_DetailProjectCell
- (void)clickToCheckBigImage:(NSInteger)index{
    
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = index;//这个参数表示当前图片的index，默认是0
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString * s in self.model.sev_photo) {//@"%@?imageView2/1/w/200/h/200",
//        NSString *str = [NSString stringWithFormat:@"%@?imageView2/1/w/414/h/700",s];
        [arrM addObject:s];
    }
    jzAlbumVC.imgArr = arrM;//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];

}

#pragma mark - GLBusiness_ChooseCellDelegate
- (void)didSeletedIndex:(NSInteger)index{
    
    self.hidesBottomBarWhenPushed = YES;
    
    switch (index) {
        case 0:
        {

            GLBusiness_CertificationController *cerVC = [[GLBusiness_CertificationController alloc] init];
            cerVC.url = [NSString stringWithFormat:@"%@%@",Certification_URL,self.item_id];
            cerVC.navTitle = @"官方认证";
            [self.navigationController pushViewController:cerVC animated:YES];
            
        }
            break;
        case 1:
        {
          
            GLBusiness_FundTrendController *fundVC = [[GLBusiness_FundTrendController alloc] init];
            fundVC.item_id = self.item_id;
            
            [self.navigationController pushViewController:fundVC animated:YES];
        }
            break;
        case 2:
        {
            GLBusiness_Detail_heartCommentController *commentVC = [[GLBusiness_Detail_heartCommentController alloc] init];
            commentVC.item_id = self.item_id;

            [self.navigationController pushViewController:commentVC animated:YES];
        }
            break;
        case 3:
        {
            if ([self.model.ensure_type integerValue] == 1) {
                [SVProgressHUD showErrorWithStatus:@"无保障计划"];
                return;
            }else if ([self.model.ensure_type integerValue] == 2){
                GLBusiness_CertificationController *ensureVC = [[GLBusiness_CertificationController alloc] init];
                ensureVC.url = Other_ensure_URL;
                ensureVC.navTitle = @"关于保障";
                [self.navigationController pushViewController:ensureVC animated:YES];
            }else if ([self.model.ensure_type integerValue] == 3){
                GLBusiness_CertificationController *ensureVC = [[GLBusiness_CertificationController alloc] init];
                ensureVC.url = Other_lose_URL;
                ensureVC.navTitle = @"关于保障";
                [self.navigationController pushViewController:ensureVC animated:YES];
            }
            
        }
            break;
        case 4:
        {
            GLBusiness_RelevalteFileController *fileVC = [[GLBusiness_RelevalteFileController alloc] init];
            fileVC.item_id = self.item_id;
            
            [self.navigationController pushViewController:fileVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - GLBusiness_DetailCommentCellDelegate
- (void)personInfo{
    
    NSLog(@"个人信息");
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            if (self.model.invest_list.count <= 10) {
                
                return self.model.invest_list.count;
                
            }else{
                
                return 10;
            }
        }
            break;
            
        default:
            break;
    }
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                GLBusiness_DetailProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_DetailProjectCell"];
                cell.selectionStyle = 0;
                
                cell.dataSourceArr = self.model.sev_photo;
                cell.detailLabel.text = self.model.info;
                cell.delegate = self;
                
                return cell;
                
            }else if(indexPath.row == 1){
                
                GLBusiness_ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_ChooseCell"];
                cell.selectionStyle = 0;
                
                cell.delegate = self;
                return cell;
            }
        }
            break;
        default:
        {
            GLBusiness_DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_DetailCommentCell"];
            cell.selectionStyle = 0;
            
            GLBusiness_CommentModel *model = self.model.invest_list[indexPath.row];
            model.linkman = self.model.linkman;
            model.signIndex = 0;
            
            cell.delegate = self;
            cell.model = model;
            return cell;
        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        if(indexPath.row == 1){
         
            return 280;
        }else{
            
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.estimatedRowHeight = 44;
            return tableView.rowHeight;
        }
    }
    
      return self.model.invest_list[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    self.hidesBottomBarWhenPushed = YES;
//    GLBusiness_DetailController *detailVC = [[GLBusiness_DetailController alloc] init];
//    [self.navigationController pushViewController:detailVC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
}

@end
