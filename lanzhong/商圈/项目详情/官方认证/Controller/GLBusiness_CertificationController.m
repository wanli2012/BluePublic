//
//  GLBusiness_CertificationController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_CertificationController.h"

@interface GLBusiness_CertificationController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GLBusiness_CertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"官方认证";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString *url = [NSString stringWithFormat:@"http://192.168.1.186/Raise/index.php/Api/Item/item_content?item_id=%@",self.item_id];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
                             
//    self.webView.scrollView.scrollEnabled = NO;
//    self.webView.scrollView;
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"kaishi jiazai le  ");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    CGFloat webViewHeight=[webView.scrollView contentSize].height;
//    CGRect newFrame = webView.frame;
//    newFrame.size.height = webViewHeight;
//    
//    newFrame = CGRectMake(0, 0, kSCREEN_WIDTH, newFrame.size.height + 10);
//    
//    self.webView.frame = newFrame;
}



@end
