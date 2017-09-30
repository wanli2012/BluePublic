//
//  GLPay_CompletedController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPay_CompletedController.h"
#import "GLPublish_ReviewCell.h"

@interface GLPay_CompletedController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation GLPay_CompletedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkBtn.layer.cornerRadius = 5.f;
    self.navigationItem.title = @"支付成功";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLPublish_ReviewCell" bundle:nil] forCellReuseIdentifier:@"GLPublish_ReviewCell"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLPublish_ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLPublish_ReviewCell"];
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

//查看项目
- (IBAction)checkOut:(id)sender {
    NSLog(@"查看项目");
}

@end
