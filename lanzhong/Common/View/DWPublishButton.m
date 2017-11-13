//
//  DWPublishButton.m
//  DWCustomTabBarDemo
//
//  Created by Damon on 10/20/15.
//  Copyright © 2015 damonwong. All rights reserved.
//

#import "DWPublishButton.h"
#import "GLPublishController.h"
#import "DWTabBarController.h"
#import "BaseNavigationViewController.h"

@interface DWPublishButton ()<UIActionSheetDelegate>

@end

@implementation DWPublishButton

#pragma mark -
#pragma mark - Private Methods

//上下结构的 button
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 控件大小,间距大小
    CGFloat const imageViewEdge   = self.bounds.size.width * 0.6;
    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdge;
    CGFloat const verticalMargin  = verticalMarginT / 2;
    
    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdge * 0.5;
    CGFloat const centerOfTitleLabel = imageViewEdge  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;
    
    //imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdge, imageViewEdge);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    
    //title position 位置
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
    
}

#pragma mark -
#pragma mark - Life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    
    return self;
}

#pragma mark -
#pragma mark - Public Methods

+(instancetype)publishButton{
    
    DWPublishButton *button = [[DWPublishButton alloc]init];
    
    [button setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
    [button setTitle:@"发  布" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    
    [button sizeToFit];
    
    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
    
}
#pragma mark - Event Response

- (void)clickPublish {
    
    if ([UserModel defaultUser].loginstatus == NO) {
       
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    
    if ([[UserModel defaultUser].real_state integerValue] == 0 || [[UserModel defaultUser].real_state integerValue] == 2) {
        
        [SVProgressHUD showErrorWithStatus:@"请前往个人中心实名认证"];
        return;
    }else if([[UserModel defaultUser].real_state integerValue] == 3){
      
        [SVProgressHUD showErrorWithStatus:@"实名认证审核中,请等待"];
        return;
    }
    
    GLPublishController * publishVC = [[GLPublishController alloc] init];
    BaseNavigationViewController *publishNav = [[BaseNavigationViewController alloc] initWithRootViewController:publishVC];
    
    [[self topViewController] presentViewController:publishNav animated:YES completion:nil];
    
}

- (UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:self.window.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
