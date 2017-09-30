//
//  GLPublish_FundraisingController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_FundraisingController.h"
#import "GLPublish_FundraisingCell.h"

@interface GLPublish_FundraisingController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLPublish_FundraisingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLPublish_FundraisingCell" bundle:nil] forCellReuseIdentifier:@"GLPublish_FundraisingCell"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLPublish_FundraisingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLPublish_FundraisingCell"];
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

@end
