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

@property (nonatomic, copy)NSString  *experience;//经验值
@property (nonatomic, copy)NSString  *groupid;//身份
@property (nonatomic, copy)NSString  *userId;//用户id
@property (nonatomic, copy)NSString  *number_name;//等级
@property (nonatomic, copy)NSString  *phone;//手机号
@property (nonatomic, copy)NSString  *portrait;//
@property (nonatomic, copy)NSString  *token;
@property (nonatomic, copy)NSString  *user_name;//用户名

+(UserModel*)defaultUser;

@end
