//
//  GLBusiness_trendCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_trendCell.h"
#import "GLBusiness_tradeSubCell.h"

@interface GLBusiness_trendCell ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLBusiness_trendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_tradeSubCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_tradeSubCell"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.webView loadRequest:request];
    self.webView.scrollView.scrollEnabled = NO;
    
}

- (IBAction)seletedItem:(UISegmentedControl *)sender {
    if ([self.delegate respondsToSelector:@selector(seletedItem:)]) {
        [self.delegate selectedItem:sender.selectedSegmentIndex];
    }
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            NSLog(@"0");
            self.webView.hidden = NO;
        }
            break;
        case 1:
        {
            NSLog(@"1");
            self.webView.hidden = YES;
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
    
//    if (indexPath.row == 0) {
//        GLBusiness_DetailProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_DetailProjectCell"];
//        cell.selectionStyle = 0;
//        return cell;
//        
//    }else{
//        
//        GLBusiness_DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_DetailCommentCell"];
//        cell.selectionStyle = 0;
//        return cell;
//    }
    
    GLBusiness_tradeSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_tradeSubCell"];
    cell.selectionStyle = 0;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    return tableView.rowHeight;
}

@end
