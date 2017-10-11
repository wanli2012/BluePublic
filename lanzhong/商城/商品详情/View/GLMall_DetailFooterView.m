//
//  GLMall_DetailFooterView.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailFooterView.h"

@implementation GLMall_DetailFooterView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.webView loadRequest:request];

}

@end
