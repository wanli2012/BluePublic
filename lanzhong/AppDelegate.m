//
//  AppDelegate.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "DWTabBarController.h"
#import "BaseNavigationViewController.h"

#import "GLLoginController.h"

#import "yindaotuViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMMobClick/MobClick.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    //统计集成
    UMConfigInstance.appKey = USHARE_APPKEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc] initWithRootViewController:[[GLLoginController alloc] init]];
    self.window.rootViewController = loginNav;
    
    [self.window makeKeyAndVisible];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isdirect1"] isEqualToString:@"YES"]) {
        
        self.window.rootViewController = [[DWTabBarController alloc]init];

    }else{
        self.window.rootViewController = [[yindaotuViewController alloc]init];
    }

    return YES;
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}
- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WEIXIN_APPKEY appSecret:WEIXIN_APPSECRET redirectURL:nil];


    /* 支付宝的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:nil];
    
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"pay"]) {
            
            return [WXApi handleOpenURL:url delegate:self];
            
        }else if ([url.host isEqualToString:@"safepay"]){
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

            }];
        }
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
// NOTE: 9.0以后使用新API接口
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    if ([url.host isEqualToString:@"pay"]) {
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }else if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Alipaysucess" object:nil];
                
            }else{
                NSString *returnStr;
                switch (orderState) {
                    case 8000:
                        returnStr=@"订单正在处理中";
                        break;
                    case 4000:
                        returnStr=@"订单支付失败";
                        break;
                    case 6001:
                        returnStr=@"订单取消";
                        break;
                    case 6002:
                        returnStr=@"网络连接出错";
                        break;
                        
                    default:
                        break;
                }

                [SVProgressHUD showErrorWithStatus:returnStr];
                
            }
        }];
    }
    
    return YES;
    
}
/**
 *微信支付
 */
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wxpaysucess" object:nil];
                [SVProgressHUD showSuccessWithStatus:strMsg];
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付结果：取消！";
                [SVProgressHUD showErrorWithStatus:strMsg];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败"];
                [SVProgressHUD showErrorWithStatus:strMsg];
                break;
        }
    }

}

@end
