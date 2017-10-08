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

@property (nonatomic, copy)NSString  *address;//
@property (nonatomic, copy)NSString  *area;//
@property (nonatomic, copy)NSString  *city;//
@property (nonatomic, copy)NSString  *del;//
@property (nonatomic, copy)NSString  *face_pic;//
@property (nonatomic, copy)NSString  *g_id;//
@property (nonatomic, copy)NSString  *g_name;//
@property (nonatomic, copy)NSString  *idcard;//
@property (nonatomic, copy)NSString  *is_help;//
@property (nonatomic, copy)NSString  *pay_pwd;//
@property (nonatomic, copy)NSString  *phone;//
@property (nonatomic, copy)NSString  *province;//
@property (nonatomic, copy)NSString  *real_state;//
@property (nonatomic, copy)NSString  *real_time;//
@property (nonatomic, copy)NSString  *token;//token
@property (nonatomic, copy)NSString  *truename;//
@property (nonatomic, copy)NSString  *uid;//
@property (nonatomic, copy)NSString  *umark;//
@property (nonatomic, copy)NSString  *umoney;//
@property (nonatomic, copy)NSString  *uname;//
@property (nonatomic, copy)NSString  *upwd;//
@property (nonatomic, copy)NSString  *user_pic;//




+(UserModel*)defaultUser;

@end
