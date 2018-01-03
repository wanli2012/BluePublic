//
//  GLPublish_WebsiteController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/2.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_WebsiteController.h"

@interface GLPublish_WebsiteController ()
@property (weak, nonatomic) IBOutlet UILabel *webLabel;

@end

@implementation GLPublish_WebsiteController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}


/**
 复制文本

 @param longGes 长按手势
 */

- (IBAction)copyContent:(UILongPressGestureRecognizer *)longGes {
    
    if (longGes.state == UIGestureRecognizerStateBegan) {
        
        [MBProgressHUD showSuccess:@"复制成功!"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.webLabel.text;
    }
}

/**
 返回

 @param sender
 */
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
