//
//  GLTrainDetailController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/12/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLTrainDetailController.h"
#import "GLTrainDetailModel.h"

@interface GLTrainDetailController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeight;

@property (nonatomic, strong)GLTrainDetailModel *model;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLTrainDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"培训详情";
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 700;
    
//    self.webView.scrollView.backgroundColor = YYSRGBColor(250, 250, 250, 1);
    
    [self postRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)postRequest {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    dic[@"train_id"] = self.train_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kTrain_Detail_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            self.model = nil;
            if([responseObject[@"data"] count] != 0){
                self.model = [GLTrainDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self fuzhi];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
}

- (void)fuzhi{
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[formattime formateTimeOfDate4:self.model.start_time],[formattime formateTimeOfDate4:self.model.end_time]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.train_money];
    self.numberLabel.text = [NSString stringWithFormat:@"限额: %@",self.model.num];
    self.benefitLabel.text = [NSString stringWithFormat:@"%@",self.model.gain];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://www.lzcke.com/index.php/Api/Train/train_data?train_id=%@",self.train_id];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    
    CGRect rect = [self.model.gain boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    
    self.contentViewHeight.constant = 440 + rect.size.height;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    
    CGRect rect = [self.model.gain boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    self.detailHeight.constant = webViewHeight + 60;
    self.contentViewHeight.constant = 440 + rect.size.height + webViewHeight;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
        self.webView.frame = CGRectMake(0, 0, fittingSize.width, fittingSize.height);
        
        CGRect rect = [self.model.gain boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
        
        self.contentViewHeight.constant = 440 + rect.size.height + fittingSize.height;
    }
}

@end
