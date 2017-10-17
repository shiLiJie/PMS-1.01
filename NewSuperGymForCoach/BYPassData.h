//
//  BYPassData.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/7/19.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYPassData : NSObject
/**
 *  单例方法
 *
 *  @return 单例方法
 */
+ (instancetype)sharedTools;


//初始化字典穿到报告页面
-(NSDictionary *)passDicToChart:(NSMutableArray *)arrb//波形数组
                            arrc:(NSMutableArray *)arrc
                            arrd:(NSMutableArray *)arrd
                            arre:(NSMutableArray *)arre
                            arrf:(NSMutableArray *)arrf
                            arrg:(NSMutableArray *)arrg
                            arrh:(NSMutableArray *)arrh
                            arri:(NSMutableArray *)arri
                            arrj:(NSMutableArray *)arrj
                               b:(long)b//波形总和
                               c:(long)c
                               d:(long)d
                               e:(long)e
                               f:(long)f
                               g:(long)g
                               h:(long)h
                           sleep:(float)sleep//睡眠指数
                          jiaolv:(float)jiaolv
                            yiyu:(float)yiyu
                           happy:(float)happy;


//在cut之前检测的睡眠焦虑抑郁幸福感的值
-(NSDictionary *)fristCut:(NSMutableArray *)arrb
                     arri:(NSMutableArray *)arri
                     arrj:(NSMutableArray *)arrj
                        b:(long)b
                        c:(long)c
                        d:(long)d
                        e:(long)e
                        f:(long)f
                        g:(long)g
                        h:(long)h
                    sleep:(float)sleep
                   jiaolv:(float)jiaolv
                     yiyu:(float)yiyu
                    happy:(float)happy;

-(void)dictionaryAddObject:(NSMutableDictionary *)dict objectArr:(NSArray *)arr;
-(void)dictionaryAddObjectMore:(NSMutableDictionary *)dict objectArr:(NSArray *)arr;
-(NSString *)fileStrWithDic:(NSDictionary *)dict sleep:(float)sleep jiaolv:(float)jiaolv yiyu:(float)yiyu happy:(float)happy loaarr:(NSMutableArray *)lowaarr higharr:(NSMutableArray *)highaarr lowamax:(NSNumber *)lowamax highamax:(NSNumber *)highamax;
@end
