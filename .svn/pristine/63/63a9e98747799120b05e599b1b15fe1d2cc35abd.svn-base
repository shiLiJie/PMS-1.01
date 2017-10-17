//
//  BYNotificationTools.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/6/22.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import "SLJNotificationTools.h"

@implementation SLJNotificationTools
/**
 *  发送通知
 *
 *  @param dict       字典, 可有可无
 *  @param methodName 通知名字
 */
+(void)postNotification:(id)dict methodName:(NSString *)methodName
{
    NSNotification *notification = [NSNotification notificationWithName:methodName object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

/**
 *  接收通知
 *
 *  @param selector   接收通知后执行的方法
 *  @param methodName 字典, 基本没有
 */
+(void)addaddObserver:(id)addObserver selector:(SEL)selector methodName:(NSString *)methodName
{
    [[NSNotificationCenter defaultCenter] addObserver:addObserver selector:selector name:methodName object:nil];
}

@end
