//
//  GLMine_NoticeController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_NoticeController.h"
#import "GLHome_NoticeCell.h"

@interface GLHome_NoticeController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLHome_NoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"公告";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_NoticeCell" bundle:nil] forCellReuseIdentifier:@"GLHome_NoticeCell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_NoticeCell"];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
