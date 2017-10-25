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
//#import "GLBusiness_trendCell.h"
#import "GLBusiness_ChooseCell.h"//资金动向和官方认证
#import "GLBusiness_CertificationController.h"//官方认证
#import "GLBusiness_LoveListController.h"
#import "GLBusiness_FundTrendController.h"//资金动向
#import "GLBusiness_DetailModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GLBusiness_Detail_heartCommentController.h"//更多评论

#import "GLPay_ChooseController.h"//选择支付界面

#import <UShareUI/UShareUI.h>

@interface GLBusiness_DetailController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,GLBusiness_ChooseCellDelegate,GLBusiness_DetailCommentCellDelegate>
{
    CGRect _rect;
}

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

-(void)refresh{
    
    [self postRequest:YES];
}

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
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
    }];
}

//为头视图赋值
- (void)headerViewFuzhi {
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.model.user_info_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.personNameLabel.text = self.model.linkman;
    self.targetMoneyLabel.text = [NSString stringWithFormat:@"%@元",self.model.admin_money];
    self.raisedLabel.text = [NSString stringWithFormat:@"%@元",self.model.draw_money];
    self.listNumLabel.text = [NSString stringWithFormat:@"榜单:%@人",self.model.invest_count];
    
    if (self.model.invest_10.count >= 1) {
        
        [self.iconImageV3 sd_setImageWithURL:[NSURL URLWithString:self.model.invest_10[0].must_user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        if (self.model.invest_10.count >= 2) {
            
            [self.iconImageV2 sd_setImageWithURL:[NSURL URLWithString:self.model.invest_10[1].must_user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
            if (self.model.invest_10.count >= 3) {
                
                [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:self.model.invest_10[2].must_user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
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
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",ratio * 100];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *DateTime = [formatter stringFromDate:date];
    
    
    NSTimeInterval time=[self.model.need_time doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];

    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *endDateStr = [dateFormatter stringFromDate: detaildate];

    NSInteger dayCount = [self getTheCountOfTwoDaysWithBeginDate:DateTime endDate:endDateStr];
    
    self.needTimeLabel.text = [NSString stringWithFormat:@"剩余时间%zd天",dayCount];
    
    
    if([self.model.state integerValue] == 3){
        self.supportBtn.enabled = YES;
        self.supportBtn.backgroundColor = MAIN_COLOR;
    }else{
        self.supportBtn.enabled = NO;
        self.supportBtn.backgroundColor = [UIColor lightGrayColor];
    }
}
/**任意两天相差天数*/
- (NSInteger)getTheCountOfTwoDaysWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *startD =[inputFormatter dateFromString:beginDate];
    NSDate *endD = [inputFormatter dateFromString:endDate];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:startD toDate:endD options:0];
    
    return dateCom.day;
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

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

- (IBAction)support:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLPay_ChooseController *payVC = [[GLPay_ChooseController alloc] init];
    payVC.item_id = self.item_id;
    [self.navigationController pushViewController:payVC animated:YES];

}

//爱心贡献榜
- (IBAction)contributionList:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_LoveListController *lovelistVC = [[GLBusiness_LoveListController alloc] init];
    lovelistVC.dataSourceArr = self.model.invest_10;
    [self.navigationController pushViewController:lovelistVC animated:YES];
    
}

- (IBAction)share:(id)sender {

    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"http://192.168.1.188:8080/item_details.html?item_id=%@",self.item_id];
    
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
            if (self.model.invest_list.count <= 2) {
                
                return self.model.invest_list.count;
                
            }else{
                
                return 2;
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
         
            return 180;
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
