//
//  GLMine_WalletDetailController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_WalletDetailController.h"
//#import "GLMine_WalletDetailCell.h"
#import "GLMine_WalletExchangeController.h"//兑换
#import "GLMine_WalletRechargeController.h"//充值

@interface GLMine_WalletDetailController ()
@property (nonatomic, strong)GLMine_WalletExchangeController *exchangeVC;
@property (nonatomic, strong)GLMine_WalletRechargeController *rechargeVC;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIViewController *currentViewController;
//@property (weak, nonatomic) IBOutlet UITableView *exchangeTableView;//兑换tableView
//@property (weak, nonatomic) IBOutlet UITableView *rechargeTableView;//充值tableView
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;//兑换
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;//充值

@end

@implementation GLMine_WalletDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"明细";

    _exchangeVC = [[GLMine_WalletExchangeController alloc]init];
    _rechargeVC = [[GLMine_WalletRechargeController alloc]init];

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-154)];
    [self.view addSubview:_contentView];
    
    [self addChildViewController:self.exchangeVC];
    [self addChildViewController:self.rechargeVC];

    
    self.currentViewController = self.exchangeVC;
    [self fitFrameForChildViewController:self.exchangeVC];
    [self.contentView addSubview:self.exchangeVC.view];
    
    [self buttonEvent:self.exchangeBtn];
    
//    __block typeof(self) bself = self;
//    _encourageVC.retureValue = ^(NSString *remainBeans){
//        
//        _firstBeanRemainNum = [remainBeans floatValue];
//        [bself changeColor:bself.beanRemainLabel rangeNumber:[remainBeans floatValue]];
//    };
//    _recommendVC.retureValue = ^(NSString *remainBeans){
//        _secondBeanRemainNum = [remainBeans floatValue];
//        [bself changeColor:bself.beanRemainLabel rangeNumber:[remainBeans floatValue]];
//    };
//    _receiveVC.retureValue = ^(NSString *remainBeans){
//        _thirdBeanRemainNum = [remainBeans floatValue];
//        [bself changeColor:bself.beanRemainLabel rangeNumber:[remainBeans floatValue]];
//    };

    
}
- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}

//按钮点击事件
- (IBAction)buttonEvent:(UIButton *)sender {
    
    [self.exchangeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.rechargeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.exchangeBtn.backgroundColor = [UIColor whiteColor];
    self.rechargeBtn.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor = YYSRGBColor(0, 126, 255, 1);
    
    if (sender == self.exchangeBtn) {
        
        [self transitionFromVC:self.currentViewController toviewController:self.exchangeVC];
        [self fitFrameForChildViewController:self.exchangeVC];
        
    }else{
        
        [self transitionFromVC:self.currentViewController toviewController:self.rechargeVC];
        [self fitFrameForChildViewController:self.rechargeVC];
        
    }
}

- (void)transitionFromVC:(UIViewController *)viewController toviewController:(UIViewController *)toViewController {
    
    if ([toViewController isEqual:self.currentViewController]) {
        return;
    }
    [self transitionFromViewController:viewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:^(BOOL finished) {
        [viewController willMoveToParentViewController:nil];
        [toViewController willMoveToParentViewController:self];
        self.currentViewController = toViewController;
    }];
}

//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}
//
//- (IBAction)switchItem:(UIButton *)sender {
//    
//    [self.exchangeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [self.rechargeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    self.exchangeBtn.backgroundColor = [UIColor whiteColor];
//    self.rechargeBtn.backgroundColor = [UIColor whiteColor];
//    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    sender.backgroundColor = YYSRGBColor(0, 126, 255, 1);
//    
//    if (sender == self.exchangeBtn) {
//        NSLog(@"兑换");
//    }else{
//        NSLog(@"充值");
//    }
//    
//}
//
//#pragma mark - UITableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return 3;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    GLMine_WalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_WalletDetailCell"];
//    cell.selectionStyle = 0;
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 60;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
//    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
//    imageV.backgroundColor = [UIColor redColor];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 10, imageV.y, kSCREEN_WIDTH - 50, 20)];
//    label.text = @"2017.02";
//    
//    label.font = [UIFont systemFontOfSize:17];
//    label.textColor = [UIColor blackColor];
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(label.x, 39, kSCREEN_WIDTH - 50, 1)];
//    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    
//    [view addSubview:imageV];
//    [view addSubview:label];
//    [view addSubview:lineView];
//    
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

@end
