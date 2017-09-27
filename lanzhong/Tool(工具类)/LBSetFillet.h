//
//  LBSetFillet.h
//  lanzhong
//
//  Created by 四川三君科技有限公司 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBSetFillet : NSObject

//设置圆角
+(CAShapeLayer*)setFilletRoundedRect:(CGRect)rect cornerRadii:(CGSize)size;

@end
