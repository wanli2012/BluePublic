//
//  GLBusiness_trendCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLBusiness_trendCellDelegate <NSObject>

- (void)selectedItem:(NSInteger)selectedSegmentIndex;

@end

@interface GLBusiness_trendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, weak)id <GLBusiness_trendCellDelegate> delegate;

@end
