//
//  predicateModel.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "predicateModel.h"

@implementation predicateModel
//判断网址格式是否正确
+ (BOOL)isValidateUrl:(NSString *)url
{
    NSString *      regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:url];
}

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile
{
    if (mobile.length == 11) {       // 判断是不是11位
        for (int i = 0; i < mobile.length; i++) {
            
            char c = [mobile characterAtIndex:i]; // 从NSString中获取单个字符
            if (c > 57 || c < 48) { // 判断是否是纯数字，比较ASCII码。0~9 对应ASCII范围 48 ~ 57
                return NO;
            } else {                    // 判断第一位是不是 1
                if (i == 0 && c != '1') {
                    return NO;
                }                // 判断第二位是不是 3 4 5 7 8 这些数字
                else if(i == 1 && c != '3' && c != '4' && c != '5' && c != '7' && c != '8') {
                    return NO;
                }
            }
        }
        return YES;
    }
    return NO;
}

//判断邮箱格式是否正确
+(BOOL)isValidateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)value{
    
    BOOL flag;
    if (value.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}$)";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:value];
    
}

+(BOOL) IsBankCard:(NSString *)bankCardNumber;
{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,21})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}

+(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fff)
        { return YES;
        }
    } return NO;
}

+(BOOL)judgePassWordLegal:(NSString *)pass{
    
      BOOL result = false;
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^[A-Za-z0-9]+$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];

       return result;
    
}

//直接调用这个方法就行
+(int)checkIsHaveNumAndLetter:(NSString*)password{
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, password.length)];
    
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    if (tNumMatchCount == password.length) {
        //全部符合数字，表示沒有英文
        return 1;
    } else if (tLetterMatchCount == password.length) {
        //全部符合英文，表示沒有数字
        return 2;
    } else if (tNumMatchCount + tLetterMatchCount == password.length) {
        //符合英文和符合数字条件的相加等于密码长度
        return 3;
    } else {
        return 4;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
    
}

#pragma mark - UITExtfield 输入判断

//只能输入字母或数字;
+ (BOOL)inputShouldLetterOrNum:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}
//只能输入字母
+ (BOOL)inputShouldLetter:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}
//只能输入数字
+ (BOOL)inputShouldNumber:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}
//判断全汉字
+ (BOOL)inputShouldChinese:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}



@end
