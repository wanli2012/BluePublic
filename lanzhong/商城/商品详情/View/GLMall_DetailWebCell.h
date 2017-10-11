//
//  GLMall_DetailWebCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMall_DetailWebCell : UITableViewCell

@property (nonatomic, copy)NSString *url;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
