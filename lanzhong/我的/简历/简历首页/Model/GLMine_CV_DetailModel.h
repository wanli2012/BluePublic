//
//  GLMine_CV_DetailModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_CV_basic : NSObject
@property (nonatomic, copy)NSString *birth_time;//出生年月
@property (nonatomic, copy)NSString *city_id;
@property (nonatomic, copy)NSString *city_name;
@property (nonatomic, copy)NSString *education;//现在学历
@property (nonatomic, copy)NSString *email;
@property (nonatomic, copy)NSString *head_pic;//头像
@property (nonatomic, copy)NSString *i_info;//自我描述
@property (nonatomic, copy)NSString *is_open;//是否展示 1展示 2不展示
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *phone;//联系电话
@property (nonatomic, copy)NSString *province_id;
@property (nonatomic, copy)NSString *province_name;
@property (nonatomic, copy)NSString *resume_id;//简历id
@property (nonatomic, copy)NSString *save_time;//更新时间 时间戳
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSArray *show_photo;//风采展示图片 序列化
@property (nonatomic, copy)NSString *uid;//用户id
@property (nonatomic, copy)NSString *work;//工作时间

@end

@interface GLMine_CV_teach : NSObject
@property (nonatomic, copy)NSString *education_leave;//毕业学历
@property (nonatomic, copy)NSString *leave_time;//离校时间
@property (nonatomic, copy)NSString *major;//教育经历 专业
@property (nonatomic, copy)NSString *school;//教育经历 学校
@end

@interface GLMine_CV_want : NSObject
@property (nonatomic, copy)NSString *want_city_id;//期望工作城市id
@property (nonatomic, copy)NSString *want_city_name;//期望工作城市
@property (nonatomic, copy)NSString *want_duty;//期望 职业
@property (nonatomic, copy)NSString *want_province_id;//期望工作省份id
@property (nonatomic, copy)NSString *want_province_name;//期望工作省份
@property (nonatomic, copy)NSString *want_wages;//期望薪资
@end

@interface GLMine_CV_skill : NSObject

@property (nonatomic, copy)NSString *skill_id;//评价id
@property (nonatomic, copy)NSString *skill_name;//技能名称
@property (nonatomic, copy)NSString *mastery;//熟练度1了解 2掌握 3熟练 4精通 5专家

@end

@interface GLMine_CV_live : NSObject

@property (nonatomic, copy)NSString *live_id;//工作经历id
@property (nonatomic, copy)NSString *company_name;//公司名称
@property (nonatomic, copy)NSString *career_name;//职业
@property (nonatomic, copy)NSString *work_time;//工作时间
@property (nonatomic, copy)NSString *work_content;//工作内容

@end

@interface GLMine_CV_DetailModel : NSObject

@property (nonatomic, strong)GLMine_CV_basic *basic;
@property (nonatomic, copy)NSArray <GLMine_CV_live *>*live;
@property (nonatomic, copy)NSArray <GLMine_CV_skill *>*skill;
@property (nonatomic, strong)GLMine_CV_teach *teach;
@property (nonatomic, strong)GLMine_CV_want *want;

@end
