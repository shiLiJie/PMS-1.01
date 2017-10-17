//
//  musicClassModel.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/4/14.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface musicClassModel : NSObject

@property (nonatomic, copy) NSString *name;//音乐编号
@property (nonatomic, copy) NSString *path;//音乐名称


+ (instancetype)musicClassWithDict:(NSDictionary *)dict;

@end
