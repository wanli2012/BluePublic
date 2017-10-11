//
//  GLMall_DetailWebCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailWebCell.h"

@interface GLMall_DetailWebCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;

@end

@implementation GLMall_DetailWebCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.webView.scrollView.scrollEnabled = NO;
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGSize fittingSize = [self.webView sizeThatFits:CGSizeZero];
//        
//        self.webView.frame = CGRectMake(0, 0, fittingSize.width, fittingSize.height);
//        self.webViewHeight.constant = fittingSize.height;
//    }
//}

- (void)setUrl:(NSString *)url{
    _url = url;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];

}
//
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat webViewHeight = [webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    
    self.webViewHeight.constant = webViewHeight;
    self.webView.height = webViewHeight;
    
}


@end
