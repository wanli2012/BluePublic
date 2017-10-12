//
//  GLPublish_ProjectCompletedController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_ProjectCompletedController.h"
#import "GLPublish_ProjectCell.h"

@interface GLPublish_ProjectCompletedController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLPublish_ProjectCompletedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLPublish_ProjectCell" bundle:nil] forCellReuseIdentifier:@"GLPublish_ProjectCell"];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLPublish_ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLPublish_ProjectCell"];
    
    cell.fundTrendBtn.hidden = YES;
    cell.numberLabel.hidden = NO;
    cell.arrowImageV.hidden = YES;
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
@end
