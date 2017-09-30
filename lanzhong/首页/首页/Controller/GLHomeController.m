//
//  GLHomeController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeController.h"
#import "GLHomeCell.h"

#import "GLPay_ChooseController.h"//支付选择
#import "GLHome_CasesController.h"//经典案例

@interface GLHomeController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIView *noticeLayerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *middleViewLayerView;

//切换要用到的控件
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@end

@implementation GLHomeController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headerView.height = 250;
    
    self.segment.selectedSegmentIndex = 1;
    
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
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHomeCell" bundle:nil] forCellReuseIdentifier:@"GLHomeCell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)more:(id)sender {
    NSLog(@"更多");
    self.hidesBottomBarWhenPushed = YES;
    GLHome_CasesController *caseVC = [[GLHome_CasesController alloc] init];
    [self.navigationController pushViewController:caseVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (IBAction)notice:(id)sender {
    NSLog(@"公告详情");
}

- (IBAction)switchSelected:(id)sender {
    
    UISegmentedControl* control = (UISegmentedControl*)sender;
    
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                self.titleLabel.text = @"蓝众大数据";
                self.label.text = @"蓝众人数";
                self.label2.text = @"蓝众项目";
                self.label3.text = @"蓝众资金";
            }];
            
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                self.titleLabel.text = @"爱心大数据";
                self.label.text = @"爱心人数";
                self.label2.text = @"帮扶项目";
                self.label3.text = @"爱心资金";
            }];
        }
            
            break;
            
        default:
            
            break;
    }

}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHomeCell"];
    cell.selectionStyle = 0;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    GLPay_ChooseController *payVC = [[GLPay_ChooseController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
@end
