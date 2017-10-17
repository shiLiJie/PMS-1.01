//
//  BYPassData.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/7/19.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import "BYPassData.h"

static BYPassData *_sharedModel = nil;

@implementation BYPassData

/**
 *  单例方法
 *
 *  @return 单例方法
 */
+ (instancetype)sharedTools {
    if (!_sharedModel) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedModel = [[self alloc] init];
        });
    }
    return _sharedModel;
}

-(NSDictionary *)passDicToChart:(NSMutableArray *)arrb
                           arrc:(NSMutableArray *)arrc
                           arrd:(NSMutableArray *)arrd
                           arre:(NSMutableArray *)arre
                           arrf:(NSMutableArray *)arrf
                           arrg:(NSMutableArray *)arrg
                           arrh:(NSMutableArray *)arrh
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
                          happy:(float)happy{
    //上边八组数组的的总数
    NSNumber *sum1 = [arrb valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum2 = [arrc valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum3 = [arrd valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum4 = [arre valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum5 = [arrf valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum6 = [arrg valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum7 = [arrh valueForKeyPath:@"@max.floatValue"];
    //冥想关注的数组总数
    NSNumber *sum8 = [arri valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum9 = [arrj valueForKeyPath:@"@max.floatValue"];
    
    
    
    int GuanMax = 0;//关注大于冥想的时长
    int MingMax = 0;//冥想大于关注的时长
    
    int GuanTotal = 0;//关注比冥想大的总值
    int MingTotal = 0;//冥想比关注大的总值
    
    //循环冥想关注数组
    for (int i = 0; i <arri.count; i++) {
        // 关注 - 冥想
        int value = [arri[i] intValue] - [arrj[i] intValue];
        //如果大于零
        if (value >0) {
            // GuanTotal 是实际差值
            GuanTotal += value;
            value = 1;
            // GuanMax 是把差值化为1 也就是秒数 压制了多少秒
            GuanMax += value;
        }else if (value <0){//如果小于零 就是冥想压制关注
            MingTotal += value;
            value = -1;
            
            MingMax += value;
        }
    }
    
    float tota = GuanMax+(-MingMax); // 秒数总和
    float tot = GuanTotal+(-MingTotal); // 实际差值总和
    
    float i = GuanMax/tota; // 秒数百分比

    
    float iiii = GuanTotal/tot; // 差值百分比
    float jjjj = -(MingTotal)/tot;
    
    
    float total = b + c + d + e + f + g + h; // 所有数据的总和值
    
    //这些事上边八组数据占总数的百分比
    float lowa = b/total; // lowa百分比
    float lowb = c/total; // lowb百分比
    float lowg = d/total; // lowg百分比
    float highg = e/total; // highg百分比
    float theta = f/total; // theta百分比
    float hihga = g/total; // hihga百分比
    float highb = h/total; // highb百分比
    
    // 睡眠 ——  冥想高于关注时长的百分比
    float j = GuanMax/tota;
    
    // 焦虑 ——  伽马占整个的比 5 —— 20 区间换算
    float JiaoLv = lowg + highg;
    if (JiaoLv <= 5) {//小于等于5
        JiaoLv = 0;//为0
    }else if (JiaoLv >= 20){//大于等于20
        JiaoLv = 0.9;//为100
    }else{
        JiaoLv = (JiaoLv - 5) * 6.6;//中间区间换算
    }
    
    // 抑郁 ——  斯塔波占整个的百分比 75 ——— 95 区间换算
    float YiYu = theta;
    if (YiYu <= 75) {//小于等于5
        YiYu = 0;//为0
    }else if (YiYu >= 95){//大于等于20
        YiYu = 0.9;//为100
    }else{
        YiYu = (YiYu - 75) * 5;//中间区间换算
    }
    
    // 幸福感 —— 阿尔法波占整个的百分比
    float Happy = lowa + hihga;
    //这里算出需要的数据,然后保存然后赋予key值,下面的方法中取出key值
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%f",lowa],@"b",//总数的百分比
                         [NSString stringWithFormat:@"%f",lowb],@"c",
                         [NSString stringWithFormat:@"%f",lowg],@"d",
                         [NSString stringWithFormat:@"%f",highg],@"e",
                         [NSString stringWithFormat:@"%f",theta],@"f",
                         [NSString stringWithFormat:@"%f",hihga],@"g",
                         [NSString stringWithFormat:@"%f",highb],@"h",
                         [NSString stringWithFormat:@"%f",i],@"i",
                         [NSString stringWithFormat:@"%f",j],@"j",//睡眠
                         [NSString stringWithFormat:@"%f",JiaoLv],@"jiaolv",//焦虑
                         [NSString stringWithFormat:@"%f",YiYu],@"yiyu",//抑郁
                         [NSString stringWithFormat:@"%f",Happy],@"happy",//幸福感
                         [NSString stringWithFormat:@"%f",sleep],@"SS",//睡眠
                         [NSString stringWithFormat:@"%f",jiaolv],@"JJ",//焦虑
                         [NSString stringWithFormat:@"%f",yiyu],@"YY",//抑郁
                         [NSString stringWithFormat:@"%f",happy],@"HH",//幸福感
                         [NSString stringWithFormat:@"%@",sum1],@"sumb",//总值
                         [NSString stringWithFormat:@"%@",sum2],@"sumc",
                         [NSString stringWithFormat:@"%@",sum3],@"sumd",
                         [NSString stringWithFormat:@"%@",sum4],@"sume",
                         [NSString stringWithFormat:@"%@",sum5],@"sumf",
                         [NSString stringWithFormat:@"%@",sum6],@"sumg",
                         [NSString stringWithFormat:@"%@",sum7],@"sumh",
                         [NSString stringWithFormat:@"%@",sum9],@"sumi",
                         [NSString stringWithFormat:@"%@",sum8],@"sumj",
                         [NSString stringWithFormat:@"%f",iiii],@"chai",
                         [NSString stringWithFormat:@"%f",jjjj],@"chaj",
                         [NSString stringWithFormat:@"%lu",(unsigned long)arrf.count],@"TIMELAB",nil];
    
    return dict;
}

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
          happy:(float)happy{
    
    int GuanMax = 0;//关注大于冥想的时长
    int MingMax = 0;//冥想大于关注的时长
    
    int GuanTotal = 0;//关注比冥想大的总值
    int MingTotal = 0;//冥想比关注大的总值
    
    //循环冥想关注数组
    for (int i = 0; i <arri.count; i++) {
        // 关注 - 冥想
        int value = [arri[i] intValue] - [arrj[i] intValue];
        //如果大于零
        if (value >0) {
            // GuanTotal 是实际差值
            GuanTotal += value;
            value = 1;
            // GuanMax 是把差值化为1 也就是秒数 压制了多少秒
            GuanMax += value;
        }else if (value <0){//如果小于零 就是冥想压制关注
            MingTotal += value;
            value = -1;
            
            MingMax += value;
        }
    }
    
    float tota = GuanMax+(-MingMax); // 秒数总和
//    float tot = GuanTotal+(-MingTotal); // 实际差值总和
    
//    float i = GuanMax/tota; // 秒数百分比
    
    // 睡眠 ——  冥想高于关注时长的百分比
    float j = -(MingMax)/tota;
    
//    float iiii = GuanTotal/tot; // 差值百分比
//    float jjjj = -(MingTotal)/tot;
    
    
    float total = b + c + d + e + f + g + h; // 所有数据的总和值
    
    //这些事上边八组数据占总数的百分比
    float lowa = b/total; // lowa百分比
//    float lowb = c/total; // lowb百分比
    float lowg = d/total; // lowg百分比
    float highg = e/total; // highg百分比
    float theta = f/total; // theta百分比
    float hihga = g/total; // hihga百分比
//    float highb = h/total; // highb百分比
    
    // 焦虑 ——  伽马占整个的比 5 —— 20 区间换算
    float JiaoLv = lowg + highg;
    if (JiaoLv <= 5) {//小于等于5
        JiaoLv = 0;//为0
    }else if (JiaoLv >= 20){//大于等于20
        JiaoLv = 1;//为100
    }else{
        JiaoLv = (JiaoLv - 5) * 6.6;//中间区间换算
    }
    
    // 抑郁 ——  斯塔波占整个的百分比 75 ——— 95 区间换算
    float YiYu = theta;
    if (YiYu <= 75) {//小于等于5
        YiYu = 0;//为0
    }else if (YiYu >= 95){//大于等于20
        YiYu = 1;//为100
    }else{
        YiYu = (YiYu - 75) * 5;//中间区间换算
    }
    
    // 幸福感 —— 阿尔法波占整个的百分比
    float Happy = lowa + hihga;
    
    sleep = j;
    jiaolv = JiaoLv;
    yiyu = YiYu;
    happy = Happy;
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:

                         [NSString stringWithFormat:@"%f",j],@"j",//睡眠
                         [NSString stringWithFormat:@"%f",JiaoLv],@"jiaolv",//焦虑
                         [NSString stringWithFormat:@"%f",YiYu],@"yiyu",//抑郁
                         [NSString stringWithFormat:@"%f",Happy],@"happy",nil];
    
    return dict;
}


-(void)dictionaryAddObject:(NSMutableDictionary *)dict objectArr:(NSArray *)arr{
    [dict setObject:arr[0] forKey:@"b"];
    [dict setObject:arr[1] forKey:@"c"];
    [dict setObject:arr[2] forKey:@"d"];
    [dict setObject:arr[3] forKey:@"e"];
    [dict setObject:arr[4] forKey:@"f"];
    [dict setObject:arr[5] forKey:@"g"];
    [dict setObject:arr[6] forKey:@"h"];
    [dict setObject:arr[7] forKey:@"i"];
    [dict setObject:arr[8] forKey:@"j"];
    [dict setObject:arr[9] forKey:@"jiaolv"];
    [dict setObject:arr[10] forKey:@"yiyu"];
    [dict setObject:arr[11] forKey:@"happy"];
    [dict setObject:arr[12] forKey:@"SS"];
    [dict setObject:arr[13] forKey:@"JJ"];
    [dict setObject:arr[14] forKey:@"YY"];
    [dict setObject:arr[15] forKey:@"HH"];
    [dict setObject:arr[16] forKey:@"sumb"];
    [dict setObject:arr[17] forKey:@"sumc"];
    [dict setObject:arr[18] forKey:@"sumd"];
    [dict setObject:arr[19] forKey:@"sume"];
    [dict setObject:arr[20] forKey:@"sumf"];
    [dict setObject:arr[21] forKey:@"sumg"];
    [dict setObject:arr[22] forKey:@"sumh"];
    [dict setObject:arr[23] forKey:@"sumi"];
    [dict setObject:arr[24] forKey:@"sumj"];
    [dict setObject:arr[25] forKey:@"chai"];
    [dict setObject:arr[26] forKey:@"chaj"];
    [dict setObject:arr[27] forKey:@"TIMELAB"];
    
}
-(void)dictionaryAddObjectMore:(NSMutableDictionary *)dict objectArr:(NSArray *)arr{
    [dict setObject:arr[0] forKey:@"b"];
    [dict setObject:arr[1] forKey:@"c"];
    [dict setObject:arr[2] forKey:@"d"];
    [dict setObject:arr[3] forKey:@"e"];
    [dict setObject:arr[4] forKey:@"f"];
    [dict setObject:arr[5] forKey:@"g"];
    [dict setObject:arr[6] forKey:@"h"];
    [dict setObject:arr[7] forKey:@"i"];
    [dict setObject:arr[8] forKey:@"j"];
    [dict setObject:arr[9] forKey:@"jiaolv"];
    [dict setObject:arr[10] forKey:@"yiyu"];
    [dict setObject:arr[11] forKey:@"happy"];
    [dict setObject:arr[12] forKey:@"SS"];
    [dict setObject:arr[13] forKey:@"JJ"];
    [dict setObject:arr[14] forKey:@"YY"];
    [dict setObject:arr[15] forKey:@"HH"];
    [dict setObject:arr[16] forKey:@"sumb"];
    [dict setObject:arr[17] forKey:@"sumc"];
    [dict setObject:arr[18] forKey:@"sumd"];
    [dict setObject:arr[19] forKey:@"sume"];
    [dict setObject:arr[20] forKey:@"sumf"];
    [dict setObject:arr[21] forKey:@"sumg"];
    [dict setObject:arr[22] forKey:@"sumh"];
    [dict setObject:arr[23] forKey:@"sumi"];
    [dict setObject:arr[24] forKey:@"sumj"];
    [dict setObject:arr[25] forKey:@"chai"];
    [dict setObject:arr[26] forKey:@"chaj"];
    [dict setObject:arr[27] forKey:@"TIMELAB"];
    [dict setObject:arr[28] forKey:@"Lowa"];
    [dict setObject:arr[29] forKey:@"Higha"];
    [dict setObject:arr[30] forKey:@"LowaMax"];
    [dict setObject:arr[31] forKey:@"HighaMax"];
    
}

-(NSString *)fileStrWithDic:(NSDictionary *)dict sleep:(float)sleep jiaolv:(float)jiaolv yiyu:(float)yiyu happy:(float)happy loaarr:(NSMutableArray *)lowaarr higharr:(NSMutableArray *)highaarr lowamax:(NSNumber *)lowamax highamax:(NSNumber *)highamax{
    //总数的百分比
    NSString *lowa = [dict objectForKey:@"b"];
    NSString *lowb = [dict objectForKey:@"c"];
    NSString *lowg = [dict objectForKey:@"d"];
    NSString *highg = [dict objectForKey:@"e"];
    NSString *theta = [dict objectForKey:@"f"];
    NSString *higha = [dict objectForKey:@"g"];
    NSString *highb = [dict objectForKey:@"h"];
    NSString *i = [dict objectForKey:@"i"];
    
    //测试用的:能否正常数据数据 cut 之后的
    NSString *Sleep = [dict objectForKey:@"j"];
    NSString *Jiaolv = [dict objectForKey:@"jiaolv"];
    NSString *Yiyu = [dict objectForKey:@"yiyu"];
    NSString *Happy = [dict objectForKey:@"happy"];
    
    NSString *sum1 = [dict objectForKey:@"sumb"];
    NSString *sum2 = [dict objectForKey:@"sumc"];
    NSString *sum3 = [dict objectForKey:@"sumd"];
    NSString *sum4 = [dict objectForKey:@"sume"];
    NSString *sum5 = [dict objectForKey:@"sumf"];
    NSString *sum6 = [dict objectForKey:@"sumg"];
    NSString *sum7 = [dict objectForKey:@"sumh"];
    NSString *sum9 = [dict objectForKey:@"sumi"];
    NSString *sum8 = [dict objectForKey:@"sumj"];
    NSString *iiii = [dict objectForKey:@"chai"];
    NSString *jjjj = [dict objectForKey:@"chaj"];
    NSString *time = [dict objectForKey:@"TIMELAB"];

    
    //拼接字符串
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@-%@-%@-%@-%@-%@-%@-%f-%f-%f-%f-%@-%@-%@-%@-%@-%@-%@-%@-%@-%@-%@-%@-%@-%@-%@-%@",lowa,lowb,lowg,highg,theta,higha,highb,i,Sleep,Jiaolv,Yiyu,Happy,sleep,jiaolv,yiyu,happy,sum1,sum2,sum3,sum4,sum5,sum6,sum7,sum9,sum8,iiii,jjjj,time,lowaarr,highaarr,lowamax,highamax];
    return str;
}



@end
