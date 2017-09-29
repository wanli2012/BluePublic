//
//  GLPublish_FundraisingSuccessController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_FundraisingSuccessController.h"
#import "GLPublish_ProjectInProgressCell.h"

@interface GLPublish_FundraisingSuccessController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLPublish_FundraisingSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLPublish_ProjectInProgressCell" bundle:nil] forCellReuseIdentifier:@"GLPublish_ProjectInProgressCell"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLPublish_ProjectInProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLPublish_ProjectInProgressCell"];
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
@end
