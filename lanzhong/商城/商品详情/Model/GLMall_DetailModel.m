//
//  GLMall_DetailModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailModel.h"

@implementation GLDetail_GoodsDetail

@end

@implementation GLDetail_comment_data

- (CGFloat)cellHeight{
    
    CGRect commentRect = [self.comment boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
    
    CGRect replyRect;
    if(self.reply.length == 0){
        
        replyRect = CGRectZero;
        return 70 + commentRect.size.height + replyRect.size.height;
        
    }else{
        
        NSString *replyStr = [NSString stringWithFormat:@"回复:%@",self.reply];
        replyRect = [replyStr boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 85, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
        return 90 + commentRect.size.height + replyRect.size.height;
    }
}

@end

@implementation GLDetail_spec

@end

@implementation GLMall_DetailModel


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"comment_data":@"GLDetail_comment_data",
             @"spec":@"GLDetail_spec"
             };
}


@end
