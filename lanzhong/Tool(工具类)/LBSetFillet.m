//
//  LBSetFillet.m
//  lanzhong
//
//  Created by 四川三君科技有限公司 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBSetFillet.h"

@implementation LBSetFillet

+(CAShapeLayer*)setFilletRoundedRect:(CGRect)rect cornerRadii:(CGSize)size{

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    return  maskLayer;

}

@end
