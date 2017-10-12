//
//  GLPublish_FailedController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_FailedController.h"
#import "GLPublish_ReviewCell.h"

@interface GLPublish_FailedController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLPublish_FailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    return 110;
}

@end
