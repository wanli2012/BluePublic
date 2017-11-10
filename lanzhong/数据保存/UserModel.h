//
//  UserModel.h
//  813DeepBreathing
//
//  Created by rimi on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>

@property (nonatomic, assign)BOOL needAutoLogin;

@property (nonatomic, assign)BOOL loginstatus;//登陆状态

@property (nonatomic, copy)NSString  *address;//详细地址
@property (nonatomic, copy)NSString  *area;//区id
@property (nonatomic, copy)NSString  *city;//市id
@property (nonatomic, copy)NSString  *del;// 禁用账号   1确定   0否
@property (nonatomic, copy)NSString  *face_pic;//身份证正反面照片（序列化）  不用管  不用
@property (nonatomic, copy)NSString  *g_id;//分享注册人id
@property (nonatomic, copy)NSString  *g_name;//推荐人姓名
@property (nonatomic, copy)NSString  *idcard;//身份证号码
@property (nonatomic, copy)NSString  *is_help;//是否已捐助  0否  1是
@property (nonatomic, copy)NSString  *phone;//电话
@property (nonatomic, copy)NSString  *province;//省id
@property (nonatomic, copy)NSString  *real_state;//实名认证状态 0未认证  1成功   2失败   3审核中
@property (nonatomic, copy)NSString  *real_time;//认证时间
@property (nonatomic, copy)NSString  *token;// token
@property (nonatomic, copy)NSString  *truename;//真实姓名
@property (nonatomic, copy)NSString  *uid;//
@property (nonatomic, copy)NSString  *umark;//积分
@property (nonatomic, copy)NSString  *umoney;// 用户余额
@property (nonatomic, copy)NSString  *uname;//用户名
@property (nonatomic, copy)NSString  *nickname;//昵称
@property (nonatomic, copy)NSString  *user_pic;//头像
@property (nonatomic, copy)NSString  *upwd;//
@property (nonatomic, copy)NSString  *pay_pwd;//

@property (nonatomic, copy)NSString  *invest_count;//我参与项目数量统计
@property (nonatomic, copy)NSString  *item_count;//我的项目数量统计
@property (nonatomic, copy)NSString  *user_server;//客服电话

+(UserModel*)defaultUser;

@end
