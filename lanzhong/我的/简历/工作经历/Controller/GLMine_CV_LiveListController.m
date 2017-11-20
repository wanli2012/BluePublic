//
//  GLMine_CV_LiveListController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_LiveListController.h"
#import "GLMine_CV_WorkCell.h"
#import "GLMine_CV_AddWorkLiveController.h"//添加工作经历

@interface GLMine_CV_LiveListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end


@implementation GLMine_CV_LiveListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"工作经历";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_WorkCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_WorkCell"];
    
    self.addBtn.layer.cornerRadius = 5.f;
    
}

- (IBAction)addWorkLife:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_CV_AddWorkLiveController *addVC = [[GLMine_CV_AddWorkLiveController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_CV_WorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_WorkCell"];
    cell.model = self.models[indexPath.row];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    return self.tableView.rowHeight;
 
}
@end
