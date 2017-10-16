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
@property (weak, nonatomic) IBOutlet UITextView *messageTextV;//留言textView

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)  NSMutableArray *dataarr;
@property (strong, nonatomic)  NSMutableArray *selectB;
@property (assign, nonatomic)  NSInteger selectIndex;

@property (nonatomic, strong)GLOrderPayView *contentView;

@property (nonatomic, strong)UIView *maskView;

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
    
    //没有米劵
    //    if ([[UserModel defaultUser].mark floatValue] == 0.0) {
    //
    //        for ( int i = 0 ; i < self.dataarr.count; i++) {
    //            [self.selectB addObject:@NO];
    //        }
    //
    //    }else{
    //
    [self.selectB addObject:@YES];
    
    if (self.dataarr.count <= 1) {
        return;
    }
    
    for ( int i = 1 ; i < self.dataarr.count; i++) {
        [self.selectB addObject:@NO];
    }
    self.selectIndex = 0;
    //    }
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
    NSLog(@"确认支付");
    
    self.hidesBottomBarWhenPushed = YES;
    GLPay_CompletedController *completeVC = [[GLPay_CompletedController alloc] init];
    [self.navigationController pushViewController:completeVC animated:YES];
    
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
