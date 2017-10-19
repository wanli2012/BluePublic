//
//  GLBusiness_DetailModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailModel.h"

@implementation GLBusiness_HeartModel

@end

@implementation GLBusiness_CommentModel

- (CGFloat)cellHeight{
    
  
//   CGSize replySize = [self.reply boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 80, kSCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    CGSize commentSize = [self.comment boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 70, kSCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;

    CGRect replyRect;
    if(self.reply.length == 0){
        
        replyRect = CGRectZero;
        return 70 + commentSize.height + replyRect.size.height;
        
    }else{
        
        NSString *replyStr = [NSString stringWithFormat:@"回复:%@",self.reply];
        replyRect = [replyStr boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 85, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
        return 90 + commentSize.height + replyRect.size.height;
    }

//    return 70 + replyRect.size.height + commentSize.height;
}

@end

@implementation GLBusiness_DetailModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"invest_10":@"GLBusiness_HeartModel",
             @"invest_list":@"GLBusiness_CommentModel"
             };
}

@end
