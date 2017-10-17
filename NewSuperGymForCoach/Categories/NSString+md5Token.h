//
//  NSString+md5Token.h
//  Http929Demo
//
//  Created by 凤凰八音 on 16/11/4.
//  Copyright © 2016年 铅笔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (md5Token)

/**
 *  获取MD5token
 *
 *  @return <#return value description#>
 */
+ (NSString *)md5WithString;

/**
 *  md5编码
 *
 *  @return <#return value description#>
 */
- (NSString *) stringFromMD5;

/**
 *  获取网络请求后返回的result里的msg
 *
 *  @param obj response的obj
 *
 *  @return <#return value description#>
 */
+(NSString *)getResponseMsgWithObject:(id)obj;

/**
 *  登录注册过后取出用户uid
 *
 *  @param obj response的obj
 *
 *  @return <#return value description#>
 */
+(NSString *)getResponseUIDWithObject:(id)obj;
@end
