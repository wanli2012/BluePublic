//
//  GLTalent_CVModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/22.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLTalent_CVModel : NSObject

@property (nonatomic, copy)NSString *resume_id;//简历id
@property (nonatomic, copy)NSString *name;//姓名
@property (nonatomic, copy)NSString *sex;//性别 1男 2女
@property (nonatomic, copy)NSString *phone;//电话
@property (nonatomic, copy)NSString *education;//学历
@property (nonatomic, copy)NSString *work_id;//工作时限
@property (nonatomic, copy)NSString *birth_time;//出生年月
@property (nonatomic, copy)NSString *duty;//期望职业
@property (nonatomic, copy)NSString *want_wages;//期望薪资
@property (nonatomic, copy)NSString *want_province;//期望工作省份
@property (nonatomic, copy)NSString *want_city;//期望工作城市
@property (nonatomic, copy)NSString *head_pic;//头像

@end
