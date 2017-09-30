//
//  GLBusiness_FundTrendController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_FundTrendController.h"
#import "GLBusiness_FundTrendCell.h"

@interface GLBusiness_FundTrendController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLBusiness_FundTrendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资金动向";

    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_FundTrendCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_FundTrendCell"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBusiness_FundTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_FundTrendCell"];
    cell.selectionStyle = 0;
    
    if (indexPath.row == 0) {
        
        cell.topImageV.hidden = YES;
        cell.bottomImageV.hidden = NO;
        
    }else if(indexPath.row == 2){
        
        cell.topImageV.hidden = NO;
        cell.bottomImageV.hidden = YES;
    }else{
        cell.topImageV.hidden = NO;
        cell.bottomImageV.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    return tableView.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
    label.text = @"项目支出明细";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
@end
