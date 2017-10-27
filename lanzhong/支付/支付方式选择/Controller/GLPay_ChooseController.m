//
//  GLPay_ChooseController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPay_ChooseController.h"
#import "GLPay_CompletedController.h"
#import "LBMineCenterPayPagesTableViewCell.h"
#import "GLOrderPayView.h"

@interface GLPay_ChooseController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *weixinSignImageV;
@property (weak, nonatomic) IBOutlet UIImageView *alipaySignImageV;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;//微信支付
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;//支付宝支付

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)  NSMutableArray *dataarr;
@property (strong, nonatomic)  NSMutableArray *selectB;
@property (assign, nonatomic)  NSInteger selectIndex;

@property (nonatomic, strong)GLOrderPayView *contentView;

@property (nonatomic, strong)UIView *maskView;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextView *messageTextV;//留言textView

@end

@implementation GLPay_ChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT;
    
    self.ensureBtn.layer.cornerRadius = 5.f;
    
    self.messageTextV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.messageTextV.layer.borderWidth = 1.f;
    
    [self switchPay:self.weixinBtn];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBMineCenterPayPagesTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterPayPagesTableViewCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popScrectView) name:@"input_PasswordNotification" object:nil];
    
    [self isShowPayInterface];
}
- (void)popScrectView{
    
    //弹出密码输入框
    CGFloat contentViewH = 300;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.contentView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, contentViewH);
        [self.contentView.passwordF becomeFirstResponder];
        
    }];
    
    self.maskView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    
    [window addSubview:self.maskView];
    [window addSubview:self.contentView];
    
}

-(void)isShowPayInterface{

    [self.dataarr addObject:@{@"image":@"余额",@"title":@"余额支付"}];
    [self.dataarr addObject:@{@"image":@"weixin",@"title":@"微信支付"}];
    [self.dataarr addObject:@{@"image":@"zhifubao",@"title":@"支付宝支付"}];
    
    [self setPayType];
}

- (void)setPayType {

    [self.selectB addObject:@YES];
    
    if (self.dataarr.count <= 1) {
        return;
    }
    
    for ( int i = 1 ; i < self.dataarr.count; i++) {
        [self.selectB addObject:@NO];
    }
    self.selectIndex = 0;
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

//选择方式
- (IBAction)switchPay:(UIButton *)sender {
    
    self.weixinBtn.layer.borderColor = YYSRGBColor(184, 184, 184, 0.5).CGColor;
    self.aliPayBtn.layer.borderColor = YYSRGBColor(184, 184, 184, 0.5).CGColor;
    
    sender.layer.borderColor = YYSRGBColor(170, 193, 255, 1).CGColor;
    
    if (sender == self.weixinBtn) {
        
        self.weixinSignImageV.hidden = NO;
        self.alipaySignImageV.hidden = YES;
        
    }else{
        
        self.weixinSignImageV.hidden = YES;
        self.alipaySignImageV.hidden = NO;
    }
}

//确认支付
- (IBAction)ensurePay:(id)sender {
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入登录密码";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([predicateModel checkIsHaveNumAndLetter:self.moneyTF.text] != 1){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"支持金额只能为数字"];
                
            });
            
            return;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"item_id"] = self.item_id;
        dict[@"money"] = self.moneyTF.text;
        dict[@"comment"] = self.messageTextV.text;
        dict[@"c_time"] = timeString;
        dict[@"upwd"] = alertVC.textFields.lastObject.text;
        
        switch (self.selectIndex) {
            case 0://余额
            {
                dict[@"paytype"] = @"3";
            }
                break;
            case 1://微信
            {
                dict[@"paytype"] = @"2";
            }
                break;
            case 2://支付宝
            {
                dict[@"paytype"] = @"1";
            }
                break;
            default:
                break;
        }
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kSUPPORT_URL paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                
                self.hidesBottomBarWhenPushed = YES;
                GLPay_CompletedController *completeVC = [[GLPay_CompletedController alloc] init];
                completeVC.item_id = self.item_id;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"supportNotification" object:nil];
                [self.navigationController pushViewController:completeVC animated:YES];
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
                
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];
        
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([self.messageTextV.text isEqualToString:@"留言"]) {
        
        self.messageTextV.textColor = [UIColor darkGrayColor];
        self.messageTextV.text = @"";
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if ([self.messageTextV.text isEqualToString:@""]) {
        
        self.messageTextV.textColor = [UIColor lightGrayColor];
        self.messageTextV.text = @"留言";
        
    }
    return YES;
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterPayPagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterPayPagesTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.payimage.image = [UIImage imageNamed:_dataarr[indexPath.row][@"image"]];
    cell.paytitile.text = _dataarr[indexPath.row][@"title"];
    
    if ([self.selectB[indexPath.row] boolValue] == NO) {
        
        cell.selectimage.image = [UIImage imageNamed:@"nochoice1"];
        
    }else{
        
        cell.selectimage.image = [UIImage imageNamed:@"mine_choice"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self choosePayType:indexPath.row];

    [self.tableView reloadData];
    
}

- (void)choosePayType:(NSInteger )index {
    
    if (self.selectIndex == -1) {
        
        BOOL a = [self.selectB[index] boolValue];
        [self.selectB replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!a]];
        self.selectIndex = index;
        
    }else{
        
        if (self.selectIndex == index) {
            return;
        }
        
        BOOL a = [self.selectB[index]boolValue];
        [self.selectB replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!a]];
        [self.selectB replaceObjectAtIndex:self.selectIndex withObject:[NSNumber numberWithBool:NO]];
        self.selectIndex = index;
    }
}

-(NSMutableArray*)dataarr{
    
    if (!_dataarr) {
        
        _dataarr = [NSMutableArray array];
    }
    
    return _dataarr;
}
-(NSMutableArray*)selectB{
    
    if (!_selectB) {
        _selectB=[NSMutableArray array];
    }
    
    return _selectB;
    
}
@end
