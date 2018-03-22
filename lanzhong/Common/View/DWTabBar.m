//
//  DWTabBar.m
//  DWCustomTabBarDemo
//
//  Created by Damon on 10/20/15.
//  Copyright © 2015 damonwong. All rights reserved.
//

#import "DWTabBar.h"
#import "DWPublishButton.h"

#define ButtonNumber 5

@interface DWTabBar ()

@property (nonatomic, strong) DWPublishButton *publishButton;/**< 发布按钮 */
@property (nonatomic,assign)UIEdgeInsets oldSafeAreaInsets;

@end

@implementation DWTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        DWPublishButton *button = [DWPublishButton publishButton];
        [self addSubview:button];
        self.publishButton = button;
        
    }
    
    return self;
}

- (void) safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    if(self.oldSafeAreaInsets.left != self.safeAreaInsets.left || self.oldSafeAreaInsets.right != self.safeAreaInsets.right || self.oldSafeAreaInsets.top != self.safeAreaInsets.top || self.oldSafeAreaInsets.bottom != self.safeAreaInsets.bottom) {
        self.oldSafeAreaInsets = self.safeAreaInsets;
        [self invalidateIntrinsicContentSize];
        [self.superview setNeedsLayout];
        [self.superview layoutSubviews];
    }
}

- (CGSize) sizeThatFits:(CGSize) size {
    CGSize s = [super sizeThatFits:size];
    if(@available(iOS 11.0, *)) {
        CGFloat bottomInset = self.safeAreaInsets.bottom;
        if( bottomInset > 0 && s.height < 50) {
            s.height += bottomInset;
        }
    }
    return s;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat barWidth = self.frame.size.width;
    CGFloat barHeight = self.frame.size.height;
    
    CGFloat buttonW = barWidth / ButtonNumber;
    CGFloat buttonH = barHeight - 2;
    CGFloat buttonY = 1;
    
    NSInteger buttonIndex = 0;
    
    self.publishButton.center = CGPointMake(barWidth * 0.5, barHeight * 0.4);
    
    for (UIView *view in self.subviews) {
        
        NSString *viewClass = NSStringFromClass([view class]);
        if (![viewClass isEqualToString:@"UITabBarButton"]) continue;

        CGFloat buttonX = buttonIndex * buttonW;
//        if (buttonIndex >= 2) { // 右边2个按钮
//            buttonX += buttonW;
//        }
        if(kSCREEN_HEIGHT == 812){
            buttonH = 50;
        }
        view.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        buttonIndex ++;
    }
}

@end
